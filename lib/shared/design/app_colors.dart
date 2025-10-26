// shared/design/app_colors.dart
import 'package:flutter/material.dart';

/// Sistema de cores consolidado do app ÊHIT
/// Elimina duplicações e centraliza todas as cores
class AppColors {
  // ============================================================================
  // PRIMARY COLORS (ÊHIT Theme - #ef2731)
  // ============================================================================
  
  static const Color primaryRed = Color(0xFFEF2731); // Main brand color
  static const Color primaryDark = Color(0xFFEF2731); // Same color
  static const Color backgroundDark = Color(0xFF000000); // Main background color (preto)
  static const Color backgroundCard = Color(0xFF1A1A1A); // Dark card background
  static const Color backgroundLight = Color(0xFF2A2A2A); // Light background
  static const Color backgroundElevated = Color(0xFF333333); // Elevated background
  
  // ============================================================================
  // TEXT COLORS
  // ============================================================================
  
  static const Color textPrimary = Color(0xFFFFFFFF); // White text
  static const Color textSecondary = Color(0xFFB3B3B3); // Light gray
  static const Color textTertiary = Color(0xFF808080); // Medium gray
  static const Color textDisabled = Color(0xFF555555); // Disabled text
  
  // ============================================================================
  // ACCENT COLORS
  // ============================================================================
  
  static const Color primaryGreen = Color(0xFF1DB954); // Spotify green
  
  static const Color accentYellow = Color(0xFFFFD700); // Gold for album titles
  static const Color accentBlue = Color(0xFF4169E1); // Blue for backgrounds
  static const Color accentGreen = Color(0xFF4CAF50); // Green for success
  static const Color accentOrange = Color(0xFFFF9800); // Orange for warnings
  
  // ============================================================================
  // STATUS COLORS
  // ============================================================================
  
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // ============================================================================
  // GRADIENT COLORS
  // ============================================================================
  
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF2731), Color(0xFFD11F2D)],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF000000), // Preto puro top-left
      Color(0xFF0A0A0A), // Quase preto
      Color(0xFF141414), // Preto mais claro
      Color(0xFF1A1A1A), // Cinza escuro
      Color(0xFF1F1F1F), // Cinza mais claro
    ],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  );

  static const Color solidBackground = Color(0xFF000000); // Solid background color (preto)

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A1A1A), // Dark gray card
      Color(0xFF0F0F0F), // Very dark gray
    ],
  );
  
  // ============================================================================
  // OVERLAY COLORS
  // ============================================================================
  
  static const Color overlayLight = Color(0x1A000000); // 10% black
  static const Color overlayMedium = Color(0x33000000); // 20% black
  static const Color overlayDark = Color(0x66000000); // 40% black
  static const Color overlayStrong = Color(0x99000000); // 60% black
  
  // ============================================================================
  // BORDER COLORS
  // ============================================================================
  
  static const Color borderLight = Color(0xFF333333);
  static const Color borderMedium = Color(0xFF555555);
  static const Color borderDark = Color(0xFF777777);
  
  // ============================================================================
  // SHADOW COLORS
  // ============================================================================
  
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x66000000);
  
  // ============================================================================
  // UTILITY METHODS
  // ============================================================================
  
  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  /// Get primary color with opacity
  static Color primaryWithOpacity(double opacity) {
    return primaryRed.withOpacity(opacity);
  }
  
  /// Get text color with opacity
  static Color textWithOpacity(double opacity) {
    return textPrimary.withOpacity(opacity);
  }
  
  /// Get background color with opacity
  static Color backgroundWithOpacity(double opacity) {
    return backgroundDark.withOpacity(opacity);
  }
}
