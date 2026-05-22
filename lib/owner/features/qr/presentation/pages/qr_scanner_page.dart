import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:zymmanagement/owner/features/qr/presentation/pages/sucess_scan_page.dart';
import '../cubit/scan_qr_cubit.dart';
import '../cubit/scan_qr_state.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() =>
      _QrScannerPageState();
}

class _QrScannerPageState
    extends State<QrScannerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController
  _animationController;

  final FlutterTts flutterTts =
  FlutterTts();

  final MobileScannerController
  scannerController =
  MobileScannerController(
    detectionSpeed:
    DetectionSpeed.noDuplicates,

    detectionTimeoutMs: 1200,

    facing: CameraFacing.back,

    torchEnabled: false,
  );

  bool isTorchOn = false;

  bool isFrontCamera = false;

  bool isProcessing = false;

  @override
  void initState() {
    super.initState();

    _animationController =
    AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    )..repeat(reverse: true);

    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage(
      "en-US",
    );

    await flutterTts.setSpeechRate(
      0.45,
    );

    await flutterTts.setPitch(1.0);
  }

  @override
  void dispose() {
    _animationController.dispose();

    scannerController.dispose();

    flutterTts.stop();

    super.dispose();
  }

  Future<void> _onDetectBarcode(
      BarcodeCapture capture,
      ) async {
    if (isProcessing) return;

    final List<Barcode> barcodes =
        capture.barcodes;

    if (barcodes.isEmpty) return;

    final String? rawValue =
        barcodes.first.rawValue;

    if (rawValue == null) return;

    isProcessing = true;

    /// STOP CAMERA
    await scannerController.stop();

    SystemSound.play(
      SystemSoundType.click,
    );

    /// HIT API
    context
        .read<ScanQrCubit>()
        .checkInCheckOut(
      qrToken: rawValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size =
        MediaQuery.of(context).size;

    final bool isTablet =
        size.width > 700;

    final double scanSize =
    isTablet
        ? 380
        : size.width * .78;

    return Scaffold(
      backgroundColor:
      const Color(0xFF070B16),

      body: BlocConsumer<
          ScanQrCubit,
          ScanQrState
      >(
        listener: (
            context,
            state,
            ) async {
          /// SUCCESS
          if (state
          is ScanQrSuccess) {
            await flutterTts.speak(
              state.voiceText,
            );

            if (!mounted) return;

            await Navigator.push(
              context,

              MaterialPageRoute(
                builder:
                    (_) =>
                    ScanSuccessPage(
                      type:
                      state.type,

                      memberName:
                      state
                          .memberName,

                      message:
                      state
                          .message,

                      checkInTime:
                      state
                          .checkInTime,

                      checkOutTime:
                      state
                          .checkOutTime,

                      attendanceDate:
                      state
                          .attendanceDate,

                      profilePhoto:
                      state
                          .profilePhoto,
                    ),
              ),
            );

            /// RESTART CAMERA
            await scannerController
                .start();

            isProcessing = false;
          }

          /// ERROR
          if (state
          is ScanQrError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
              ),
            );

            await scannerController
                .start();

            isProcessing = false;
          }
        },

        builder: (
            context,
            state,
            ) {
          return Stack(
            children: [
              /// CAMERA
              MobileScanner(
                controller:
                scannerController,

                onDetect:
                _onDetectBarcode,
              ),

              /// DARK OVERLAY
              Container(
                color: Colors.black
                    .withOpacity(.55),
              ),

              /// TOP GLOW
              Positioned(
                top: -100,
                right: -80,

                child: Container(
                  height: 240,
                  width: 240,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: const Color(
                      0xFF7B61FF,
                    ).withOpacity(.20),
                  ),
                ),
              ),

              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints:
                    BoxConstraints(
                      maxWidth:
                      isTablet
                          ? 700
                          : double
                          .infinity,
                    ),

                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(
                        horizontal:
                        isTablet
                            ? 28
                            : 18,

                        vertical: 18,
                      ),

                      child: Column(
                        children: [
                          /// APP BAR
                          Row(
                            children: [
                              _topButton(
                                icon:
                                Icons
                                    .arrow_back_ios_new_rounded,

                                onTap: () {
                                  Navigator.pop(
                                    context,
                                  );
                                },
                              ),

                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Scan Member QR",

                                    style: TextStyle(
                                      color:
                                      Colors
                                          .white,

                                      fontSize:
                                      isTablet
                                          ? 28
                                          : 22,

                                      fontWeight:
                                      FontWeight
                                          .w700,
                                    ),
                                  ),
                                ),
                              ),

                              Row(
                                children: [
                                  _topButton(
                                    icon:
                                    isTorchOn
                                        ? Icons
                                        .flash_on
                                        : Icons
                                        .flash_off,

                                    onTap:
                                        () async {
                                      await scannerController
                                          .toggleTorch();

                                      setState(
                                            () {
                                          isTorchOn =
                                          !isTorchOn;
                                        },
                                      );
                                    },
                                  ),

                                  const SizedBox(
                                    width: 10,
                                  ),

                                  _topButton(
                                    icon:
                                    Icons
                                        .flip_camera_ios_rounded,

                                    onTap:
                                        () async {
                                      await scannerController
                                          .switchCamera();

                                      setState(
                                            () {
                                          isFrontCamera =
                                          !isFrontCamera;
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const Spacer(),

                          /// SCAN AREA
                          Stack(
                            alignment:
                            Alignment
                                .center,

                            children: [
                              /// GLOW
                              Container(
                                height:
                                scanSize +
                                    40,

                                width:
                                scanSize +
                                    40,

                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(
                                    40,
                                  ),

                                  gradient:
                                  RadialGradient(
                                    colors: [
                                      const Color(
                                        0xFF7B61FF,
                                      ).withOpacity(
                                        .22,
                                      ),

                                      Colors
                                          .transparent,
                                    ],
                                  ),
                                ),
                              ),

                              /// BOX
                              Container(
                                height:
                                scanSize,

                                width:
                                scanSize,

                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(
                                    32,
                                  ),

                                  border: Border.all(
                                    color: Colors
                                        .white
                                        .withOpacity(
                                      .08,
                                    ),
                                  ),
                                ),
                              ),

                              /// SCAN LINE
                              AnimatedBuilder(
                                animation:
                                _animationController,

                                builder:
                                    (
                                    context,
                                    child,
                                    ) {
                                  return Positioned(
                                    top:
                                    (_animationController.value *
                                        (scanSize -
                                            40)),

                                    child:
                                    Container(
                                      width:
                                      scanSize *
                                          .85,

                                      height:
                                      4,

                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(
                                          20,
                                        ),

                                        gradient:
                                        const LinearGradient(
                                          colors: [
                                            Colors
                                                .transparent,

                                            Color(
                                              0xFFB28CFF,
                                            ),

                                            Colors
                                                .transparent,
                                          ],
                                        ),

                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFFB28CFF,
                                            ).withOpacity(
                                              .9,
                                            ),

                                            blurRadius:
                                            12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),

                              /// CORNERS
                              SizedBox(
                                height:
                                scanSize,

                                width:
                                scanSize,

                                child: Stack(
                                  children: [
                                    _corner(
                                      top: 0,
                                      left: 0,
                                    ),

                                    _corner(
                                      top: 0,
                                      right: 0,
                                    ),

                                    _corner(
                                      bottom: 0,
                                      left: 0,
                                    ),

                                    _corner(
                                      bottom: 0,
                                      right: 0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height:
                            isTablet
                                ? 36
                                : 26,
                          ),

                          Text(
                            "Place Member QR Inside Frame",

                            textAlign:
                            TextAlign.center,

                            style: TextStyle(
                              color:
                              Colors.white,

                              fontSize:
                              isTablet
                                  ? 22
                                  : 18,

                              fontWeight:
                              FontWeight
                                  .w700,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Text(
                            "Attendance will be marked automatically",

                            textAlign:
                            TextAlign.center,

                            style: TextStyle(
                              color:
                              Colors
                                  .white70,

                              fontSize:
                              isTablet
                                  ? 16
                                  : 13,
                            ),
                          ),

                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _topButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 52,
        width: 52,

        decoration: BoxDecoration(
          color: Colors.white
              .withOpacity(.08),

          borderRadius:
          BorderRadius.circular(
            18,
          ),

          border: Border.all(
            color: Colors.white
                .withOpacity(.06),
          ),
        ),

        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _corner({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,

      child: Container(
        height: 46,
        width: 46,

        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.only(
            topLeft:
            top != null &&
                left != null
                ? const Radius.circular(
              20,
            )
                : Radius.zero,

            topRight:
            top != null &&
                right != null
                ? const Radius.circular(
              20,
            )
                : Radius.zero,

            bottomLeft:
            bottom != null &&
                left != null
                ? const Radius.circular(
              20,
            )
                : Radius.zero,

            bottomRight:
            bottom != null &&
                right != null
                ? const Radius.circular(
              20,
            )
                : Radius.zero,
          ),

          border: Border(
            top:
            top != null
                ? const BorderSide(
              color: Color(
                0xFF9F7CFF,
              ),
              width: 5,
            )
                : BorderSide.none,

            left:
            left != null
                ? const BorderSide(
              color: Color(
                0xFF9F7CFF,
              ),
              width: 5,
            )
                : BorderSide.none,

            right:
            right != null
                ? const BorderSide(
              color: Color(
                0xFF9F7CFF,
              ),
              width: 5,
            )
                : BorderSide.none,

            bottom:
            bottom != null
                ? const BorderSide(
              color: Color(
                0xFF9F7CFF,
              ),
              width: 5,
            )
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}