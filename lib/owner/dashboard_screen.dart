import 'package:flutter/material.dart';
import 'package:zymmanagement/owner/features/attendance/presentation/pages/attendance_details_page.dart';
import 'package:zymmanagement/owner/features/member/presentation/pages/member_details_page.dart';
import 'package:zymmanagement/owner/features/profile/presentation/pages/profile_page.dart';
import 'package:zymmanagement/owner/features/qr/presentation/pages/qr_scanner_page.dart';
import '../theme/app_colors.dart';
import 'custom_bottom_navbar.dart';
import 'features/home/presentation/pages/owner_dashboard_page.dart';
import 'package:permission_handler/permission_handler.dart';


class DashboardScreen extends StatefulWidget {
  final int initialIndex;

  const DashboardScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}


class _DashboardScreenState extends State<DashboardScreen> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }



  Future<void> openScanner() async {

    final status = await Permission.camera.request();

    if (status.isGranted) {

      setState(() {
        selectedIndex = 2;
      });

    } else if (status.isDenied) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Camera permission is required to scan QR.",
          ),
        ),
      );

    } else if (status.isPermanentlyDenied) {

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Camera Permission"),
          content: const Text(
            "Please enable camera permission from settings.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await openAppSettings();
              },
              child: const Text("Settings"),
            ),
          ],
        ),
      );
    }
  }

  final List<Widget> screens = [
    const OwnerDashboardPage(),
    const MemberDetailsPage(),
    const QrScannerPage(),
    const  AttendanceDetailsPage(),
    const ProfilePage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex == 0) {
          final shouldExit = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Exit App"),
                content: const Text(
                  "Are you sure you want to exit?",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text("Yes"),
                  ),
                ],
              );
            },
          );

          return shouldExit ?? false;
        } else {
          setState(() {
            selectedIndex = 0;
          });

          return false;
        }
      },

      child: Scaffold(
        backgroundColor: AppColors.background,

        body: screens[selectedIndex],

        // floatingActionButton: GestureDetector(
        //   onTap: () {
        //     onTabTapped(2);
        //   },

        floatingActionButton: GestureDetector(
          onTap: () async {
            await openScanner();
          },

          child: Container(
            height: 68,
            width: 68,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              gradient: const LinearGradient(
                colors: [
                  Color(0xFF8B5CF6),
                  Color(0xFF6D28D9),
                ],
              ),

              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),

        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: CustomBottomNav(
          selectedIndex: selectedIndex,
          onItemTapped: onTabTapped,
        ),
      ),
    );
  }
}



