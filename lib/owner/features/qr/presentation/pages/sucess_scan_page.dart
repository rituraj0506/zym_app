import 'dart:async';

import 'package:flutter/material.dart';

class ScanSuccessPage
    extends StatefulWidget {
  final String type;

  final String memberName;

  final String message;

  final String checkInTime;

  final String? checkOutTime;

  final String attendanceDate;

  final String? profilePhoto;

  const ScanSuccessPage({
    super.key,

    required this.type,

    required this.memberName,

    required this.message,

    required this.checkInTime,

    this.checkOutTime,

    required this.attendanceDate,

    this.profilePhoto,
  });

  @override
  State<ScanSuccessPage> createState() =>
      _ScanSuccessPageState();
}

class _ScanSuccessPageState
    extends State<ScanSuccessPage> {
  @override
  void initState() {
    super.initState();

    /// AUTO CLOSE
    Future.delayed(
      const Duration(seconds: 2),
          () {
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size =
        MediaQuery.of(context).size;

    final bool isTablet =
        size.width > 700;

    final bool isCheckOut =
        widget.type == "check-out";

    final Color primaryColor =
    isCheckOut
        ? const Color(0xFFFF8A00)
        : const Color(0xFF21C16B);

    return Scaffold(
      backgroundColor:
      const Color(0xFF070B16),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding:
              EdgeInsets.symmetric(
                horizontal:
                isTablet
                    ? 40
                    : 22,
              ),

              child: Container(
                width:
                isTablet ? 520 : null,

                padding:
                EdgeInsets.all(
                  isTablet
                      ? 36
                      : 26,
                ),

                decoration: BoxDecoration(
                  color: const Color(
                    0xFF12192D,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    36,
                  ),

                  border: Border.all(
                    color: primaryColor
                        .withOpacity(.25),
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: primaryColor
                          .withOpacity(.18),

                      blurRadius: 30,
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    /// ICON
                    Container(
                      height:
                      isTablet
                          ? 140
                          : 120,

                      width:
                      isTablet
                          ? 140
                          : 120,

                      decoration: BoxDecoration(
                        shape:
                        BoxShape.circle,

                        color: primaryColor
                            .withOpacity(
                          .15,
                        ),
                      ),

                      child: Icon(
                        Icons
                            .check_rounded,

                        color:
                        primaryColor,

                        size:
                        isTablet
                            ? 80
                            : 65,
                      ),
                    ),

                    SizedBox(
                      height:
                      isTablet
                          ? 28
                          : 22,
                    ),

                    Text(
                      widget.memberName,

                      textAlign:
                      TextAlign.center,

                      style: TextStyle(
                        color:
                        Colors.white,

                        fontSize:
                        isTablet
                            ? 34
                            : 28,

                        fontWeight:
                        FontWeight
                            .w700,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      isCheckOut
                          ? "Check-out Successful"
                          : "Check-in Successful",

                      style: TextStyle(
                        color:
                        primaryColor,

                        fontSize:
                        isTablet
                            ? 24
                            : 20,

                        fontWeight:
                        FontWeight
                            .w700,
                      ),
                    ),

                    SizedBox(
                      height:
                      isTablet
                          ? 34
                          : 26,
                    ),

                    /// DETAILS CARD
                    Container(
                      width:
                      double.infinity,

                      padding:
                      const EdgeInsets.all(
                        22,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(
                          .04,
                        ),

                        borderRadius:
                        BorderRadius.circular(
                          24,
                        ),

                        border: Border.all(
                          color: Colors
                              .white
                              .withOpacity(
                            .06,
                          ),
                        ),
                      ),

                      child: Column(
                        children: [
                          _detailRow(
                            title:
                            "Check-in Time",

                            value:
                            widget
                                .checkInTime,
                          ),

                          if (widget
                              .checkOutTime !=
                              null) ...[
                            const SizedBox(
                              height: 16,
                            ),

                            _detailRow(
                              title:
                              "Check-out Time",

                              value:
                              widget
                                  .checkOutTime!,
                            ),
                          ],

                          const SizedBox(
                            height: 16,
                          ),

                          _detailRow(
                            title: "Date",

                            value:
                            widget
                                .attendanceDate,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height:
                      isTablet
                          ? 40
                          : 30,
                    ),

                    /// LOADER
                    SizedBox(
                      width:
                      double.infinity,

                      child:
                      LinearProgressIndicator(
                        minHeight: 6,

                        borderRadius:
                        BorderRadius.circular(
                          30,
                        ),

                        color:
                        primaryColor,

                        backgroundColor:
                        Colors.white
                            .withOpacity(
                          .08,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    Text(
                      "Redirecting to scanner...",

                      style: TextStyle(
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow({
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,

            style: TextStyle(
              color: Colors.white
                  .withOpacity(.65),

              fontSize: 15,
            ),
          ),
        ),

        Text(
          value,

          style: const TextStyle(
            color: Colors.white,

            fontSize: 15,

            fontWeight:
            FontWeight.w700,
          ),
        ),
      ],
    );
  }
}