// shared/themes/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (ÊHIT Theme - Dark Red)
  static const Color primaryRed = Color(0xFF8B0000); // Dark red
  static const Color primaryDark = Color(0xFF1A0000); // Very dark red
  static const Color backgroundDark = Color(0xFF0D0000); // Almost black with red tint
  static const Color backgroundCard = Color(0xFF2A0000); // Dark red card background
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF); // White text
  static const Color textSecondary = Color(0xFFB3B3B3); // Light gray
  static const Color textTertiary = Color(0xFF808080); // Medium gray
  
  // Accent Colors
  static const Color accentYellow = Color(0xFFFFD700); // Gold for album titles
  static const Color accentBlue = Color(0xFF4169E1); // Blue for backgrounds
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryRed, primaryDark],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundDark, Color(0xFF000000)],
  );
}
