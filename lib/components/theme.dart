import 'package:flutter/material.dart';
import 'colors.dart';

class ZahraTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ZahraColors.deepSpace,
      primaryColor: ZahraColors.electricBlue,
      colorScheme: const ColorScheme.dark(
        primary: ZahraColors.electricBlue,
        secondary: ZahraColors.healingTeal,
        surface: ZahraColors.deepSpace,
        background: ZahraColors.deepSpace,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: ZahraColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: ZahraColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: ZahraColors.textPrimary,
        ),
      ),
    );
  }
}
