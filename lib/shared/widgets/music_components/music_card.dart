// shared/widgets/music_components/music_card.dart
import 'package:flutter/material.dart';
import '../../design/app_colors.dart';
import '../../design/app_text_styles.dart';
import '../../design/design_tokens.dart';

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
              width: widget.width,
              height: widget.height,
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
                              size: (widget.width ?? DesignTokens.artistCardSize) * 0.3,
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
                                Colors.black.withOpacity(0.3),
                                Colors.black.withOpacity(0.7),
                              ],
                              stops: const [0.0, 0.6, 1.0],
                            ),
                            borderRadius: widget.isCircular
                                ? BorderRadius.circular(DesignTokens.radiusCircular)
                                : BorderRadius.circular(DesignTokens.cardBorderRadius),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  DesignTokens.screenPadding, 
                                  DesignTokens.screenPadding, 
                                  DesignTokens.screenPadding, 
                                  DesignTokens.spaceLG
                                ),
                                child: Text(
                                  widget.title,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
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

  Widget _buildNormalCard() {
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
              width: widget.width,
              height: widget.height,
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
                                    size: (widget.width ?? DesignTokens.artistCardSize) * 0.3,
                                  ),
                                );
                              },
                            ),
                          ),
                          if (widget.showPlayButton)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: widget.isCircular
                                      ? BorderRadius.circular(DesignTokens.radiusCircular)
                                      : BorderRadius.circular(DesignTokens.cardBorderRadius),
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: widget.onPlay,
                                    child: Container(
                                      padding: const EdgeInsets.all(DesignTokens.spaceSM),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryRed,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: DesignTokens.iconMD,
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
                    SizedBox(height: DesignTokens.spaceSM),
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
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: DesignTokens.spaceXS),
                          Text(
                            widget.artist,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
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
  }
}