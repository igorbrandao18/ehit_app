// features/music_library/presentation/pages/artist_detail_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../shared/design/design_tokens.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../shared/widgets/music_components/artist_hero_section.dart';
import '../../../../shared/widgets/music_components/songs_list_section.dart';
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
    _controller = ArtistDetailController();
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
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.subtleGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(DesignTokens.spaceSM),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
          ),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: DesignTokens.iconSM,
          ),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(DesignTokens.spaceSM),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
            ),
            child: const Icon(
              Icons.more_vert,
              color: Colors.white,
              size: DesignTokens.iconSM,
            ),
          ),
          onPressed: () {
            // TODO: Implementar menu de opções
          },
        ),
      ],
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
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero section
          ArtistHeroSection(
            artist: controller.artist!,
          ),

          // Songs list section
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.screenPadding,
              vertical: 0,
            ),
            child: SongsListSection(
              songs: controller.songs,
              artistName: controller.artist!.name,
              onSongTap: (song) => _onSongTap(song),
              onShuffleTap: () => _onShuffleTap(),
              onRepeatTap: () => _onRepeatTap(),
            ),
          ),

          // Bottom padding
          const SizedBox(height: DesignTokens.miniPlayerHeight + DesignTokens.spaceXL),
        ],
      ),
    );
  }

  void _onSongTap(Song song) {
    _controller.playSong(song);
    // TODO: Implementar navegação para player
  }

  void _onShuffleTap() {
    _controller.shufflePlay();
    // TODO: Implementar reprodução aleatória
  }

  void _onRepeatTap() {
    _controller.repeatPlay();
    // TODO: Implementar reprodução em loop
  }
}
