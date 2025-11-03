import 'package:flutter/material.dart';
import '../../../../shared/widgets/layout/app_layout.dart';
import '../../../../shared/widgets/layout/app_header.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../shared/design/design_tokens.dart';
import '../../../../shared/utils/responsive_utils.dart';

class RadiosPage extends StatefulWidget {
  const RadiosPage({super.key});

  @override
  State<RadiosPage> createState() => _RadiosPageState();
}

class _RadiosPageState extends State<RadiosPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 360.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.3, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.3), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = ResponsiveUtils.getResponsiveIconSize(
      context,
      mobile: 120,
      tablet: 150,
      desktop: 180,
    );

    return AppLayout(
      appBar: AppHeader(
        title: 'Rádios',
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.solidBackground,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value * 3.14159 / 180,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _opacityAnimation.value,
                        child: Container(
                          width: iconSize,
                          height: iconSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.primaryRed.withOpacity(0.2),
                                AppColors.primaryRed.withOpacity(0.05),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.radio,
                            size: iconSize * 0.6,
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
                context,
                mobile: DesignTokens.spaceXL,
                tablet: DesignTokens.spaceXL + DesignTokens.spaceMD,
                desktop: DesignTokens.spaceXL * 1.5,
              )),
              Text(
                'Rádio Ehit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    mobile: DesignTokens.fontSizeXL,
                    tablet: DesignTokens.fontSizeXL + DesignTokens.fontSizeAdjustmentSmall,
                    desktop: DesignTokens.fontSizeXL + DesignTokens.fontSizeAdjustmentMedium,
                  ),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
                context,
                mobile: DesignTokens.spaceMD,
                tablet: DesignTokens.spaceLG,
                desktop: DesignTokens.spaceXL,
              )),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getResponsiveSpacing(
                    context,
                    mobile: DesignTokens.screenPadding * 2,
                    tablet: DesignTokens.screenPadding * 2.5,
                    desktop: DesignTokens.screenPadding * 3,
                  ),
                ),
                child: Text(
                  'Em breve você poderá ouvir a Rádio Ehit, nossa rádio online com os maiores sucessos',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      mobile: DesignTokens.fontSizeMD,
                      tablet: DesignTokens.fontSizeLG,
                      desktop: DesignTokens.fontSizeLG + DesignTokens.fontSizeAdjustmentSmall,
                    ),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

