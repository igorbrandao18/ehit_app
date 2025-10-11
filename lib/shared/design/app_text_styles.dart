// shared/design/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_tokens.dart';
import 'app_colors.dart';

/// Sistema de tipografia consolidado do app ÊHIT
/// Usa Montserrat (similar ao Spotify Circular)
class AppTextStyles {
  // ============================================================================
  // BASE TEXT STYLES
  // ============================================================================
  
  static TextStyle get _baseTextStyle => GoogleFonts.montserrat(
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  // ============================================================================
  // HEADING STYLES
  // ============================================================================
  
  static TextStyle get h1 => GoogleFonts.montserrat(
    fontSize: DesignTokens.displayFontSize, // 32px
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static TextStyle get h2 => GoogleFonts.montserrat(
    fontSize: DesignTokens.headingFontSize, // 24px
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static TextStyle get h3 => GoogleFonts.montserrat(
    fontSize: DesignTokens.titleFontSize, // 20px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static TextStyle get h4 => GoogleFonts.montserrat(
    fontSize: DesignTokens.subtitleFontSize, // 18px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static TextStyle get h5 => GoogleFonts.montserrat(
    fontSize: DesignTokens.bodyFontSize, // 16px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static TextStyle get h6 => GoogleFonts.montserrat(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  // ============================================================================
  // BODY TEXT STYLES
  // ============================================================================
  
  static TextStyle get bodyLarge => GoogleFonts.montserrat(
    fontSize: DesignTokens.fontSizeLG, // 18px
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static TextStyle get bodyMedium => GoogleFonts.montserrat(
    fontSize: DesignTokens.bodyFontSize, // 16px
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static TextStyle get bodySmall => GoogleFonts.montserrat(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  
  // ============================================================================
  // CAPTION STYLES
  // ============================================================================
  
  static TextStyle get caption => GoogleFonts.montserrat(
    fontSize: DesignTokens.captionFontSize, // 12px
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.3,
  );
  
  static TextStyle get captionSmall => GoogleFonts.montserrat(
    fontSize: 10.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.2,
  );
  
  // ============================================================================
  // BUTTON TEXT STYLES
  // ============================================================================
  
  static TextStyle get buttonText => GoogleFonts.montserrat(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static TextStyle get buttonTextLarge => GoogleFonts.montserrat(
    fontSize: DesignTokens.bodyFontSize, // 16px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static TextStyle get buttonTextSmall => GoogleFonts.montserrat(
    fontSize: DesignTokens.captionFontSize, // 12px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  // ============================================================================
  // INPUT TEXT STYLES
  // ============================================================================
  
  static TextStyle get inputText => GoogleFonts.montserrat(
    fontSize: DesignTokens.bodyFontSize, // 16px
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static TextStyle get inputLabel => GoogleFonts.montserrat(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.3,
  );
  
  static TextStyle get inputHint => GoogleFonts.montserrat(
    fontSize: DesignTokens.bodyFontSize, // 16px
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.4,
  );
  
  // ============================================================================
  // NAVIGATION TEXT STYLES
  // ============================================================================
  
  static TextStyle get navigationLabel => GoogleFonts.montserrat(
    fontSize: DesignTokens.captionFontSize, // 12px
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    height: 1.2,
  );
  
  static TextStyle get navigationLabelSelected => GoogleFonts.montserrat(
    fontSize: DesignTokens.captionFontSize, // 12px
    fontWeight: FontWeight.w600,
    color: AppColors.primaryRed,
    height: 1.2,
  );
  
  // ============================================================================
  // MUSIC-SPECIFIC TEXT STYLES
  // ============================================================================
  
  static TextStyle get songTitle => GoogleFonts.montserrat(
    fontSize: DesignTokens.bodyFontSize, // 16px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static TextStyle get songArtist => GoogleFonts.montserrat(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.3,
  );
  
  static TextStyle get songDuration => GoogleFonts.montserrat(
    fontSize: DesignTokens.captionFontSize, // 12px
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.2,
  );
  
  static TextStyle get albumTitle => GoogleFonts.montserrat(
    fontSize: DesignTokens.subtitleFontSize, // 18px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static TextStyle get playlistTitle => GoogleFonts.montserrat(
    fontSize: DesignTokens.titleFontSize, // 20px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  // ============================================================================
  // STATUS TEXT STYLES
  // ============================================================================
  
  static TextStyle get successText => GoogleFonts.montserrat(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.normal,
    color: AppColors.success,
    height: 1.4,
  );
  
  static TextStyle get errorText => GoogleFonts.montserrat(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.normal,
    color: AppColors.error,
    height: 1.4,
  );
  
  static TextStyle get warningText => GoogleFonts.montserrat(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.normal,
    color: AppColors.warning,
    height: 1.4,
  );
  
  static TextStyle get infoText => GoogleFonts.montserrat(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.normal,
    color: AppColors.info,
    height: 1.4,
  );
  
  // ============================================================================
  // UTILITY METHODS
  // ============================================================================
  
  /// Get text style with custom color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
  
  /// Get text style with custom font size
  static TextStyle withSize(TextStyle style, double fontSize) {
    return style.copyWith(fontSize: fontSize);
  }
  
  /// Get text style with custom font weight
  static TextStyle withWeight(TextStyle style, FontWeight fontWeight) {
    return style.copyWith(fontWeight: fontWeight);
  }
  
  /// Get text style with custom opacity
  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: style.color?.withOpacity(opacity));
  }
  
  /// Get responsive text style based on screen size
  static TextStyle responsive(BuildContext context, TextStyle baseStyle) {
    final screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = 1.0;
    
    if (screenWidth >= DesignTokens.desktopBreakpoint) {
      scaleFactor = 1.2;
    } else if (screenWidth >= DesignTokens.tabletBreakpoint) {
      scaleFactor = 1.1;
    }
    
    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 16.0) * scaleFactor,
    );
  }
}