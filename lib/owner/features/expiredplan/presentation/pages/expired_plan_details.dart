import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zymmanagement/owner/features/expiredplan/presentation/pages/renew_member_page.dart';
import '../../../plan/presentation/cubit/plan_cubit.dart';
import '../cubit/delete_member_cubit.dart';
import '../cubit/expired_plan_cubit.dart';
import '../cubit/expired_plan_state.dart';
import '../cubit/renew_member_cubit.dart';
import 'delete_member_page.dart';

class ExpiredMemberDetails extends StatefulWidget {
  const ExpiredMemberDetails({super.key});

  @override
  State<ExpiredMemberDetails> createState() => _ExpiredMemberDetailsState();
}

class _ExpiredMemberDetailsState extends State<ExpiredMemberDetails> {
  int selectedTab = 0;

  final ScrollController _scrollController =
  ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;
      context.read<ExpiredPlanCubit>().fetchAll();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {

      final cubit =
      context.read<ExpiredPlanCubit>();

      if (selectedTab == 0) {

        cubit.loadMoreExpiringSoon();

      } else {

        cubit.loadMoreExpired();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openRenewOrRejoinSheet(
    BuildContext context,
    String memberId, {
    DateTime? expiryDate,
    bool allowRejoin = true,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: context.read<PlanCubit>()..getAllPlans(),
            ),
            BlocProvider(
              create: (_) => RenewMemberCubit(),
            ),
          ],
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.88,
            child: RenewMemberPage(
              memberId: memberId,
              expiryDate: expiryDate,
              allowRejoin: allowRejoin,
            ),
          ),
        );
      },
    );
  }

  void _openDeleteSheet(BuildContext context, String memberId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return BlocProvider(
          create: (_) => DeleteMemberCubit(),
          child: DeleteMemberPage(
            memberId: memberId,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final bool isTablet = size.width >= 700;

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FE),

      body: SafeArea(
        child: BlocBuilder<ExpiredPlanCubit, ExpiredPlanState>(
          builder: (context, state) {
            final cubit = context.read<ExpiredPlanCubit>();

            final expiringSoonMembers =
                cubit.expiringSoonPlan?.data ?? [];

            final expiredMembers =
                cubit.expiredPlan?.data ?? [];

            final currentList = selectedTab == 0
                ? expiringSoonMembers
                : expiredMembers;

            final isLoading = state is ExpiredPlanLoading &&
                currentList.isEmpty;

            return Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: isTablet ? 700 : 500),

                margin: EdgeInsets.all(isTablet ? 24 : 14),

                child: Column(
                  children: [
                    /// HEADER
                    Container(
                      width: double.infinity,

                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 28 : 20,

                        vertical: isTablet ? 24 : 18,
                      ),

                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff6C63FF), Color(0xff8B5CF6)],
                        ),

                        borderRadius: BorderRadius.circular(28),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withValues(alpha: 0.18),

                            blurRadius: 20,

                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [
                          /// BACK BUTTON
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: isTablet ? 52 : 46,
                              width: isTablet ? 52 : 46,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Plan Expiry Alerts",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: isTablet ? 26 : 20,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.amberAccent,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Manage expiring & expired memberships",
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: isTablet ? 14 : 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BODY
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(isTablet ? 24 : 18),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(28),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),

                              blurRadius: 12,

                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [
                            /// TABS
                            Container(
                              height: isTablet ? 62 : 54,

                              padding: const EdgeInsets.all(5),

                              decoration: BoxDecoration(
                                color: const Color(0xffF3F4F6),

                                borderRadius: BorderRadius.circular(18),
                              ),

                              child: Row(
                                children: [
                                  /// EXPIRING SOON
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedTab = 0;
                                        });
                                      },

                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 250,
                                        ),

                                        decoration: BoxDecoration(
                                          gradient: selectedTab == 0
                                              ? const LinearGradient(
                                                  colors: [
                                                    Color(0xff6C63FF),
                                                    Color(0xff8B5CF6),
                                                  ],
                                                )
                                              : null,

                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),

                                        child: Center(
                                          child: Text(
                                            "Expiring Soon (${cubit.expiringSoonPlan?.pagination?.totalMembers ?? 0})",
                                            style: TextStyle(
                                              color: selectedTab == 0
                                                  ? Colors.white
                                                  : Colors.black87,

                                              fontWeight: FontWeight.bold,

                                              fontSize: isTablet ? 15 : 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// EXPIRED
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedTab = 1;
                                        });
                                      },

                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 250,
                                        ),

                                        decoration: BoxDecoration(
                                          gradient: selectedTab == 1
                                              ? const LinearGradient(
                                                  colors: [
                                                    Color(0xffEF4444),
                                                    Color(0xffDC2626),
                                                  ],
                                                )
                                              : null,

                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),

                                        child: Center(
                                          child: Text(
                                            "Expired (${cubit.expiredPlan?.pagination?.totalMembers ?? 0})",
                                            style: TextStyle(
                                              color: selectedTab == 1
                                                  ? Colors.white
                                                  : Colors.black87,

                                              fontWeight: FontWeight.bold,

                                              fontSize: isTablet ? 15 : 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            Expanded(
                              child: RefreshIndicator(
                                color: selectedTab == 0
                                    ? const Color(0xff6C63FF)
                                    : const Color(0xffEF4444),
                                onRefresh: () async {
                                  await context.read<ExpiredPlanCubit>().fetchAll();
                                },
                                child: state is ExpiredPlanError
                                    ? ListView(
                                        physics: const AlwaysScrollableScrollPhysics(
                                          parent: BouncingScrollPhysics(),
                                        ),
                                        children: [
                                          SizedBox(
                                            height: 300,
                                            child: Center(
                                              child: Text(
                                                state.message,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : (!isLoading && currentList.isEmpty)
                                        ? ListView(
                                            physics: const AlwaysScrollableScrollPhysics(
                                              parent: BouncingScrollPhysics(),
                                            ),
                                            children: [
                                              SizedBox(
                                                height: 300,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.people_outline,
                                                        size: 48,
                                                        color: Colors.grey.shade400,
                                                      ),
                                                      const SizedBox(height: 12),
                                                      Text(
                                                        selectedTab == 0
                                                            ? "No Expiring Soon Members"
                                                            : "No Expired Members",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.grey.shade600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                        "Pull down to refresh",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey.shade400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : ListView.builder(
                                            controller: _scrollController,
                                            physics: const AlwaysScrollableScrollPhysics(
                                              parent: BouncingScrollPhysics(),
                                            ),
                                            itemCount: isLoading
                                                ? 6
                                                : currentList.length + 1,
                                            itemBuilder: (context, index) {

                                    /// SHIMMER
                                    if (isLoading) {

                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,

                                        highlightColor:
                                        Colors.grey.shade100,

                                        child: Container(
                                          height: 90,

                                          margin: const EdgeInsets.only(
                                            bottom: 16,
                                          ),

                                          decoration: BoxDecoration(
                                            color: Colors.white,

                                            borderRadius:
                                            BorderRadius.circular(
                                              22,
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    /// PAGINATION LOADER
                                    if (index == currentList.length) {

                                      final hasNextPage =
                                      selectedTab == 0
                                          ? cubit
                                          .expiringSoonPlan
                                          ?.pagination
                                          ?.hasNextPage ??
                                          false
                                          : cubit
                                          .expiredPlan
                                          ?.pagination
                                          ?.hasNextPage ??
                                          false;

                                      if (!hasNextPage) {
                                        return const SizedBox.shrink();
                                      }

                                      return const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 18,
                                        ),

                                        child: Center(
                                          child:
                                          CircularProgressIndicator(),
                                        ),
                                      );
                                    }

                                    /// REAL DATA
                                    String memberName = "";

                                    DateTime? expiryDate;

                                    String memberId = "";

                                    if (selectedTab == 0) {

                                      final member =
                                      expiringSoonMembers[index];

                                      memberName =
                                          member.user?.name ?? "";

                                      expiryDate =
                                          member.expiryDate;

                                      memberId =
                                          member.id ?? "";

                                    } else {

                                      final member =
                                      expiredMembers[index];

                                      memberName =
                                          member.user?.name ?? "";

                                      expiryDate =
                                          member.expiryDate;

                                      memberId =
                                          member.id ?? "";
                                    }

                                    int daysLeft = 0;

                                    if (expiryDate != null) {

                                      final difference =
                                      expiryDate.difference(
                                        DateTime.now(),
                                      );

                                      daysLeft =
                                      difference.inHours <= 24
                                          ? 1
                                          : (difference.inHours / 24)
                                          .ceil();
                                    }

                                    return Container(
                                      margin: const EdgeInsets.only(
                                        bottom: 18,
                                      ),

                                      padding: const EdgeInsets.all(
                                        16,
                                      ),

                                      decoration: BoxDecoration(
                                        color: Colors.white,

                                        borderRadius:
                                        BorderRadius.circular(24),

                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.04),

                                            blurRadius: 12,

                                            offset: const Offset(0, 6),
                                          ),
                                        ],

                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),

                                      child: Column(
                                        children: [

                                          /// TOP INFO
                                          Row(
                                            children: [

                                              /// AVATAR
                                              Container(
                                                height: 62,
                                                width: 62,

                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors:
                                                    selectedTab == 0
                                                        ? [
                                                      const Color(
                                                        0xff8B5CF6,
                                                      ),
                                                      const Color(
                                                        0xff6D28D9,
                                                      ),
                                                    ]
                                                        : [
                                                      const Color(
                                                        0xffEF4444,
                                                      ),
                                                      const Color(
                                                        0xffDC2626,
                                                      ),
                                                    ],
                                                  ),

                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    20,
                                                  ),
                                                ),

                                                child: const Icon(
                                                  Icons.person,

                                                  color: Colors.white,

                                                  size: 28,
                                                ),
                                              ),

                                              const SizedBox(width: 14),

                                              /// DETAILS
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,

                                                  children: [

                                                    Text(
                                                      memberName,

                                                      style:
                                                      const TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,

                                                        fontSize: 17,
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height: 6,
                                                    ),

                                                    Container(
                                                      padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 6,
                                                      ),

                                                      decoration:
                                                      BoxDecoration(
                                                        color:
                                                        selectedTab ==
                                                            0
                                                            ? Colors
                                                            .orange
                                                            .shade50
                                                            : Colors
                                                            .red
                                                            .shade50,

                                                        borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                      ),

                                                      child: Text(
                                                        selectedTab == 0
                                                            ? "Expires in $daysLeft day${daysLeft > 1 ? "s" : ""}"
                                                            : "Membership Expired",

                                                        style: TextStyle(
                                                          color:
                                                          selectedTab ==
                                                              0
                                                              ? Colors
                                                              .orange
                                                              : Colors.red,

                                                          fontWeight:
                                                          FontWeight
                                                              .w700,

                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height: 8,
                                                    ),

                                                    Text(
                                                      expiryDate != null
                                                          ? DateFormat(
                                                        "dd MMM yyyy",
                                                      ).format(
                                                        expiryDate,
                                                      )
                                                          : "",

                                                      style: TextStyle(
                                                        color:
                                                        Colors
                                                            .grey
                                                            .shade600,

                                                        fontWeight:
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 18),

                                          /// BUTTONS
                                          Row(
                                            children: [
                                              /// RENEW / REJOIN
                                              Expanded(
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  onTap: () {
                                                    _openRenewOrRejoinSheet(
                                                      context,
                                                      memberId,
                                                      expiryDate: expiryDate,
                                                      allowRejoin:
                                                          selectedTab == 1,
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 52,
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                          const LinearGradient(
                                                        colors: [
                                                          Color(0xff6C63FF),
                                                          Color(0xff8B5CF6),
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        16,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                          Icons.refresh,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          selectedTab == 1
                                                              ? "Renew / Rejoin"
                                                              : "Renew",
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),

                                              /// DELETE
                                              Expanded(
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  onTap: () {
                                                    _openDeleteSheet(
                                                      context,
                                                      memberId,
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 52,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xffFEF2F2,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        16,
                                                      ),
                                                      border: Border.all(
                                                        color: Colors
                                                            .red.shade200,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.delete_outline,
                                                          color: Colors
                                                              .red.shade700,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        const Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
