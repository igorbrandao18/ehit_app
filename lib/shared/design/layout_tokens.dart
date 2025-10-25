// shared/design/layout_tokens.dart
import 'package:flutter/material.dart';

class LayoutTokens {
  // Spacing System
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;

  // Grid System
  static const double cardPadding = 8.0;
  static const double cardMargin = 4.0;
  static const double sectionSpacing = 24.0;
  static const double sectionPadding = 16.0;

  // Border Radius
  static const double radiusSM = 4.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusCircular = 1000.0;

  // Component Dimensions
  static const double miniPlayerHeight = 60.0;
  static const double bannerCardWidth = 80.0;
  static const double bannerCardHeight = 60.0;
  static const double featuredCardHeight = 120.0;
  static const double playlistCardSize = 160.0;
  static const double gridCardSize = 80.0;

  // Responsive Utilities
  static double responsiveWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  static double responsiveHeight(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  static double getAvailableHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height -
           mediaQuery.padding.top -
           mediaQuery.padding.bottom -
           kBottomNavigationBarHeight;
  }

  static double getAvailableWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 768;
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }

  static int getResponsiveColumns(BuildContext context) {
    if (isTablet(context)) {
      return 4;
    }
    if (isSmallScreen(context)) {
      return 2;
    }
    return 3;
  }

  static double getResponsiveCardSize(BuildContext context) {
    final width = getAvailableWidth(context);
    if (isSmallScreen(context)) {
      return width * 0.45;
    }
    if (isTablet(context)) {
      return width * 0.22;
    }
    return width * 0.3;
  }

  static double getGridCardSize(BuildContext context) {
    final width = getAvailableWidth(context);
    return (width - (paddingMD * 2) - (cardMargin * 3)) / 4; // 4 cards per row
  }

  static double getPlaylistCardSize(BuildContext context) {
    final width = getAvailableWidth(context);
    return (width - (paddingMD * 2) - (cardMargin * 2)) / 3; // 3 cards per row
  }
}
