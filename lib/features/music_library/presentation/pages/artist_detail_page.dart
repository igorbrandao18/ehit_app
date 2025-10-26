// features/music_library/presentation/pages/artist_detail_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../shared/design/design_tokens.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../shared/widgets/layout/gradient_scaffold.dart';
import '../../../../shared/widgets/music_components/sections/artist_hero_section.dart';
import '../../../../shared/widgets/music_components/lists/songs_list_section.dart';
import '../../../../core/audio/audio_player_service.dart';
import '../../../../core/injection/injection_container.dart' as di;
import '../controllers/artist_detail_controller.dart';
import '../../domain/entities/song.dart';

/// Página de detalhes do artista completamente componentizada
class ArtistDetailPage extends StatefulWidget {
  final String artistId;

  const ArtistDetailPage({
    super.key,
    required this.artistId,
  });

  @override
  State<ArtistDetailPage> createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> {
  late ArtistDetailController _controller;

  @override
  void initState() {
    super.initState();
    // Criar nova instância para cada página
    _controller = ArtistDetailController(
      getArtistsUseCase: di.sl(),
      getSongsUseCase: di.sl(),
    );
    _loadArtistData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadArtistData() async {
    await _controller.loadArtistData(widget.artistId);
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: ChangeNotifierProvider.value(
        value: _controller,
        child: Consumer<ArtistDetailController>(
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
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: DesignTokens.iconMD,
        ),
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
            'Erro ao carregar dados do artista',
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
            onPressed: _loadArtistData,
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

  Widget _buildContent(ArtistDetailController controller) {
    return Column(
      children: [
        // Hero section (fixed)
        ArtistHeroSection(
          artist: controller.artist!,
        ),

        // Songs list section (scrollable)
        Expanded(
          child: SongsListSection(
            songs: controller.songs,
            artistName: controller.artist!.name,
            onSongTap: (song) => _onSongTap(song),
            onShuffleTap: () => _onShuffleTap(),
            onRepeatTap: () => _onRepeatTap(),
          ),
        ),
      ],
    );
  }

  void _onSongTap(Song song) {
    // Usa o AudioPlayerService para tocar a música
    final audioPlayer = Provider.of<AudioPlayerService>(context, listen: false);
    final songs = _controller.songs;
    
    // Encontra o índice da música na lista
    final songIndex = songs.indexWhere((s) => s.id == song.id);
    
    if (songIndex >= 0) {
      audioPlayer.playPlaylist(songs, startIndex: songIndex);
      debugPrint('🎵 Tocando artista: ${_controller.artist!.name}');
      debugPrint('🎵 Música atual: ${song.title} - ${song.artist}');
    } else {
      // Fallback: toca apenas a música
      audioPlayer.playSong(song);
    }
    
    // Navegar para o player
    context.pushNamed('player');
  }

  void _onShuffleTap() {
    // Usa o AudioPlayerService para tocar todas as músicas em ordem aleatória
    final audioPlayer = Provider.of<AudioPlayerService>(context, listen: false);
    final songs = _controller.songs;
    if (songs.isNotEmpty) {
      // Embaralha a lista de músicas
      final shuffledSongs = List<Song>.from(songs)..shuffle();
      audioPlayer.playPlaylist(shuffledSongs, startIndex: 0);
      debugPrint('🔀 Shuffle play: ${songs.length} músicas do artista ${_controller.artist!.name}');
      context.pushNamed('player');
    }
  }

  void _onRepeatTap() {
    // Usa o AudioPlayerService para tocar todas as músicas
    final audioPlayer = Provider.of<AudioPlayerService>(context, listen: false);
    final songs = _controller.songs;
    if (songs.isNotEmpty) {
      audioPlayer.playPlaylist(songs, startIndex: 0);
      debugPrint('🔁 Repeat play: ${songs.length} músicas do artista ${_controller.artist!.name}');
      context.pushNamed('player');
    }
  }
}
