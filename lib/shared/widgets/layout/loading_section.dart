import 'package:flutter/material.dart';
import '../../design/app_text_styles.dart';
import '../../design/app_colors.dart';
import '../../design/design_tokens.dart';
class LoadingSection extends StatelessWidget {
  final String message;
  final double? height;
  final EdgeInsetsGeometry? padding;
  const LoadingSection({
    super.key,
    required this.message,
    this.height,
    this.padding,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 200,
      padding: padding ?? const EdgeInsets.all(DesignTokens.screenPadding),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppColors.primaryRed,
              strokeWidth: 2.0,
            ),
            const SizedBox(height: DesignTokens.spaceMD),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
