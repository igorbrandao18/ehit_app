// shared/widgets/music_components/player_controls.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design/app_colors.dart';
import '../../design/app_borders.dart';
import '../../design/app_shadows.dart';
import '../../design/app_animations.dart';
import '../../../features/music_player/presentation/controllers/music_player_controller.dart';

class PlayerControls extends StatefulWidget {
  final double? size;
  final bool showLabels;

  const PlayerControls({
    super.key,
    this.size = 56,
    this.showLabels = false,
  });

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls>
    with TickerProviderStateMixin {
  late AnimationController _playAnimationController;
  late Animation<double> _playScaleAnimation;

  @override
  void initState() {
    super.initState();
    _playAnimationController = AppAnimations.createPlayerController(this);
    _playScaleAnimation = AppAnimations.createPlayerAnimation(_playAnimationController);
  }

  @override
  void dispose() {
    _playAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayerController>(
      builder: (context, playerController, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Previous button
            _buildControlButton(
              icon: Icons.skip_previous,
              onTap: () {
                // Previous track logic
              },
            ),
            
            const SizedBox(width: 24),
            
            // Play/Pause button
            _buildPlayButton(playerController),
            
            const SizedBox(width: 24),
            
            // Next button
            _buildControlButton(
              icon: Icons.skip_next,
              onTap: () {
                // Next track logic
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          shape: BoxShape.circle,
          boxShadow: AppShadows.getShadow(AppShadows.elevationSm),
        ),
        child: Icon(
          icon,
          color: AppColors.textPrimary,
          size: widget.size! * 0.4,
        ),
      ),
    );
  }

  Widget _buildPlayButton(MusicPlayerController playerController) {
    return GestureDetector(
      onTap: () {
        playerController.togglePlayPause();
        _playAnimationController.forward().then((_) {
          _playAnimationController.reverse();
        });
      },
      child: AnimatedBuilder(
        animation: _playScaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_playScaleAnimation.value * 0.1),
            child: Container(
              width: (widget.size ?? 56) * 1.2,
              height: (widget.size ?? 56) * 1.2,
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                shape: BoxShape.circle,
                boxShadow: AppShadows.getShadow(AppShadows.elevationLg),
              ),
              child: Icon(
                playerController.isPlaying ? Icons.pause : Icons.play_arrow,
                color: AppColors.textPrimary,
                size: (widget.size ?? 56) * 0.5,
              ),
            ),
          );
        },
      ),
    );
  }
}

