// shared/themes/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (ÊHIT Theme - Red/Brown)
  static const Color primaryRed = Color(0xFFE50914); // Spotify-like red
  static const Color primaryBrown = Color(0xFF8B4513); // Saddle brown
  static const Color darkRed = Color(0xFFB71C1C); // Darker red
  static const Color lightBrown = Color(0xFFD2691E); // Chocolate
  
  // Background Colors
  static const Color backgroundDark = Color(0xFF121212); // Dark background
  static const Color backgroundCard = Color(0xFF1E1E1E); // Card background
  static const Color backgroundElevated = Color(0xFF2C2C2C); // Elevated background
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF); // White text
  static const Color textSecondary = Color(0xFFB3B3B3); // Light gray
  static const Color textTertiary = Color(0xFF808080); // Medium gray
  static const Color textDisabled = Color(0xFF4A4A4A); // Dark gray
  
  // Accent Colors
  static const Color accentGreen = Color(0xFF1DB954); // Spotify green
  static const Color accentOrange = Color(0xFFFF6B35); // Orange accent
  static const Color accentGold = Color(0xFFFFD700); // Gold accent
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryRed, primaryBrown],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundDark, Color(0xFF000000)],
  );
}
