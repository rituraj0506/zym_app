import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../plan/presentation/cubit/plan_cubit.dart';
import '../../../plan/presentation/cubit/plan_state.dart';

import '../cubit/expired_plan_cubit.dart';

import '../cubit/renew_member_cubit.dart';
import '../cubit/renew_member_state.dart';

class RenewMemberPage
    extends StatefulWidget {

  final String memberId;
  final DateTime? expiryDate;
  final bool allowRejoin;

  const RenewMemberPage({

    super.key,
    required this.memberId,
    this.expiryDate,
    this.allowRejoin = true,
  });

  @override
  State<RenewMemberPage>
  createState() =>
      _RenewMemberPageState();
}

class _RenewMemberPageState
    extends State<RenewMemberPage> {

  String selectedPlanId = "";
  int? selectedPlanDuration;
  String selectedPaymentMode = "cash";
  late bool isRejoin;

  @override
  void initState() {
    super.initState();
    if (widget.expiryDate != null) {
      final daysExpired =
          DateTime.now().difference(widget.expiryDate!).inDays;
      isRejoin = widget.allowRejoin && daysExpired > 30;
    } else {
      isRejoin = false;
    }
  }

  DateTime _addMonths(DateTime date, int months) {
    var newYear = date.year;
    var newMonth = date.month + months;
    while (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    final daysInNewMonth =
        DateTime(newYear, newMonth + 1, 0).day;
    final newDay =
        date.day > daysInNewMonth ? daysInNewMonth : date.day;
    return DateTime(newYear, newMonth, newDay);
  }

  @override
  Widget build(BuildContext context) {

    return Container(

      decoration: const BoxDecoration(

        color: Color(0xffF4F7FE),

        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),

      child:
      SafeArea(

        top: false,

        child:
        BlocConsumer<
            RenewMemberCubit,
            RenewMemberState>(

          listener:
              (
              context,
              state,
              ) {

            /// SUCCESS
            if (state
            is RenewMemberSuccess) {

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(

                SnackBar(

                  content:
                  Text(
                    state.message,
                  ),
                ),
              );

              /// REFRESH MEMBERS
              context
                  .read<
                  ExpiredPlanCubit>()
                  .fetchAll();

              Navigator.pop(
                context,
              );
            }

            /// ERROR
            if (state
            is RenewMemberError) {

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(

                SnackBar(

                  backgroundColor:
                  Colors.red,

                  content:
                  Text(
                    state.message,
                  ),
                ),
              );
            }
          },

          builder:
              (
              context,
              renewState,
              ) {

            return Padding(

              padding:
              const EdgeInsets.all(20),

              child: Column(

                children: [

                  /// HANDLE
                  Container(

                    width: 70,
                    height: 6,

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.grey
                          .shade300,

                      borderRadius:
                      BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  /// HEADER CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isRejoin
                            ? const [
                                Color(0xff10B981),
                                Color(0xff059669),
                              ]
                            : const [
                                Color(0xff6C63FF),
                                Color(0xff8B5CF6),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isRejoin
                                ? Icons.person_add_alt_1_rounded
                                : Icons.workspace_premium,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isRejoin
                                    ? "Rejoin Membership"
                                    : "Renew Membership",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                widget.expiryDate != null
                                    ? "Expired: ${DateFormat('dd MMM yyyy').format(widget.expiryDate!)} (${DateTime.now().difference(widget.expiryDate!).inDays} days ago)"
                                    : "Select a membership plan",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// SMART MODE SELECTOR (Only if allowRejoin is true and expiryDate is provided)
                  if (widget.allowRejoin && widget.expiryDate != null) ...[
                    const SizedBox(height: 14),
                    _buildModeSelector(),
                    _buildWarningBanner(),
                  ],

                  const SizedBox(
                    height: 24,
                  ),

                  /// PLAN LIST
                  Expanded(

                    child:
                    BlocBuilder<
                        PlanCubit,
                        PlanState>(

                      builder:
                          (
                          context,
                          state,
                          ) {

                        /// LOADING
                        if (state
                        is PlanDetailsLoading) {

                          return const Center(

                            child:
                            CircularProgressIndicator(),
                          );
                        }

                        /// ERROR
                        if (state
                        is PlanDetailsError) {

                          return Center(

                            child:
                            Text(
                              state.message,
                            ),
                          );
                        }

                        /// SUCCESS
                        if (state
                        is PlanDetailsLoaded) {

                          final plans =
                              state
                                  .plans
                                  .data ??
                                  [];

                          if (plans
                              .isEmpty) {

                            return const Center(

                              child: Text(
                                "No Plans Found",
                              ),
                            );
                          }

                          return ListView.builder(

                            physics:
                            const BouncingScrollPhysics(),

                            itemCount:
                            plans.length,

                            itemBuilder:
                                (
                                context,
                                index,
                                ) {

                              final plan =
                              plans[index];

                              final isSelected =
                                  selectedPlanId ==
                                      plan.id;

                              return GestureDetector(

                                onTap: () {
                                  setState(() {
                                    selectedPlanId = plan.id ?? "";
                                    selectedPlanDuration =
                                        plan.durationInMonths ?? 1;
                                  });
                                },

                                child:
                                AnimatedContainer(

                                  duration:
                                  const Duration(
                                    milliseconds:
                                    250,
                                  ),

                                  margin:
                                  const EdgeInsets.only(
                                    bottom: 18,
                                  ),

                                  padding:
                                  const EdgeInsets.all(
                                    18,
                                  ),

                                  decoration:
                                  BoxDecoration(

                                    gradient:
                                    isSelected

                                        ? const LinearGradient(

                                      colors: [

                                        Color(
                                          0xff6C63FF,
                                        ),

                                        Color(
                                          0xff8B5CF6,
                                        ),
                                      ],
                                    )

                                        : null,

                                    color:
                                    isSelected

                                        ? null

                                        : Colors.white,

                                    borderRadius:
                                    BorderRadius.circular(
                                      24,
                                    ),

                                    boxShadow: [

                                      BoxShadow(

                                        color:
                                        Colors.black
                                            .withOpacity(
                                          0.04,
                                        ),

                                        blurRadius:
                                        10,

                                        offset:
                                        const Offset(
                                          0,
                                          4,
                                        ),
                                      ),
                                    ],

                                    border:
                                    Border.all(

                                      color:
                                      isSelected

                                          ? Colors.transparent

                                          : Colors.grey
                                          .shade200,
                                    ),
                                  ),

                                  child: Row(

                                    children: [

                                      /// ICON
                                      Container(

                                        height: 60,
                                        width: 60,

                                        decoration:
                                        BoxDecoration(

                                          color:
                                          isSelected

                                              ? Colors.white
                                              .withOpacity(
                                            0.15,
                                          )

                                              : const Color(
                                            0xffF3F4F6,
                                          ),

                                          borderRadius:
                                          BorderRadius.circular(
                                            18,
                                          ),
                                        ),

                                        child: Icon(

                                          Icons.fitness_center,

                                          color:
                                          isSelected

                                              ? Colors.white

                                              : const Color(
                                            0xff6C63FF,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 16,
                                      ),

                                      /// PLAN DETAILS
                                      Expanded(

                                        child: Column(

                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,

                                          children: [

                                            Text(

                                              plan.planName ??
                                                  "",

                                              style:
                                              TextStyle(

                                                color:
                                                isSelected

                                                    ? Colors.white

                                                    : Colors.black,

                                                fontWeight:
                                                FontWeight.bold,

                                                fontSize:
                                                18,
                                              ),
                                            ),

                                            const SizedBox(
                                              height: 6,
                                            ),

                                            Text(

                                              "${plan.durationInMonths} Month Membership",

                                              style:
                                              TextStyle(

                                                color:
                                                isSelected

                                                    ? Colors.white70

                                                    : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      /// CHECK
                                      AnimatedContainer(

                                        duration:
                                        const Duration(
                                          milliseconds:
                                          250,
                                        ),

                                        height: 28,
                                        width: 28,

                                        decoration:
                                        BoxDecoration(

                                          color:
                                          isSelected

                                              ? Colors.white

                                              : Colors.transparent,

                                          shape:
                                          BoxShape.circle,

                                          border:
                                          Border.all(

                                            color:
                                            isSelected

                                                ? Colors.white

                                                : Colors.grey
                                                .shade400,
                                          ),
                                        ),

                                        child:
                                        isSelected

                                            ? const Icon(

                                          Icons.check,

                                          size: 18,

                                          color:
                                          Color(
                                            0xff6C63FF,
                                          ),
                                        )

                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),

                  /// LIVE VALIDITY PREVIEW
                  _buildValidityPreview(),

                  DropdownButtonFormField<String>(
                    value: selectedPaymentMode,

                    decoration: InputDecoration(
                      labelText: "Payment Mode",

                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                    ),

                    items: const [

                      DropdownMenuItem(
                        value: "cash",
                        child: Text("Cash"),
                      ),

                      DropdownMenuItem(
                        value: "upi",
                        child: Text("UPI"),
                      ),

                      DropdownMenuItem(
                        value: "bank",
                        child: Text("Bank Transfer"),
                      ),
                    ],

                    onChanged: (value) {

                      setState(() {

                        selectedPaymentMode = value!;

                      });

                    },
                  ),

                  const SizedBox(height: 14),

                  /// BUTTON
                  SizedBox(

                    width: double.infinity,

                    height: 60,

                    child:
                    ElevatedButton(

                      style:
                      ElevatedButton.styleFrom(

                        backgroundColor: isRejoin
                            ? const Color(0xff10B981)
                            : const Color(0xff6C63FF),

                        elevation: 0,

                        shape:
                        RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(
                            20,
                          ),
                        ),
                      ),

                      onPressed:
                      renewState
                      is RenewMemberLoading

                          ? null

                          : () {

                        if (selectedPlanId
                            .isEmpty) {

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(

                            const SnackBar(

                              content: Text(
                                "Please select a plan",
                              ),
                            ),
                          );

                          return;
                        }

                        if (isRejoin) {
                          context
                              .read<RenewMemberCubit>()
                              .rejoinMember(
                            memberId: widget.memberId,
                            planId: selectedPlanId,
                            paymentMode: selectedPaymentMode,
                          );
                        } else {
                          context
                              .read<RenewMemberCubit>()
                              .renewMember(
                            memberId: widget.memberId,
                            planId: selectedPlanId,
                            paymentMode: selectedPaymentMode,
                          );
                        }
                      },

                      child:
                      renewState
                      is RenewMemberLoading

                          ? const SizedBox(

                        height: 24,
                        width: 24,

                        child:
                        CircularProgressIndicator(
                          color:
                          Colors.white,
                        ),
                      )

                          : Text(

                        isRejoin
                            ? "Confirm Rejoin"
                            : "Confirm Renew",

                        style: const TextStyle(

                          fontSize: 17,

                          fontWeight:
                          FontWeight.bold,

                          color:
                          Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xffE2E8F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          /// REGULAR RENEW
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isRejoin = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: !isRejoin ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: !isRejoin
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh,
                          size: 16,
                          color: !isRejoin
                              ? const Color(0xff6C63FF)
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Regular Renew",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: !isRejoin
                                ? const Color(0xff6C63FF)
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.expiryDate != null
                          ? "From: ${DateFormat('dd MMM').format(widget.expiryDate!)}"
                          : "Old cycle",
                      style: TextStyle(
                        fontSize: 11,
                        color: !isRejoin
                            ? Colors.grey.shade700
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// FRESH REJOIN
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isRejoin = true;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: isRejoin ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isRejoin
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_add_alt_1,
                          size: 16,
                          color: isRejoin
                              ? const Color(0xff10B981)
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Fresh Rejoin",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isRejoin
                                ? const Color(0xff10B981)
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "From: Today (${DateFormat('dd MMM').format(DateTime.now())})",
                      style: TextStyle(
                        fontSize: 11,
                        color: isRejoin
                            ? Colors.grey.shade700
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner() {
    if (widget.expiryDate == null) return const SizedBox();
    final daysExpired =
        DateTime.now().difference(widget.expiryDate!).inDays;

    if (isRejoin && daysExpired <= 30) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xffFFFBEB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffFDE68A)),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline,
                color: Color(0xffD97706), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Member expired only $daysExpired day${daysExpired == 1 ? '' : 's'} ago. Rejoining starts from today instead of previous expiry (${DateFormat('dd MMM').format(widget.expiryDate!)}).",
                style: const TextStyle(
                    fontSize: 11.5, color: Color(0xff92400E)),
              ),
            ),
          ],
        ),
      );
    } else if (!isRejoin && daysExpired > 30) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xffFEF2F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffFECACA)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Color(0xffDC2626), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Member expired $daysExpired days ago. Regular Renew will add to the old date (${DateFormat('dd MMM yyyy').format(widget.expiryDate!)}). Fresh Rejoin is recommended.",
                style: const TextStyle(
                    fontSize: 11.5, color: Color(0xff991B1B)),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildValidityPreview() {
    if (selectedPlanDuration == null) return const SizedBox();

    final startDate = isRejoin
        ? DateTime.now()
        : (widget.expiryDate ?? DateTime.now());
    final endDate = _addMonths(startDate, selectedPlanDuration!);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isRejoin ? const Color(0xffECFDF5) : const Color(0xffEEF2FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isRejoin ? const Color(0xffA7F3D0) : const Color(0xffC7D2FE),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 18,
            color:
                isRejoin ? const Color(0xff059669) : const Color(0xff4F46E5),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 12.5, color: Colors.black87),
                children: [
                  TextSpan(
                    text: isRejoin
                        ? "Rejoin Validity: "
                        : "Renewed Validity: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "${DateFormat('dd MMM yyyy').format(startDate)} ➔ ${DateFormat('dd MMM yyyy').format(endDate)}",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isRejoin
                          ? const Color(0xff065F46)
                          : const Color(0xff3730A3),
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
}