import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../theme/app_colors.dart';

class MemberTile extends StatelessWidget {
  final String name;
  final String mobNo;
  final String status;
  final String image;
  final String? planName;
  final int? planMonths;
  final DateTime? expiryDate;
  final bool isTablet;
  final VoidCallback? onEdit;
  final VoidCallback? onDownloadPdf;
  final VoidCallback? onTap;
  final VoidCallback? onViewProfile;

  const MemberTile({
    super.key,
    required this.name,
    required this.mobNo,
    required this.status,
    required this.image,
    this.planName,
    this.planMonths,
    this.expiryDate,
    required this.isTablet,
    this.onEdit,
    this.onDownloadPdf,
    this.onTap,
    this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    final style = _getStatusStyle(status);
    final bool hasImage = image.trim().isNotEmpty;

    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP ROW: AVATAR + NAME/PHONE + STATUS BADGE + 3-DOT MENU
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildAvatar(hasImage, style),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name.isNotEmpty ? name : "Unknown Member",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isTablet ? 17 : 15.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 13,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  mobNo.isNotEmpty ? mobNo : "No Phone",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: isTablet ? 13 : 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusBadge(style),
                    const SizedBox(width: 4),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      splashRadius: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _showOptions(context),
                      icon: Icon(
                        Icons.more_vert_rounded,
                        size: 20,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// MIDDLE STRIP: PLAN NAME + EXPIRY BADGE
                _buildPlanAndExpiryStrip(),

                const SizedBox(height: 12),

                /// BOTTOM ACTIONS: CALL & WHATSAPP
                Row(
                  children: [
                    /// CALL
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _callMember,
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.call_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Call Member",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: isTablet ? 14 : 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// WHATSAPP
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _openWhatsapp,
                      child: Container(
                        height: 42,
                        width: 44,
                        decoration: BoxDecoration(
                          color: const Color(0x1A25D366),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF25D366).withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.whatsapp,
                            color: Color(0xFF25D366),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// MIDDLE STRIP (PLAN & EXPIRY)
  Widget _buildPlanAndExpiryStrip() {
    final hasPlan = planName != null && planName!.trim().isNotEmpty;
    final String displayPlanName;
    if (hasPlan) {
      if (planMonths != null &&
          planMonths! > 0 &&
          !planName!.toLowerCase().contains('month') &&
          !planName!.toLowerCase().contains('mo')) {
        displayPlanName = "$planName (${planMonths}M)";
      } else {
        displayPlanName = planName!;
      }
    } else {
      displayPlanName = "No Active Plan";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.card_membership_rounded,
            size: 15,
            color: hasPlan ? AppColors.primary : Colors.grey.shade400,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              displayPlanName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: hasPlan ? Colors.black87 : Colors.grey.shade500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildExpiryBadge(),
        ],
      ),
    );
  }

  /// EXPIRY COUNTDOWN BADGE
  Widget _buildExpiryBadge() {
    if (expiryDate == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          "No Expiry",
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
          ),
        ),
      );
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expLocal = expiryDate!.toLocal();
    final exp = DateTime(expLocal.year, expLocal.month, expLocal.day);
    final diff = exp.difference(today).inDays;

    final Color bgColor;
    final Color textColor;
    final IconData icon;
    final String label;

    if (diff < 0) {
      bgColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFFDC2626);
      icon = Icons.cancel_outlined;
      label = diff == -1 ? "Expired y'day" : "Expired ${diff.abs()}d ago";
    } else if (diff == 0) {
      bgColor = const Color(0xFFFEF3C7);
      textColor = const Color(0xFFD97706);
      icon = Icons.alarm_rounded;
      label = "Expires Today";
    } else if (diff <= 5) {
      bgColor = const Color(0xFFFEF3C7);
      textColor = const Color(0xFFD97706);
      icon = Icons.access_time_rounded;
      label = "Exp: ${DateFormat('dd MMM').format(expLocal)} (${diff}d left)";
    } else {
      bgColor = const Color(0xFFECFDF5);
      textColor = const Color(0xFF059669);
      icon = Icons.event_available_rounded;
      label = "Exp: ${DateFormat('dd MMM yyyy').format(expLocal)}";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  /// INITIALS GENERATOR
  String _getInitials(String str) {
    final parts = str.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return "";
    if (parts.length == 1) {
      final s = parts[0];
      return s.substring(0, s.length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  /// AVATAR WITH INITIALS FALLBACK AND STATUS DOT
  Widget _buildAvatar(bool hasImage, _StatusStyle style) {
    final double radius = isTablet ? 26 : 23;
    final initials = _getInitials(name);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: AppColors.primary.withValues(alpha: 0.08),
            backgroundImage: hasImage ? CachedNetworkImageProvider(image) : null,
            child: !hasImage
                ? (initials.isNotEmpty
                    ? Text(
                        initials,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: isTablet ? 15 : 13.5,
                        ),
                      )
                    : Icon(
                        Icons.person_rounded,
                        size: isTablet ? 24 : 20,
                        color: Colors.grey.shade400,
                      ))
                : null,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            height: 11,
            width: 11,
            decoration: BoxDecoration(
              color: style.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// STATUS PILL BADGE
  Widget _buildStatusBadge(_StatusStyle style) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3.5,
      ),
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            style.icon,
            size: 11,
            color: style.color,
          ),
          const SizedBox(width: 4),
          Text(
            style.label,
            style: TextStyle(
              color: style.color,
              fontWeight: FontWeight.w700,
              fontSize: 10,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  /// CALL ACTION
  Future<void> _callMember() async {
    final String cleanPhone = mobNo.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleanPhone.isEmpty) return;
    final Uri phoneUri = Uri(scheme: 'tel', path: cleanPhone);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } catch (e) {
      debugPrint("Error making call: $e");
    }
  }

  /// WHATSAPP ACTION
  Future<void> _openWhatsapp() async {
    final String digits = mobNo.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return;
    final String phone = digits.length == 10 ? '91$digits' : digits;

    final Uri whatsappUri = Uri.parse("whatsapp://send?phone=$phone");
    final Uri fallbackUri = Uri.parse("https://wa.me/$phone");

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(
          whatsappUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        await launchUrl(
          fallbackUri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      debugPrint("Error launching WhatsApp: $e");
    }
  }

  /// BOTTOM SHEET OPTIONS
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    "View Profile",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onViewProfile?.call();
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    "Edit Member",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onEdit?.call();
                  },
                ),
                if (onDownloadPdf != null)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: Color(0xFF25D366),
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      "Receipt PDF (Share / View)",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onDownloadPdf?.call();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// STATUS STYLE CONFIG
  _StatusStyle _getStatusStyle(String value) {
    final status = value.trim().toLowerCase();

    switch (status) {
      case "active":
        return _StatusStyle(
          label: "ACTIVE",
          color: const Color(0xFF16A34A),
          bgColor: const Color(0xFFDCFCE7),
          icon: Icons.check_circle_rounded,
        );

      case "expired":
        return _StatusStyle(
          label: "EXPIRED",
          color: const Color(0xFFEA580C),
          bgColor: const Color(0xFFFFEDD5),
          icon: Icons.access_time_filled_rounded,
        );

      case "inactive":
        return _StatusStyle(
          label: "INACTIVE",
          color: const Color(0xFFDC2626),
          bgColor: const Color(0xFFFEE2E2),
          icon: Icons.cancel_rounded,
        );

      default:
        return _StatusStyle(
          label: value.isNotEmpty ? value.toUpperCase() : "UNKNOWN",
          color: Colors.grey.shade600,
          bgColor: Colors.grey.shade100,
          icon: Icons.info_rounded,
        );
    }
  }
}

class _StatusStyle {
  final String label;
  final Color color;
  final Color bgColor;
  final IconData icon;

  _StatusStyle({
    required this.label,
    required this.color,
    required this.bgColor,
    required this.icon,
  });
}