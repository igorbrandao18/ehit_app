// shared/widgets/music_components/music_card.dart
import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/app_borders.dart';
import '../../themes/app_shadows.dart';
import '../../themes/app_animations.dart';

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
  });

  @override
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

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
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_scaleAnimation.value * 0.05),
            child: Container(
              width: widget.width,
              height: widget.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image container
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: widget.isCircular
                              ? AppBorders.circularBorderRadius
                              : AppBorders.cardBorderRadius,
                          child: Image.network(
                            widget.imageUrl,
                            width: widget.width,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: widget.width,
                                height: double.infinity,
                                color: AppColors.backgroundCard,
                                child: Icon(
                                  widget.isCircular ? Icons.person : Icons.music_note,
                                  color: AppColors.textTertiary,
                                  size: (widget.width ?? 120) * 0.3,
                                ),
                              );
                            },
                          ),
                        ),
                        
                        // Play button overlay
                        if (widget.showPlayButton && widget.onPlay != null)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: widget.isCircular
                                    ? AppBorders.circularBorderRadius
                                    : AppBorders.cardBorderRadius,
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: widget.onPlay,
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryRed,
                                      shape: BoxShape.circle,
                                      boxShadow: AppShadows.getShadow(AppShadows.elevationMd),
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: AppColors.textPrimary,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  // Text info - only show if showText is true
                  if (widget.showText) ...[
                    if (!widget.isCircular) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.artist,
                        style: AppTextStyles.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ] else ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.title,
                        style: AppTextStyles.bodySmall,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
