import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';
import '../../design/app_colors.dart';
import '../../design/app_text_styles.dart';

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
    final style = textStyle ??
        AppTextStyles.headlineLarge.copyWith(
          fontSize: fontSize ?? 24,
          fontWeight: FontWeight.bold,
          color: color ?? AppColors.textPrimary,
        );

    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
      child: Text(
        title,
        style: style,
      ),
    );
  }
}
