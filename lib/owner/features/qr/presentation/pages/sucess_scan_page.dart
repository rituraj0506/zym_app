import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScanSuccessPage extends StatefulWidget {

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
    extends State<ScanSuccessPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 700,
      ),
    );

    scaleAnimation =
        CurvedAnimation(
          parent: _controller,
          curve: Curves.elasticOut,
        );

    _controller.forward();

    /// AUTO CLOSE
    Future.delayed(
      const Duration(seconds: 5),
          () {

        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  void dispose() {

    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size =
        MediaQuery.of(context).size;

    final bool isTablet =
        size.width > 700;

    final bool isCheckout =
        widget.type == "check-out";

    final Color primaryColor =
    isCheckout
        ? const Color(0xFFFF8A00)
        : const Color(0xFF22C55E);

    return Scaffold(
      backgroundColor:
      Colors.black.withOpacity(.45),

      body: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 12,
          sigmaY: 12,
        ),

        child: Center(
          child: ScaleTransition(
            scale: scaleAnimation,

            child: Container(
              width:
              isTablet
                  ? 480
                  : size.width * .88,

              padding:
              EdgeInsets.all(
                isTablet ? 34 : 24,
              ),

              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(36),

                gradient:
                const LinearGradient(
                  begin: Alignment.topLeft,
                  end:
                  Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A1F38),
                    Color(0xFF101426),
                  ],
                ),

                border: Border.all(
                  color: Colors.white
                      .withOpacity(.08),
                ),

                boxShadow: [
                  BoxShadow(
                    color: primaryColor
                        .withOpacity(.30),

                    blurRadius: 35,

                    spreadRadius: 1,
                  ),
                ],
              ),

              child: Column(
                mainAxisSize:
                MainAxisSize.min,

                children: [

                  /// GLOW ICON
                  Container(
                    height:
                    isTablet ? 140 : 120,

                    width:
                    isTablet ? 140 : 120,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      gradient:
                      RadialGradient(
                        colors: [
                          primaryColor
                              .withOpacity(.35),

                          primaryColor
                              .withOpacity(.08),
                        ],
                      ),
                    ),

                    child: Icon(
                      isCheckout
                          ? Icons.logout_rounded
                          : Icons.check_circle_rounded,

                      color: primaryColor,

                      size:
                      isTablet ? 72 : 60,
                    ),
                  ),

                  SizedBox(
                    height:
                    isTablet ? 28 : 22,
                  ),

                  /// TITLE
                  Text(
                    isCheckout
                        ? "CHECK OUT"
                        : "CHECK IN",

                    style: TextStyle(
                      color: primaryColor,

                      fontSize:
                      isTablet ? 16 : 13,

                      letterSpacing: 3,

                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 12),

                  /// NAME
                  Text(
                    widget.memberName,

                    textAlign:
                    TextAlign.center,

                    style: TextStyle(
                      color: Colors.white,

                      fontSize:
                      isTablet ? 32 : 26,

                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),

                  SizedBox(height: 12),

                  /// MESSAGE
                  Text(
                    widget.message,

                    textAlign:
                    TextAlign.center,

                    style: TextStyle(
                      color: Colors.white70,

                      fontSize:
                      isTablet ? 17 : 14,
                    ),
                  ),

                  SizedBox(
                    height:
                    isTablet ? 28 : 24,
                  ),

                  /// DETAILS CARD
                  Container(
                    width: double.infinity,

                    padding:
                    const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(.04),

                      borderRadius:
                      BorderRadius.circular(24),

                      border: Border.all(
                        color: Colors.white
                            .withOpacity(.05),
                      ),
                    ),

                    child: Column(
                      children: [

                        _detailTile(
                          icon:
                          Icons.access_time_rounded,

                          title:
                          "Check-in Time",

                          value:
                          _formatTime(widget.checkInTime),
                        ),

                        if (widget.checkOutTime != null &&
                            widget.checkOutTime!.trim().isNotEmpty) ...[

                          const SizedBox(height: 18),

                          _detailTile(
                            icon:
                            Icons.logout_rounded,

                            title:
                            "Check-out Time",

                            value:
                            _formatTime(widget.checkOutTime),
                          ),
                        ],

                        const SizedBox(height: 18),

                        _detailTile(
                          icon:
                          Icons.calendar_month_rounded,

                          title: "Date",

                          value:
                          _formatDate(widget.attendanceDate),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height:
                    isTablet ? 28 : 24,
                  ),

                  /// LOADER
                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(30),

                    child:
                    LinearProgressIndicator(
                      minHeight: 6,

                      color: primaryColor,

                      backgroundColor:
                      Colors.white
                          .withOpacity(.06),
                    ),
                  ),

                  SizedBox(height: 16),

                  Text(
                    "Redirecting to scanner...",

                    style: TextStyle(
                      color: Colors.white54,

                      fontSize:
                      isTablet ? 15 : 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailTile({

    required IconData icon,

    required String title,

    required String value,
  }) {

    return Row(
      children: [

        Container(
          height: 44,
          width: 44,

          decoration: BoxDecoration(
            color: Colors.white
                .withOpacity(.05),

            borderRadius:
            BorderRadius.circular(14),
          ),

          child: Icon(
            icon,
            color: Colors.white70,
            size: 22,
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
                  color: Colors.white54,

                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 4),

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
          ),
        ),
      ],
    );
  }

  String _formatTime(String? raw) {
    if (raw == null || raw.trim().isEmpty) return "--";
    final trimmed = raw.trim();
    try {
      final dt = DateTime.tryParse(trimmed);
      if (dt != null) {
        return DateFormat('hh:mm a').format(dt.toLocal());
      }
    } catch (_) {}
    return trimmed;
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return "--";
    final trimmed = raw.trim();
    try {
      final dt = DateTime.tryParse(trimmed);
      if (dt != null) {
        return DateFormat('dd MMM yyyy').format(dt.toLocal());
      }
    } catch (_) {}
    return trimmed;
  }
}