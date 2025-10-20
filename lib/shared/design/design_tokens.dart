// shared/design/design_tokens.dart
import 'package:flutter/material.dart';

/// Design tokens centralizados para o app ÊHIT
/// Elimina duplicações entre app_dimensions.dart, ui_constants.dart e outros arquivos de tema
class DesignTokens {
  // ============================================================================
  // BREAKPOINTS & RESPONSIVE
  // ============================================================================
  
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  // ============================================================================
  // SPACING SYSTEM
  // ============================================================================
  
  // Base spacing unit (8px)
  static const double spaceUnit = 8.0;
  
  // Spacing scale
  static const double spaceXXS = spaceUnit * 0.25; // 2px
  static const double spaceXS = spaceUnit * 0.5; // 4px
  static const double spaceSM = spaceUnit; // 8px
  static const double spaceMD = spaceUnit * 2; // 16px
  static const double spaceLG = spaceUnit * 3; // 24px
  static const double spaceXL = spaceUnit * 4; // 32px
  static const double spaceXXL = spaceUnit * 5; // 40px
  static const double spaceXXXL = spaceUnit * 6; // 48px

  // Semantic spacing
  static const double screenPadding = spaceMD; // 16px
  static const double cardPadding = spaceUnit * 1.5; // 12px
  static const double buttonPadding = spaceMD; // 16px
  static const double inputPadding = spaceUnit * 1.5; // 12px
  static const double sectionSpacing = spaceXL; // 32px
  static const double cardSpacing = spaceMD; // 16px
  static const double itemSpacing = spaceSM; // 8px
  static const double listHeaderSpacing = spaceUnit * 1.5; // 12px
  static const double songItemSpacing = spaceXXS; // 2px

  // ============================================================================
  // BORDER RADIUS SYSTEM
  // ============================================================================
  
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircular = 50.0;

  // Semantic border radius
  static const double cardBorderRadius = radiusMD; // 12px
  static const double buttonBorderRadius = radiusSM; // 8px
  static const double inputBorderRadius = radiusSM; // 8px
  static const double imageBorderRadius = radiusSM; // 8px
  static const double modalRadius = radiusMD; // 12px
  static const double bottomSheetRadius = radiusLG; // 16px
  static const double searchBarRadius = radiusXL; // 24px

  // ============================================================================
  // TYPOGRAPHY SYSTEM
  // ============================================================================
  
  // Font sizes
  static const double fontSizeXS = 12.0;
  static const double fontSizeSM = 14.0;
  static const double fontSizeMD = 16.0;
  static const double fontSizeLG = 18.0;
  static const double fontSizeXL = 20.0;
  static const double fontSizeXXL = 24.0;
  static const double fontSizeXXXL = 32.0;

  // Semantic font sizes
  static const double captionFontSize = fontSizeXS; // 12px
  static const double bodyFontSize = fontSizeMD; // 16px
  static const double subtitleFontSize = fontSizeLG; // 18px
  static const double titleFontSize = fontSizeXL; // 20px
  static const double headingFontSize = fontSizeXXL; // 24px
  static const double displayFontSize = fontSizeXXXL; // 32px

  // ============================================================================
  // ICON SYSTEM
  // ============================================================================
  
  static const double iconXS = 16.0;
  static const double iconSM = 20.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;
  static const double iconXL = 48.0;
  static const double iconXXL = 64.0;

  // ============================================================================
  // COMPONENT DIMENSIONS
  // ============================================================================
  
  // Card dimensions
  static const double musicCardWidth = 180.0;
  static const double musicCardHeight = 260.0;
  static const double musicCardHeightLarge = 300.0;
  static const double artistCardSize = 120.0;
  static const double albumCardWidth = 160.0;
  static const double albumCardHeight = 200.0;

  // Player dimensions
  static const double miniPlayerHeight = 80.0;
  static const double playerControlsHeight = 120.0;
  static const double playButtonSize = iconXL; // 48px
  static const double playButtonSizeLarge = iconXXL; // 64px

  // ============================================================================
  // IMAGE SIZES
  // ============================================================================
  
  static const double songThumbnailSize = 50.0;
  static const double artistImageSize = 180.0;
  static const double albumArtSize = 280.0;
  static const double controlButtonSize = 40.0;

  // Input dimensions
  static const double searchBarHeight = 48.0;
  static const double inputHeight = 48.0;
  static const double buttonHeight = 48.0;
  static const double buttonHeightSM = 32.0;
  static const double buttonHeightLG = 56.0;

