import 'package:flutter/material.dart';

class AppColors {
  // From your Figma (teal/dark header + neutrals)
  static const teal = Color(0xFF33595B);
  static const tealDark = Color(0xFF0B4A46);
  static const bg = Color(0xFFF6F7F8);
  static const card = Colors.white;
  static const text = Color(0xFF1E1E1E);
  static const subtext = Color(0xFF6F7376);
  static const divider = Color(0xFFE8EAED);
  static const success = Color(0xFF1FBF75);
  static const danger = Color(0xFFE24A4A);
  static const warning = Color(0xFFF8B84E);
}

class AppSpacings {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const r = 14.0; // card radius matches Figma
}

ThemeData buildAppTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    primaryColor: AppColors.teal,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.teal,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
    ),
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.teal,
      secondary: AppColors.teal,
      surface: AppColors.card,
    ),
    textTheme: base.textTheme.copyWith(
      titleLarge: const TextStyle(
          fontSize: 18, height: 1.25, fontWeight: FontWeight.w600, color: AppColors.text),
      titleMedium: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.text),
      bodyLarge: const TextStyle(fontSize: 16, color: AppColors.text),
      bodyMedium: const TextStyle(fontSize: 14, color: AppColors.subtext),
      labelLarge: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
    ),
    dividerColor: AppColors.divider,
    cardTheme: CardThemeData(
  color: AppColors.card,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppSpacings.r),
  ),
  elevation: 0,
  margin: EdgeInsets.zero,
),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      dense: true,
      horizontalTitleGap: 12,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.teal,
      unselectedItemColor: AppColors.subtext,
      selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 11),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}
