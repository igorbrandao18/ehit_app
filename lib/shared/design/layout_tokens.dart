import 'package:flutter/material.dart';
import 'design_tokens.dart';
class LayoutTokens {
  static const double sectionSpacing = DesignTokens.spaceLG;
  static const double sectionPadding = DesignTokens.spaceMD;
  static const double sectionMargin = DesignTokens.spaceSM;
  static const double bannerBottomSpacing = DesignTokens.bannerBottomSpacing;
  static const double cardSpacing = DesignTokens.cardSpacing;
  static const double cardPadding = DesignTokens.cardPadding;
  static const double cardMargin = DesignTokens.cardMargin;
  static const double gridSpacing = DesignTokens.spaceMD;
  static const double gridPadding = DesignTokens.spaceLG;
  static const double listItemSpacing = DesignTokens.spaceSM;
  static const double listPadding = DesignTokens.spaceMD;
  static const double headerHeight = 56.0;
  static const double headerPadding = DesignTokens.spaceMD;
  static const double bottomNavHeight = kBottomNavigationBarHeight;
  static const double bottomNavPadding = DesignTokens.spaceSM;
  static const double paddingXS = DesignTokens.spaceXS;
  static const double paddingSM = DesignTokens.spaceSM;
  static const double paddingMD = DesignTokens.spaceMD;
  static const double paddingLG = DesignTokens.spaceLG;
  static const double paddingXL = DesignTokens.spaceXL;
  static const double radiusXS = DesignTokens.radiusSM;
  static const double radiusSM = DesignTokens.radiusSM;
  static const double radiusMD = DesignTokens.radiusMD;
  static const double radiusLG = DesignTokens.radiusLG;
  static const double radiusXL = DesignTokens.radiusLG;
  static const double radiusCircular = DesignTokens.radiusCircular;
  static const double featuredCardHeight = DesignTokens.musicCardHeightLarge;
  static const double bannerCardHeight = DesignTokens.musicCardHeight;
  static const double bannerCardWidth = DesignTokens.musicCardWidth;
  static const double playlistCardSize = DesignTokens.playlistCardSize;
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return DesignTokens.getResponsivePadding(context);
  }
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
  static const double maxContentWidth = 1200.0;
  static const double mobileContentWidth = 360.0;
  static const double sidebarWidth = 280.0;
  static const double drawerWidth = 300.0;
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  static const double mobileBreakpoint = 480.0;
  static const double tabletBreakpoint = 768.0;
  static const double desktopBreakpoint = 1024.0;
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }
}
