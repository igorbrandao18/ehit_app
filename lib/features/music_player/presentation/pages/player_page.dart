// features/music_player/presentation/pages/player_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../core/audio/audio_player_service.dart';
import '../controllers/music_player_controller.dart';

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
        return Scaffold(
          backgroundColor: AppColors.primaryRed,
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.subtleGradient,
              ),
              child: Column(
                children: [
                  // Header com seta para voltar e título
                  _buildHeader(context),
                  
                  // Conteúdo principal
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.06, // 6% da largura
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04), // 4% da altura
                          
                          // Album Art
                          _buildAlbumArt(context),
                          
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04), // 4% da altura
                          
                          // Informações da música
                          _buildSongInfo(context),
                          
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04), // 4% da altura
                          
                          // Progress bar
                          _buildProgressBar(context, audioPlayer),
                          
                          const Spacer(),
                          
                          // Controles do player
                          _buildPlayerControls(context, audioPlayer),
                          
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04), // 4% da altura
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.08; // 8% da largura
    final fontSize = screenWidth * 0.045; // 4.5% da largura
    final padding = screenWidth * 0.04; // 4% da largura
    
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
          SizedBox(width: iconSize), // Espaço para balancear o layout
        ],
      ),
    );
  }

  Widget _buildAlbumArt(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayerService>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final albumSize = screenWidth * 0.6; // 60% da largura da tela
    final imageUrl = audioPlayer.currentSong?.imageUrl ?? '';
    
    return Container(
      width: albumSize,
      height: albumSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                      size: albumSize * 0.3,
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
    final titleFontSize = screenWidth * 0.06; // 6% da largura
    final artistFontSize = screenWidth * 0.045; // 4.5% da largura
    
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
        SizedBox(height: screenWidth * 0.02), // 2% da largura
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
        // Botão anterior
        _buildControlButton(
          context: context,
          icon: Icons.skip_previous,
          onTap: () => audioPlayer.previous(),
        ),
        
        // Botão play/pause principal
        _buildMainControlButton(context, audioPlayer),
        
        // Botão próximo
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
    final buttonSize = screenWidth * 0.14; // 14% da largura
    final iconSize = screenWidth * 0.07; // 7% da largura
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.black,
          size: iconSize,
        ),
      ),
    );
  }

  Widget _buildMainControlButton(BuildContext context, AudioPlayerService audioPlayer) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth * 0.2; // 20% da largura
    final iconSize = screenWidth * 0.1; // 10% da largura
    
    return GestureDetector(
      onTap: () {
        audioPlayer.togglePlayPause();
      },
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: const BoxDecoration(
          color: AppColors.primaryRed,
          shape: BoxShape.circle,
        ),
        child: Icon(
          audioPlayer.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }
}
