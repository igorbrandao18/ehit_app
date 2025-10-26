import 'package:flutter/material.dart';
import '../../design/app_text_styles.dart';
import '../../design/app_colors.dart';
import '../../design/design_tokens.dart';
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;
  final VoidCallback? onActionTap;
  final EdgeInsetsGeometry? padding;
  final TextStyle? titleStyle;
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onActionTap,
    this.padding,
    this.titleStyle,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: DesignTokens.screenPadding,
        vertical: DesignTokens.spaceMD,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: titleStyle ?? AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (action != null)
            GestureDetector(
              onTap: onActionTap,
              child: action!,
            ),
        ],
      ),
    );
  }
}
