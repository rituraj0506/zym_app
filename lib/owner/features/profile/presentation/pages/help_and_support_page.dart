import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zymmanagement/owner/features/home/presentation/cubit/owner_dashboard_cubit.dart';
import 'package:zymmanagement/owner/features/home/presentation/cubit/owner_dashboard_state.dart';
import 'package:zymmanagement/owner/features/profile/presentation/cubit/gym_profile_cubit.dart';
import 'package:zymmanagement/owner/features/profile/presentation/cubit/gym_profile_state.dart';
import 'package:zymmanagement/theme/app_colors.dart';
import 'package:zymmanagement/utils/support_helper.dart';

class HelpAndSupportPage extends StatefulWidget {
  const HelpAndSupportPage({super.key});

  @override
  State<HelpAndSupportPage> createState() => _HelpAndSupportPageState();
}

class _HelpAndSupportPageState extends State<HelpAndSupportPage> {
  int? _expandedFaqIndex;

  final List<Map<String, String>> _faqs = [
    {
      "question": "How do I add a new member?",
      "answer":
          "Navigate to the 'Members' tab from the bottom navigation bar. Tap the '+' button at the top-right corner, enter the member's details (Name, Phone, Plan, Joining Date), and tap 'Add Member'."
    },
    {
      "question": "How does QR attendance work?",
      "answer":
          "Members can display their digital QR code from their app. As a gym owner, tap the 'QR Scanner' icon in the center of the bottom navigation bar to scan and record daily attendance instantly."
    },
    {
      "question": "How can I download member fee receipts?",
      "answer":
          "Open the 'Members' tab. On any paid member's card, tap the 'PDF Receipt' icon to download and share a standard Indian B&W gym fee receipt with complete tax and validity details."
    },
    {
      "question": "How do I create or edit membership plans?",
      "answer":
          "On the Owner Dashboard, tap 'Add Plan' or 'Manage Plans'. Enter the plan name (e.g., Monthly, Quarterly), duration in months, and fee amount to make it active for your gym."
    },
    {
      "question": "How do I renew or upgrade my GymFlow subscription?",
      "answer":
          "Check your subscription card on the Profile page. You can tap 'Renew Plan' or reach out directly to our dedicated support team via WhatsApp anytime to extend or upgrade your account."
    },
    {
      "question": "Can I use GymFlow on multiple devices?",
      "answer":
          "Yes! You can log into your GymFlow account on multiple mobile devices or tablets simultaneously with your registered credentials."
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width >= 700;

    // Retrieve gym name & owner name for customized support messages
    String gymName = "My Gym";
    String ownerName = "Gym Owner";

    final gymState = context.watch<GymProfileCubit>().state;
    if (gymState is GymProfileDataSuccess) {
      gymName = gymState.profile.data?.gymName ?? gymName;
      ownerName = gymState.profile.data?.owner?.name ?? ownerName;
    } else {
      final dashState = context.watch<OwnerDashboardCubit>().state;
      if (dashState is OwnerDashboardLoaded) {
        gymName = dashState.dashboardData.data?.gym?.gymName ?? gymName;
        ownerName = dashState.dashboardData.data?.owner?.name ?? ownerName;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Help & Support",
          style: TextStyle(
            fontSize: isTablet ? 22 : 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade200,
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 650 : double.infinity,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 24 : 16,
                vertical: 18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 1. HERO BANNER
                  _buildHeroBanner(isTablet),

                  const SizedBox(height: 22),

                  /// 2. QUICK CONTACT SECTION
                  _buildSectionTitle("DIRECT ASSISTANCE"),
                  const SizedBox(height: 10),

                  // WhatsApp Support
                  _buildContactCard(
                    icon: FontAwesomeIcons.whatsapp,
                    iconColor: const Color(0xFF25D366),
                    iconBgColor: const Color(0x1A25D366),
                    title: "Chat on WhatsApp",
                    subtitle: "Instant reply for technical help & queries",
                    badgeText: "Fastest",
                    badgeColor: const Color(0xFF25D366),
                    onTap: () {
                      SupportHelper.openWhatsApp(
                        message:
                            "Hello GymFlow Support, I need assistance for my gym '$gymName' (Owner: $ownerName).",
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // Call Support
                  _buildContactCard(
                    icon: Icons.phone_in_talk_rounded,
                    iconColor: const Color(0xFF2563EB),
                    iconBgColor: const Color(0x1A2563EB),
                    title: "Call Direct Helpline",
                    subtitle: "+91 6202339633 • Mon - Sat (9:00 AM - 8:00 PM)",
                    onTap: () {
                      SupportHelper.callSupport();
                    },
                  ),

                  const SizedBox(height: 12),

                  // Email Support
                  _buildContactCard(
                    icon: Icons.mail_outline_rounded,
                    iconColor: const Color(0xFF7C3AED),
                    iconBgColor: const Color(0x1A7C3AED),
                    title: "Email Support",
                    subtitle: "support@gymflow.in • Detailed queries & feedback",
                    onTap: () {
                      SupportHelper.sendEmail(
                        subject: "GymFlow Support Request - $gymName",
                        body:
                            "Hello GymFlow Team,\n\nI am reaching out regarding my gym account:\nGym Name: $gymName\nOwner Name: $ownerName\n\nIssue Description:\n",
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  /// 3. FAQ SECTION
                  _buildSectionTitle("FREQUENTLY ASKED QUESTIONS"),
                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: List.generate(_faqs.length, (index) {
                        final faq = _faqs[index];
                        final isExpanded = _expandedFaqIndex == index;
                        final isLast = index == _faqs.length - 1;

                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _expandedFaqIndex =
                                      isExpanded ? null : index;
                                });
                              },
                              borderRadius: BorderRadius.vertical(
                                top: index == 0
                                    ? const Radius.circular(16)
                                    : Radius.zero,
                                bottom: isLast && !isExpanded
                                    ? const Radius.circular(16)
                                    : Radius.zero,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        faq["question"] ?? "",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isExpanded
                                              ? AppColors.primary
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      isExpanded
                                          ? Icons.keyboard_arrow_up_rounded
                                          : Icons.keyboard_arrow_down_rounded,
                                      color: Colors.grey.shade500,
                                      size: 22,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isExpanded)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 14,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    faq["answer"] ?? "",
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.5,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ),
                            if (!isLast)
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey.shade100,
                              ),
                          ],
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// 4. FOOTER INFO
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.fitness_center_rounded,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "GymFlow Management",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Version 1.0.0 • Dedicated 24/7 Support",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildHeroBanner(bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 22 : 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7B4DFF),
            Color(0xFF5E35D6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B4DFF).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "24/7 HELP DESK",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "We're Here For You",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 22 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Have queries regarding billing, attendance, or members? Get instant support anytime.",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: isTablet ? 14 : 12.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required dynamic icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    String? badgeText,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: icon is IconData
                    ? Icon(icon, color: iconColor, size: 22)
                    : FaIcon(icon, color: iconColor, size: 20),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (badgeText != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: (badgeColor ?? AppColors.primary)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                              color: badgeColor ?? AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
