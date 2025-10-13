// shared/widgets/playhits_card.dart
import 'package:flutter/material.dart';
import '../design/design_tokens.dart';
import '../design/app_colors.dart';
import '../utils/image_utils.dart';
import '../design/app_text_styles.dart';

class PlayHitsCard extends StatefulWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final bool isLarge;
  final VoidCallback? onTap;

  const PlayHitsCard({
    super.key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    this.isLarge = false,
    this.onTap,
  });

  @override
  State<PlayHitsCard> createState() => _PlayHitsCardState();
}

class _PlayHitsCardState extends State<PlayHitsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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

  void _onTapDown() {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _onTapUp() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = DesignTokens.musicCardWidth;
    final cardHeight = widget.isLarge ? DesignTokens.musicCardHeightLarge : DesignTokens.musicCardHeight;
    
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: () => _onTapCancel(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DesignTokens.cardBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(DesignTokens.cardBorderRadius),
                child: Stack(
                  children: [
                    // Image
                    Positioned.fill(
                      child: ImageUtils.buildNetworkImage(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                        fallbackWidget: Container(
                          color: AppColors.backgroundCard,
                          child: const Icon(
                            Icons.music_note,
                            color: AppColors.textTertiary,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                    
                    // Gradient overlay with text
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                DesignTokens.screenPadding,
                                DesignTokens.screenPadding,
                                DesignTokens.screenPadding,
                                DesignTokens.spaceLG,
                              ),
                              child: Text(
                                widget.title,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
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
  }
}
