// shared/design/app_colors.dart
import 'package:flutter/material.dart';

/// Sistema de cores consolidado do app ÊHIT
/// Elimina duplicações e centraliza todas as cores
class AppColors {
  // ============================================================================
  // PRIMARY COLORS (ÊHIT Theme - #ef2731)
  // ============================================================================
  
  static const Color primaryRed = Color(0xFFEF2731); // Main brand color
  static const Color primaryDark = Color(0xFFC41E3A); // Darker red
  static const Color backgroundDark = Color(0xFFEF2731); // Main background color
  static const Color backgroundCard = Color(0xFF2A0000); // Dark red card background
  static const Color backgroundLight = Color(0xFF1A1A1A); // Light background
  static const Color backgroundElevated = Color(0xFF2A2A2A); // Elevated background
  
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
    colors: [primaryRed, primaryDark],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEF2731), // Main brand color top-left
      Color(0xFFE0242F), // Slightly darker red
      Color(0xFFD11F2D), // A bit darker
      Color(0xFFC21C2B), // Darker red
      Color(0xFFB31929), // Darkest red
    ],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  );

  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFEF2731), // Main brand color (top)
      Color(0xFFE0242F), // Slightly darker red (middle)
      Color(0xFFD11F2D), // A bit darker (bottom)
    ],
    stops: [0.0, 0.6, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2A0000), // Dark red card
      Color(0xFF1A0000), // Very dark red
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
