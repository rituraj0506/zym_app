import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  /// BottomSheet to pick source: Camera or Gallery
  static Future<ImageSource?> showImageSourceDialog(
    BuildContext context, {
    int maxSizeInKb = 200,
    String title = "Select Photo Source",
  }) async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Max size: $maxSizeInKb KB (Auto-compressed & Cropped)",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 18),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xff6C63FF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.photo_library_outlined,
                    color: Color(0xff6C63FF),
                  ),
                ),
                title: const Text(
                  "Choose from Gallery",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
              const SizedBox(height: 6),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xff10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: Color(0xff10B981),
                  ),
                ),
                title: const Text(
                  "Take Photo",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Pick, Crop, and compress to <= 200KB
  static Future<File?> pickCropAndCompressImage({
    required BuildContext context,
    required ImageSource source,
    int maxSizeInKb = 200,
    String cropTitle = 'Crop Photo',
  }) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (pickedFile == null) return null;

      File file = File(pickedFile.path);

      /// CROP IMAGE (Safely handled with fallback if native cropper encounters an issue)
      try {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: file.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 85,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: cropTitle,
              toolbarColor: const Color(0xff6C63FF),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ],
            ),
            IOSUiSettings(
              title: cropTitle,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ],
            ),
          ],
        );

        if (croppedFile != null) {
          file = File(croppedFile.path);
        } else {
          // User intentionally pressed the cancel/back button inside the crop screen
          return null;
        }
      } catch (cropError) {
        debugPrint("ImageCropper error (falling back to camera photo): $cropError");
        // Fallback: If native cropper failed, use the camera photo directly
      }

      final int maxBytes = maxSizeInKb * 1024;
      int currentBytes = await file.length();

      // If already under max size, return immediately
      if (currentBytes <= maxBytes) {
        return file;
      }

      // Auto-compress and reduce resolution if needed
      try {
        final rawBytes = await file.readAsBytes();
        final img.Image? decoded = img.decodeImage(rawBytes);
        if (decoded == null) return file;
        img.Image processed = decoded;

        // Resize if dimensions are unnecessarily large
        if (processed.width > 800 || processed.height > 800) {
          processed = img.copyResize(
            processed,
            width: processed.width >= processed.height ? 800 : null,
            height: processed.height > processed.width ? 800 : null,
          );
        }

        int quality = 80;
        Uint8List compressed = Uint8List.fromList(
          img.encodeJpg(processed, quality: quality),
        );

        while (compressed.length > maxBytes && quality > 15) {
          quality -= 15;
          if (quality <= 40 && processed.width > 400) {
            processed = img.copyResize(
              processed,
              width: (processed.width * 0.8).toInt(),
            );
          }
          compressed = Uint8List.fromList(
            img.encodeJpg(processed, quality: quality),
          );
        }

        final tempDir = await getTemporaryDirectory();
        final resultFile = File(
          '${tempDir.path}/img_crop_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await resultFile.writeAsBytes(compressed);
        debugPrint(
            "Compressed image size: ${(resultFile.lengthSync() / 1024).toStringAsFixed(1)} KB (Max: $maxSizeInKb KB)");
        return resultFile;
      } catch (compressError) {
        debugPrint("Compression error (using file as-is): $compressError");
        return file;
      }
    } catch (e) {
      debugPrint("pickCropAndCompressImage error: $e");
      return null;
    }
  }
}