  // List dimensions
  static const double listItemHeight = 60.0;
  static const double listItemPadding = spaceUnit * 1.5; // 12px
  static const double listDividerHeight = 1.0;

  // Avatar dimensions
  static const double avatarXS = 32.0;
  static const double avatarSM = 48.0;
  static const double avatarMD = 64.0;
  static const double avatarLG = 96.0;

  // Badge dimensions
  static const double badgeSize = 20.0;
  static const double badgeRadius = 10.0;
  static const double badgePadding = spaceXS; // 4px

  // Chip dimensions
  static const double chipHeight = 32.0;
  static const double chipRadius = 16.0;
  static const double chipPadding = spaceUnit * 1.5; // 12px

  // Progress bar dimensions
  static const double progressBarHeight = 4.0;
  static const double progressBarRadius = 2.0;

  // Snackbar dimensions
  static const double snackbarHeight = 48.0;
  static const double snackbarRadius = radiusSM; // 8px
  static const double snackbarPadding = spaceMD; // 16px

  // Bottom sheet dimensions
  static const double bottomSheetHandleWidth = 40.0;
  static const double bottomSheetHandleHeight = 4.0;

  // Modal dimensions
  static const double modalPadding = 20.0;
  static const double modalMaxWidth = 400.0;

  // Tooltip dimensions
  static const double tooltipRadius = radiusXS; // 4px
  static const double tooltipPadding = spaceSM; // 8px
  static const double tooltipMargin = spaceSM; // 8px

  // ============================================================================
  // ELEVATION SYSTEM
  // ============================================================================
  
  static const double elevationNone = 0.0;
  static const double elevationSM = 2.0;
  static const double elevationMD = 4.0;
  static const double elevationLG = 8.0;
  static const double elevationXL = 16.0;

  // ============================================================================
  // OPACITY SYSTEM
  // ============================================================================
  
  static const double opacityDisabled = 0.5;
  static const double opacityOverlay = 0.4;
  static const double opacitySubtle = 0.7;
  static const double opacityStrong = 0.9;

  // ============================================================================
  // ANIMATION SYSTEM
  // ============================================================================
  
  // Durations
  static const int animationDurationXS = 150;
  static const int animationDurationSM = 200;
  static const int animationDurationMD = 300;
  static const int animationDurationLG = 500;

  // Values
  static const double scaleAnimationValue = 0.05;
  static const double fadeAnimationValue = 0.3;
  static const double slideAnimationValue = 20.0;

  // ============================================================================
  // ASPECT RATIOS
  // ============================================================================
  
  static const double aspectRatioSquare = 1.0;
  static const double aspectRatioLandscape = 16.0 / 9.0;
  static const double aspectRatioPortrait = 9.0 / 16.0;
  static const double aspectRatioAlbum = 1.0;
  static const double aspectRatioArtist = 1.0;

  // ============================================================================
  // GRID SYSTEM
  // ============================================================================
  
  static const int gridColumnsMobile = 2;
  static const int gridColumnsTablet = 3;
  static const int gridColumnsDesktop = 4;
  static const double gridSpacing = spaceMD; // 16px

