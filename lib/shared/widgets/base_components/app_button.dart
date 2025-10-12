// shared/widgets/base_components/app_button.dart
import 'package:flutter/material.dart';
import '../../design/app_colors.dart';
import '../../design/app_text_styles.dart';
import '../../design/design_tokens.dart';
import '../../design/app_shadows.dart';
import '../../design/app_borders.dart';

enum AppButtonType { primary, secondary, outline, text }
enum AppButtonSize { small, medium, large }

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AppAnimations.createPlayerController(this);
    _scaleAnimation = AppAnimations.createPlayerAnimation(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_scaleAnimation.value * 0.05),
            child: Container(
              width: widget.isFullWidth ? double.infinity : null,
              height: _getButtonHeight(),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: AppBorders.buttonBorderRadius,
                border: _getBorder(),
                boxShadow: AppShadows.buttonShadow,
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getTextColor(),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            widget.icon!,
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.text,
                            style: _getTextStyle(),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  double _getButtonHeight() {
    switch (widget.size) {
      case AppButtonSize.small:
        return 32;
      case AppButtonSize.medium:
        return 40;
      case AppButtonSize.large:
        return 48;
    }
  }

  Color _getBackgroundColor() {
    if (widget.onPressed == null) {
      return AppColors.textTertiary;
    }
    
    switch (widget.type) {
      case AppButtonType.primary:
        return AppColors.primaryRed;
      case AppButtonType.secondary:
        return AppColors.backgroundCard;
      case AppButtonType.outline:
      case AppButtonType.text:
        return Colors.transparent;
    }
  }

  Border? _getBorder() {
    switch (widget.type) {
      case AppButtonType.outline:
        return AppBorders.getBorder(
          color: AppColors.primaryRed,
          width: AppBorders.borderWidthNormal,
        );
      case AppButtonType.primary:
      case AppButtonType.secondary:
      case AppButtonType.text:
        return null;
    }
  }

  Color _getTextColor() {
    if (widget.onPressed == null) {
      return AppColors.textTertiary;
    }
    
    switch (widget.type) {
      case AppButtonType.primary:
        return AppColors.textPrimary;
      case AppButtonType.secondary:
        return AppColors.textPrimary;
      case AppButtonType.outline:
      case AppButtonType.text:
        return AppColors.primaryRed;
    }
  }

  TextStyle _getTextStyle() {
    final baseStyle = AppTextStyles.buttonText.copyWith(
      color: _getTextColor(),
    );
    
    switch (widget.size) {
      case AppButtonSize.small:
        return baseStyle.copyWith(fontSize: 12);
      case AppButtonSize.medium:
        return baseStyle.copyWith(fontSize: 14);
      case AppButtonSize.large:
        return baseStyle.copyWith(fontSize: 16);
    }
  }
}
