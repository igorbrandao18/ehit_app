import 'package:flutter/material.dart';
class DesignTokens {
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double fontSizeXS = 12.0;
  static const double fontSizeSM = 14.0;
  static const double fontSizeMD = 16.0;
  static const double fontSizeLG = 18.0;
  static const double fontSizeXL = 24.0;
  static const double radiusSM = 4.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 12.0;
  static const double radiusCircular = 50.0;
  static const double screenPadding = 16.0;
  static const double musicCardHeight = 200.0;
  static const double musicCardHeightLarge = 240.0;
  static const double musicCardWidth = 120.0; 
  static const double cardSpacing = 12.0;
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
  static const double paddingXS = spaceXS;
  static const double paddingSM = spaceSM;
  static const double paddingMD = spaceMD;
  static const double paddingLG = spaceLG;
  static const double paddingXL = spaceXL;
  static const double sectionSpacing = spaceLG;
  static const double sectionPadding = spaceMD;
  static const double bannerBottomSpacing = 20.0;
  static const double cardPadding = spaceSM;
  static const double cardMargin = spaceXS;
  static const double playlistCardSize = musicCardWidth;
  static const double elevationNone = 0.0;
  static const double elevationSM = 2.0;
  static const double elevationMD = 4.0;
  static const double elevationLG = 8.0;
  static const double elevationXL = 16.0;
  static const double cardBorderRadius = radiusMD;
  static const double buttonBorderRadius = radiusMD;
  static const double inputBorderRadius = radiusSM;
  static const double chipRadius = radiusCircular;
  static const double snackbarRadius = radiusMD;
  static const double modalRadius = radiusLG;
  static const double bottomSheetRadius = radiusLG;
  static const double tooltipRadius = radiusSM;
  static const double buttonPadding = spaceMD;
  static const double buttonHeight = 48.0;
  static const double buttonMinWidth = 88.0;
  static const double iconXS = 12.0;
  static const double iconSM = 16.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;
  static const double iconXL = 40.0;
  static const double iconXXL = 48.0;
  static const double miniPlayerHeight = 80.0;
  static const double playerHorizontalSpacing = spaceLG;
  static const double playerVerticalSpacing = spaceMD;
  static const double playerIconSizeRatio = 0.08;
  static const double playerFontSizeRatio = 0.04;
  static const double playerAlbumSizeRatio = 0.6;
  static const double playerTitleFontSizeRatio = 0.05;
  static const double playerSmallSpacingRatio = 0.02;
  static const double playerButtonSizeRatio = 0.12;
  static const double playerSmallIconSizeRatio = 0.06;
  static const double playerMainButtonSizeRatio = 0.15;
  static const double playerMainIconSizeRatio = 0.08;
  static const double playerProgressBarPadding = spaceMD;
  static const double playerShadowBlur = 8.0;
  static const double playerShadowOffset = 4.0;
  static const double artistHeroImageSizeRatio = 0.4;
  static const double artistHeroIconSizeRatio = 0.15;
  static const double artistHeroFontSizeRatio = 0.045;
  static const double artistHeroShadowBlur = 12.0;
  static const double artistHeroShadowOffset = 6.0;
  static const double albumArtSize = 160.0; 
  static const double playlistCoverSizeRatio = 1.0;
  static const double playlistDetailCoverSizeRatio = 0.833; 
  static const double albumsListOffset = -100.0; 
  static const double albumCardTextHeight = 60.0; 
  static const double titleFontSize = fontSizeXL;
  static const double subtitleFontSize = fontSizeLG;
  static const double bodyFontSize = fontSizeMD;
  static const double captionFontSize = fontSizeXS;
  static const double opacitySubtle = 0.1;
  static const double opacityLight = 0.2;
  static const double opacityMedium = 0.4;
  static const double opacityStrong = 0.6;
  static const double opacityTextSecondary = 0.7;
  static const double opacityShadow = 0.3;
  static const double opacityOverlayLight = 0.1;
  static const double opacityCardOverlay = 0.4;
  static const double listDividerHeight = 1.0;
  static const double chipPadding = spaceSM;
  static const double tooltipPadding = spaceSM;
  static const double cardOverlayOpacity = opacityCardOverlay;
  static const double cardShadowOffset = 2.0;
  static const double cardIconSizeRatio = 0.3;
  static const double miniPlayerShadowBlur = 8.0;
  static const double miniPlayerShadowOffset = 4.0;
  static const double miniPlayerButtonSize = 40.0;
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 768) {
      return const EdgeInsets.symmetric(horizontal: spaceXL);
    } else if (screenWidth > 480) {
      return const EdgeInsets.symmetric(horizontal: spaceLG);
    } else {
      return const EdgeInsets.symmetric(horizontal: spaceMD);
    }
  }
  static const double songItemThumbnailMobile = 50.0; 
  static const double songItemThumbnailTablet = 60.0; 
  static const double songItemThumbnailDesktop = 70.0; 
  static const double playhitsCardHeight = 160.0;
  static const double playhitsCardWidth = 120.0;
  static const double mobileSpacingMultiplier = 0.8;
  static const double mobileHorizontalPaddingMultiplier = 0.5;
  static const double mobileFontSizeMultiplier = 0.9;
  static const double mobileIconSizeMultiplier = 0.7;
  static const double mobilePaddingMultiplier = 0.4;
  static const double mobileSpacingSmallMultiplier = 0.3;
  static const double mobileSpacingTinyMultiplier = 0.2;
  static const double shadowBlurMobile = 4.0;
  static const double shadowBlurTablet = 6.0;
  static const double shadowBlurDesktop = 8.0;
  static const double loadingStrokeMobile = 1.5;
  static const double loadingStrokeDefault = 2.0;
  static const double borderWidthThin = 0.5;
  static const double borderWidthNormal = 1.0;
  static const double opacityOverlayMedium = 0.2;
  static const double lineHeightTight = 1.1;
  static const double lineHeightNormal = 1.2;
  static const double fontSizeAdjustmentSmall = 2.0;
  static const double fontSizeAdjustmentMedium = 3.0;
  static const double fontSizeAdjustmentLarge = 4.0;
  static const double songsListHeightPercentage = 0.4;
  static const int snackbarDurationSeconds = 2;
  static const double cardGradientStop1 = 0.0;
  static const double cardGradientStop2 = 0.5;
  static const double cardGradientStop3 = 1.0;
}
