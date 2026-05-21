import 'package:flutter/material.dart';
import 'package:zymmanagement/user/user_bottom_navbar.dart';
import '../theme/app_colors.dart';

class DashboardContainer extends StatefulWidget {
  const DashboardContainer({super.key});

  @override
  State<DashboardContainer> createState() => _DashboardContainerState();
}

class _DashboardContainerState extends State<DashboardContainer> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const DummyPage(title: "Home"),
    const DummyPage(title: "Profile"),

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



        bottomNavigationBar: UserBottomNavbar(
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
