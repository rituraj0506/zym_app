import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/attendance_cubit.dart';
import '../cubit/attendance_state.dart';

class AttendanceDetailsPage
    extends StatefulWidget {

  const AttendanceDetailsPage({
    super.key,
  });

  @override
  State<AttendanceDetailsPage>
  createState() =>
      _AttendanceDetailsPageState();
}

class _AttendanceDetailsPageState
    extends State<
        AttendanceDetailsPage
    > {

  int selectedTab = 0;

  @override
  void initState() {

    super.initState();

    context
        .read<AttendanceCubit>()
        .fetchAttendanceData();
  }

  String formatTime(
      String? dateTime,
      ) {

    if (dateTime == null ||
        dateTime.isEmpty) {

      return "";
    }

    try {

      final date =
      DateTime.parse(
        dateTime,
      ).toLocal();

      return DateFormat(
        'hh:mm a',
      ).format(date);

    } catch (e) {

      return "";
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
          AttendanceCubit,
          AttendanceState
      >(

        listenWhen: (
            previous,
            current,
            ) {

          return current
          is AttendanceError;
        },

        listener: (
            context,
            state,
            ) {

          if (state
          is AttendanceError) {

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

          final cubit =
          context.read<
              AttendanceCubit
          >();

          final allData =
              cubit
                  .todayAttendanceResponseModel
                  ?.data ??
                  [];

          final presentData =
              cubit
                  .todayPresentMembersResponseModel
                  ?.data ??
                  [];

          final checkedOutData =
              cubit
                  .todayCheckedOutResponseModel
                  ?.data ??
                  [];

          final totalAttendance =
              cubit
                  .todayAttendanceResponseModel
                  ?.totalAttendance ??
                  0;

          final totalPresent =
              cubit
                  .todayPresentMembersResponseModel
                  ?.totalPresent ??
                  0;

          final totalCheckedOut =
              cubit
                  .todayCheckedOutResponseModel
                  ?.totalCheckedOut ??
                  0;

          dynamic currentList = [];

          if (selectedTab == 0) {

            currentList = allData;

          } else if (
          selectedTab == 1) {

            currentList =
                presentData;

          } else {

            currentList =
                checkedOutData;
          }

          return SafeArea(
            child: Center(
              child: ConstrainedBox(

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

                      child: Container(

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

                        child: Column(
                          children: [

                            /// HEADER
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                              children: [

                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                                  children: [

                                    Text(
                                      "Attendance",

                                      style:
                                      TextStyle(
                                        color:
                                        Colors.white,

                                        fontSize:
                                        isTablet
                                            ? 30
                                            : 24,

                                        fontWeight:
                                        FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 6,
                                    ),

                                    Text(
                                      "Track today's member activity",

                                      style:
                                      TextStyle(
                                        color:
                                        Colors.white70,

                                        fontSize:
                                        isTablet
                                            ? 16
                                            : 13,
                                      ),
                                    ),
                                  ],
                                ),

                                Container(
                                  height:
                                  isTablet
                                      ? 58
                                      : 50,

                                  width:
                                  isTablet
                                      ? 58
                                      : 50,

                                  decoration:
                                  BoxDecoration(
                                    color:
                                    Colors.white
                                        .withOpacity(
                                      .15,
                                    ),

                                    borderRadius:
                                    BorderRadius.circular(
                                      18,
                                    ),
                                  ),

                                  child:
                                  const Icon(
                                    Icons
                                        .calendar_month_rounded,

                                    color:
                                    Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height:
                              isTablet
                                  ? 26
                                  : 20,
                            ),

                            /// STATS
                            Row(
                              children: [

                                Expanded(
                                  child:
                                  _statCard(
                                    title:
                                    "All",

                                    value:
                                    totalAttendance
                                        .toString(),

                                    icon:
                                    Icons.people_alt,

                                    selected:
                                    selectedTab ==
                                        0,

                                    onTap: () {

                                      setState(() {

                                        selectedTab =
                                        0;
                                      });
                                    },
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child:
                                  _statCard(
                                    title:
                                    "Present",

                                    value:
                                    totalPresent
                                        .toString(),

                                    icon:
                                    Icons.login,

                                    selected:
                                    selectedTab ==
                                        1,

                                    onTap: () {

                                      setState(() {

                                        selectedTab =
                                        1;
                                      });
                                    },
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child:
                                  _statCard(
                                    title:
                                    "Checked Out",

                                    value:
                                    totalCheckedOut
                                        .toString(),

                                    icon:
                                    Icons.logout,

                                    selected:
                                    selectedTab ==
                                        2,

                                    onTap: () {

                                      setState(() {

                                        selectedTab =
                                        2;
                                      });
                                    },
                                  ),
                                ),
                              ],
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
                    is AttendanceLoading)

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
                          currentList.isEmpty

                              ? const Center(
                            child: Text(
                              "No data found",
                            ),
                          )

                              : ListView.builder(

                            itemCount:
                            currentList
                                .length,

                            itemBuilder: (
                                context,
                                index,
                                ) {

                              final member =
                              currentList[index];

                              final user =
                                  member
                                      .member
                                      ?.user;

                              final bool
                              isCheckedOut =

                                  selectedTab ==
                                      2 ||

                                      (selectedTab ==
                                          0 &&
                                          member.status ==
                                              "checked-out");

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
                                      "",

                                  checkIn:
                                  member.checkInTime ??
                                      "",

                                  checkedOut:
                                  isCheckedOut,

                                  checkOutTime:
                                  isCheckedOut

                                      ? (member.checkOutTime ??
                                      "")

                                      : "",

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

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {

    return GestureDetector(

      onTap: onTap,

      child: AnimatedContainer(

        duration:
        const Duration(
          milliseconds: 250,
        ),

        padding:
        const EdgeInsets.symmetric(
          vertical: 16,
        ),

        decoration:
        BoxDecoration(

          color:
          selected

              ? Colors.white

              : Colors.white
              .withOpacity(.12),

          borderRadius:
          BorderRadius.circular(
            22,
          ),
        ),

        child: Column(
          children: [

            Icon(
              icon,

              color:
              selected

                  ? const Color(
                0xFF6A42F4,
              )

                  : Colors.white,
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              value,

              style: TextStyle(

                color:
                selected

                    ? const Color(
                  0xFF6A42F4,
                )

                    : Colors.white,

                fontWeight:
                FontWeight.w700,

                fontSize: 18,
              ),
            ),

            const SizedBox(
              height: 4,
            ),

            Text(
              title,

              textAlign:
              TextAlign.center,

              style: TextStyle(

                color:
                selected

                    ? Colors.black87

                    : Colors.white70,

                fontSize: 12,

                fontWeight:
                FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _memberTile({

    required String name,

    required String checkIn,

    required bool checkedOut,

    required String checkOutTime,

    required bool isTablet,
  }) {

    final formattedCheckIn =
    formatTime(checkIn);

    final formattedCheckOut =
    formatTime(checkOutTime);

    return Container(

      padding: EdgeInsets.all(
        isTablet ? 18 : 14,
      ),

      decoration: BoxDecoration(

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
                : 48,

            width:
            isTablet
                ? 70
                : 48,

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
                20,
              ),
            ),

            child: Center(
              child: Text(

                name.isNotEmpty
                    ? name[0]
                    : "",

                style: TextStyle(

                  color:
                  Colors.white,

                  fontSize:
                  isTablet
                      ? 28
                      : 16,

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

          /// NAME
          Expanded(
            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [

                Text(
                  name,

                  style: TextStyle(
                    fontSize:
                    isTablet
                        ? 20
                        : 12,

                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Row(
                  children: [

                    Icon(
                      Icons
                          .access_time_rounded,

                      size: 14,

                      color:
                      Colors
                          .grey
                          .shade600,
                    ),

                    const SizedBox(
                      width: 5,
                    ),

                    Text(

                      "Check-in $formattedCheckIn",

                      style:
                      TextStyle(

                        color:
                        Colors.grey
                            .shade700,

                        fontWeight:
                        FontWeight.w500,

                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// STATUS
          checkedOut

              ? Container(

            padding:
            const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),

            decoration:
            BoxDecoration(

              color:
              const Color(
                0xFFFFF0EE,
              ),

              borderRadius:
              BorderRadius.circular(
                10,
              ),
            ),

            child: Column(
              children: [

                const Text(
                  "Checked Out",

                  style:
                  TextStyle(

                    color:
                    Color(
                      0xFFE74C3C,
                    ),

                    fontSize: 8,

                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(

                  formattedCheckOut,

                  style:
                  const TextStyle(

                    color:
                    Color(
                      0xFFE74C3C,
                    ),

                    fontWeight:
                    FontWeight.w700,

                    fontSize: 8,
                  ),
                ),
              ],
            ),
          )

              : Container(

            padding:
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),

            decoration:
            BoxDecoration(

              color:
              const Color(
                0xFFE9FFF0,
              ),

              borderRadius:
              BorderRadius.circular(
                16,
              ),
            ),

            child: Row(
              children: const [

                Icon(
                  Icons.circle,

                  color:
                  Color(
                    0xFF21C16B,
                  ),

                  size: 10,
                ),

                SizedBox(
                  width: 6,
                ),

                Text(
                  "IN",

                  style:
                  TextStyle(

                    color:
                    Color(
                      0xFF21C16B,
                    ),

                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}