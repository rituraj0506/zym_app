import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            icon: Icons.home_filled,
            label: "Dashboard",
            index: 0,
          ),

          _navItem(
            icon: Icons.groups_rounded,
            label: "Members",
            index: 1,
          ),

          const SizedBox(width: 40),

          _navItem(
            icon: Icons.fact_check_outlined,
            label: "Attendance",
            index: 3,
          ),

          _navItem(
            icon: Icons.person_outline_rounded,
            label: "Profile",
            index: 4,
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        onItemTapped(index);
      },

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected
                ? AppColors.primary
                : Colors.grey.shade500,
          ),

          const SizedBox(height: 4),

          Text(
            label,

            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected
                  ? FontWeight.w600
                  : FontWeight.w500,

              color: isSelected
                  ? AppColors.primary
                  : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}