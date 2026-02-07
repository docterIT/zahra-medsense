import 'package:flutter/material.dart';

class ZahraColors {
  static const Color deepSpace = Color(0xFF070B0A); // Very dark green background
  static const Color mintGreen = Color(0xFF00FFA3); // Designer's primary green
  static const Color darkCard = Color(0xFF111E1A);  // Card background
  static const Color electricBlue = Color(0xFF00E0FF);
  static const Color healingTeal = Color(0xFF00FFA3);
  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8DA399); // Muted sage/grey
  
  static const Gradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [mintGreen, electricBlue],
  );
}
