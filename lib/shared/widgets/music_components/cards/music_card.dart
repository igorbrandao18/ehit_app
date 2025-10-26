// shared/widgets/music_components/music_card.dart
import 'package:flutter/material.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_text_styles.dart';
import '../../../design/design_tokens.dart';
import '../../../utils/responsive_utils.dart';

class MusicCard extends StatefulWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onPlay;
  final bool showPlayButton;
  final double? width;
  final double? height;
  final bool isCircular;
  final bool showText;
  final bool centerText;

  const MusicCard({
    super.key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    this.onTap,
    this.onPlay,
    this.showPlayButton = false,
    this.width,
    this.height,
    this.isCircular = false,
    this.showText = true,
    this.centerText = false,
  });

  @override
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
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
    if (widget.centerText) {
      return _buildCenteredTextCard();
    } else {
      return _buildNormalCard();
    }
  }

  Widget _buildCenteredTextCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = ResponsiveUtils.getDeviceType(context);
        final cardWidth = widget.width ?? _getResponsiveCardWidth(deviceType);
        final cardHeight = widget.height ?? _getResponsiveCardHeight(deviceType);
        final fontSize = ResponsiveUtils.getResponsiveFontSize(context);
        final iconSize = ResponsiveUtils.getResponsiveIconSize(context);
        final padding = ResponsiveUtils.getResponsivePadding(context);
        
        return GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: () {
            widget.onTap?.call();
          },
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 - (_scaleAnimation.value * DesignTokens.scaleAnimationValue),
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  child: ClipRRect(
                    borderRadius: widget.isCircular
                        ? BorderRadius.circular(DesignTokens.radiusCircular)
                        : BorderRadius.circular(DesignTokens.cardBorderRadius),
                    child: Stack(
                      children: [
                        // Image container
                        Positioned.fill(
                          child: Image.network(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.backgroundCard,
                                child: Icon(
                                  widget.isCircular ? Icons.person : Icons.music_note,
                                  color: AppColors.textTertiary,
                                  size: iconSize * 2,
                                ),
                              );
                            },
                          ),
                        ),
                      
                        // Dark overlay with centered text
                        if (widget.showText)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(DesignTokens.opacityShadow),
                                    Colors.black.withOpacity(DesignTokens.opacityStrong),
                                  ],
                                  stops: const [DesignTokens.cardGradientStop1, DesignTokens.cardGradientStop2, DesignTokens.cardGradientStop3],
                                ),
                                borderRadius: widget.isCircular
                                    ? BorderRadius.circular(DesignTokens.radiusCircular)
                                    : BorderRadius.circular(DesignTokens.cardBorderRadius),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      padding.left, 
                                      padding.top, 
                                      padding.right, 
                                      ResponsiveUtils.getResponsiveSpacing(context, mobile: 16, tablet: 20, desktop: 24)
                                    ),
                                    child: Text(
                                      widget.title,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                        fontSize: fontSize,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNormalCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = ResponsiveUtils.getDeviceType(context);
        final cardWidth = widget.width ?? _getResponsiveCardWidth(deviceType);
        final cardHeight = widget.height ?? _getResponsiveCardHeight(deviceType);
        final fontSize = ResponsiveUtils.getResponsiveFontSize(context);
        final iconSize = ResponsiveUtils.getResponsiveIconSize(context);
        final spacing = ResponsiveUtils.getResponsiveSpacing(context);
        
        return GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: () {
            widget.onTap?.call();
          },
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 - (_scaleAnimation.value * DesignTokens.scaleAnimationValue),
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image container
                      Expanded(
                        flex: 3,
                        child: ClipRRect(
                          borderRadius: widget.isCircular
                              ? BorderRadius.circular(DesignTokens.radiusCircular)
                              : BorderRadius.circular(DesignTokens.cardBorderRadius),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  widget.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppColors.backgroundCard,
                                      child: Icon(
                                        widget.isCircular ? Icons.person : Icons.music_note,
                                        color: AppColors.textTertiary,
                                        size: iconSize * 2,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              if (widget.showPlayButton)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(DesignTokens.opacityShadow),
                                      borderRadius: widget.isCircular
                                          ? BorderRadius.circular(DesignTokens.radiusCircular)
                                          : BorderRadius.circular(DesignTokens.cardBorderRadius),
                                    ),
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: widget.onPlay,
                                        child: Container(
                                          padding: EdgeInsets.all(spacing),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryRed,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                            size: iconSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Text content
                      if (widget.showText) ...[
                        SizedBox(height: spacing),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  fontSize: fontSize,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: spacing / 2),
                              Text(
                                widget.artist,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: fontSize - 2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Retorna a largura responsiva do card baseada no tipo de dispositivo
  double _getResponsiveCardWidth(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 150.0; // Smaller width for mobile
      case DeviceType.tablet:
        return 180.0; // Medium width for tablet
      case DeviceType.desktop:
        return 200.0; // Larger width for desktop
    }
  }

  /// Retorna a altura responsiva do card baseada no tipo de dispositivo
  double _getResponsiveCardHeight(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 200.0; // Smaller height for mobile
      case DeviceType.tablet:
        return 240.0; // Medium height for tablet
      case DeviceType.desktop:
        return 280.0; // Larger height for desktop
    }
  }
}