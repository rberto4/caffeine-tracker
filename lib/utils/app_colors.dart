import 'package:flutter/material.dart';

/// Centralized color palette for the Caffeine Tracker app
class AppColors {
  AppColors._();

  // Primary colors
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color primaryOrangeDark = Color(0xFFE55A2B);
  static const Color primaryOrangeLight = Color(0xFFFF8A65);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Background colors for light theme
  static const Color backgroundLight = white;
  static const Color surfaceLight = white;
  static const Color surfaceContainerLight = white;
  static const Color onBackgroundLight = grey900;
  static const Color onSurfaceLight = grey900;

  // Background colors for dark theme
  static const Color backgroundDark = Color.fromARGB(255, 0, 0, 0);
  static const Color surfaceDark = Color.fromARGB(255, 35, 35, 35);
  static const Color surfaceContainerDark = Color.fromARGB(255, 58, 58, 58);
  static const Color onBackgroundDark = white;
  static const Color onSurfaceDark = white;

  // Caffeine level indicator colors
  static const Color caffeineLevel1 = Color(0xFF4CAF50); // Low (Green)
  static const Color caffeineLevel2 = Color(0xFFFFEB3B); // Medium (Yellow)
  static const Color caffeineLevel3 = Color(0xFFFF9800); // High (Orange)
  static const Color caffeineLevel4 = Color(0xFFF44336); // Very High (Red)

  // Beverage category colors (for drink identification)
  static const Color beverageBlue = Color(0xFF2196F3);    // Blue
  static const Color beverageGreen = Color(0xFF4CAF50);   // Green
  static const Color beverageOrange = Color(0xFFFF9800);  // Orange
  static const Color beveragePurple = Color(0xFF9C27B0);  // Purple
  static const Color beverageRed = Color(0xFFF44336);     // Red
  static const Color beverageTeal = Color(0xFF009688);    // Teal
  static const Color beverageBrown = Color(0xFF795548);  // Brown

  /// List of available beverage colors
  static const List<Color> beverageColors = [
    beverageBlue,
    beverageGreen,
    beverageOrange,
    beveragePurple,
    beverageRed,
    beverageTeal,
    beverageBrown,
  ];

  /// Get beverage color by index
  static Color getBeverageColor(int index) {
    return beverageColors[index % beverageColors.length];
  }
}
