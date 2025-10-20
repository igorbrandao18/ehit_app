// features/music_library/presentation/pages/playlist_detail_page.dart
import 'package:flutter/material.dart';
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              playlist.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(DesignTokens.cardBorderRadius),
              child: Image.network(
                playlist.cover,
                width: DesignTokens.albumArtSize,
                height: DesignTokens.albumArtSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: DesignTokens.albumArtSize,
                    height: DesignTokens.albumArtSize,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(DesignTokens.cardBorderRadius),
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
          
          // Playlist info
          Text(
            playlist.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: DesignTokens.headingFontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: DesignTokens.spaceSM),
          Text(
            '${playlist.musicsCount} músicas',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: DesignTokens.bodyFontSize,
            ),
            textAlign: TextAlign.center,
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
          const Text(
            'Músicas',
            style: TextStyle(
              color: Colors.white,
              fontSize: DesignTokens.titleFontSize,
              fontWeight: FontWeight.bold,
            ),
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
}
