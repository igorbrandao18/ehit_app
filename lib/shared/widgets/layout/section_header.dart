// shared/widgets/layout/section_header.dart
import 'package:flutter/material.dart';
import '../../design/app_text_styles.dart';
import '../../design/design_tokens.dart';

/// Cabeçalho de seção reutilizável
class SectionHeader extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final EdgeInsets? padding;
  final Widget? action;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.titleStyle,
    this.padding,
    this.action,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(
        DesignTokens.screenPadding,
        DesignTokens.spaceLG,
        DesignTokens.screenPadding,
        DesignTokens.screenPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleStyle ?? AppTextStyles.h3,
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
