// shared/design/layout_tokens.dart
import 'package:flutter/material.dart';
import 'design_tokens.dart';

/// Layout-specific tokens for consistent spacing and sizing
/// This class provides layout-specific constants that complement DesignTokens
class LayoutTokens {
  // ============================================================================
  // SECTION SPACING
  // ============================================================================
  
  static const double sectionSpacing = DesignTokens.spaceLG;
  static const double sectionPadding = DesignTokens.spaceMD;
  static const double sectionMargin = DesignTokens.spaceSM;
  
  // ============================================================================
  // CARD LAYOUT
  // ============================================================================
  
  static const double cardSpacing = DesignTokens.cardSpacing;
  static const double cardPadding = DesignTokens.cardPadding;
  static const double cardMargin = DesignTokens.cardMargin;
  
  // ============================================================================
  // GRID LAYOUT
  // ============================================================================
  
  static const double gridSpacing = DesignTokens.spaceMD;
  static const double gridPadding = DesignTokens.spaceLG;
  
  // ============================================================================
  // LIST LAYOUT
  // ============================================================================
  
  static const double listItemSpacing = DesignTokens.spaceSM;
  static const double listPadding = DesignTokens.spaceMD;
  
  // ============================================================================
  // HEADER LAYOUT
  // ============================================================================
  
  static const double headerHeight = 56.0;
  static const double headerPadding = DesignTokens.spaceMD;
  
  // ============================================================================
  // BOTTOM NAVIGATION
  // ============================================================================
  
  static const double bottomNavHeight = kBottomNavigationBarHeight;
  static const double bottomNavPadding = DesignTokens.spaceSM;
  
  // ============================================================================
  // PADDING SYSTEM (Legacy compatibility)
  // ============================================================================
  
  static const double paddingXS = DesignTokens.spaceXS;
  static const double paddingSM = DesignTokens.spaceSM;
  static const double paddingMD = DesignTokens.spaceMD;
  static const double paddingLG = DesignTokens.spaceLG;
  static const double paddingXL = DesignTokens.spaceXL;
  
  // ============================================================================
  // BORDER RADIUS SYSTEM (Legacy compatibility)
  // ============================================================================
  
  static const double radiusXS = DesignTokens.radiusSM;
  static const double radiusSM = DesignTokens.radiusSM;
  static const double radiusMD = DesignTokens.radiusMD;
  static const double radiusLG = DesignTokens.radiusLG;
  static const double radiusXL = DesignTokens.radiusLG;
  static const double radiusCircular = DesignTokens.radiusCircular;
  
  // ============================================================================
  // CARD DIMENSIONS (Legacy compatibility)
  // ============================================================================
  
  static const double featuredCardHeight = DesignTokens.musicCardHeightLarge;
  static const double bannerCardHeight = DesignTokens.musicCardHeight;
  static const double bannerCardWidth = DesignTokens.musicCardWidth;
  static const double playlistCardSize = DesignTokens.playlistCardSize;
  
  // ============================================================================
  // RESPONSIVE LAYOUT UTILITIES
  // ============================================================================
  
  /// Get safe area padding for the current context
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }
  
  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return DesignTokens.getResponsivePadding(context);
  }
  
  /// Get responsive margin based on screen size
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 768) {
      return const EdgeInsets.all(DesignTokens.spaceXL);
    } else if (screenWidth > 480) {
      return const EdgeInsets.all(DesignTokens.spaceLG);
    } else {
      return const EdgeInsets.all(DesignTokens.spaceMD);
    }
  }
  
  /// Get responsive spacing between sections
  static double getResponsiveSpacing(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 768) {
      return DesignTokens.spaceXL;
    } else if (screenWidth > 480) {
      return DesignTokens.spaceLG;
    } else {
      return DesignTokens.spaceMD;
    }
  }
  
  // ============================================================================
  // LAYOUT CONSTANTS
  // ============================================================================
  
  /// Standard content width for tablets
  static const double maxContentWidth = 1200.0;
  
  /// Standard content width for mobile
  static const double mobileContentWidth = 360.0;
  
  /// Standard sidebar width
  static const double sidebarWidth = 280.0;
  
  /// Standard drawer width
  static const double drawerWidth = 300.0;
  
  // ============================================================================
  // ANIMATION DURATIONS
  // ============================================================================
  
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // ============================================================================
  // BREAKPOINTS
  // ============================================================================
  
  static const double mobileBreakpoint = 480.0;
  static const double tabletBreakpoint = 768.0;
  static const double desktopBreakpoint = 1024.0;
  
  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }
  
  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }
  
  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }
}
