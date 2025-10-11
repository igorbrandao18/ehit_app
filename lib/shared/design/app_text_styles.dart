// shared/design/app_text_styles.dart
import 'package:flutter/material.dart';
import 'design_tokens.dart';
import 'app_colors.dart';

/// Sistema de tipografia consolidado do app ÊHIT
/// Elimina duplicações e centraliza todos os estilos de texto
class AppTextStyles {
  // ============================================================================
  // BASE TEXT STYLES
  // ============================================================================
  
  static const TextStyle _baseTextStyle = TextStyle(
    fontFamily: 'Inter',
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  // ============================================================================
  // HEADING STYLES
  // ============================================================================
  
  static const TextStyle h1 = TextStyle(
    fontSize: DesignTokens.displayFontSize, // 32px
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: DesignTokens.headingFontSize, // 24px
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: DesignTokens.titleFontSize, // 20px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static const TextStyle h4 = TextStyle(
    fontSize: DesignTokens.subtitleFontSize, // 18px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle h5 = TextStyle(
    fontSize: DesignTokens.bodyFontSize, // 16px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle h6 = TextStyle(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  // ============================================================================
  // BODY TEXT STYLES
  // ============================================================================
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: DesignTokens.fontSizeLG, // 18px
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: DesignTokens.bodyFontSize, // 16px
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  
  // ============================================================================
  // CAPTION STYLES
  // ============================================================================
  
  static const TextStyle caption = TextStyle(
    fontSize: DesignTokens.captionFontSize, // 12px
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.3,
  );
  
  static const TextStyle captionSmall = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.2,
  );
  
  // ============================================================================
  // BUTTON TEXT STYLES
  // ============================================================================
  
  static const TextStyle buttonText = TextStyle(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle buttonTextLarge = TextStyle(
    fontSize: DesignTokens.bodyFontSize, // 16px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle buttonTextSmall = TextStyle(
    fontSize: DesignTokens.captionFontSize, // 12px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  // ============================================================================
  // INPUT TEXT STYLES
  // ============================================================================
  
  static const TextStyle inputText = TextStyle(
    fontSize: DesignTokens.bodyFontSize, // 16px
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle inputLabel = TextStyle(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.3,
  );
  
  static const TextStyle inputHint = TextStyle(
    fontSize: DesignTokens.bodyFontSize, // 16px
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.4,
  );
  
  // ============================================================================
  // NAVIGATION TEXT STYLES
  // ============================================================================
  
  static const TextStyle navigationLabel = TextStyle(
    fontSize: DesignTokens.captionFontSize, // 12px
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    height: 1.2,
  );
  
  static const TextStyle navigationLabelSelected = TextStyle(
    fontSize: DesignTokens.captionFontSize, // 12px
    fontWeight: FontWeight.w600,
    color: AppColors.primaryRed,
    height: 1.2,
  );
  
  // ============================================================================
  // MUSIC-SPECIFIC TEXT STYLES
  // ============================================================================
  
  static const TextStyle songTitle = TextStyle(
    fontSize: DesignTokens.bodyFontSize, // 16px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static const TextStyle songArtist = TextStyle(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.3,
  );
  
  static const TextStyle songDuration = TextStyle(
    fontSize: DesignTokens.captionFontSize, // 12px
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.2,
  );
  
  static const TextStyle albumTitle = TextStyle(
    fontSize: DesignTokens.subtitleFontSize, // 18px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static const TextStyle playlistTitle = TextStyle(
    fontSize: DesignTokens.titleFontSize, // 20px
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  // ============================================================================
  // STATUS TEXT STYLES
  // ============================================================================
  
  static const TextStyle successText = TextStyle(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.normal,
    color: AppColors.success,
    height: 1.4,
  );
  
  static const TextStyle errorText = TextStyle(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.normal,
    color: AppColors.error,
    height: 1.4,
  );
  
  static const TextStyle warningText = TextStyle(
    fontSize: DesignTokens.fontSizeSM, // 14px
    fontWeight: FontWeight.normal,
    color: AppColors.warning,
    height: 1.4,
  );
  
  static const TextStyle infoText = TextStyle(
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
