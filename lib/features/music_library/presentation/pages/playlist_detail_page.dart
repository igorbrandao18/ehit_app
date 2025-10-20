// features/music_library/presentation/pages/playlist_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/layout/gradient_scaffold.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../shared/design/design_tokens.dart';
import '../../../../shared/widgets/music_components/songs_list_section.dart';
import '../../../../core/audio/audio_player_service.dart';
import '../controllers/music_library_controller.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/song.dart';

/// Página de detalhes da playlist com lista de músicas
class PlaylistDetailPage extends StatelessWidget {
  final String playlistId;

  const PlaylistDetailPage({
    super.key,
    required this.playlistId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicLibraryController>(
      builder: (context, controller, child) {
        // Encontrar a playlist pelo ID
        final playlist = controller.playlists
            .where((p) => p.id.toString() == playlistId)
            .firstOrNull;

        if (playlist == null) {
          return GradientScaffold(
            appBar: AppBar(
              title: const Text('Playlist não encontrada'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(
              child: Text(
                'Playlist não encontrada',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        return GradientScaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            // Removido o título do AppBar
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status bar padding - Reduzido para subir a foto mais
                SizedBox(height: MediaQuery.of(context).padding.top + DesignTokens.spaceMD),
                
                // Header section
                _buildHeaderSection(context, playlist),
                
                // Songs section
                _buildSongsSection(context, playlist),
                
                // Bottom padding
                SizedBox(height: DesignTokens.miniPlayerHeight + DesignTokens.spaceLG),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(BuildContext context, Playlist playlist) {
    return Padding(
      padding: DesignTokens.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Playlist cover
          Center(
            child: ClipOval(
              child: Image.network(
                playlist.cover,
                width: DesignTokens.albumArtSize * DesignTokens.playlistCoverSizeRatio,
                height: DesignTokens.albumArtSize * DesignTokens.playlistCoverSizeRatio,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: DesignTokens.albumArtSize * DesignTokens.playlistCoverSizeRatio,
                    height: DesignTokens.albumArtSize * DesignTokens.playlistCoverSizeRatio,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.grey,
                      size: DesignTokens.iconXXL,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: DesignTokens.spaceMD), // Reduzido de sectionSpacing para spaceMD
          
          // Playlist info - Centralizado
          Center(
            child: Column(
              children: [
                Text(
                  playlist.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: DesignTokens.subtitleFontSize, // Diminuído de titleFontSize (20px) para subtitleFontSize (18px)
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: DesignTokens.spaceSM),
                FutureBuilder<Duration>(
                  future: _calculateTotalDurationAsync(context, playlist),
                  builder: (context, snapshot) {
                    final duration = snapshot.hasData 
                        ? snapshot.data! 
                        : Duration(minutes: _calculateTotalDurationFallback(playlist));
                    
                    final durationText = _formatDuration(duration);
                    
                    return Text(
                      '${playlist.musicsCount} Músicas • $durationText',
                      style: TextStyle(
                        color: Colors.white.withOpacity(DesignTokens.opacityTextSecondary),
                        fontSize: DesignTokens.subtitleFontSize, // 18px (menor que bodyFontSize 16px)
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongsSection(BuildContext context, Playlist playlist) {
    return SongsListSection(
      songs: playlist.musicsData,
      artistName: playlist.name, // Usando o nome da playlist como contexto
      onSongTap: (song) => _onSongTap(context, song),
      onShuffleTap: () => _onShuffleTap(context, playlist),
      onRepeatTap: () => _onRepeatTap(context, playlist),
    );
  }

  void _onSongTap(BuildContext context, Song song) {
    // Usa o AudioPlayerService para tocar a música
    final audioPlayer = Provider.of<AudioPlayerService>(context, listen: false);
    
    // Configura a playlist com todas as músicas da playlist antes de tocar
    final playlist = Provider.of<MusicLibraryController>(context, listen: false)
        .playlists
        .where((p) => p.id.toString() == playlistId)
        .firstOrNull;
    
    if (playlist != null && playlist.musicsData.isNotEmpty) {
      // Encontra o índice da música na playlist
      final songIndex = playlist.musicsData.indexWhere((s) => s.id == song.id);
      
      if (songIndex >= 0) {
        audioPlayer.playPlaylist(playlist.musicsData, startIndex: songIndex);
        debugPrint('🎵 Tocando playlist: ${playlist.name}');
        debugPrint('🎵 Música atual: ${song.title} - ${song.artist}');
      } else {
        // Se não encontrar o índice, toca apenas a música
        audioPlayer.playSong(song);
      }
    } else {
      // Fallback: toca apenas a música
      audioPlayer.playSong(song);
    }
    
    // Navegar para o player
    context.pushNamed('player');
  }

  /// Calcula a duração total usando metadata real dos arquivos de áudio
  Future<Duration> _calculateTotalDurationAsync(BuildContext context, Playlist playlist) async {
    if (playlist.musicsData.isEmpty) return Duration.zero;
    
    final audioPlayer = Provider.of<AudioPlayerService>(context, listen: false);
    return await audioPlayer.calculateTotalDuration(playlist.musicsData);
  }

  /// Fallback para calcular duração usando strings (método antigo)
  int _calculateTotalDurationFallback(Playlist playlist) {
    if (playlist.musicsData.isEmpty) return 0;
    
    int totalSeconds = 0;
    for (final song in playlist.musicsData) {
      // Converter duration de string (formato "MM:SS") para segundos
      final durationParts = song.duration.split(':');
      if (durationParts.length == 2) {
        final minutes = int.tryParse(durationParts[0]) ?? 0;
        final seconds = int.tryParse(durationParts[1]) ?? 0;
        totalSeconds += minutes * 60 + seconds;
      }
    }
    
    return totalSeconds ~/ 60;
  }

  /// Formata a duração para exibição (ex: "3min 45s" ou "5min")
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    
    if (seconds == 0) {
      return '${minutes}min';
    } else {
      return '${minutes}min ${seconds}s';
    }
  }

  void _onShuffleTap(BuildContext context, Playlist playlist) {
    final audioPlayer = Provider.of<AudioPlayerService>(context, listen: false);
    if (playlist.musicsData.isNotEmpty) {
      // Embaralha a lista de músicas
      final shuffledSongs = List<Song>.from(playlist.musicsData)..shuffle();
      audioPlayer.playPlaylist(shuffledSongs, startIndex: 0);
      debugPrint('🔀 Shuffle play: ${playlist.musicsData.length} músicas da playlist ${playlist.name}');
      context.pushNamed('player');
    }
  }

  void _onRepeatTap(BuildContext context, Playlist playlist) {
    final audioPlayer = Provider.of<AudioPlayerService>(context, listen: false);
    if (playlist.musicsData.isNotEmpty) {
      audioPlayer.playPlaylist(playlist.musicsData, startIndex: 0);
      debugPrint('🔁 Repeat play: ${playlist.musicsData.length} músicas da playlist ${playlist.name}');
      context.pushNamed('player');
    }
  }
}
