import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportHelper {
  /// Super Admin Support Phone Number
  static const String superAdminPhone = "6202339633";
  static const String superAdminCountryCode = "91";

  /// Open WhatsApp with a pre-filled message
  static Future<void> openWhatsApp({
    required String message,
    String? phone,
  }) async {
    final rawPhone = (phone ?? superAdminPhone).replaceAll(RegExp(r'[^0-9]'), '');
    final fullPhone = rawPhone.length == 10 ? '$superAdminCountryCode$rawPhone' : rawPhone;
    final encodedMessage = Uri.encodeComponent(message);

    final Uri whatsappNativeUri = Uri.parse("whatsapp://send?phone=$fullPhone&text=$encodedMessage");
    final Uri fallbackWebUri = Uri.parse("https://wa.me/$fullPhone?text=$encodedMessage");

    try {
      if (await canLaunchUrl(whatsappNativeUri)) {
        await launchUrl(
          whatsappNativeUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        await launchUrl(
          fallbackWebUri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      debugPrint("Error opening WhatsApp: $e");
    }
  }

  /// Super Admin Support Email
  static const String superAdminEmail = "support@gymflow.in";

  /// Open Phone Dialer to directly call Super Admin
  static Future<void> callSupport({String? phone}) async {
    final rawPhone = (phone ?? superAdminPhone).replaceAll(RegExp(r'[^0-9]'), '');
    final fullPhone = rawPhone.length == 10 ? '+91$rawPhone' : '+$rawPhone';
    final Uri callUri = Uri.parse("tel:$fullPhone");

    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      }
    } catch (e) {
      debugPrint("Error calling support: $e");
    }
  }

  /// Open Email client to write to Support
  static Future<void> sendEmail({
    String? email,
    String? subject,
    String? body,
  }) async {
    final targetEmail = email ?? superAdminEmail;
    final Map<String, String> query = {};
    if (subject != null && subject.isNotEmpty) query['subject'] = subject;
    if (body != null && body.isNotEmpty) query['body'] = body;

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: targetEmail,
      queryParameters: query.isNotEmpty ? query : null,
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      }
    } catch (e) {
      debugPrint("Error sending email: $e");
    }
  }
}
