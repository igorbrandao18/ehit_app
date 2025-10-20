// features/music_library/presentation/pages/playlist_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/layout/gradient_scaffold.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../shared/design/design_tokens.dart';
import '../../../../shared/widgets/music_components/song_list_item.dart';
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
                // Status bar padding
                SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
                
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
                width: DesignTokens.albumArtSize * 0.8, // Diminuído para 80%
                height: DesignTokens.albumArtSize * 0.8, // Diminuído para 80%
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: DesignTokens.albumArtSize * 0.8,
                    height: DesignTokens.albumArtSize * 0.8,
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
          SizedBox(height: DesignTokens.sectionSpacing),
          
          // Playlist info - Centralizado
          Center(
            child: Column(
              children: [
                Text(
                  playlist.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: DesignTokens.titleFontSize, // 20px (menor que headingFontSize 24px)
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: DesignTokens.spaceSM),
                Text(
                  '${playlist.musicsCount} Músicas • ${_calculateTotalDuration(playlist)}min',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: DesignTokens.subtitleFontSize, // 18px (menor que bodyFontSize 16px)
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongsSection(BuildContext context, Playlist playlist) {
    if (playlist.musicsData.isEmpty) {
      return Padding(
        padding: DesignTokens.getResponsivePadding(context),
        child: Center(
          child: Text(
            'Esta playlist não possui músicas',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: DesignTokens.bodyFontSize,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: DesignTokens.getResponsiveHorizontalPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Divider
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.2),
            margin: EdgeInsets.symmetric(vertical: DesignTokens.spaceMD),
          ),
          
          // Header da lista de músicas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lista de sons',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: DesignTokens.titleFontSize,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _onShuffleTap(context, playlist),
                    icon: const Icon(
                      Icons.shuffle,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _onRepeatTap(context, playlist),
                    icon: const Icon(
                      Icons.repeat,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: DesignTokens.spaceMD),
          
          // Songs list
          ...playlist.musicsData.asMap().entries.map((entry) {
            final index = entry.key;
            final song = entry.value;
            return Column(
              children: [
                SongListItem(
                  song: song,
                  index: index,
                  onTap: () => _onSongTap(context, song),
                ),
                if (index < playlist.musicsData.length - 1)
                  SizedBox(height: DesignTokens.songItemSpacing),
              ],
            );
          }).toList(),
        ],
      ),
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

  String _calculateTotalDuration(Playlist playlist) {
    if (playlist.musicsData.isEmpty) return '0';
    
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
    
    int minutes = totalSeconds ~/ 60;
    return minutes.toString();
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
