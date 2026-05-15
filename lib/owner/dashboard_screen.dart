import 'package:flutter/material.dart';
import 'package:zymmanagement/owner/features/profile/presentation/pages/profile_page.dart';

import '../theme/app_colors.dart';
import 'custom_bottom_navbar.dart';
import 'features/home/presentation/pages/owner_dashboard_page.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const OwnerDashboardPage(),
    const DummyPage(title: "Members"),
    const DummyPage(title: "QR Scanner"),
    const DummyPage(title: "Attendance"),
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

        floatingActionButton: GestureDetector(
          onTap: () {
            onTabTapped(2);
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

class DummyPage extends StatelessWidget {
  final String title;

  const DummyPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}