  // ============================================================================
  // RESPONSIVE UTILITIES
  // ============================================================================
  
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  static double getResponsiveCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) {
      return 200.0;
    } else if (screenWidth >= tabletBreakpoint) {
      return musicCardWidth;
    } else {
      return 160.0;
    }
  }

  static double getResponsiveCardHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) {
      return 280.0;
    } else if (screenWidth >= tabletBreakpoint) {
      return musicCardHeight;
    } else {
      return 240.0;
    }
  }

  static double getResponsiveSpacing(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) {
      return spaceLG;
    } else if (screenWidth >= tabletBreakpoint) {
      return spaceMD;
    } else {
      return spaceSM;
    }
  }

  static int getResponsiveColumns(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) {
      return gridColumnsDesktop;
    } else if (screenWidth >= tabletBreakpoint) {
      return gridColumnsTablet;
    } else {
      return gridColumnsMobile;
    }
  }

  // ============================================================================
  // MUSIC-SPECIFIC RESPONSIVE UTILITIES
  // ============================================================================
  
  static double getMusicCardWidth(BuildContext context, {bool isLarge = false}) {
    final baseWidth = getResponsiveCardWidth(context);
    return isLarge ? baseWidth * 1.2 : baseWidth;
  }

  static double getMusicCardHeight(BuildContext context, {bool isLarge = false}) {
    final baseHeight = getResponsiveCardHeight(context);
    return isLarge ? baseHeight * 1.15 : baseHeight;
  }

  static double getArtistCardSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) {
      return 140.0;
    } else if (screenWidth >= tabletBreakpoint) {
      return artistCardSize;
    } else {
      return 100.0;
    }
  }

  static double getPlaylistCardHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) {
      return 220.0;
    } else if (screenWidth >= tabletBreakpoint) {
      return 200.0;
    } else {
      return 180.0;
    }
  }

  static double getPlayerControlsHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= tabletBreakpoint) {
      return 140.0;
    } else {
      return playerControlsHeight;
    }
  }

  static double getMiniPlayerHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= tabletBreakpoint) {
      return 90.0;
    } else {
      return miniPlayerHeight;
    }
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) {
      return const EdgeInsets.all(spaceXL);
    } else if (screenWidth >= tabletBreakpoint) {
      return const EdgeInsets.all(spaceLG);
    } else {
      return const EdgeInsets.all(screenPadding);
    }
  }

  static EdgeInsets getResponsiveHorizontalPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: spaceXL);
    } else if (screenWidth >= tabletBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: spaceLG);
    } else {
      return const EdgeInsets.symmetric(horizontal: screenPadding);
    }
  }

  // ============================================================================
  // PLAYER PAGE SPECIFIC DIMENSIONS
  // ============================================================================
  
  // Player page spacing percentages (converted to fixed values for consistency)
  static const double playerVerticalSpacing = spaceXL; // 32px
  static const double playerHorizontalSpacing = spaceLG; // 24px
  static const double playerAlbumSizeRatio = 0.6; // 60% of screen width
  static const double playerIconSizeRatio = 0.08; // 8% of screen width
  static const double playerFontSizeRatio = 0.045; // 4.5% of screen width
  static const double playerTitleFontSizeRatio = 0.06; // 6% of screen width
  static const double playerButtonSizeRatio = 0.14; // 14% of screen width
  static const double playerMainButtonSizeRatio = 0.2; // 20% of screen width
  static const double playerMainIconSizeRatio = 0.1; // 10% of screen width
  static const double playerSmallIconSizeRatio = 0.07; // 7% of screen width
  static const double playerSmallSpacingRatio = 0.02; // 2% of screen width
  
  // Player page fixed dimensions
  static const double playerShadowBlur = 20.0;
  static const double playerShadowOffset = 10.0;
  static const double playerProgressBarPadding = 16.0;
  
  // ============================================================================
  // ARTIST HERO SECTION DIMENSIONS
  // ============================================================================
  
  static const double artistHeroImageSizeRatio = 0.4; // 40% of screen width
  static const double artistHeroFontSizeRatio = 0.08; // 8% of screen width
  static const double artistHeroIconSizeRatio = 0.3; // 30% of image size
  static const double artistHeroShadowBlur = 20.0;
  static const double artistHeroShadowOffset = 10.0;
  
  // ============================================================================
  // MINI PLAYER DIMENSIONS
  // ============================================================================
  
  static const double miniPlayerShadowBlur = 10.0;
  static const double miniPlayerShadowOffset = 2.0;
  static const double miniPlayerButtonSize = 32.0;
  
  // ============================================================================
  // OPACITY VALUES
  // ============================================================================
  
  static const double opacityShadow = 0.3;
  static const double opacityOverlayLight = 0.2;
  static const double opacityTextSecondary = 0.7;

  // ============================================================================
  // CARD COMPONENTS DIMENSIONS
  // ============================================================================
  
  static const double cardIconSizeRatio = 0.3; // 30% of card size
  static const double cardShadowBlur = 4.0;
  static const double cardShadowOffset = 2.0;
  static const double cardOverlayOpacity = 0.2;
  static const double cardGradientStop1 = 0.0;
  static const double cardGradientStop2 = 0.6;
  static const double cardGradientStop3 = 1.0;
  
  static const double playlistCoverSizeRatio = 0.8; // 80% of albumArtSize
  
  static const double artistHeroHeight = 300.0;
  static const int floatingParticlesCount = 20;
  static const String songsListTitle = 'Lista de sons';
  static const double trackNumberWidth = 24.0;
}
