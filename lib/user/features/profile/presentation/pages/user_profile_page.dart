import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../cubit/user_profile_cubit.dart';
import '../cubit/user_profile_state.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() =>
      _UserProfilePageState();
}

class _UserProfilePageState
    extends State<UserProfilePage> {

  bool showLargeQr = false;

  bool get isTablet {

    final width =
        MediaQuery.of(context).size.width;

    return width > 600;
  }

  @override
  void initState() {
    super.initState();

    context
        .read<UserProfileCubit>()
        .getUserProfile();
  }

  Future<void> logout() async {

    final shouldLogout = await showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(24),
          ),

          title: const Text(
            "Logout",
          ),

          content: const Text(
            "Are you sure you want to logout?",
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text(
                "Cancel",
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text(
                "Logout",

                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {

      final prefs =
      await SharedPreferences.getInstance();

      /// CLEAR CACHE
      await context
          .read<UserProfileCubit>()
          .clearProfileCache();

      await prefs.clear();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final width =
        MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
      const Color(0xFFF5F7FB),

      body: SafeArea(
        child: BlocBuilder<
            UserProfileCubit,
            UserProfileState>(
          builder: (context, state) {

            /// LOADING
            if (state
            is UserProfileFetchingLoading) {

              return buildSkeletonLoader();
            }

            /// ERROR
            if (state
            is UserProfileError) {

              return Center(
                child: Text(
                  state.message,
                ),
              );
            }

            /// SUCCESS
            if (state
            is UserProfileDataSuccess) {

              final profile =
                  state.response.data;

              final lastAttendance =
              profile?.lastAttendanceDate == null
                  ? "Attendance not marked yet"
                  : DateFormat(
                'dd MMM yyyy • hh:mm a',
              ).format(
                DateTime.parse(
                  profile!.lastAttendanceDate!,
                ).toLocal(),
              );

              return RefreshIndicator(
                onRefresh: () async {

                  await context
                      .read<UserProfileCubit>()
                      .getUserProfile(
                    forceRefresh: true,
                  );
                },

                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                      isTablet
                          ? 700
                          : width,
                    ),

                    child: SingleChildScrollView(
                      physics:
                      const AlwaysScrollableScrollPhysics(),

                      padding:
                      EdgeInsets.symmetric(
                        horizontal:
                        isTablet
                            ? 30
                            : 20,

                        vertical:
                        isTablet
                            ? 28
                            : 18,
                      ),

                      child: Column(
                        children: [

                          /// HEADER
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                            children: [

                              Text(
                                "Profile",

                                style: TextStyle(
                                  fontSize:
                                  isTablet
                                      ? 38
                                      : 30,

                                  fontWeight:
                                  FontWeight
                                      .w700,

                                  color:
                                  const Color(
                                    0xFF111827,
                                  ),
                                ),
                              ),

                              GestureDetector(
                                onTap: logout,

                                child: Container(
                                  height:
                                  isTablet
                                      ? 58
                                      : 48,

                                  width:
                                  isTablet
                                      ? 58
                                      : 48,

                                  decoration:
                                  BoxDecoration(
                                    color: Colors.red
                                        .withOpacity(
                                      .08,
                                    ),

                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      18,
                                    ),
                                  ),

                                  child: const Icon(
                                    Icons
                                        .logout_rounded,

                                    color:
                                    Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height:
                            isTablet
                                ? 28
                                : 22,
                          ),

                          /// PROFILE CARD
                          Container(
                            width:
                            double.infinity,

                            padding:
                            EdgeInsets.all(
                              isTablet
                                  ? 34
                                  : 26,
                            ),

                            decoration:
                            BoxDecoration(
                              gradient:
                              const LinearGradient(
                                begin:
                                Alignment
                                    .topLeft,

                                end:
                                Alignment
                                    .bottomRight,

                                colors: [
                                  Color(
                                    0xFF22C55E,
                                  ),

                                  Color(
                                    0xFF16A34A,
                                  ),
                                ],
                              ),

                              borderRadius:
                              BorderRadius
                                  .circular(
                                36,
                              ),
                            ),

                            child: Column(
                              children: [

                                /// IMAGE
                                Hero(
                                  tag: "profile",

                                  child:
                                  Container(
                                    height:
                                    isTablet
                                        ? 150
                                        : 120,

                                    width:
                                    isTablet
                                        ? 150
                                        : 120,

                                    decoration:
                                    BoxDecoration(
                                      shape:
                                      BoxShape
                                          .circle,

                                      border:
                                      Border
                                          .all(
                                        color:
                                        Colors
                                            .white,

                                        width:
                                        5,
                                      ),

                                      image:
                                      DecorationImage(
                                        image:
                                        NetworkImage(
                                          profile?.profilePhoto ??
                                              "",
                                        ),

                                        fit:
                                        BoxFit
                                            .cover,
                                      ),

                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                          Colors
                                              .black
                                              .withOpacity(
                                            .15,
                                          ),

                                          blurRadius:
                                          20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height:
                                  isTablet
                                      ? 26
                                      : 20,
                                ),

                                Text(
                                  profile
                                      ?.user
                                      ?.name ??
                                      "",

                                  style:
                                  TextStyle(
                                    fontSize:
                                    isTablet
                                        ? 34
                                        : 28,

                                    fontWeight:
                                    FontWeight
                                        .w700,

                                    color:
                                    Colors
                                        .white,
                                  ),
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                Text(
                                  "+91 ${profile?.user?.mobNo ?? ""}",

                                  style:
                                  TextStyle(
                                    fontSize:
                                    isTablet
                                        ? 18
                                        : 16,

                                    color:
                                    Colors
                                        .white70,

                                    fontWeight:
                                    FontWeight
                                        .w500,
                                  ),
                                ),

                                SizedBox(
                                  height:
                                  isTablet
                                      ? 24
                                      : 20,
                                ),

                                Container(
                                  padding:
                                  const EdgeInsets
                                      .symmetric(
                                    horizontal:
                                    18,

                                    vertical: 10,
                                  ),

                                  decoration:
                                  BoxDecoration(
                                    color:
                                    Colors
                                        .white
                                        .withOpacity(
                                      .16,
                                    ),

                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      18,
                                    ),
                                  ),

                                  child: Row(
                                    mainAxisSize:
                                    MainAxisSize
                                        .min,

                                    children: [

                                      const Icon(
                                        Icons
                                            .workspace_premium_rounded,

                                        color:
                                        Colors
                                            .white,

                                        size: 20,
                                      ),

                                      const SizedBox(
                                        width: 8,
                                      ),

                                      Text(
                                        profile
                                            ?.plan
                                            ?.planName ??
                                            "",

                                        style:
                                        const TextStyle(
                                          color:
                                          Colors
                                              .white,

                                          fontWeight:
                                          FontWeight
                                              .w700,

                                          fontSize:
                                          15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height:
                            isTablet
                                ? 26
                                : 20,
                          ),

                          /// LAST ATTENDANCE
                          Container(
                            width:
                            double.infinity,

                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal:
                              20,

                              vertical:
                              18,
                            ),

                            decoration:
                            BoxDecoration(
                              color:
                              Colors.white,

                              borderRadius:
                              BorderRadius
                                  .circular(
                                26,
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color:
                                  Colors
                                      .black
                                      .withOpacity(
                                    .03,
                                  ),

                                  blurRadius:
                                  12,
                                ),
                              ],
                            ),

                            child: Row(
                              children: [

                                Container(
                                  height: 58,
                                  width: 58,

                                  decoration:
                                  BoxDecoration(
                                    color:
                                    const Color(
                                      0xFFEFF8F1,
                                    ),

                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      18,
                                    ),
                                  ),

                                  child:
                                  const Icon(
                                    Icons
                                        .calendar_today_rounded,

                                    color:
                                    Color(
                                      0xFF22C55E,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  width: 16,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                    children: [

                                      const Text(
                                        "Last Attendance",

                                        style:
                                        TextStyle(
                                          fontSize:
                                          14,

                                          color:
                                          Color(
                                            0xFF6B7280,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 4,
                                      ),

                                      Text(
                                        lastAttendance,

                                        style:
                                        const TextStyle(
                                          fontSize:
                                          17,

                                          fontWeight:
                                          FontWeight
                                              .w700,

                                          color:
                                          Color(
                                            0xFF111827,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height:
                            isTablet
                                ? 26
                                : 20,
                          ),

                          /// QR CARD
                          GestureDetector(
                            onTap: () {

                              setState(() {
                                showLargeQr =
                                !showLargeQr;
                              });
                            },

                            child:
                            AnimatedContainer(
                              duration:
                              const Duration(
                                milliseconds:
                                350,
                              ),

                              width:
                              double.infinity,

                              padding:
                              EdgeInsets.all(
                                isTablet
                                    ? 30
                                    : 24,
                              ),

                              decoration:
                              BoxDecoration(
                                color:
                                Colors.white,

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  36,
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Colors
                                        .black
                                        .withOpacity(
                                      .04,
                                    ),

                                    blurRadius:
                                    20,
                                  ),
                                ],
                              ),

                              child: Column(
                                children: [

                                  Container(
                                    height:
                                    isTablet
                                        ? 82
                                        : 72,

                                    width:
                                    isTablet
                                        ? 82
                                        : 72,

                                    decoration:
                                    const BoxDecoration(
                                      color:
                                      Color(
                                        0xFFEFF8F1,
                                      ),

                                      shape:
                                      BoxShape
                                          .circle,
                                    ),

                                    child:
                                    const Icon(
                                      Icons
                                          .qr_code_scanner_rounded,

                                      color:
                                      Color(
                                        0xFF22C55E,
                                      ),

                                      size: 38,
                                    ),
                                  ),

                                  SizedBox(
                                    height:
                                    isTablet
                                        ? 22
                                        : 18,
                                  ),

                                  Text(
                                    showLargeQr
                                        ? "Your Attendance QR"
                                        : "Tap To Show QR",

                                    style:
                                    TextStyle(
                                      fontSize:
                                      isTablet
                                          ? 32
                                          : 28,

                                      fontWeight:
                                      FontWeight
                                          .w700,

                                      color:
                                      const Color(
                                        0xFF111827,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 8,
                                  ),

                                  const Text(
                                    "Show this QR at gym entrance",

                                    textAlign:
                                    TextAlign
                                        .center,

                                    style:
                                    TextStyle(
                                      color:
                                      Color(
                                        0xFF6B7280,
                                      ),

                                      fontSize:
                                      15,

                                      height:
                                      1.5,
                                    ),
                                  ),

                                  SizedBox(
                                    height:
                                    isTablet
                                        ? 30
                                        : 24,
                                  ),

                                  AnimatedContainer(
                                    duration:
                                    const Duration(
                                      milliseconds:
                                      350,
                                    ),

                                    height:
                                    showLargeQr
                                        ? (isTablet
                                        ? 420
                                        : 320)
                                        : (isTablet
                                        ? 280
                                        : 220),

                                    width:
                                    showLargeQr
                                        ? (isTablet
                                        ? 420
                                        : 320)
                                        : (isTablet
                                        ? 280
                                        : 220),

                                    padding:
                                    const EdgeInsets
                                        .all(
                                      18,
                                    ),

                                    decoration:
                                    BoxDecoration(
                                      color:
                                      Colors.white,

                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                        32,
                                      ),

                                      border:
                                      Border.all(
                                        color:
                                        const Color(
                                          0xFF22C55E,
                                        ),

                                        width:
                                        3,
                                      ),
                                    ),

                                    child: Center(
                                      child:
                                      // QrImageView(
                                      //   data:
                                      //   profile?.qrToken ??
                                      //       "",
                                      //
                                      //   version:
                                      //   QrVersions
                                      //       .auto,
                                      //
                                      //   backgroundColor:
                                      //   Colors
                                      //       .white,
                                      // ),

                                      QrImageView(
                                        data: profile?.qrToken ?? "",

                                        version: QrVersions.auto,

                                        backgroundColor: Colors.white,

                                        eyeStyle: const QrEyeStyle(
                                          eyeShape: QrEyeShape.square,
                                          color: Color(0xFF111827),
                                        ),

                                        dataModuleStyle: const QrDataModuleStyle(
                                          dataModuleShape: QrDataModuleShape.square,
                                          color: Color(0xFF111827),
                                        ),
                                      )

                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget buildSkeletonLoader() {

    return Shimmer.fromColors(
      baseColor:
      Colors.grey.shade300,

      highlightColor:
      Colors.grey.shade100,

      child: SingleChildScrollView(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),

        child: Column(
          children: [

            Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,

              children: [

                Container(
                  height: 34,
                  width: 140,

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      12,
                    ),
                  ),
                ),

                Container(
                  height: 50,
                  width: 50,

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              height: 320,

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  36,
                ),
              ),
            ),

            const SizedBox(height: 22),

            Container(
              width: double.infinity,
              height: 100,

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  26,
                ),
              ),
            ),

            const SizedBox(height: 22),

            Container(
              width: double.infinity,
              height: 420,

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  36,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}