import 'package:flutter/material.dart';

import '../ui/theme/app_theme.dart';

class FFBottomNav extends StatelessWidget {
  const FFBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.teal,
      unselectedItemColor: AppColors.subtext,
      selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Image.asset(
    'assets/icons/inactive_offer.png', // Your icon's asset path
    width: 24, // Adjust size as needed
    height: 24,
    color: Color(0xFF8A8A8D), // Color for the unselected state (e.g., grey)
    ),
    // Optionally, provide a different look for the active/selected state
    activeIcon: Image.asset(
    'assets/icons/active_offer.png', // Your icon's asset path
    width: 24, // Adjust size as needed
    height: 24,
    color: Color(0xFF33595B), // Color for the selected state (e.g., your teal color)
    ), label: 'Offer'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Order'),
        BottomNavigationBarItem(icon: Icon(Icons.help_outline_rounded), label: 'Help'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
      ],
    );
  }
}
