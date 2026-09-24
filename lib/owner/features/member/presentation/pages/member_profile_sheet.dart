import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../owner/models/member_response.dart';

class MemberProfileSheet extends StatelessWidget {
  final MemberData member;
  final VoidCallback? onEdit;
  final VoidCallback? onDownloadPdf;

  const MemberProfileSheet({
    super.key,
    required this.member,
    this.onEdit,
    this.onDownloadPdf,
  });

  static void show(
    BuildContext context, {
    required MemberData member,
    VoidCallback? onEdit,
    VoidCallback? onDownloadPdf,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MemberProfileSheet(
        member: member,
        onEdit: onEdit,
        onDownloadPdf: onDownloadPdf,
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return DateFormat("dd MMM yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    final bool isExpired = member.memberStatus.toLowerCase() == "expired";
    final Color statusColor = isExpired ? AppColors.error : AppColors.success;
    final String email = member.user?.email ?? "N/A";
    final String mobNo = member.user?.mobNo ?? member.mobNo;
    final String planName = member.plan?.planName ?? "No Plan";
    final num planPrice = member.plan?.price ?? 0;
    final int planMonths = member.plan?.durationInMonths ?? 0;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FD),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Member Profile",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 22),
                  onPressed: () => Navigator.pop(context),
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Scrollable Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Hero Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Avatar (Clickable to view full image)
                        GestureDetector(
                          onTap: (member.profilePhoto.trim().isNotEmpty &&
                                  member.profilePhoto.startsWith("http"))
                              ? () => _viewFullImage(
                                    context,
                                    member.profilePhoto,
                                    member.user?.name ?? member.name,
                                  )
                              : null,
                          child: Stack(
                            children: [
                              Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary.withValues(alpha: 0.25),
                                    width: 3,
                                  ),
                                ),
                                child: ClipOval(
                                  child: (member.profilePhoto.trim().isNotEmpty &&
                                          member.profilePhoto.startsWith("http"))
                                      ? CachedNetworkImage(
                                          imageUrl: member.profilePhoto,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                            color: AppColors.primaryLight,
                                            child: const Icon(
                                              Icons.person_rounded,
                                              size: 40,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Container(
                                            color: AppColors.primaryLight,
                                            child: const Icon(
                                              Icons.person_rounded,
                                              size: 40,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          color: AppColors.primaryLight,
                                          child: Center(
                                            child: Text(
                                              member.name.isNotEmpty
                                                  ? member.name[0].toUpperCase()
                                                  : "M",
                                              style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              if (member.profilePhoto.trim().isNotEmpty &&
                                  member.profilePhoto.startsWith("http"))
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.fullscreen_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Name
                        Text(
                          member.name,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 6),

                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                member.memberStatus.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: statusColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Membership & Plan Details Card
                  _buildSectionHeader("MEMBERSHIP & PLAN"),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.card_membership_rounded,
                          label: "Current Plan",
                          value: "$planName ($planMonths Months)",
                          highlightValue: true,
                        ),
                        const Divider(height: 20),
                        _buildInfoRow(
                          icon: Icons.payments_outlined,
                          label: "Plan Price",
                          value: "₹$planPrice",
                        ),
                        const Divider(height: 20),
                        _buildInfoRow(
                          icon: Icons.calendar_today_rounded,
                          label: "Joining Date",
                          value: _formatDate(member.joiningDate),
                        ),
                        const Divider(height: 20),
                        _buildInfoRow(
                          icon: Icons.event_busy_rounded,
                          label: "Expiry Date",
                          value: _formatDate(member.expiryDate),
                          valueColor: statusColor,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Personal Info Card
                  _buildSectionHeader("PERSONAL & CONTACT DETAILS"),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.phone_android_rounded,
                          label: "Mobile Number",
                          value: mobNo,
                        ),
                        const Divider(height: 20),
                        _buildInfoRow(
                          icon: Icons.email_outlined,
                          label: "Email Address",
                          value: email,
                        ),
                        const Divider(height: 20),
                        _buildInfoRow(
                          icon: Icons.cake_outlined,
                          label: "Age",
                          value: member.age > 0 ? "${member.age} Years" : "Not specified",
                        ),
                        const Divider(height: 20),
                        _buildInfoRow(
                          icon: Icons.badge_outlined,
                          label: "Aadhaar Number",
                          value: member.aadhaarNo.trim().isNotEmpty
                              ? member.aadhaarNo
                              : "Not provided",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Attendance & Activity Card
                  _buildSectionHeader("ACTIVITY & ATTENDANCE"),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.access_time_rounded,
                          label: "Last Attendance",
                          value: member.lastAttendanceDate != null
                              ? _formatDate(member.lastAttendanceDate)
                              : "Never visited yet",
                        ),
                        const Divider(height: 20),
                        _buildInfoRow(
                          icon: Icons.qr_code_2_rounded,
                          label: "QR Token Status",
                          value: member.qrToken.isNotEmpty
                              ? "Active & Linked"
                              : "Not Generated",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF6B7280),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool highlightValue = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: highlightValue ? FontWeight.w700 : FontWeight.w600,
                  color: valueColor ?? AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _viewFullImage(BuildContext context, String imageUrl, String name) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Name and Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Full / Zoomable Image
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4.0,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(
                          Icons.broken_image_rounded,
                          size: 60,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Pinch to zoom",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
