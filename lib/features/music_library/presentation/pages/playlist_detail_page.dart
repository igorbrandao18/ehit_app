import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/layout/gradient_scaffold.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../shared/design/design_tokens.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../../shared/widgets/music_components/lists/songs_list_section.dart';
import '../../../../core/audio/audio_player_service.dart';
import '../controllers/music_library_controller.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/song.dart';
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
          showMiniPlayer: false,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: DesignTokens.playerHorizontalSpacing,
                          ),
                          child: _buildHeaderSection(context, playlist),
                        ),
                        SizedBox(height: DesignTokens.playerVerticalSpacing),
                        _buildSongsSection(context, playlist),
                        SizedBox(height: ResponsiveUtils.getMiniPlayerHeight(context) + DesignTokens.spaceLG),
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
    final screenWidth = ResponsiveUtils.getScreenWidth(context);
    final iconSize = screenWidth * DesignTokens.playerIconSizeRatio;
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
        ],
      ),
    );
  }
  Widget _buildHeaderSection(BuildContext context, Playlist playlist) {
    final screenWidth = ResponsiveUtils.getScreenWidth(context);
    final albumSize = screenWidth * DesignTokens.playerAlbumSizeRatio * DesignTokens.playlistDetailCoverSizeRatio;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
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
            child: Image.network(
              playlist.cover,
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
            ),
          ),
        ),
        SizedBox(height: DesignTokens.spaceLG),
        Text(
          playlist.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveUtils.getScreenWidth(context) * DesignTokens.playerTitleFontSizeRatio,
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
                color: Colors.white70,
                fontSize: ResponsiveUtils.getScreenWidth(context) * DesignTokens.playerFontSizeRatio,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            );
          },
        ),
      ],
    );
  }
  Widget _buildSongsSection(BuildContext context, Playlist playlist) {
    return SongsListSection(
      songs: playlist.musicsData,
      artistName: playlist.name, 
      onSongTap: (song) => _onSongTap(context, song),
      onShuffleTap: () => _onShuffleTap(context, playlist),
      onRepeatTap: () => _onRepeatTap(context, playlist),
      playlistCoverUrl: playlist.cover, // Passar a capa da playlist
    );
  }
  void _onSongTap(BuildContext context, Song song) {
    final audioPlayer = Provider.of<AudioPlayerService>(context, listen: false);
    final playlist = Provider.of<MusicLibraryController>(context, listen: false)
        .playlists
        .where((p) => p.id.toString() == playlistId)
        .firstOrNull;
    if (playlist != null && playlist.musicsData.isNotEmpty) {
      final songIndex = playlist.musicsData.indexWhere((s) => s.id == song.id);
      if (songIndex >= 0) {
        // Atualizar músicas sem imageUrl para usar a capa da playlist
        final updatedSongs = playlist.musicsData.map((s) {
          // Se a música não tem imageUrl ou está vazio, usar capa da playlist
          final shouldUsePlaylistCover = (s.imageUrl.isEmpty || s.imageUrl.trim().isEmpty) && 
                                         playlist.cover.isNotEmpty && 
                                         playlist.cover.trim().isNotEmpty;
          
          final updatedSong = shouldUsePlaylistCover
              ? s.copyWith(imageUrl: playlist.cover)
              : s;
          debugPrint('🎵 Song: ${updatedSong.title}');
          debugPrint('   - imageUrl original: ${s.imageUrl.isEmpty ? "VAZIO" : s.imageUrl}');
          debugPrint('   - cover da playlist: ${playlist.cover}');
          debugPrint('   - imageUrl atualizado: ${updatedSong.imageUrl.isEmpty ? "VAZIO" : updatedSong.imageUrl}');
          return updatedSong;
        }).toList();
        audioPlayer.playPlaylist(updatedSongs, startIndex: songIndex);
        debugPrint('🎵 Tocando playlist: ${playlist.name}');
        debugPrint('🎵 Música atual: ${song.title} - ${song.artist}');
        debugPrint('🎵 Cover da playlist: ${playlist.cover}');
        debugPrint('🎵 Current song imageUrl após update: ${updatedSongs[songIndex].imageUrl}');
      } else {
        // Se a música não está na playlist, usar capa como fallback se necessário
        final songToPlay = song.imageUrl.isEmpty && playlist.cover.isNotEmpty
            ? song.copyWith(imageUrl: playlist.cover)
            : song;
        audioPlayer.playSong(songToPlay);
      }
    } else {
      audioPlayer.playSong(song);
    }
    context.pushNamed('player');
  }
  Future<Duration> _calculateTotalDurationAsync(BuildContext context, Playlist playlist) async {
    if (playlist.musicsData.isEmpty) return Duration.zero;
    final audioPlayer = Provider.of<AudioPlayerService>(context, listen: false);
    return await audioPlayer.calculateTotalDuration(playlist.musicsData);
  }
  int _calculateTotalDurationFallback(Playlist playlist) {
    if (playlist.musicsData.isEmpty) return 0;
    int totalSeconds = 0;
    for (final song in playlist.musicsData) {
      final durationParts = song.duration.split(':');
      if (durationParts.length == 2) {
        final minutes = int.tryParse(durationParts[0]) ?? 0;
        final seconds = int.tryParse(durationParts[1]) ?? 0;
        totalSeconds += minutes * 60 + seconds;
      }
    }
    return totalSeconds ~/ 60;
  }
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
      // Atualizar músicas sem imageUrl para usar a capa da playlist
      final updatedSongs = playlist.musicsData.map((s) {
        // Se a música não tem imageUrl ou está vazio, usar capa da playlist
        final shouldUsePlaylistCover = (s.imageUrl.isEmpty || s.imageUrl.trim().isEmpty) && 
                                       playlist.cover.isNotEmpty && 
                                       playlist.cover.trim().isNotEmpty;
        
        return shouldUsePlaylistCover
            ? s.copyWith(imageUrl: playlist.cover)
            : s;
      }).toList();
      final shuffledSongs = List<Song>.from(updatedSongs)..shuffle();
      audioPlayer.playPlaylist(shuffledSongs, startIndex: 0);
      debugPrint('🔀 Shuffle play: ${playlist.musicsData.length} músicas da playlist ${playlist.name}');
      context.pushNamed('player');
    }
  }
  void _onRepeatTap(BuildContext context, Playlist playlist) {
    final audioPlayer = Provider.of<AudioPlayerService>(context, listen: false);
    if (playlist.musicsData.isNotEmpty) {
      // Atualizar músicas sem imageUrl para usar a capa da playlist
      final updatedSongs = playlist.musicsData.map((s) {
        // Se a música não tem imageUrl ou está vazio, usar capa da playlist
        final shouldUsePlaylistCover = (s.imageUrl.isEmpty || s.imageUrl.trim().isEmpty) && 
                                       playlist.cover.isNotEmpty && 
                                       playlist.cover.trim().isNotEmpty;
        
        return shouldUsePlaylistCover
            ? s.copyWith(imageUrl: playlist.cover)
            : s;
      }).toList();
      audioPlayer.playPlaylist(updatedSongs, startIndex: 0);
      debugPrint('🔁 Repeat play: ${playlist.musicsData.length} músicas da playlist ${playlist.name}');
      context.pushNamed('player');
    }
  }
}
