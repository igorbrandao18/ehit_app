// shared/widgets/music_components/mini_player.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/audio/audio_player_service.dart';
import '../../../design/app_colors.dart';
import '../../../design/design_tokens.dart';

/// Mini player que aparece fixo no bottom quando não está na tela do player
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerService>(
      builder: (context, audioPlayer, child) {
        // Só mostra se há uma música atual (tocando ou pausada)
        if (audioPlayer.currentSong == null) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.solidBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(DesignTokens.opacityShadow),
                blurRadius: DesignTokens.miniPlayerShadowBlur,
                offset: const Offset(0, -DesignTokens.miniPlayerShadowOffset),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Navegar para o player
                context.push('/player');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spaceMD,
                  vertical: DesignTokens.spaceXS,
                ),
                child: Row(
                  children: [
                    // Album art
                    _buildAlbumArt(audioPlayer),
                    const SizedBox(width: DesignTokens.spaceMD),
                    
                    // Song info
                    Expanded(
                      child: _buildSongInfo(audioPlayer),
                    ),
                    
                    // Controls
                    _buildControls(audioPlayer),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlbumArt(AudioPlayerService audioPlayer) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
          color: Colors.black.withOpacity(DesignTokens.opacityShadow),
          blurRadius: DesignTokens.miniPlayerShadowBlur,
          offset: const Offset(0, DesignTokens.miniPlayerShadowOffset),
          ),
        ],
      ),
        child: ClipOval(
          child: audioPlayer.currentSong != null
              ? Image.network(
                  audioPlayer.currentSong!.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 24,
                    ),
                  );
                },
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 24,
                ),
              ),
      ),
    );
  }

  Widget _buildSongInfo(AudioPlayerService audioPlayer) {
    if (audioPlayer.currentSong == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          audioPlayer.currentSong!.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: DesignTokens.fontSizeMD,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 1),
        Text(
          audioPlayer.currentSong!.artist,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: DesignTokens.fontSizeSM,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          '${_formatDuration(audioPlayer.position)} / ${_formatDuration(audioPlayer.duration)}',
          style: const TextStyle(
            color: Colors.white60,
            fontSize: DesignTokens.fontSizeXS,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildControls(AudioPlayerService audioPlayer) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Play/Pause button
        GestureDetector(
          onTap: () {
            audioPlayer.togglePlayPause();
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primaryRed,
              shape: BoxShape.circle,
            ),
            child: Icon(
              audioPlayer.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        
        const SizedBox(width: DesignTokens.spaceSM),
        
        // Next button
        GestureDetector(
          onTap: () {
            audioPlayer.next();
          },
          child: Container(
            width: 32,
            height: DesignTokens.miniPlayerButtonSize,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(DesignTokens.opacityOverlayLight),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.skip_next,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
