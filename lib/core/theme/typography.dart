import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      height: 1.1,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.2,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.25,
    ),
    titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600),
    titleMedium: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
    titleSmall: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
    bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
    bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
    bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
    labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
    labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
  );
}
