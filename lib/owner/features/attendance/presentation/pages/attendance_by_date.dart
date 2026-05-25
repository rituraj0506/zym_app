import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../models/attendance_by_date_response.dart';
import '../cubit/attendance_by_date_cubit.dart';
import '../cubit/attendance_by_date_state.dart';

class AttendanceByDate extends StatefulWidget {

  final DateTime selectedDate;

  const AttendanceByDate({
    super.key,
    required this.selectedDate,
  });

  @override
  State<AttendanceByDate> createState() =>
      _AttendanceByDateState();
}

class _AttendanceByDateState
    extends State<AttendanceByDate> {

  @override
  void initState() {

    super.initState();

    Future.microtask(() {

      context
          .read<AttendanceByDateCubit>()
          .fetchAttendanceByDate(
        selectedDate:
        widget.selectedDate,
      );
    });
  }

  String formatTime(
      String? isoTime,
      ) {

    if (isoTime == null ||
        isoTime.isEmpty) {

      return "--";
    }

    try {

      return DateFormat(
        "hh:mm a",
      ).format(
        DateTime.parse(
          isoTime,
        ).toLocal(),
      );

    } catch (e) {

      return "--";
    }
  }

  @override
  Widget build(BuildContext context) {

    final size =
        MediaQuery.of(context).size;

    final bool isTablet =
        size.width > 700;

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FB),

      body: BlocConsumer<
          AttendanceByDateCubit,
          AttendanceByDateState>(

        listenWhen: (
            previous,
            current,
            ) {

          return current
          is AttendanceByDateError;
        },

        listener: (
            context,
            state,
            ) {

          if (state
          is AttendanceByDateError) {

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(

              SnackBar(

                behavior:
                SnackBarBehavior
                    .floating,

                content: Text(
                  state.message,
                ),
              ),
            );
          }
        },

        builder: (
            context,
            state,
            ) {

          List<AttendanceData>
          attendanceList = [];

          if (state
          is AttendanceByDateLoaded) {

            attendanceList =
                state.attendance.data ??
                    [];
          }

          return SafeArea(
            child: Center(
              child:
              ConstrainedBox(

                constraints:
                BoxConstraints(

                  maxWidth:
                  isTablet
                      ? 700
                      : 500,
                ),

                child: Column(
                  children: [

                    /// TOP CARD
                    Padding(

                      padding:
                      EdgeInsets.only(

                        left:
                        isTablet
                            ? 24
                            : 16,

                        right:
                        isTablet
                            ? 24
                            : 16,

                        top:
                        isTablet
                            ? 24
                            : 16,
                      ),

                      child:
                      Container(

                        padding:
                        EdgeInsets.all(

                          isTablet
                              ? 28
                              : 20,
                        ),

                        decoration:
                        BoxDecoration(

                          gradient:
                          const LinearGradient(

                            colors: [

                              Color(
                                0xFF7B61FF,
                              ),

                              Color(
                                0xFF5B36F2,
                              ),
                            ],

                            begin:
                            Alignment
                                .topLeft,

                            end:
                            Alignment
                                .bottomRight,
                          ),

                          borderRadius:
                          BorderRadius.circular(
                            32,
                          ),

                          boxShadow: [

                            BoxShadow(

                              color:
                              const Color(
                                0xFF7B61FF,
                              ).withOpacity(
                                .25,
                              ),

                              blurRadius:
                              25,

                              offset:
                              const Offset(
                                0,
                                12,
                              ),
                            ),
                          ],
                        ),

                        child: Row(

                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            /// BACK BUTTON
                            GestureDetector(

                              onTap: () {

                                Navigator.pop(
                                  context,
                                );
                              },

                              child: Container(

                                height:
                                isTablet
                                    ? 52
                                    : 44,

                                width:
                                isTablet
                                    ? 52
                                    : 44,

                                decoration:
                                BoxDecoration(

                                  color:
                                  Colors.white
                                      .withOpacity(
                                    .15,
                                  ),

                                  borderRadius:
                                  BorderRadius.circular(
                                    16,
                                  ),
                                ),

                                child:
                                const Icon(

                                  Icons
                                      .arrow_back_ios_new_rounded,

                                  color:
                                  Colors.white,

                                  size: 18,
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 16,
                            ),

                            /// TITLE
                            Expanded(
                              child: Column(

                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                                children: [

                                  Text(

                                    "Attendance History",

                                    style:
                                    TextStyle(

                                      color:
                                      Colors.white,

                                      fontSize:
                                      isTablet
                                          ? 30
                                          : 24,

                                      fontWeight:
                                      FontWeight
                                          .w700,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 6,
                                  ),

                                  Text(

                                    DateFormat(
                                      "dd MMM yyyy",
                                    ).format(
                                      widget
                                          .selectedDate,
                                    ),

                                    style:
                                    TextStyle(

                                      color:
                                      Colors
                                          .white70,

                                      fontSize:
                                      isTablet
                                          ? 16
                                          : 13,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 14,
                                  ),

                                  Text(

                                    "${attendanceList.length} members visited",

                                    style:
                                    TextStyle(

                                      color:
                                      Colors.white,

                                      fontSize:
                                      isTablet
                                          ? 16
                                          : 13,

                                      fontWeight:
                                      FontWeight
                                          .w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    /// LOADING
                    if (state
                    is AttendanceByDateLoading)

                      const Expanded(
                        child: Center(
                          child:
                          CircularProgressIndicator(),
                        ),
                      )

                    else

                    /// LIST
                      Expanded(
                        child: Container(

                          margin:
                          EdgeInsets.symmetric(

                            horizontal:
                            isTablet
                                ? 24
                                : 16,
                          ),

                          padding:
                          EdgeInsets.all(

                            isTablet
                                ? 24
                                : 18,
                          ),

                          decoration:
                          BoxDecoration(

                            color:
                            Colors.white,

                            borderRadius:
                            BorderRadius.circular(
                              30,
                            ),

                            boxShadow: [

                              BoxShadow(

                                color:
                                Colors.black
                                    .withOpacity(
                                  .04,
                                ),

                                blurRadius:
                                18,

                                offset:
                                const Offset(
                                  0,
                                  8,
                                ),
                              ),
                            ],
                          ),

                          child:
                          attendanceList
                              .isEmpty

                              ? const Center(
                            child: Text(
                              "No attendance found",
                            ),
                          )

                              : ListView.builder(

                            physics:
                            const BouncingScrollPhysics(),

                            itemCount:
                            attendanceList
                                .length,

                            itemBuilder: (
                                context,
                                index,
                                ) {

                              final attendance =
                              attendanceList[index];

                              final user =
                                  attendance
                                      .member
                                      ?.user;

                              final bool
                              isCheckedOut =

                                  attendance
                                      .status ==
                                      "checked-out";

                              return Padding(

                                padding:
                                const EdgeInsets.only(
                                  bottom:
                                  18,
                                ),

                                child:
                                _memberTile(

                                  name:
                                  user?.name ??
                                      "Unknown",

                                  checkIn:
                                  attendance
                                      .checkInTime,

                                  checkedOut:
                                  isCheckedOut,

                                  checkOutTime:
                                  attendance
                                      .checkOutTime,

                                  isTablet:
                                  isTablet,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _memberTile({

    required String name,

    required String? checkIn,

    required bool checkedOut,

    required String? checkOutTime,

    required bool isTablet,
  }) {

    final formattedCheckIn =
    formatTime(checkIn);

    final formattedCheckOut =
    formatTime(checkOutTime);

    return Container(

      padding:
      EdgeInsets.all(
        isTablet
            ? 18
            : 14,
      ),

      decoration:
      BoxDecoration(

        color:
        const Color(
          0xFFF7F8FC,
        ),

        borderRadius:
        BorderRadius.circular(
          22,
        ),
      ),

      child: Row(
        children: [

          /// AVATAR
          Container(

            height:
            isTablet
                ? 70
                : 50,

            width:
            isTablet
                ? 70
                : 50,

            decoration:
            BoxDecoration(

              gradient:
              const LinearGradient(
                colors: [

                  Color(
                    0xFF7B61FF,
                  ),

                  Color(
                    0xFF5B36F2,
                  ),
                ],
              ),

              borderRadius:
              BorderRadius.circular(
                18,
              ),
            ),

            child: Center(
              child: Text(

                name.isNotEmpty
                    ? name[0]
                    .toUpperCase()
                    : "?",

                style: TextStyle(

                  color:
                  Colors.white,

                  fontSize:
                  isTablet
                      ? 28
                      : 18,

                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ),

          SizedBox(
            width:
            isTablet
                ? 18
                : 14,
          ),

          /// DETAILS
          Expanded(
            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [

                Text(

                  name,

                  maxLines: 1,

                  overflow:
                  TextOverflow
                      .ellipsis,

                  style:
                  TextStyle(

                    fontSize:
                    isTablet
                        ? 18
                        : 14,

                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(

                  "Check-in : $formattedCheckIn",

                  style:
                  TextStyle(

                    color:
                    Colors.grey
                        .shade700,

                    fontSize: 12,

                    fontWeight:
                    FontWeight.w500,
                  ),
                ),

                if (checkedOut) ...[

                  const SizedBox(
                    height: 4,
                  ),

                  Text(

                    "Check-out : $formattedCheckOut",

                    style:
                    const TextStyle(

                      color:
                      Color(
                        0xFFE74C3C,
                      ),

                      fontSize: 12,

                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          /// STATUS
          Container(

            padding:
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),

            decoration:
            BoxDecoration(

              color:
              checkedOut

                  ? const Color(
                0xFFFFF0EE,
              )

                  : const Color(
                0xFFE9FFF0,
              ),

              borderRadius:
              BorderRadius.circular(
                14,
              ),
            ),

            child: Text(

              checkedOut
                  ? "OUT"
                  : "IN",

              style:
              TextStyle(

                color:
                checkedOut

                    ? const Color(
                  0xFFE74C3C,
                )

                    : const Color(
                  0xFF21C16B,
                ),

                fontWeight:
                FontWeight.w700,

                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}