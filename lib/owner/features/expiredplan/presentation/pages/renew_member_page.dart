import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../plan/presentation/cubit/plan_cubit.dart';
import '../../../plan/presentation/cubit/plan_state.dart';

import '../cubit/expired_plan_cubit.dart';

import '../cubit/renew_member_cubit.dart';
import '../cubit/renew_member_state.dart';

class RenewMemberPage
    extends StatefulWidget {

  final String memberId;

  const RenewMemberPage({

    super.key,
    required this.memberId,
  });

  @override
  State<RenewMemberPage>
  createState() =>
      _RenewMemberPageState();
}

class _RenewMemberPageState
    extends State<RenewMemberPage> {

  String selectedPlanId = "";
  String selectedPaymentMode = "cash";

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

                    padding:
                    const EdgeInsets.all(
                      24,
                    ),

                    decoration:
                    BoxDecoration(

                      gradient:
                      const LinearGradient(

                        colors: [

                          Color(
                            0xff6C63FF,
                          ),

                          Color(
                            0xff8B5CF6,
                          ),
                        ],
                      ),

                      borderRadius:
                      BorderRadius.circular(
                        28,
                      ),
                    ),

                    child: Column(

                      children: [

                        Container(

                          padding:
                          const EdgeInsets.all(
                            18,
                          ),

                          decoration:
                          BoxDecoration(

                            color:
                            Colors.white
                                .withOpacity(
                              0.15,
                            ),

                            shape:
                            BoxShape.circle,
                          ),

                          child:
                          const Icon(

                            Icons.workspace_premium,

                            size: 42,

                            color:
                            Colors.white,
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        const Text(

                          "Renew Membership",

                          style: TextStyle(

                            color:
                            Colors.white,

                            fontSize: 24,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(

                          "Select a membership plan",

                          style: TextStyle(

                            color:
                            Colors.white
                                .withOpacity(
                              0.9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

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

                                    selectedPlanId =
                                        plan.id ??
                                            "";
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

                        backgroundColor:
                        const Color(
                          0xff6C63FF,
                        ),

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

                        context
                            .read<
                            RenewMemberCubit>()
                            .renewMember(

                          memberId:
                          widget.memberId,

                          planId:
                          selectedPlanId,


                          paymentMode:
                          selectedPaymentMode,
                        );
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

                          : const Text(

                        "Renew Membership",

                        style: TextStyle(

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
}