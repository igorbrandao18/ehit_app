import 'package:flutter/material.dart';
import 'design_tokens.dart';
import 'app_colors.dart';
class AppTextStyles {
  static const TextStyle headlineLarge = TextStyle(
    fontSize: DesignTokens.fontSizeXL,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontSize: DesignTokens.fontSizeLG,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontSize: DesignTokens.fontSizeMD,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: DesignTokens.fontSizeMD,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: DesignTokens.fontSizeSM,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: DesignTokens.fontSizeXS,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.3,
  );
  static const TextStyle labelLarge = TextStyle(
    fontSize: DesignTokens.fontSizeSM,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  static const TextStyle labelMedium = TextStyle(
    fontSize: DesignTokens.fontSizeXS,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.2,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    height: 1.1,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.2,
  );
  static const TextStyle h1 = headlineLarge;
  static const TextStyle h2 = headlineMedium;
  static const TextStyle h3 = headlineSmall;
  static const TextStyle bodyText = bodyLarge;
  static const TextStyle bodySmallText = bodySmall;
  static const TextStyle buttonText = TextStyle(
    fontSize: DesignTokens.fontSizeMD,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  static const TextStyle titleText = TextStyle(
    fontSize: DesignTokens.titleFontSize,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  static const TextStyle subtitleText = TextStyle(
    fontSize: DesignTokens.subtitleFontSize,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.3,
  );
  static const TextStyle captionText = TextStyle(
    fontSize: DesignTokens.captionFontSize,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.2,
  );
  static TextStyle headlineLargeWithColor(Color color) {
    return headlineLarge.copyWith(color: color);
  }
  static TextStyle bodyMediumWithColor(Color color) {
    return bodyMedium.copyWith(color: color);
  }
  static TextStyle labelMediumWithColor(Color color) {
    return labelMedium.copyWith(color: color);
  }
  static TextStyle buttonTextWithColor(Color color) {
    return buttonText.copyWith(color: color);
  }
  static TextStyle titleTextWithColor(Color color) {
    return titleText.copyWith(color: color);
  }
  static TextStyle subtitleTextWithColor(Color color) {
    return subtitleText.copyWith(color: color);
  }
}
