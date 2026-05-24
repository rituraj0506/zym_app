import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/delete_member_cubit.dart';
import '../cubit/delete_member_state.dart';
import '../cubit/expired_plan_cubit.dart';

class DeleteMemberPage
    extends StatelessWidget {

  final String memberId;

  const DeleteMemberPage({
    super.key,
    required this.memberId,
  });

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<
        DeleteMemberCubit,
        DeleteMemberState>(

      listener:
          (
          context,
          state,
          ) {

        /// SUCCESS
        if (state
        is DeleteMemberSuccess) {

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
        is DeleteMemberError) {

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
          state,
          ) {

        return Container(

          padding:
          const EdgeInsets.all(
            20,
          ),

          decoration:
          const BoxDecoration(

            color: Colors.white,

            borderRadius:
            BorderRadius.only(

              topLeft:
              Radius.circular(30),

              topRight:
              Radius.circular(30),
            ),
          ),

          child: SafeArea(

            child: Column(

              mainAxisSize:
              MainAxisSize.min,

              children: [

                /// TOP HANDLE
                Container(

                  width: 50,
                  height: 5,

                  decoration:
                  BoxDecoration(

                    color:
                    Colors.grey.shade300,

                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                /// ICON
                Container(

                  padding:
                  const EdgeInsets.all(
                    22,
                  ),

                  decoration:
                  BoxDecoration(

                    color:
                    Colors.red.shade50,

                    shape:
                    BoxShape.circle,
                  ),

                  child: Icon(

                    Icons.delete_forever,

                    color:
                    Colors.red.shade700,

                    size: 70,
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                /// TITLE
                const Text(

                  "Delete Member?",

                  style: TextStyle(

                    fontSize: 24,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                /// SUBTITLE
                Text(

                  "This action will permanently remove this member from your gym records.",

                  textAlign:
                  TextAlign.center,

                  style: TextStyle(

                    color:
                    Colors.grey.shade600,

                    fontSize: 15,
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                /// BUTTONS
                Row(

                  children: [

                    /// CANCEL
                    Expanded(

                      child: SizedBox(

                        height: 56,

                        child:
                        OutlinedButton(

                          style:
                          OutlinedButton.styleFrom(

                            shape:
                            RoundedRectangleBorder(

                              borderRadius:
                              BorderRadius.circular(
                                18,
                              ),
                            ),
                          ),

                          onPressed: () {

                            Navigator.pop(
                              context,
                            );
                          },

                          child: const Text(
                            "Cancel",
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 14,
                    ),

                    /// DELETE
                    Expanded(

                      child: SizedBox(

                        height: 56,

                        child:
                        ElevatedButton(

                          style:
                          ElevatedButton.styleFrom(

                            elevation: 0,

                            backgroundColor:
                            Colors.red,

                            shape:
                            RoundedRectangleBorder(

                              borderRadius:
                              BorderRadius.circular(
                                18,
                              ),
                            ),
                          ),

                          onPressed:
                          state
                          is DeleteMemberLoading

                              ? null

                              : () {

                            context
                                .read<
                                DeleteMemberCubit>()
                                .deleteMember(

                              memberId:
                              memberId,
                            );
                          },

                          child:
                          state
                          is DeleteMemberLoading

                              ? const SizedBox(

                            height: 22,
                            width: 22,

                            child:
                            CircularProgressIndicator(
                              color:
                              Colors.white,
                            ),
                          )

                              : const Text(

                            "Delete",

                            style: TextStyle(

                              color:
                              Colors.white,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}