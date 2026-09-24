import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zymmanagement/owner/features/expiredplan/presentation/cubit/expired_plan_cubit.dart';
import 'package:zymmanagement/owner/features/fee/cubit/transaction_details_cubit.dart';
import 'package:zymmanagement/owner/features/fee/presentation/pages/transaction_details_page.dart';
import '../../../../../network/secure_storge.dart';
import '../../../home/presentation/cubit/owner_dashboard_cubit.dart';
import '../../../home/presentation/cubit/owner_dashboard_state.dart';
import '../../../member/presentation/cubit/member_cubit.dart';
import '../cubit/gym_profile_cubit.dart';
import '../cubit/gym_profile_state.dart';
import 'change_password_page.dart';
import 'create_gym_profile_page.dart';
import 'gym_details_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {

  bool logoutLoading = false;

  @override
  void initState() {
    super.initState();

    context
        .read<GymProfileCubit>()
        .getGymProfile();
  }

  Future<void> logout() async {

    setState(() {
      logoutLoading = true;
    });

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.clear();

    if (!mounted) return;

    /// CLEAR DASHBOARD
    context
        .read<OwnerDashboardCubit>()
        .clearDashboard();

    /// CLEAR MEMBERS
    context
        .read<MemberCubit>()
        .clearMembers();

    context
        .read<ExpiredPlanCubit>()
        .clearMemberShip();

    context
        .read<TransactionDetailsCubit>()
        .clearTransaction();


    /// CLEAR STORAGE
    await SecureStorageService.clearAll();

    /// CLEAR IMAGE CACHE
    imageCache.clear();
    imageCache.clearLiveImages();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      "/login",
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    final size =
        MediaQuery.of(context).size;

    final width = size.width;

    final bool isTablet =
        width >= 700;

    return BlocBuilder<
        GymProfileCubit,
        GymProfileState>(

      builder: (context, state) {

        final bool isLoading =
        state is GymProfileFetchingLoading;

        /// DEFAULT VALUES
        String name = "";
        String email = "";
        String mobile = "";
        String gymName = "";
        String gymImage = "";

        /// SUCCESS DATA
        if (state
        is GymProfileDataSuccess) {

          final profile =
              state.profile.data;

          name =
              profile?.owner?.name ?? "";

          email =
              profile?.owner?.email ?? "";

          mobile =
              profile?.owner?.mobNo
                  ?.toString() ?? "";

          gymName =
              profile?.gymName ?? "";

          gymImage =
              profile?.gymImage ?? "";
        }

        /// FALLBACK TO DASHBOARD DATA IF PROFILE DATA IS EMPTY
        if (name.isEmpty || email.isEmpty || mobile.isEmpty || gymName.isEmpty) {
          final dashState = context.watch<OwnerDashboardCubit>().state;
          if (dashState is OwnerDashboardLoaded) {
            final owner = dashState.dashboardData.data?.owner;
            final gym = dashState.dashboardData.data?.gym;
            if (name.isEmpty) name = owner?.name ?? "";
            if (email.isEmpty) email = owner?.email ?? "";
            if (mobile.isEmpty) mobile = owner?.mobNo?.toString() ?? "";
            if (gymName.isEmpty) gymName = gym?.gymName ?? "";
            if (gymImage.isEmpty) gymImage = gym?.gymImage ?? "";
          }
        }

        return Scaffold(
          backgroundColor:
          const Color(0xFFF5F6FA),

          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                  isTablet
                      ? 600
                      : double.infinity,
                ),

                child: SingleChildScrollView(
                  padding:
                  EdgeInsets.symmetric(
                    horizontal:
                    isTablet
                        ? 28
                        : 16,

                    vertical:
                    isTablet
                        ? 24
                        : 14,
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      /// TITLE
                      Padding(
                        padding:
                        const EdgeInsets.only(
                          left: 4,
                          bottom: 18,
                        ),

                        child: Text(
                          "Profile",

                          style: TextStyle(
                            fontSize:
                            isTablet
                                ? 30
                                : 25,

                            fontWeight:
                            FontWeight.w700,

                            color:
                            Colors.black,
                          ),
                        ),
                      ),

                      /// PROFILE CARD
                      Container(
                        padding:
                        const EdgeInsets.all(
                            10),

                        decoration:
                        BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                          BorderRadius
                              .circular(22),

                          boxShadow: [

                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                  0.04),

                              blurRadius: 14,

                              offset:
                              const Offset(
                                  0, 6),
                            ),
                          ],
                        ),

                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            /// IMAGE
                            isLoading

                                ? Shimmer.fromColors(

                              baseColor:
                              Colors.grey.shade300,

                              highlightColor:
                              Colors.grey.shade100,

                              child: Container(
                                width:
                                isTablet ? 74 : 62,

                                height:
                                isTablet ? 74 : 62,

                                decoration:
                                const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )

                                : Container(
                              width:
                              isTablet ? 74 : 62,

                              height:
                              isTablet ? 74 : 62,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                border: Border.all(
                                  color:
                                  Colors.grey.shade300,

                                  width: 1.5,
                                ),
                              ),

                              child: ClipOval(
                                child: (gymImage.trim().isNotEmpty &&
                                        gymImage.startsWith("http"))
                                    ? Image.network(
                                        gymImage.replaceAll(
                                            "127.0.0.1", "10.0.2.2"),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                _buildAvatarFallback(
                                                    name, isTablet),
                                      )
                                    : _buildAvatarFallback(name, isTablet),
                              ),
                            ),

                            const SizedBox(width: 16),

                            /// TEXTS
                            Expanded(
                              child: isLoading

                                  ? Shimmer.fromColors(

                                baseColor:
                                Colors.grey.shade300,

                                highlightColor:
                                Colors.grey.shade100,

                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,

                                  children: [

                                    Container(
                                      height: 18,
                                      width: 140,

                                      decoration:
                                      BoxDecoration(
                                        color: Colors.white,

                                        borderRadius:
                                        BorderRadius.circular(
                                            6),
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Container(
                                      height: 12,
                                      width: 100,

                                      decoration:
                                      BoxDecoration(
                                        color: Colors.white,

                                        borderRadius:
                                        BorderRadius.circular(
                                            6),
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    Container(
                                      height: 12,
                                      width: 180,

                                      decoration:
                                      BoxDecoration(
                                        color: Colors.white,

                                        borderRadius:
                                        BorderRadius.circular(
                                            6),
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Container(
                                      height: 12,
                                      width: 110,

                                      decoration:
                                      BoxDecoration(
                                        color: Colors.white,

                                        borderRadius:
                                        BorderRadius.circular(
                                            6),
                                      ),
                                    ),
                                  ],
                                ),
                              )

                                  : Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [

                                  Text(
                                    name.isNotEmpty ? name : "Gym Owner",

                                    style: TextStyle(
                                      fontSize:
                                      isTablet
                                          ? 22
                                          : 18,

                                      fontWeight:
                                      FontWeight.w700,

                                      color:
                                      Colors.black,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    gymName.isNotEmpty
                                        ? "Owner • $gymName"
                                        : "Owner • Setup Incomplete",

                                    style: TextStyle(
                                      fontSize:
                                      isTablet
                                          ? 14
                                          : 12.5,

                                      fontWeight:
                                      FontWeight.w600,

                                      color:
                                      gymName.isNotEmpty
                                          ? Colors.grey.shade700
                                          : const Color(0xFFD97706),
                                    ),
                                  ),

                                  if (email.isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    Text(
                                      email,
                                      style: TextStyle(
                                        fontSize:
                                        isTablet
                                            ? 13
                                            : 11.5,
                                        color:
                                        Colors.grey.shade600,
                                      ),
                                    ),
                                  ],

                                  if (mobile.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      mobile,
                                      style: TextStyle(
                                        fontSize:
                                        isTablet
                                            ? 13
                                            : 11.5,
                                        color:
                                        Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),

                      ),

                      if (gymName.isEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFDE68A),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.storefront_rounded,
                                  size: 20,
                                  color: Color(0xFFB45309),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Gym Setup Pending",
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF92400E),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      "Complete setup to manage gym details",
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: Color(0xFFB45309),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const CreateGymProfilePage(),
                                    ),
                                  );
                                  if (context.mounted) {
                                    context
                                        .read<GymProfileCubit>()
                                        .getGymProfile();
                                  }
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD97706),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    "Setup",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(
                          height: 18),

                      /// MENU CARD
                      Container(
                        decoration:
                        BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                          BorderRadius
                              .circular(22),

                          boxShadow: [

                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                  0.04),

                              blurRadius: 14,

                              offset:
                              const Offset(
                                  0, 6),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [

                            profileRow(
                              icon: Icons
                                  .badge_outlined,

                              title:
                              "Gym Details",

                                onTap: () {

                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (_) =>
                                      const GymDetailsPage(),
                                    ),
                                  );

                              },
                            ),

                            divider(),

                            profileRow(
                              icon: Icons
                                  .lock_outline,

                              title:
                              "Change Password",

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ChangePasswordPage(),
                                  ),
                                );
                              },
                            ),

                            divider(),

                            profileRow(
                              icon: Icons
                                  .notifications_none,

                              title:
                              "Notification Settings",

                              onTap: () {},
                            ),

                            divider(),

                            profileRow(
                              icon: Icons
                                  .payments,

                              title:
                              "Transaction Settings",

                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> TransactionDetailsPage()));
                              },
                            ),

                            divider(),

                            profileRow(
                              icon: Icons
                                  .help_outline,

                              title:
                              "Help & Support",

                              onTap: () {},
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          height: 18),

                      /// LOGOUT CARD
                      Container(
                        decoration:
                        BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                          BorderRadius
                              .circular(22),

                          boxShadow: [

                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                  0.04),

                              blurRadius: 14,

                              offset:
                              const Offset(
                                  0, 6),
                            ),
                          ],
                        ),

                        child: profileRow(
                          icon: Icons.logout,

                          title:
                          logoutLoading
                              ? "Logging out..."
                              : "Logout",

                          iconColor:
                          Colors.red,

                          titleColor:
                          Colors.red,

                          onTap:
                          logoutLoading
                              ? null
                              : logout,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget divider() {

    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade100,
    );
  }

  Widget profileRow({

    required IconData icon,
    required String title,

    Color? iconColor,
    Color? titleColor,

    VoidCallback? onTap,

  }) {

    return InkWell(
      borderRadius:
      BorderRadius.circular(16),

      onTap: onTap,

      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),

        child: Row(
          children: [

            /// ICON BOX
            Container(
              width: 38,
              height: 38,

              decoration:
              BoxDecoration(
                color: Colors
                    .grey.shade100,

                borderRadius:
                BorderRadius
                    .circular(12),
              ),

              child: Icon(
                icon,

                size: 20,

                color:
                iconColor ??
                    Colors.black87,
              ),
            ),

            const SizedBox(width: 14),

            /// TITLE
            Expanded(
              child: Text(
                title,

                style: TextStyle(
                  fontSize: 15.5,

                  fontWeight:
                  FontWeight.w600,

                  color:
                  titleColor ??
                      Colors.black87,
                ),
              ),
            ),

            /// ARROW
            Icon(
              Icons
                  .arrow_forward_ios_rounded,

              size: 15,

              color: Colors
                  .grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarFallback(String name, bool isTablet) {
    final initial = name.trim().isNotEmpty
        ? name.trim().substring(0, 1).toUpperCase()
        : "";
    return Container(
      width: isTablet ? 74 : 62,
      height: isTablet ? 74 : 62,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: initial.isNotEmpty
          ? Text(
              initial,
              style: TextStyle(
                fontSize: isTablet ? 28 : 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          : Icon(
              Icons.fitness_center_rounded,
              size: isTablet ? 32 : 26,
              color: Colors.white,
            ),
    );
  }
}