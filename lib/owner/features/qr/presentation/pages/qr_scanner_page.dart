import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../cubit/scan_qr_cubit.dart';
import '../cubit/scan_qr_state.dart';
import 'sucess_scan_page.dart';

class QrScannerPage extends StatefulWidget {

  const QrScannerPage({
    super.key,
  });

  @override
  State<QrScannerPage> createState() =>
      _QrScannerPageState();
}

class _QrScannerPageState
    extends State<QrScannerPage>
    with
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver {

  late AnimationController
  _animationController;

  final FlutterTts flutterTts =
  FlutterTts();

  final MobileScannerController
  scannerController =
  MobileScannerController(

    detectionSpeed:
    DetectionSpeed.normal,

    detectionTimeoutMs: 1500,

    facing: CameraFacing.back,

    torchEnabled: false,
  );

  bool isTorchOn = false;

  bool isFrontCamera = false;

  bool isProcessing = false;

  bool isScannerPaused = false;

  /// SAME QR COOLDOWN
  String? lastScannedQr;

  DateTime? lastScanTime;

  Timer? restartTimer;

  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance
        .addObserver(this);

    _animationController =
    AnimationController(
      vsync: this,

      duration: const Duration(
        seconds: 2,
      ),
    )..repeat(reverse: true);

    _initTts();
  }

  /// APP LIFECYCLE
  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state) async {

    if (state ==
        AppLifecycleState.paused) {

      try {

        await scannerController.stop();

      } catch (_) {}
    }

    if (state ==
        AppLifecycleState.resumed) {

      try {

        await scannerController.start();

      } catch (_) {}
    }
  }

  Future<void> _initTts() async {

    await flutterTts.setLanguage(
      "en-US",
    );

    await flutterTts.setSpeechRate(
      0.45,
    );

    await flutterTts.setPitch(1.0);

    await flutterTts.setVolume(1.0);
  }

  @override
  void dispose() {

    WidgetsBinding.instance
        .removeObserver(this);

    restartTimer?.cancel();

    _animationController.dispose();

    scannerController.dispose();

    flutterTts.stop();

    super.dispose();
  }

  Future<void> _restartScanner({
    int delaySeconds = 2,
  }) async {

    restartTimer?.cancel();

    restartTimer = Timer(
      Duration(
        seconds: delaySeconds,
      ),
          () async {

        if (!mounted) return;

        try {

          await scannerController
              .start();

        } catch (_) {}

        isProcessing = false;

        isScannerPaused = false;
      },
    );
  }

  Future<void> _onDetectBarcode(
      BarcodeCapture capture,
      ) async {

    /// PREVENT MULTIPLE API CALLS
    if (isProcessing ||
        isScannerPaused) {
      return;
    }

    final List<Barcode> barcodes =
        capture.barcodes;

    if (barcodes.isEmpty) {
      return;
    }

    final String? rawValue =
        barcodes.first.rawValue;

    if (rawValue == null ||
        rawValue.trim().isEmpty) {
      return;
    }

    /// SAME QR COOLDOWN
    if (lastScannedQr == rawValue &&
        lastScanTime != null) {

      final difference =
      DateTime.now().difference(
        lastScanTime!,
      );

      /// BLOCK SAME QR FOR 3 SEC
      if (difference.inSeconds < 3) {
        return;
      }
    }

    /// SAVE LAST QR
    lastScannedQr = rawValue;

    lastScanTime = DateTime.now();

    isProcessing = true;

    isScannerPaused = true;

    /// CLICK SOUND
    SystemSound.play(
      SystemSoundType.click,
    );

    try {

      await scannerController.stop();

    } catch (_) {}

    if (!mounted) return;

    context
        .read<ScanQrCubit>()
        .checkInCheckOut(
      qrToken: rawValue,
    );
  }

  @override
  Widget build(BuildContext context) {

    final size =
        MediaQuery.of(context).size;

    final bool isTablet =
        size.width > 700;

    final double scanSize =
    isTablet
        ? 380
        : size.width * .78;

    return Scaffold(
      backgroundColor:
      const Color(0xFF070B16),

      body: BlocConsumer<
          ScanQrCubit,
          ScanQrState>(

        listener: (
            context,
            state,
            ) async {

          /// SUCCESS
          if (state
          is ScanQrSuccess) {

            try {

              await flutterTts.stop();

              await flutterTts.speak(
                state.voiceText
                    .toString(),
              );

            } catch (_) {}

            if (!mounted) return;

            await Navigator.push(
              context,

              PageRouteBuilder(
                opaque: false,

                transitionDuration:
                const Duration(
                  milliseconds: 400,
                ),

                pageBuilder:
                    (
                    context,
                    animation,
                    secondaryAnimation,
                    ) =>
                    FadeTransition(
                      opacity: animation,

                      child:
                      ScanSuccessPage(

                        type:
                        state.type,

                        memberName:
                        state.memberName,

                        message:
                        state.message,

                        checkInTime:
                        state.checkInTime,

                        checkOutTime:
                        state.checkOutTime,

                        attendanceDate:
                        state.attendanceDate,

                        profilePhoto:
                        state.profilePhoto,
                      ),
                    ),
              ),
            );

            /// RESTART
            await _restartScanner(
              delaySeconds: 1,
            );

          }

          /// ERROR
          else if (state
          is ScanQrError) {

            if (!mounted) return;

            Color snackColor =
            const Color(
              0xFF1A1F38,
            );

            IconData icon =
                Icons.error_outline_rounded;

            switch (state.type) {

            /// WAIT BEFORE CHECKOUT
              case "wait":

                snackColor =
                const Color(
                  0xFFE6A700,
                );

                icon =
                    Icons.timer_rounded;

                break;

            /// ATTENDANCE COMPLETE
              case "already-completed":

                snackColor =
                const Color(
                  0xFFD32F2F,
                );

                icon =
                    Icons.check_circle_rounded;

                break;

            /// GYM CLOSED
              case "gym-closed":

                snackColor =
                const Color(
                  0xFFEF6C00,
                );

                icon =
                    Icons.lock_clock_rounded;

                break;

            /// DUPLICATE
              case "duplicate":

                snackColor =
                const Color(
                  0xFF8E24AA,
                );

                icon =
                    Icons.warning_amber_rounded;

                break;

            /// SERVER ERROR
              case "server-error":

                snackColor =
                const Color(
                  0xFFC62828,
                );

                icon =
                    Icons.cloud_off_rounded;

                break;
            }

            ScaffoldMessenger.of(
              context,
            )
              ..hideCurrentSnackBar()
              ..showSnackBar(

                SnackBar(
                  behavior:
                  SnackBarBehavior
                      .floating,

                  backgroundColor:
                  snackColor,

                  margin:
                  const EdgeInsets.all(
                    16,
                  ),

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      16,
                    ),
                  ),

                  duration:
                  const Duration(
                    seconds: 2,
                  ),

                  content: Row(
                    children: [

                      Icon(
                        icon,
                        color:
                        Colors.white,
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      Expanded(
                        child: Text(
                          state.message
                              .toString(),

                          style:
                          const TextStyle(
                            color:
                            Colors.white,

                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

            /// ERROR VOICE
            try {

              await flutterTts.stop();

              await flutterTts.speak(
                state.message
                    .toString(),
              );

            } catch (_) {}

            /// WAIT CASE
            if (state.type ==
                "wait") {

              await _restartScanner(
                delaySeconds: 3,
              );

            } else {

              await _restartScanner(
                delaySeconds: 2,
              );
            }
          }
        },

        builder: (
            context,
            state,
            ) {

          return Stack(
            children: [

              /// CAMERA
              RepaintBoundary(
                child: MobileScanner(
                  controller:
                  scannerController,

                  fit: BoxFit.cover,

                  onDetect:
                  _onDetectBarcode,
                ),
              ),

              /// OVERLAY
              Container(
                color: Colors.black
                    .withOpacity(.55),
              ),

              /// TOP GLOW
              Positioned(
                top: -120,
                right: -80,

                child: Container(
                  height: 260,
                  width: 260,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: const Color(
                      0xFF7B61FF,
                    ).withOpacity(.18),
                  ),
                ),
              ),

              /// BOTTOM GLOW
              Positioned(
                bottom: -140,
                left: -100,

                child: Container(
                  height: 260,
                  width: 260,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: const Color(
                      0xFF7B61FF,
                    ).withOpacity(.12),
                  ),
                ),
              ),

              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints:
                    BoxConstraints(
                      maxWidth:
                      isTablet
                          ? 700
                          : double.infinity,
                    ),

                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(
                        horizontal:
                        isTablet
                            ? 28
                            : 18,

                        vertical: 18,
                      ),

                      child: Column(
                        children: [

                          /// TOP BAR
                          Row(
                            children: [

                              Expanded(
                                child: Center(
                                  child: Column(
                                    children: [

                                      Text(
                                        "Gym Scanner",

                                        style:
                                        TextStyle(
                                          color:
                                          Colors
                                              .white54,

                                          fontSize:
                                          isTablet
                                              ? 14
                                              : 11,

                                          letterSpacing:
                                          2,
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                        4,
                                      ),

                                      Text(
                                        "Scan Member QR",

                                        style:
                                        TextStyle(
                                          color:
                                          Colors
                                              .white,

                                          fontSize:
                                          isTablet
                                              ? 28
                                              : 22,

                                          fontWeight:
                                          FontWeight
                                              .w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Row(
                                children: [

                                  /// FLASH
                                  _topButton(
                                    icon:
                                    isTorchOn
                                        ? Icons.flash_on_rounded
                                        : Icons.flash_off_rounded,

                                    onTap:
                                        () async {

                                      await scannerController
                                          .toggleTorch();

                                      setState(() {
                                        isTorchOn =
                                        !isTorchOn;
                                      });
                                    },
                                  ),

                                  const SizedBox(
                                    width: 10,
                                  ),

                                  /// CAMERA SWITCH
                                  _topButton(
                                    icon:
                                    Icons
                                        .flip_camera_ios_rounded,

                                    onTap:
                                        () async {

                                      await scannerController
                                          .switchCamera();

                                      setState(() {
                                        isFrontCamera =
                                        !isFrontCamera;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const Spacer(),

                          /// SCAN AREA
                          Stack(
                            alignment:
                            Alignment.center,

                            children: [

                              /// OUTER GLOW
                              Container(
                                height:
                                scanSize + 50,

                                width:
                                scanSize + 50,

                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(
                                    40,
                                  ),

                                  gradient:
                                  RadialGradient(
                                    colors: [
                                      const Color(
                                        0xFF7B61FF,
                                      ).withOpacity(
                                        .20,
                                      ),

                                      Colors
                                          .transparent,
                                    ],
                                  ),
                                ),
                              ),

                              /// MAIN BOX
                              Container(
                                height:
                                scanSize,

                                width:
                                scanSize,

                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(
                                    32,
                                  ),

                                  border:
                                  Border.all(
                                    color: Colors
                                        .white
                                        .withOpacity(
                                      .10,
                                    ),

                                    width: 1.5,
                                  ),
                                ),
                              ),

                              /// SCAN LINE
                              AnimatedBuilder(
                                animation:
                                _animationController,

                                builder:
                                    (
                                    context,
                                    child,
                                    ) {

                                  return Positioned(
                                    top:
                                    (_animationController.value *
                                        (scanSize -
                                            50)),

                                    child:
                                    Container(
                                      width:
                                      scanSize *
                                          .82,

                                      height:
                                      4,

                                      decoration:
                                      BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(
                                          30,
                                        ),

                                        gradient:
                                        const LinearGradient(
                                          colors: [
                                            Colors.transparent,

                                            Color(
                                              0xFFB28CFF,
                                            ),

                                            Colors.transparent,
                                          ],
                                        ),

                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFFB28CFF,
                                            ).withOpacity(
                                              .8,
                                            ),

                                            blurRadius:
                                            12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),

                              /// CORNERS
                              SizedBox(
                                height:
                                scanSize,

                                width:
                                scanSize,

                                child: Stack(
                                  children: [

                                    _corner(
                                      top: 0,
                                      left: 0,
                                    ),

                                    _corner(
                                      top: 0,
                                      right: 0,
                                    ),

                                    _corner(
                                      bottom: 0,
                                      left: 0,
                                    ),

                                    _corner(
                                      bottom: 0,
                                      right: 0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height:
                            isTablet
                                ? 36
                                : 26,
                          ),

                          Text(
                            "Place Member QR Inside Frame",

                            textAlign:
                            TextAlign.center,

                            style: TextStyle(
                              color:
                              Colors.white,

                              fontSize:
                              isTablet
                                  ? 22
                                  : 18,

                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            "Attendance will be marked automatically",

                            textAlign:
                            TextAlign.center,

                            style: TextStyle(
                              color:
                              Colors.white70,

                              fontSize:
                              isTablet
                                  ? 16
                                  : 13,
                            ),
                          ),

                          const Spacer(),

                          if (state
                          is ScanQrLoading)

                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal:
                                20,

                                vertical: 14,
                              ),

                              decoration:
                              BoxDecoration(
                                color: Colors.white
                                    .withOpacity(
                                  .08,
                                ),

                                borderRadius:
                                BorderRadius.circular(
                                  20,
                                ),
                              ),

                              child: const Row(
                                mainAxisSize:
                                MainAxisSize.min,

                                children: [

                                  SizedBox(
                                    height:
                                    18,

                                    width:
                                    18,

                                    child:
                                    CircularProgressIndicator(
                                      strokeWidth:
                                      2,

                                      color:
                                      Color(
                                        0xFFB28CFF,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: 14,
                                  ),

                                  Text(
                                    "Processing Attendance...",

                                    style:
                                    TextStyle(
                                      color:
                                      Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _topButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {

    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 52,
        width: 52,

        decoration: BoxDecoration(
          color: Colors.white
              .withOpacity(.08),

          borderRadius:
          BorderRadius.circular(
            18,
          ),

          border: Border.all(
            color: Colors.white
                .withOpacity(.06),
          ),
        ),

        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _corner({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,

      child: Container(
        height: 48,
        width: 48,

        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.only(
            topLeft:
            top != null &&
                left != null
                ? const Radius.circular(
              20,
            )
                : Radius.zero,

            topRight:
            top != null &&
                right != null
                ? const Radius.circular(
              20,
            )
                : Radius.zero,

            bottomLeft:
            bottom != null &&
                left != null
                ? const Radius.circular(
              20,
            )
                : Radius.zero,

            bottomRight:
            bottom != null &&
                right != null
                ? const Radius.circular(
              20,
            )
                : Radius.zero,
          ),

          border: Border(
            top:
            top != null
                ? const BorderSide(
              color: Color(
                0xFF9F7CFF,
              ),

              width: 5,
            )
                : BorderSide.none,

            left:
            left != null
                ? const BorderSide(
              color: Color(
                0xFF9F7CFF,
              ),

              width: 5,
            )
                : BorderSide.none,

            right:
            right != null
                ? const BorderSide(
              color: Color(
                0xFF9F7CFF,
              ),

              width: 5,
            )
                : BorderSide.none,

            bottom:
            bottom != null
                ? const BorderSide(
              color: Color(
                0xFF9F7CFF,
              ),

              width: 5,
            )
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}