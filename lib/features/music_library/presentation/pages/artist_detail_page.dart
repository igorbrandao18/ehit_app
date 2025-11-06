import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../shared/design/design_tokens.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../shared/widgets/layout/app_layout.dart';
import '../../../../shared/widgets/music_components/sections/artist_hero_section.dart';
import '../../../../shared/widgets/music_components/lists/albums_list_section.dart';
import '../../../../core/injection/injection_container.dart' as di;
import '../controllers/artist_detail_controller.dart';
import '../../domain/entities/album.dart';
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
    _controller = ArtistDetailController(
      getArtistsUseCase: di.sl(),
      getAlbumsByArtistUseCase: di.sl(),
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
  
  PreferredSizeWidget _buildAppBar() {
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
    return SingleChildScrollView(
      child: Column(
        children: [
          ArtistHeroSection(
            artist: controller.artist!,
          ),
          AlbumsListSection(
            albums: controller.albums,
            onAlbumTap: (album) => _onAlbumTap(album),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 140),
        ],
      ),
    );
  }

  void _onAlbumTap(Album album) {
    context.pushNamed(
      'album-detail',
      pathParameters: {'albumId': album.id.toString()},
      extra: album,
    );
  }
}
