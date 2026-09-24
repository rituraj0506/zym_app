import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zymmanagement/owner/features/profile/presentation/pages/create_gym_profile_page.dart';
import 'package:zymmanagement/owner/features/profile/presentation/pages/update_gym_profile_page.dart';
import 'package:zymmanagement/theme/app_colors.dart';

import '../cubit/gym_profile_cubit.dart';
import '../cubit/gym_profile_state.dart';

class GymDetailsPage extends StatelessWidget {
  const GymDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final bool isTablet =
        size.width >= 700;

    return Scaffold(
      backgroundColor:
      const Color(0xFFF5F6FA),

      appBar: AppBar(
        elevation: 0,

        backgroundColor:
        Colors.transparent,

        foregroundColor:
        Colors.black,

        centerTitle: true,

        title: const Text(
          "Gym Details",

          style: TextStyle(
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body: BlocBuilder<
          GymProfileCubit,
          GymProfileState>(

        builder: (context, state) {
          if (state is GymProfileFetchingLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is! GymProfileDataSuccess || state.profile.data == null) {
            return Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.storefront_rounded,
                        size: 46,
                        color: Color(0xFF6D28D9),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Complete Gym Setup",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Complete your gym profile setup to view and manage gym details.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateGymProfilePage(),
                          ),
                        );
                        if (context.mounted) {
                          context.read<GymProfileCubit>().getGymProfile();
                        }
                      },
                      icon: const Icon(Icons.add_business_rounded, size: 20),
                      label: const Text(
                        "Complete Gym Setup",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6D28D9),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () {
                        context.read<GymProfileCubit>().getGymProfile();
                      },
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text("Refresh"),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final gym =
              state.profile.data;

          return SingleChildScrollView(
            padding:
            EdgeInsets.symmetric(
              horizontal:
              isTablet ? 28 : 16,

              vertical:
              isTablet ? 24 : 14,
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                /// OWNER + EDIT CARD
                Container(
                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF8B5CF6),
                        Color(0xFF6D28D9),
                      ],
                    ),

                    borderRadius:
                    BorderRadius.circular(30),

                    boxShadow: [

                      BoxShadow(
                        color: Colors.deepPurple
                            .withOpacity(.22),

                        blurRadius: 22,

                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [

                      /// OWNER IMAGE
                      Container(
                        width: 74,
                        height: 74,

                        decoration:
                        BoxDecoration(
                          color: Colors.white24,

                          shape: BoxShape.circle,

                          border: Border.all(
                            color: Colors.white30,
                            width: 2,
                          ),
                        ),

                        child: const Icon(
                          Icons.person,

                          size: 38,

                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 16),

                      /// OWNER DETAILS
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            const Text(
                              "Gym Owner",

                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              gym?.owner?.name ?? "",

                              style: TextStyle(
                                fontSize:
                                isTablet ? 24 : 20,

                                fontWeight:
                                FontWeight.bold,

                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [

                                const Icon(
                                  Icons.email_outlined,

                                  size: 15,

                                  color: Colors.white70,
                                ),

                                const SizedBox(width: 6),

                                Expanded(
                                  child: Text(
                                    gym?.owner?.email ?? "",

                                    overflow:
                                    TextOverflow.ellipsis,

                                    style:
                                    const TextStyle(
                                      color:
                                      Colors.white70,

                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 5),

                            Row(
                              children: [

                                const Icon(
                                  Icons.phone,

                                  size: 15,

                                  color: Colors.white70,
                                ),

                                const SizedBox(width: 6),

                                Text(
                                  gym?.owner?.mobNo
                                      ?.toString() ??
                                      "",

                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.white70,

                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// EDIT BUTTON
                      GestureDetector(
                        onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateGymProfilePage()));
                          
                        },

                        child: Container(
                          width: 46,
                          height: 46,

                          decoration:
                          BoxDecoration(
                            color: Colors.white,

                            borderRadius:
                            BorderRadius.circular(
                                16),
                          ),

                          child: const Icon(
                            Icons.edit_outlined,

                            color:
                            Color(0xFF6D28D9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                /// GYM IMAGE CARD
                Stack(
                  children: [

                    Container(
                      width: double.infinity,

                      height:
                      isTablet ? 300 : 230,

                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(30),

                        boxShadow: [

                          BoxShadow(
                            color: Colors.black
                                .withOpacity(.08),

                            blurRadius: 18,

                            offset:
                            const Offset(0, 8),
                          ),
                        ],
                      ),

                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(30),

                        child: ((gym?.gymImage ?? "").trim().isNotEmpty &&
                                (gym?.gymImage ?? "").startsWith("http"))
                            ? Image.network(
                                (gym?.gymImage ?? "")
                                    .replaceAll("127.0.0.1", "10.0.2.2"),

                                fit: BoxFit.cover,

                                errorBuilder:
                                    (
                                    context,
                                    error,
                                    stackTrace,
                                    ) {

                                  return Container(
                                    color: Colors.white,

                                    child: const Icon(
                                      Icons.fitness_center,

                                      size: 80,

                                      color:
                                      Colors.deepPurple,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: Colors.white,
                                child: const Icon(
                                  Icons.fitness_center,
                                  size: 80,
                                  color: Colors.deepPurple,
                                ),
                              ),
                      ),
                    ),

                    /// DARK OVERLAY
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              30),

                          gradient:
                          LinearGradient(
                            begin:
                            Alignment.topCenter,

                            end:
                            Alignment.bottomCenter,

                            colors: [

                              Colors.transparent,

                              Colors.black
                                  .withOpacity(.55),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// GYM NAME
                    Positioned(
                      left: 22,
                      right: 22,
                      bottom: 22,

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Text(
                            gym?.gymName ?? "",

                            style: TextStyle(
                              fontSize:
                              isTablet ? 34 : 28,

                              fontWeight:
                              FontWeight.w800,

                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [

                              const Icon(
                                Icons.location_on,

                                color: Colors.white70,

                                size: 18,
                              ),

                              const SizedBox(width: 4),

                              Expanded(
                                child: Text(
                                  "${gym?.address}, ${gym?.city}, ${gym?.state}",

                                  style: const TextStyle(
                                    color:
                                    Colors.white70,

                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                /// INFO CARD
                Container(
                  padding:
                  const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(28),

                    boxShadow: [

                      BoxShadow(
                        color:
                        Colors.black.withOpacity(.04),

                        blurRadius: 14,

                        offset:
                        const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [

                      buildInfoTile(
                        icon: Icons.description,

                        title: "Description",

                        value:
                        gym?.description ?? "-",
                      ),

                      divider(),

                      buildInfoTile(
                        icon: Icons.pin_drop,

                        title: "Pincode",

                        value:
                        gym?.pincode ?? "-",
                      ),

                      divider(),

                      buildInfoTile(
                        icon: Icons.access_time,

                        title: "Opening Time",

                        value:
                        gym?.openingTime ?? "-",
                      ),

                      divider(),

                      buildInfoTile(
                        icon:
                        Icons.access_time_filled,

                        title: "Closing Time",

                        value:
                        gym?.closingTime ?? "-",
                      ),

                      divider(),

                      buildInfoTile(
                        icon:
                        Icons.calendar_today,

                        title: "Created At",

                        value:
                        gym?.createdAt?.toLocal().toString().split(' ')[0] ?? "-"
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget divider() {

    return Padding(
      padding:
      const EdgeInsets.symmetric(
          vertical: 14),

      child: Divider(
        height: 1,

        thickness: 1,

        color: Colors.grey.shade100,
      ),
    );
  }

  Widget buildInfoTile({

    required IconData icon,
    required String title,
    required String value,

  }) {

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color:
            Colors.deepPurple
                .withOpacity(.08),

            borderRadius:
            BorderRadius.circular(
                14),
          ),

          child: Icon(
            icon,

            color:
            Colors.deepPurple,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Text(
                title,

                style: TextStyle(
                  fontSize: 13,

                  color:
                  Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,

                style: const TextStyle(
                  fontSize: 16,

                  fontWeight:
                  FontWeight.w600,

                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}