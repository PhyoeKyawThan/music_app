import 'package:flutter/material.dart';
import 'package:music_app/constants/app_colors.dart';

class CustomNagivationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNagivationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.navBackground,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.navActive,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      unselectedItemColor: AppColors.navInactive,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        _builtItem(Icon(Icons.home), ""),
        _builtItem(Icon(Icons.music_note), ""),
      ],
    );
  }

  BottomNavigationBarItem _builtItem(Icon icon, String label) {
    return BottomNavigationBarItem(icon: icon, label: label);
  }
}
