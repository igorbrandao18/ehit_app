import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';
import '../../design/app_colors.dart';
import '../../design/app_text_styles.dart';
import '../../utils/responsive_utils.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const SectionTitle({
    super.key,
    required this.title,
    this.fontSize,
    this.color,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveFontSize = fontSize ?? ResponsiveUtils.getResponsiveFontSize(
      context,
      mobile: DesignTokens.fontSizeLG,
      tablet: DesignTokens.fontSizeLG + DesignTokens.fontSizeAdjustmentSmall,
      desktop: DesignTokens.fontSizeXL - DesignTokens.fontSizeAdjustmentMedium,
    );

    final style = textStyle ??
        AppTextStyles.headlineMedium.copyWith(
          fontSize: responsiveFontSize,
          fontWeight: FontWeight.w700,
          color: color ?? AppColors.textPrimary,
        );

    final responsivePadding = padding ?? 
        EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getResponsiveSpacing(
            context,
            mobile: DesignTokens.screenPadding,
            tablet: DesignTokens.screenPadding + DesignTokens.spaceSM,
            desktop: DesignTokens.screenPadding + DesignTokens.spaceMD,
          ),
        );

    return Padding(
      padding: responsivePadding,
      child: Text(
        title,
        style: style,
      ),
    );
  }
}
