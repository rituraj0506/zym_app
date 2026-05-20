import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../network/secure_storge.dart';
import '../../../home/presentation/cubit/owner_dashboard_cubit.dart';
import '../cubit/gym_profile_cubit.dart';
import '../cubit/gym_profile_state.dart';
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

    /// CLEAR DASHBOARD
    context
        .read<OwnerDashboardCubit>()
        .clearDashboard();

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
                                child: gymImage.isNotEmpty

                                    ? Image.network(
                                  gymImage,
                                  fit: BoxFit.cover,
                                )

                                    : Image.asset(
                                  "assets/images/profile.png",
                                  fit: BoxFit.cover,
                                ),
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
                                    name,

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
                                    "Owner • $gymName",

                                    style: TextStyle(
                                      fontSize:
                                      isTablet
                                          ? 14
                                          : 12.5,

                                      fontWeight:
                                      FontWeight.w500,

                                      color:
                                      Colors.grey.shade700,
                                    ),
                                  ),

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
                              ),
                            ),
                          ],
                        ),

                      ),

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

                              onTap: () {},
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
}