import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../shared/design/design_tokens.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../shared/widgets/layout/app_layout.dart';
import '../../../../shared/widgets/music_components/lists/songs_list_section.dart';
import '../../../../core/audio/audio_player_service.dart';
import '../../../../core/injection/injection_container.dart' as di;
import '../controllers/album_detail_controller.dart';
import '../../domain/entities/song.dart';
import '../../domain/entities/album.dart';
import '../../../../shared/utils/responsive_utils.dart';

class AlbumDetailPage extends StatefulWidget {
  final String albumId;
  final dynamic album;
  
  const AlbumDetailPage({
    super.key,
    required this.albumId,
    this.album,
  });

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  late AlbumDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AlbumDetailController(
      getSongsByAlbumUseCase: di.sl(),
    );
    _loadAlbumData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadAlbumData() async {
    final albumId = int.tryParse(widget.albumId);
    if (albumId != null) {
      final albumFromRoute = widget.album is Album ? widget.album as Album : null;
      await _controller.loadAlbumData(albumId, albumFromRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: _buildAppBar(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.solidBackground,
        ),
        child: ChangeNotifierProvider.value(
          value: _controller,
          child: Consumer<AlbumDetailController>(
            builder: (context, controller, child) {
              if (controller.isLoading) {
                return _buildLoadingState();
              }
              if (controller.error != null) {
                return _buildErrorState();
              }
              if (!controller.hasData) {
                return _buildEmptyState();
              }
              return _buildContent(controller);
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: DesignTokens.iconXXL,
          ),
          const SizedBox(height: DesignTokens.spaceMD),
          const Text(
            'Erro ao carregar dados do álbum',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: DesignTokens.spaceSM),
          Text(
            _controller.error!,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spaceLG),
          ElevatedButton(
            onPressed: _loadAlbumData,
            child: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_off,
            color: Colors.white70,
            size: DesignTokens.iconXXL,
          ),
          SizedBox(height: DesignTokens.spaceMD),
          Text(
            'Nenhum dado encontrado',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AlbumDetailController controller) {
    final album = controller.album;
    if (album == null) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(context, album),
          _buildSongsSection(context, controller),
          // Padding inferior para não sobrepor o footer (se houver)
          SizedBox(height: MediaQuery.of(context).padding.bottom + 140),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, Album album) {
    final padding = ResponsiveUtils.getResponsivePadding(context);
    final screenWidth = MediaQuery.of(context).size.width;
    // Mesmo tamanho da imagem do artista: 50% da largura da tela
    final imageSize = screenWidth * 0.5;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: padding.horizontal,
        right: padding.horizontal,
        top: DesignTokens.spaceXS, // Padding superior mínimo (igual ao artista)
        bottom: DesignTokens.spaceMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sem espaçamento superior adicional para maximizar a posição da imagem
          Center(
            child: Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(DesignTokens.opacityShadow),
                    blurRadius: DesignTokens.artistHeroShadowBlur,
                    offset: const Offset(0, DesignTokens.artistHeroShadowOffset),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  album.imageUrl,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: imageSize,
                      height: imageSize,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.album,
                        color: Colors.grey,
                        size: imageSize * DesignTokens.artistHeroIconSizeRatio,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: DesignTokens.spaceLG), 
          Center(
            child: Column(
              children: [
                Text(
                  album.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: DesignTokens.subtitleFontSize, 
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: DesignTokens.spaceSM), 
                FutureBuilder<Duration>(
                  future: _calculateTotalDurationAsync(context, _controller.songs),
                  builder: (context, snapshot) {
                    final duration = snapshot.hasData 
                        ? snapshot.data! 
                        : Duration(minutes: _calculateTotalDurationFallback(_controller.songs));
                    final durationText = _formatDuration(duration);
                    return Text(
                      '${album.songsCount} Músicas • $durationText',
                      style: TextStyle(
                        color: Colors.white.withOpacity(DesignTokens.opacityTextSecondary),
                        fontSize: DesignTokens.subtitleFontSize, 
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                SizedBox(height: DesignTokens.spaceMD),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongsSection(BuildContext context, AlbumDetailController controller) {
    return SongsListSection(
      songs: controller.songs,
      artistName: controller.album?.artistName ?? 'Unknown Artist',
      onSongTap: (song) => _onSongTap(song),
      onShuffleTap: () => _onShuffleTap(controller),
      onRepeatTap: () => _onRepeatTap(controller),
    );
  }

  void _onSongTap(Song song) {
    final audioPlayer = Provider.of<AudioPlayerService>(context, listen: false);
    final songs = _controller.songs;
    final songIndex = songs.indexWhere((s) => s.id == song.id);
    if (songIndex >= 0) {
      audioPlayer.playPlaylist(songs, startIndex: songIndex);
      debugPrint('🎵 Tocando álbum: ${_controller.album?.title}');
      debugPrint('🎵 Música atual: ${song.title} - ${song.artist}');
    } else {
      audioPlayer.playSong(song);
    }
    context.pushNamed('player');
  }

  void _onShuffleTap(AlbumDetailController controller) {
    final audioPlayer = Provider.of<AudioPlayerService>(context, listen: false);
    final songs = controller.songs;
    if (songs.isNotEmpty) {
      final shuffledSongs = List<Song>.from(songs)..shuffle();
      audioPlayer.playPlaylist(shuffledSongs, startIndex: 0);
      debugPrint('🔀 Shuffle play: ${songs.length} músicas do álbum ${controller.album?.title}');
      context.pushNamed('player');
    }
  }

  void _onRepeatTap(AlbumDetailController controller) {
    final audioPlayer = Provider.of<AudioPlayerService>(context, listen: false);
    final songs = controller.songs;
    if (songs.isNotEmpty) {
      audioPlayer.playPlaylist(songs, startIndex: 0);
      debugPrint('🔁 Repeat play: ${songs.length} músicas do álbum ${controller.album?.title}');
      context.pushNamed('player');
    }
  }

  Future<Duration> _calculateTotalDurationAsync(BuildContext context, List<Song> songs) async {
    if (songs.isEmpty) return Duration.zero;
    final audioPlayer = Provider.of<AudioPlayerService>(context, listen: false);
    return await audioPlayer.calculateTotalDuration(songs);
  }

  int _calculateTotalDurationFallback(List<Song> songs) {
    if (songs.isEmpty) return 0;
    int totalSeconds = 0;
    for (final song in songs) {
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
}

