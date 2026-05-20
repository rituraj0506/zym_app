import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zymmanagement/theme/app_colors.dart';
import '../../../plan/presentation/pages/add_plan__page.dart';
import '../../../plan/presentation/pages/plan_details_page.dart';
import '../../../profile/presentation/pages/create_gym_profile_page.dart';
import '../cubit/owner_dashboard_cubit.dart';
import '../cubit/owner_dashboard_state.dart';


class OwnerDashboardPage extends StatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  State<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends State<OwnerDashboardPage> {


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      context
          .read<OwnerDashboardCubit>()
          .initializeDashboard();

    });
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isTablet = width >= 700;

    return BlocBuilder<OwnerDashboardCubit, OwnerDashboardState>(
      builder: (context, state) {
        /// LOADING
        if (state is OwnerDashboardLoading) {
          return Scaffold(
            backgroundColor: AppColors.background,

            body: const Center(child: CircularProgressIndicator()),
          );
        }

        /// ERROR
        if (state is OwnerDashboardError) {
          return Scaffold(
            backgroundColor: AppColors.background,

            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 70,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 18),

                    Text(state.message, textAlign: TextAlign.center),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        context.read<OwnerDashboardCubit>().getDashboardData();
                      },

                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        /// LOADED
        if (state is OwnerDashboardLoaded) {
          final dashboardData = state.dashboardData;

          final isGymSetupComplete = state.isGymSetupComplete;

          return Scaffold(
            backgroundColor: AppColors.background,

            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<OwnerDashboardCubit>().getDashboardData();
                },

                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),

                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 28 : 18,

                    vertical: isTablet ? 24 : 18,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// HEADER
                      Row(
                        children: [
                          CircleAvatar(
                            radius: isTablet ? 32 : 26,

                            backgroundColor: AppColors.primaryLight,

                            // backgroundImage:
                            //     dashboardData.data?.gym?.gymImage != null
                            //     ? NetworkImage(
                            //         dashboardData.data?.gym?.gymImage ?? "",
                            //       )
                            //     : null,


                  backgroundImage: NetworkImage(

                  (dashboardData?.data?.gym?.gymImage ?? "")
                      .replaceAll(
                    "127.0.0.1",
                    "10.0.2.2",
                  ),

                ),



              child: dashboardData.data?.gym?.gymImage == null
                                ? const Icon(
                                    Icons.storefront_rounded,

                                    color: AppColors.primary,
                                  )
                                : null,
                          ),

                          SizedBox(width: isTablet ? 16 : 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  "Hello, ${dashboardData.data?.owner?.name ?? "Owner"} 👋",

                                  style: TextStyle(
                                    fontSize: isTablet ? 24 : 18,

                                    fontWeight: FontWeight.bold,

                                    color: AppColors.textPrimary,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  dashboardData.data?.gym?.gymName ??
                                      "Setup Your Gym",

                                  style: TextStyle(
                                    fontSize: isTablet ? 15 : 13,

                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            height: isTablet ? 56 : 48,

                            width: isTablet ? 56 : 48,

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.circular(16),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.04),

                                  blurRadius: 14,
                                ),
                              ],
                            ),

                            child: const Icon(Icons.notifications_none_rounded),
                          ),
                        ],
                      ),

                      SizedBox(height: isTablet ? 28 : 22),

                      /// COMPLETE SETUP CARD
                      if (!isGymSetupComplete)
                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.all(22),

                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                            ),

                            borderRadius: BorderRadius.circular(28),

                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(.25),

                                blurRadius: 25,

                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 58,

                                    width: 58,

                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.15),

                                      borderRadius: BorderRadius.circular(18),
                                    ),

                                    child: const Icon(
                                      Icons.storefront_rounded,

                                      color: Colors.white,

                                      size: 30,
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        const Text(
                                          "Complete Your Gym Setup",

                                          style: TextStyle(
                                            color: Colors.white,

                                            fontSize: 18,

                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        Text(
                                          "Add gym details to start managing members",

                                          style: TextStyle(
                                            color: Colors.white.withOpacity(.9),

                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              SizedBox(
                                width: double.infinity,

                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,

                                      MaterialPageRoute(
                                        builder: (_) =>
                                        const CreateGymProfilePage(),
                                      ),
                                    );
                                  },

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,

                                    elevation: 0,

                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),

                                  child: const Text(
                                    "Complete Setup",

                                    style: TextStyle(
                                      color: AppColors.primary,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      /// ATTENDANCE CARD
                      Container(
                        width: double.infinity,

                        padding: EdgeInsets.all(isTablet ? 28 : 22),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),

                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,

                            end: Alignment.bottomRight,

                            colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(.35),

                              blurRadius: 25,

                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Today's Attendance",

                              style: TextStyle(
                                color: Colors.white,

                                fontSize: isTablet ? 18 : 14,

                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            SizedBox(height: isTablet ? 20 : 14),

                            Text(
                              "${dashboardData.data?.stats?.presentInsideGym ?? 0}",

                              style: TextStyle(
                                color: Colors.white,

                                fontSize: isTablet ? 52 : 40,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: isTablet ? 12 : 8),

                            Text(
                              "Members Present",

                              style: TextStyle(
                                color: Colors.white.withOpacity(.9),

                                fontSize: isTablet ? 16 : 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// STATS GRID
                      GridView.count(
                        crossAxisCount: isTablet ? 4 : 2,

                        mainAxisSpacing: 16,

                        crossAxisSpacing: 16,

                        mainAxisExtent: isTablet ? 180 : 155,

                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        children: [
                          statCard(
                            icon: Icons.groups_rounded,

                            iconColor: Colors.purple,

                            iconBg: Colors.purple.shade50,

                            title: "Total Members",

                            value:
                                "${dashboardData.data?.stats?.totalMembers ?? 0}",
                          ),

                          statCard(
                            icon: Icons.person,

                            iconColor: Colors.blue,

                            iconBg: Colors.blue.shade50,

                            title: "Active Members",

                            value:
                                "${dashboardData.data?.stats?.activeMembers ?? 0}",
                          ),

                          statCard(
                            icon: Icons.event_busy,

                            iconColor: Colors.green,

                            iconBg: Colors.green.shade50,

                            title: "Expired Plans",

                            value:
                                "${dashboardData.data?.stats?.expiredPlans ?? 0}",
                          ),

                          statCard(
                            icon: Icons.fact_check_outlined,

                            iconColor: Colors.red,

                            iconBg: Colors.red.shade50,

                            title: "Check-ins Today",

                            value:
                                "${dashboardData.data?.stats?.checkInsToday ?? 0}",
                          ),
                        ],
                      ),

                      SizedBox(height: isTablet ? 32 : 26),

                      /// QUICK ACTIONS
                      Text(
                        "Quick Actions",

                        style: TextStyle(
                          fontSize: isTablet ? 22 : 18,

                          fontWeight: FontWeight.bold,

                          color: AppColors.textPrimary,
                        ),
                      ),

                      SizedBox(height: isTablet ? 22 : 18),

                      GridView.count(
                        crossAxisCount: isTablet ? 4 : 2,

                        mainAxisSpacing: 16,

                        crossAxisSpacing: 16,

                        mainAxisExtent: isTablet ? 150 : 130,

                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        children: [
                          quickActionCard(
                            icon: Icons.workspace_premium_rounded,

                            title: "Add Plan",

                            onTap: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) => const AddPlanPage(),
                                ),
                              );
                            },
                          ),

                          quickActionCard(
                            icon: Icons.person_add_alt_1,

                            title: "Add Member",

                            onTap: () {},
                          ),

                          quickActionCard(
                            icon: Icons.description_outlined,

                            title: "Plans",

                            onTap: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) => const PlanDetailsPage(),
                                ),
                              );
                            },
                          ),

                          quickActionCard(
                            icon: Icons.groups_2_rounded,

                            title: "Members",

                            onTap: () {},
                          ),


                        ],
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget statCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 18),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: iconBg,

              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, color: iconColor, size: 22),
          ),

          const SizedBox(height: 14),

          Text(
            title,

            maxLines: 2,

            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              fontSize: 12,

              color: AppColors.textSecondary,
            ),
          ),

          const Spacer(),

          Text(
            value,

            style: const TextStyle(
              fontSize: 20,

              fontWeight: FontWeight.bold,

              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget quickActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(22),

          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 18),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.08),

                borderRadius: BorderRadius.circular(18),
              ),

              child: Icon(icon, color: AppColors.primary, size: 28),
            ),

            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),

              child: Text(
                title,

                textAlign: TextAlign.center,

                maxLines: 2,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontWeight: FontWeight.w600,

                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
