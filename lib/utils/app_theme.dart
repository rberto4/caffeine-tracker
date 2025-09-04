import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized theme configuration for the Caffeine Tracker app
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      surfaceContainer: AppColors.surfaceContainerLight,
      brightness: Brightness.light,
      primary: AppColors.primaryOrange,
      onPrimary: AppColors.white,
      secondary: AppColors.primaryOrangeLight,
      onSecondary: AppColors.white,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.onSurfaceLight,
      error: AppColors.error,
      onError: AppColors.white,
    ),
    textTheme: _textTheme(AppColors.onBackgroundLight),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.onBackgroundLight,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.onBackgroundLight,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: AppColors.white,
        textStyle: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.backgroundLight,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
      ),
      labelStyle: GoogleFonts.outfit(color: AppColors.grey600, fontSize: 16),
    ),
  );

  /// Dark theme configuration
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      surfaceContainer: AppColors.surfaceContainerDark,
      brightness: Brightness.dark,
      primary: AppColors.primaryOrange,
      onPrimary: AppColors.white,
      secondary: AppColors.primaryOrangeLight,
      onSecondary: AppColors.white,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
      error: AppColors.error,
      onError: AppColors.white,
    ),
    textTheme: _textTheme(AppColors.onBackgroundDark),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.onBackgroundDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.onBackgroundDark,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: AppColors.white,
        textStyle: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.backgroundDark,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
      ),
      labelStyle: GoogleFonts.outfit(color: AppColors.grey400, fontSize: 16),
    ),
  );

  /// Text theme configuration using Google Fonts (Outfit)
  static TextTheme _textTheme(Color textColor) {
    return TextTheme(
      headlineLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleSmall: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodySmall: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      labelLarge: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelMedium: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelSmall: GoogleFonts.outfit(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }
}
