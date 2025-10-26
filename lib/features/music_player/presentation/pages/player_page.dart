import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../shared/design/design_tokens.dart';
import '../../../../shared/widgets/layout/gradient_scaffold.dart';
import '../../../../core/audio/audio_player_service.dart';
class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerService>(
      builder: (context, audioPlayer, child) {
        return GradientScaffold(
          showMiniPlayer: false, 
          body: SafeArea(
            child: Column(
              children: [
                  _buildHeader(context),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: DesignTokens.playerHorizontalSpacing,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: DesignTokens.playerVerticalSpacing),
                          _buildAlbumArt(context),
                          SizedBox(height: DesignTokens.playerVerticalSpacing),
                          _buildSongInfo(context),
                          SizedBox(height: DesignTokens.playerVerticalSpacing),
                          _buildProgressBar(context, audioPlayer),
                          SizedBox(height: DesignTokens.playerVerticalSpacing * 2),
                          _buildPlayerControls(context, audioPlayer),
                          SizedBox(height: DesignTokens.playerVerticalSpacing * 3),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * DesignTokens.playerIconSizeRatio;
    final fontSize = screenWidth * DesignTokens.playerFontSizeRatio;
    final padding = DesignTokens.playerHorizontalSpacing;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: iconSize,
            ),
          ),
          Expanded(
            child: Text(
              'Decretos Reais',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: iconSize), 
        ],
      ),
    );
  }
  Widget _buildAlbumArt(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayerService>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final albumSize = screenWidth * DesignTokens.playerAlbumSizeRatio;
    final imageUrl = audioPlayer.currentSong?.imageUrl ?? '';
    return Container(
      width: albumSize,
      height: albumSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(DesignTokens.opacityShadow),
            blurRadius: DesignTokens.playerShadowBlur,
            offset: const Offset(0, DesignTokens.playerShadowOffset),
          ),
        ],
      ),
      child: ClipOval(
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: albumSize * DesignTokens.artistHeroIconSizeRatio,
                    ),
                  );
                },
              )
            : Container(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: albumSize * 0.3,
                ),
              ),
      ),
    );
  }
  Widget _buildSongInfo(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayerService>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth * DesignTokens.playerTitleFontSizeRatio;
    final artistFontSize = screenWidth * DesignTokens.playerFontSizeRatio;
    return Column(
      children: [
        Text(
          audioPlayer.currentSong?.title ?? 'Sem música',
          style: TextStyle(
            color: Colors.white,
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenWidth * DesignTokens.playerSmallSpacingRatio),
        Text(
          audioPlayer.currentSong?.artist ?? 'Artista desconhecido',
          style: TextStyle(
            color: Colors.white70,
            fontSize: artistFontSize,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  Widget _buildProgressBar(BuildContext context, AudioPlayerService audioPlayer) {
    final progress = audioPlayer.progress;
    final remaining = audioPlayer.duration - audioPlayer.position;
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white30,
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
          ),
          child: Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (value) {
              final newPosition = Duration(
                milliseconds: (value * audioPlayer.duration.inMilliseconds).round(),
              );
              audioPlayer.seek(newPosition);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesignTokens.playerProgressBarPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(audioPlayer.position),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Text(
                '-${_formatDuration(remaining)}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildPlayerControls(BuildContext context, AudioPlayerService audioPlayer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          context: context,
          icon: Icons.skip_previous,
          onTap: () => audioPlayer.previous(),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.05),
        _buildMainControlButton(context, audioPlayer),
        SizedBox(width: MediaQuery.of(context).size.width * 0.05),
        _buildControlButton(
          context: context,
          icon: Icons.skip_next,
          onTap: () => audioPlayer.next(),
        ),
      ],
    );
  }
  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth * 0.14; 
    final iconSize = screenWidth * 0.07; 
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: buttonSize,
        height: buttonSize,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.black87,
          size: iconSize,
        ),
      ),
    );
  }
  Widget _buildMainControlButton(BuildContext context, AudioPlayerService audioPlayer) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth * 0.25; 
    final iconSize = screenWidth * 0.12; 
    return GestureDetector(
      onTap: () {
        audioPlayer.togglePlayPause();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryRed,
              AppColors.primaryRed.withOpacity(0.8),
            ],
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryRed,
            width: 3,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            audioPlayer.isPlaying ? Icons.pause : Icons.play_arrow,
            key: ValueKey(audioPlayer.isPlaying),
            color: Colors.white,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
