import 'package:flutter/material.dart';
class AppColors {
  static const Color primaryRed = Color(0xFFEF2731); 
  static const Color primaryDark = Color(0xFFEF2731);
  static const Color genreCardRed = Color(0xFFB71C1C); 
  static const Color backgroundDark = Color(0xFF000000); 
  static const Color backgroundCard = Color(0xFF1A1A1A); 
  static const Color backgroundLight = Color(0xFF2A2A2A); 
  static const Color backgroundElevated = Color(0xFF333333); 
  static const Color textPrimary = Color(0xFFFFFFFF); 
  static const Color textSecondary = Color(0xFFB3B3B3); 
  static const Color textTertiary = Color(0xFF808080); 
  static const Color textDisabled = Color(0xFF555555); 
  static const Color primaryGreen = Color(0xFF1DB954); 
  static const Color accentYellow = Color(0xFFFFD700); 
  static const Color accentBlue = Color(0xFF4169E1); 
  static const Color accentGreen = Color(0xFF4CAF50); 
  static const Color accentOrange = Color(0xFFFF9800); 
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF2731), Color(0xFFD11F2D)],
  );
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF000000), 
      Color(0xFF0A0A0A), 
      Color(0xFF141414), 
      Color(0xFF1A1A1A), 
      Color(0xFF1F1F1F), 
    ],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  );
  static const Color solidBackground = Color(0xFF000000); 
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A1A1A), 
      Color(0xFF0F0F0F), 
    ],
  );
  static const Color overlayLight = Color(0x1A000000); 
  static const Color overlayMedium = Color(0x33000000); 
  static const Color overlayDark = Color(0x66000000); 
  static const Color overlayStrong = Color(0x99000000); 
  static const Color borderLight = Color(0xFF333333);
  static const Color borderMedium = Color(0xFF555555);
  static const Color borderDark = Color(0xFF777777);
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x66000000);
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  static Color primaryWithOpacity(double opacity) {
    return primaryRed.withOpacity(opacity);
  }
  static Color textWithOpacity(double opacity) {
    return textPrimary.withOpacity(opacity);
  }
  static Color backgroundWithOpacity(double opacity) {
    return backgroundDark.withOpacity(opacity);
  }
}
