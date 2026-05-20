import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zymmanagement/theme/app_colors.dart';
import '../../../../models/gym_plan_response.dart';
import '../cubit/plan_cubit.dart';
import '../cubit/plan_state.dart';
import 'add_plan__page.dart';

class PlanDetailsPage extends StatefulWidget {
  const PlanDetailsPage({super.key});

  @override
  State<PlanDetailsPage> createState() =>
      _PlanDetailsPageState();
}

class _PlanDetailsPageState
    extends State<PlanDetailsPage> {

  @override
  void initState() {
    super.initState();

    context.read<PlanCubit>().getAllPlans();
  }

  Color getCardColor(int index) {

    final colors = [
      const Color(0xFF8B5CF6),
      const Color(0xFF3B82F6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
    ];

    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {

    final width =
        MediaQuery.of(context).size.width;

    final bool isTablet = width >= 700;

    return BlocConsumer<PlanCubit, PlanState>(

      listener: (context, state) {

        if (state is PlanDetailsError) {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },

      builder: (context, state) {

        final isLoading =
        state is PlanDetailsLoading;

        final plans =
        state is PlanDetailsLoaded
            ? state.plans.data ?? []
            : <GymPlan>[];

        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),

          floatingActionButton:
          FloatingActionButton.extended(

            backgroundColor:
            AppColors.primary,

            elevation: 0,

            onPressed: () {

              Navigator.pushNamed(
                context,
                "/addPlan",
              );
            },

            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),

            label: const Text(
              "Add Plan",

              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          body: SafeArea(
            child: RefreshIndicator(

              color: AppColors.primary,

              onRefresh: () async {
                context
                    .read<PlanCubit>()
                    .getAllPlans();
              },

              child: SingleChildScrollView(

                physics:
                const AlwaysScrollableScrollPhysics(),

                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 28 : 18,
                  vertical: isTablet ? 24 : 18,
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    /// HEADER
                    Row(
                      children: [

                        Container(
                          height:
                          isTablet ? 54 : 48,

                          width:
                          isTablet ? 54 : 48,

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius:
                            BorderRadius.circular(
                                16),

                            boxShadow: [
                              BoxShadow(
                                color: AppColors
                                    .primary
                                    .withOpacity(.08),

                                blurRadius: 22,
                                offset:
                                const Offset(
                                    0, 8),
                              ),
                            ],
                          ),

                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(
                                  context);
                            },

                            icon: const Icon(
                              Icons
                                  .arrow_back_ios_new,
                              size: 20,
                            ),
                          ),
                        ),

                        SizedBox(
                            width:
                            isTablet
                                ? 18
                                : 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [

                              Text(
                                "Plan Management",

                                style: TextStyle(
                                  fontSize:
                                  isTablet
                                      ? 26
                                      : 21,

                                  fontWeight:
                                  FontWeight.w700,

                                  color: AppColors
                                      .textPrimary,
                                ),
                              ),

                              const SizedBox(
                                  height: 4),

                              Text(
                                "Manage gym membership plans",

                                style: TextStyle(
                                  fontSize:
                                  isTablet
                                      ? 15
                                      : 13,

                                  color: AppColors
                                      .textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height:
                      isTablet ? 34 : 28,
                    ),

                    /// SUMMARY CARD
                    Container(
                      width: double.infinity,

                      padding: EdgeInsets.all(
                        isTablet ? 28 : 22,
                      ),

                      decoration: BoxDecoration(

                        borderRadius:
                        BorderRadius.circular(
                            30),

                        gradient:
                        const LinearGradient(

                          begin:
                          Alignment.topLeft,

                          end: Alignment
                              .bottomRight,

                          colors: [
                            Color(0xFF8B5CF6),
                            Color(0xFF6D28D9),
                          ],
                        ),

                        boxShadow: [

                          BoxShadow(
                            color: AppColors
                                .primary
                                .withOpacity(.28),

                            blurRadius: 30,

                            offset:
                            const Offset(
                                0, 12),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Text(
                            "Total Plans",

                            style: TextStyle(
                              color: Colors.white
                                  .withOpacity(.9),

                              fontSize:
                              isTablet
                                  ? 16
                                  : 13,

                              fontWeight:
                              FontWeight.w500,
                            ),
                          ),

                          SizedBox(
                            height:
                            isTablet
                                ? 16
                                : 10,
                          ),

                          Text(
                            "${plans.length}",

                            style: TextStyle(
                              color: Colors.white,

                              fontSize:
                              isTablet
                                  ? 42
                                  : 34,

                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),

                          SizedBox(
                            height:
                            isTablet
                                ? 22
                                : 18,
                          ),

                          Row(
                            children: [

                              Expanded(
                                child: summaryItem(
                                  title: "Plans",
                                  value:
                                  "${plans.length}",
                                ),
                              ),

                              Expanded(
                                child: summaryItem(
                                  title: "Active",
                                  value:
                                  "${plans.where((e) => e.isActive == true).length}",
                                ),
                              ),

                              Expanded(
                                child: summaryItem(
                                  title: "Inactive",
                                  value:
                                  "${plans.where((e) => e.isActive == false).length}",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height:
                      isTablet ? 34 : 28,
                    ),

                    /// SECTION TITLE
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                      children: [

                        Text(
                          "All Plans",

                          style: TextStyle(
                            fontSize:
                            isTablet
                                ? 24
                                : 20,

                            fontWeight:
                            FontWeight.w700,

                            color: AppColors
                                .textPrimary,
                          ),
                        ),

                        Container(
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),

                          decoration:
                          BoxDecoration(
                            color: AppColors
                                .primary
                                .withOpacity(.08),

                            borderRadius:
                            BorderRadius
                                .circular(30),
                          ),

                          child: Text(
                            "${plans.length} Plans",

                            style:
                            const TextStyle(
                              color:
                              AppColors
                                  .primary,

                              fontWeight:
                              FontWeight
                                  .w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height:
                      isTablet ? 24 : 18,
                    ),

                    /// LOADING
                    if (isLoading)
                      const Padding(
                        padding:
                        EdgeInsets.only(
                            top: 100),
                        child: Center(
                          child:
                          CircularProgressIndicator(),
                        ),
                      ),

                    /// NO DATA
                    if (!isLoading &&
                        plans.isEmpty)
                      Container(

                        width: double.infinity,

                        padding:
                        const EdgeInsets.all(
                            30),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                          BorderRadius.circular(
                              28),
                        ),

                        child: Column(
                          children: [

                            Icon(
                              Icons
                                  .inventory_2_outlined,

                              size: 80,

                              color: AppColors
                                  .primary
                                  .withOpacity(.5),
                            ),

                            const SizedBox(
                                height: 18),

                            const Text(
                              "No Plans Found",

                              style: TextStyle(
                                fontSize: 22,
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),

                            const SizedBox(
                                height: 10),

                            const Text(
                              "Add your first gym membership plan",

                              textAlign:
                              TextAlign.center,

                              style: TextStyle(
                                color: AppColors
                                    .textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                    /// PLAN LIST
                    if (!isLoading &&
                        plans.isNotEmpty)
                      ListView.builder(

                        shrinkWrap: true,

                        physics:
                        const NeverScrollableScrollPhysics(),

                        itemCount: plans.length,

                        itemBuilder:
                            (context, index) {

                          final plan =
                          plans[index];

                          final color =
                          getCardColor(index);

                          return Container(

                            margin:
                            const EdgeInsets.only(
                              bottom: 18,
                            ),

                            padding:
                            EdgeInsets.all(
                              isTablet
                                  ? 22
                                  : 18,
                            ),

                            decoration:
                            BoxDecoration(

                              color:
                              Colors.white,

                              borderRadius:
                              BorderRadius
                                  .circular(
                                  26),

                              border:
                              Border.all(
                                color:
                                const Color(
                                    0xFFF0F0F5),
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color:
                                  AppColors
                                      .primary
                                      .withOpacity(
                                      .06),

                                  blurRadius:
                                  24,

                                  offset:
                                  const Offset(
                                      0,
                                      10),
                                ),
                              ],
                            ),

                            child: Row(
                              children: [

                                Container(
                                  width: 6,

                                  height:
                                  isTablet
                                      ? 120
                                      : 105,

                                  decoration:
                                  BoxDecoration(
                                    color:
                                    color,

                                    borderRadius:
                                    BorderRadius.circular(
                                        20),
                                  ),
                                ),

                                SizedBox(
                                  width:
                                  isTablet
                                      ? 20
                                      : 16,
                                ),

                                Expanded(
                                  child: Column(

                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                    children: [

                                      Row(
                                        children: [

                                          Expanded(
                                            child:
                                            Text(
                                              plan.planName ?? "",

                                              maxLines:
                                              1,

                                              overflow:
                                              TextOverflow
                                                  .ellipsis,

                                              style:
                                              TextStyle(
                                                fontSize:
                                                isTablet
                                                    ? 22
                                                    : 18,

                                                fontWeight:
                                                FontWeight.bold,

                                                color:
                                                AppColors.textPrimary,
                                              ),
                                            ),
                                          ),

                                          PopupMenuButton(

                                            onSelected:
                                                (value) {

                                              if (value ==
                                                  "delete") {

                                                confirmDelete(
                                                  plan.id ?? "",
                                                  plan.planName ?? "",
                                                );
                                              }

                                              if (value ==
                                                  "edit") {

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => AddPlanPage(
                                                      plan: plan,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },

                                            itemBuilder:
                                                (context) =>
                                            [

                                              const PopupMenuItem(
                                                value:
                                                "edit",

                                                child:
                                                Text(
                                                  "Edit Plan",
                                                ),
                                              ),

                                              const PopupMenuItem(
                                                value:
                                                "delete",

                                                child:
                                                Text(
                                                  "Delete Plan",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                        height:
                                        isTablet
                                            ? 12
                                            : 8,
                                      ),

                                      Text(
                                        "${plan.durationInMonths ?? 0} Month Duration",

                                        style:
                                        TextStyle(
                                          fontSize:
                                          isTablet
                                              ? 15
                                              : 13,

                                          color:
                                          AppColors
                                              .textSecondary,
                                        ),
                                      ),

                                      if (plan.description !=
                                          null)
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(
                                            top: 8,
                                          ),

                                          child:
                                          Text(
                                            plan.description ?? "",

                                            maxLines:
                                            2,

                                            overflow:
                                            TextOverflow
                                                .ellipsis,

                                            style:
                                            TextStyle(
                                              fontSize:
                                              isTablet
                                                  ? 14
                                                  : 12,

                                              color:
                                              AppColors
                                                  .textSecondary,
                                            ),
                                          ),
                                        ),

                                      SizedBox(
                                        height:
                                        isTablet
                                            ? 16
                                            : 12,
                                      ),

                                      Container(
                                        padding:
                                        const EdgeInsets
                                            .symmetric(
                                          horizontal:
                                          12,
                                          vertical: 6,
                                        ),

                                        decoration:
                                        BoxDecoration(

                                          color:
                                          plan.isActive == true
                                              ? const Color(
                                              0xFFEAFBF1)
                                              : const Color(
                                              0xFFFFF4E5),

                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              30),
                                        ),

                                        child: Text(

                                          plan.isActive == true
                                              ? "Active"
                                              : "Inactive",

                                          style:
                                          TextStyle(
                                            color:
                                            plan.isActive == true
                                                ? const Color(
                                                0xFF22C55E)
                                                : Colors.orange,

                                            fontWeight:
                                            FontWeight
                                                .w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  width:
                                  isTablet
                                      ? 20
                                      : 14,
                                ),

                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .end,

                                  children: [

                                    Text(
                                      "₹${plan.price ?? 0}",

                                      style:
                                      TextStyle(
                                        fontSize:
                                        isTablet
                                            ? 28
                                            : 22,

                                        fontWeight:
                                        FontWeight
                                            .w700,

                                        color:
                                        AppColors
                                            .textPrimary,
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 6),

                                    Text(
                                      "/ plan",

                                      style:
                                      TextStyle(
                                        fontSize:
                                        isTablet
                                            ? 13
                                            : 11,

                                        color:
                                        AppColors
                                            .textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget summaryItem({
    required String title,
    required String value,
  }) {

    return Column(
      children: [

        Text(
          value,

          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          title,

          style: TextStyle(
            color:
            Colors.white.withOpacity(.9),

            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void confirmDelete(
      String id,
      String name,
      ) {}
}