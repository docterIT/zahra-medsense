import 'package:flutter/material.dart';

class ZahraColors {
  static const Color deepSpace = Color(0xFF0B0E14);
  static const Color electricBlue = Color(0xFF00D1FF);
  static const Color healingTeal = Color(0xFF00F5A0);
  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  
  static const Gradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [electricBlue, healingTeal],
  );
}
