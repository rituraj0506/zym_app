import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../api_service/fcm_service.dart';
import 'package:zymmanagement/user/features/notification/presentation/cubit/user_notification_cubit.dart';
import 'package:zymmanagement/user/features/notification/presentation/cubit/user_notification_state.dart';
import 'package:zymmanagement/user/features/notification/presentation/pages/user_notifications_page.dart';
import 'package:zymmanagement/user/model/user_dashboard_response.dart';
import '../cubit/user_dashboard_cubit.dart';
import '../cubit/user_dashboard_state.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  void initState() {
    super.initState();

    context.read<UserDashboardCubit>().fetchUserDashboard();
    context.read<UserNotificationCubit>().fetchNotifications();

    // Real-time badge update when notification arrives while app is open
    FCMService.onNotificationReceived = () {
      if (mounted) {
        context.read<UserNotificationCubit>().fetchNotifications(isRefresh: true);
      }
    };
  }

  @override
  void dispose() {
    FCMService.onNotificationReceived = null;
    super.dispose();
  }

  bool _isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = _isTablet(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: BlocBuilder<UserDashboardCubit, UserDashboardState>(
          builder: (context, state) {
            /// LOADING STATE (Sleek Shimmer Skeleton)
            if (state is UserDashboardLoading) {
              return _buildSkeletonLoader(isTablet);
            }

            /// ERROR STATE
            if (state is UserDashboardError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFEE2E2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.cloud_off_rounded,
                          color: Color(0xFFDC2626),
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<UserDashboardCubit>()
                              .fetchUserDashboard(forceRefresh: true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: const Icon(Icons.refresh_rounded, size: 20),
                        label: const Text(
                          "Try Again",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            /// LOADED STATE
            if (state is UserDashboardLoaded) {
              final data = state.userDashboardData.data;
              final member = data?.member;
              final plan = data?.plan;
              final gym = data?.gym;
              final todayAttendance = data?.todayAttendance;
              final attendance = data?.attendanceSummary;

              final int presentDays = attendance?.presentDays ?? 0;
              final int absentDays = attendance?.absentDays ?? 0;
              final int totalDays = attendance?.totalDaysCurrentMonth ?? 0;
              final double successPercentage =
                  totalDays == 0 ? 0.0 : (presentDays / totalDays).clamp(0.0, 1.0);

              return RefreshIndicator(
                color: const Color(0xFF6C63FF),
                onRefresh: () async {
                  await Future.wait([
                    context
                        .read<UserDashboardCubit>()
                        .fetchUserDashboard(forceRefresh: true),
                    context
                        .read<UserNotificationCubit>()
                        .fetchNotifications(isRefresh: true),
                  ]);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 32 : 18,
                    vertical: isTablet ? 24 : 16,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 720 : screenWidth,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 1. TOP HEADER (Avatar, Greeting, ONLY Gate QR button, Notification Bell)
                          _buildTopHeader(context, member, gym, data, isTablet),

                          const SizedBox(height: 18),

                          /// 2. TODAY'S CHECK-IN STATUS BAR (Clean, no redundant QR button)
                          _buildTodayStatusBar(todayAttendance, isTablet),

                          const SizedBox(height: 18),

                          /// 3. DIGITAL MEMBERSHIP VIP PASS CARD (Clean, no redundant QR button)
                          _buildDigitalMembershipCard(member, plan, gym, isTablet),

                          const SizedBox(height: 22),

                          /// 4. ATTENDANCE & PUNCTUALITY CARD (Overflow-free layout)
                          _buildAttendanceCard(
                            presentDays: presentDays,
                            absentDays: absentDays,
                            totalDays: totalDays,
                            successPercentage: successPercentage,
                            isTablet: isTablet,
                          ),

                          const SizedBox(height: 24),

                          /// 5. QUICK ACTIONS SECTION (Overflow-free, no duplicate QR card)
                          _buildQuickActions(context, data, isTablet),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// -------------------------------------------------------------
  /// 1. TOP HEADER (The SINGLE place for Gate QR)
  /// -------------------------------------------------------------
  Widget _buildTopHeader(
    BuildContext context,
    Member? member,
    Gym? gym,
    MemberDetailsData? data,
    bool isTablet,
  ) {
    final String name = member?.name?.trim() ?? "Member";
    final String firstName = name.split(" ").first;
    final String photo = member?.profilePhoto ?? "";
    final bool hasPhoto = photo.trim().isNotEmpty && photo.startsWith("http");

    String initials = "M";
    if (name.isNotEmpty) {
      final parts = name.split(" ").where((p) => p.isNotEmpty).toList();
      if (parts.length >= 2) {
        initials = "${parts[0][0]}${parts[1][0]}".toUpperCase();
      } else if (parts.isNotEmpty) {
        initials = parts[0][0].toUpperCase();
      }
    }

    return Row(
      children: [
        /// Avatar with subtle border
        Container(
          height: isTablet ? 56 : 48,
          width: isTablet ? 56 : 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            image: hasPhoto
                ? DecorationImage(
                    image: NetworkImage(photo.replaceAll("127.0.0.1", "10.0.2.2")),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: !hasPhoto
              ? Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 20 : 17,
                    ),
                  ),
                )
              : null,
        ),

        const SizedBox(width: 14),

        /// Name & Gym Name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, $firstName 👋",
                style: TextStyle(
                  fontSize: isTablet ? 24 : 19,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                gym?.gymName ?? "Fitness Center",
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        /// THE ONLY GATE QR BUTTON IN DASHBOARD
        if (data?.member?.qrToken != null)
          GestureDetector(
            onTap: () => _showQrModal(context, data!),
            child: Container(
              height: isTablet ? 48 : 42,
              width: isTablet ? 48 : 42,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9FE),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFDDD6FE),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.qr_code_rounded,
                color: Color(0xFF6C63FF),
                size: 22,
              ),
            ),
          ),

        /// Notification Bell with Badge
        Container(
          height: isTablet ? 48 : 42,
          width: isTablet ? 48 : 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserNotificationsPage(),
                    ),
                  );
                  if (context.mounted) {
                    context
                        .read<UserNotificationCubit>()
                        .fetchNotifications(isRefresh: true);
                  }
                },
                child: const Center(
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF334155),
                    size: 24,
                  ),
                ),
              ),
              BlocBuilder<UserNotificationCubit, UserNotificationState>(
                builder: (context, notifState) {
                  final int unreadCount =
                      notifState is UserNotificationLoaded ? notifState.unreadCount : 0;

                  if (unreadCount <= 0) return const SizedBox.shrink();

                  return Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          unreadCount > 9 ? "9+" : "$unreadCount",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// -------------------------------------------------------------
  /// 2. TODAY'S CHECK-IN STATUS BAR (No duplicate QR button)
  /// -------------------------------------------------------------
  Widget _buildTodayStatusBar(
    TodayAttendance? todayAttendance,
    bool isTablet,
  ) {
    final bool isCheckedIn = todayAttendance?.checkedIn == true;

    String checkInTimeStr = "";
    if (isCheckedIn && todayAttendance?.checkInTime != null) {
      try {
        final parsed = DateTime.parse(todayAttendance!.checkInTime!).toLocal();
        checkInTimeStr = DateFormat("hh:mm a").format(parsed);
      } catch (_) {}
    }

    if (isCheckedIn) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFA7F3D0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Checked in Today",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF065F46),
                    ),
                  ),
                  if (checkInTimeStr.isNotEmpty)
                    Text(
                      "Time: $checkInTimeStr • Keep up the momentum!",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF047857),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Present 💪",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF047857),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDD6FE)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFF6C63FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_filled_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Not checked in yet today",
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4C1D95),
                  ),
                ),
                Text(
                  "Use the top QR button to check in at gym gate",
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF6D28D9),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// -------------------------------------------------------------
  /// 3. DIGITAL MEMBERSHIP VIP PASS CARD (No duplicate QR button)
  /// -------------------------------------------------------------
  Widget _buildDigitalMembershipCard(
    Member? member,
    Plan? plan,
    Gym? gym,
    bool isTablet,
  ) {
    final String status = (member?.memberStatus ?? "active").toUpperCase();
    final bool isActive = status == "ACTIVE";

    String expiryText = "No Expiry";
    if (plan?.expiryDate != null) {
      final formatted = DateFormat("dd MMM yyyy").format(plan!.expiryDate!);
      final int daysLeft = plan.daysLeft ?? 0;
      if (daysLeft < 0) {
        expiryText = "Expired on $formatted";
      } else if (daysLeft == 0) {
        expiryText = "Expires Today!";
      } else {
        expiryText = "Exp: $formatted ($daysLeft days left)";
      }
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 28 : 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4F46E5), // Indigo
            Color(0xFF7C3AED), // Violet
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Card Top Row: Gym Brand & Status Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.fitness_center_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        (gym?.gymName ?? "ZYMFLOW PASS").toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontWeight: FontWeight.w800,
                          fontSize: isTablet ? 15 : 13,
                          letterSpacing: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF10B981).withValues(alpha: 0.25)
                      : const Color(0xFFEF4444).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFF34D399).withValues(alpha: 0.6)
                        : const Color(0xFFF87171).withValues(alpha: 0.6),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF34D399) : const Color(0xFFF87171),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      status,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 12 : 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: isTablet ? 24 : 18),

          /// Plan Name & Price Tag
          Text(
            plan?.planName ?? "General Membership",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: isTablet ? 26 : 22,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            member?.name ?? "",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: isTablet ? 15 : 13.5,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: isTablet ? 24 : 18),

          /// Card Bottom Row: Expiry badge (full width, overflow-proof)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    expiryText,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: isTablet ? 13 : 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// -------------------------------------------------------------
  /// 4. ATTENDANCE & PUNCTUALITY CARD (Overflow-free)
  /// -------------------------------------------------------------
  Widget _buildAttendanceCard({
    required int presentDays,
    required int absentDays,
    required int totalDays,
    required double successPercentage,
    required bool isTablet,
  }) {
    final String currentMonth = DateFormat("MMMM yyyy").format(DateTime.now());

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 24 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Card Header Row: Title & Month Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calendar_month_rounded,
                        color: Color(0xFF6C63FF),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        "Attendance Overview",
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentMonth,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Sundays excluded note chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 13,
                  color: Color(0xFF64748B),
                ),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    "Sundays are excluded from working days",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          /// Circular Progress & Detailed Stats Row
          Row(
            children: [
              /// Circular Progress Indicator
              SizedBox(
                height: isTablet ? 110 : 96,
                width: isTablet ? 110 : 96,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: isTablet ? 110 : 96,
                      width: isTablet ? 110 : 96,
                      child: CircularProgressIndicator(
                        value: successPercentage,
                        strokeWidth: 9,
                        backgroundColor: const Color(0xFFF1F5F9),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF6C63FF),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$presentDays",
                          style: TextStyle(
                            fontSize: isTablet ? 28 : 24,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "/$totalDays Days",
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              /// Detailed Stat Pills
              Expanded(
                child: Column(
                  children: [
                    _attendanceStatTile(
                      label: "Present",
                      value: "$presentDays Days",
                      color: const Color(0xFF10B981),
                      bgColor: const Color(0xFFECFDF5),
                      icon: Icons.check_circle_outline_rounded,
                    ),
                    const SizedBox(height: 6),
                    _attendanceStatTile(
                      label: "Absent",
                      value: "$absentDays Days",
                      color: const Color(0xFFEF4444),
                      bgColor: const Color(0xFFFEF2F2),
                      icon: Icons.cancel_outlined,
                    ),
                    const SizedBox(height: 6),
                    _attendanceStatTile(
                      label: "Punctuality",
                      value: "${(successPercentage * 100).toStringAsFixed(0)}% Score",
                      color: const Color(0xFF6C63FF),
                      bgColor: const Color(0xFFF5F3FF),
                      icon: Icons.speed_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _attendanceStatTile({
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// -------------------------------------------------------------
  /// 5. QUICK ACTIONS SECTION (Overflow-free & no duplicate QR card)
  /// -------------------------------------------------------------
  Widget _buildQuickActions(BuildContext context, MemberDetailsData? data, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 6,
              width: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF6C63FF),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isTablet ? 1.7 : 1.15,
          children: [
            /// 1. GYM RECEPTION / TIMINGS
            _quickActionCard(
              title: "Gym Reception",
              subtitle: "${data?.gym?.openingTime ?? 'Open'} - ${data?.gym?.closingTime ?? 'Close'}",
              icon: Icons.access_time_filled_rounded,
              color: const Color(0xFF10B981),
              bgColor: const Color(0xFFECFDF5),
              onTap: () {
                _showGymInfoDialog(context, data?.gym);
              },
            ),

            /// 2. MEMBERSHIP DETAILS
            _quickActionCard(
              title: "My Membership",
              subtitle: data?.plan?.planName ?? "View plan status",
              icon: Icons.card_membership_rounded,
              color: const Color(0xFF6C63FF),
              bgColor: const Color(0xFFEDE9FE),
              onTap: () {
                _showFeatureSheet(
                  context,
                  title: "Membership Information",
                  icon: Icons.card_membership_rounded,
                  color: const Color(0xFF6C63FF),
                  description:
                      "Plan: ${data?.plan?.planName ?? 'N/A'}\nStatus: ${(data?.member?.memberStatus ?? 'active').toUpperCase()}\nMember ID: ${data?.member?.id ?? 'N/A'}",
                );
              },
            ),

            /// 3. WORKOUT ROUTINE
            _quickActionCard(
              title: "Workout Split",
              subtitle: "Training routine",
              icon: Icons.fitness_center_rounded,
              color: const Color(0xFF0284C7),
              bgColor: const Color(0xFFF0F9FF),
              onTap: () {
                _showFeatureSheet(
                  context,
                  title: "Workout Split & Routine",
                  icon: Icons.fitness_center_rounded,
                  color: const Color(0xFF0284C7),
                  description:
                      "Track your exercises, sets, reps and personal records. Your gym trainer can assign workout splits tailored to your goals.",
                );
              },
            ),

            /// 4. NUTRITION & DIET
            _quickActionCard(
              title: "Diet Plan",
              subtitle: "Nutrition guide",
              icon: Icons.restaurant_rounded,
              color: const Color(0xFFD97706),
              bgColor: const Color(0xFFFFFBEB),
              onTap: () {
                _showFeatureSheet(
                  context,
                  title: "Daily Nutrition & Diet",
                  icon: Icons.restaurant_rounded,
                  color: const Color(0xFFD97706),
                  description:
                      "Stay disciplined with calorie and macro targets. Ensure adequate daily protein intake for optimal muscle recovery.",
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _quickActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.grey.shade400,
                  size: 15,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// -------------------------------------------------------------
  /// QR CODE GATE PASS MODAL (Triggered only from topbar)
  /// -------------------------------------------------------------
  void _showQrModal(BuildContext context, MemberDetailsData data) {
    final String qrToken = data.member?.qrToken ?? "";
    final String memberName = data.member?.name ?? "Member";
    final String gymName = data.gym?.gymName ?? "Gym";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Grab Handle
                Container(
                  height: 4,
                  width: 42,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),

                /// Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEDE9FE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.qr_code_2_rounded,
                        color: Color(0xFF6C63FF),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Gate Entry QR Pass",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "$memberName • $gymName",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 24),

                /// QR Card Frame
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: qrToken.isNotEmpty
                      ? QrImageView(
                          data: qrToken,
                          version: QrVersions.auto,
                          size: 210,
                          backgroundColor: Colors.white,
                        )
                      : Container(
                          height: 210,
                          width: 210,
                          alignment: Alignment.center,
                          child: const Text("No QR token found"),
                        ),
                ),

                const SizedBox(height: 20),

                /// Guidance Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.light_mode_outlined, size: 16, color: Color(0xFF64748B)),
                      SizedBox(width: 8),
                      Text(
                        "Increase screen brightness for quick scanner read",
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                /// Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Done",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Gym Info Dialog
  void _showGymInfoDialog(BuildContext context, Gym? gym) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFECFDF5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.business_rounded,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  gym?.gymName ?? "Gym Details",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (gym?.address != null && gym!.address!.isNotEmpty) ...[
                const Text(
                  "Address",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  gym.address!,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 14),
              ],
              const Text(
                "Gym Timings",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                "Opening: ${gym?.openingTime ?? 'N/A'}\nClosing: ${gym?.closingTime ?? 'N/A'}",
                style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B), height: 1.4),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Close",
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6C63FF)),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Feature Informational Modal
  void _showFeatureSheet(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String description,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF475569),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Got It"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// -------------------------------------------------------------
  /// SKELETON LOADER
  /// -------------------------------------------------------------
  Widget _buildSkeletonLoader(bool isTablet) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 32 : 18,
          vertical: isTablet ? 24 : 16,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 16, width: 140, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(height: 12, width: 90, color: Colors.white),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
              ),
            ),
          ],
        ),
      ),
    );
  }
}