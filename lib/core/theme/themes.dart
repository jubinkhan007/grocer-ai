import 'package:flutter/material.dart';
import 'package:grocer_ai/core/theme/spacing.dart';
import 'colors.dart';
import 'typography.dart';

ThemeData buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.seed,
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    textTheme: AppTypography.textTheme,
    scaffoldBackgroundColor: isDark
        ? const Color(0xFF0E1013)
        : AppColors.neutral10,
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      // backgroundColor: Colors.transparent,
      //foregroundColor: scheme.onBackground,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0xFF171A1F) : AppColors.neutral0,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
    chipTheme: ChipThemeData(
      labelStyle: AppTypography.textTheme.labelMedium!,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    cardTheme: CardThemeData(
      elevation: Elevation.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    buttonTheme: const ButtonThemeData(alignedDropdown: true),
  );
}

final lightTheme = buildTheme(Brightness.light);
final darkTheme = buildTheme(Brightness.dark);
