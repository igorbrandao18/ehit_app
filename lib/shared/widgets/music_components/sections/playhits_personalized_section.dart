import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../design/design_tokens.dart';
import '../../../../features/music_library/presentation/controllers/music_library_controller.dart';

class PlayHitsPersonalizedSection extends StatelessWidget {
  const PlayHitsPersonalizedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicLibraryController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return _buildLoadingState();
        }

        if (controller.playlists.isEmpty) {
          return _buildEmptyState();
        }

        return _buildContent(context, controller);
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: DesignTokens.playhitsCardHeight + DesignTokens.spaceXL,
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: DesignTokens.playhitsCardHeight + DesignTokens.spaceXL,
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
      child: const Center(
        child: Text(
          'Nenhuma playlist encontrada',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MusicLibraryController controller) {
    final playHits = controller.playlists.take(10).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título da seção
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
          child: Text(
            'PlayHITS para você',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        
        const SizedBox(height: DesignTokens.spaceMD),
        
        // Lista horizontal de cards
        SizedBox(
          height: DesignTokens.playhitsCardHeight + DesignTokens.spaceLG,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
            itemCount: playHits.length,
            itemBuilder: (context, index) {
              final playHit = playHits[index];
              return _buildPlaylistCard(context, playHit);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlaylistCard(BuildContext context, dynamic playHit) {
    return Container(
      width: DesignTokens.playhitsCardWidth,
      margin: const EdgeInsets.only(right: DesignTokens.spaceMD),
      child: GestureDetector(
        onTap: () => _navigateToPlaylist(context, playHit.id.toString(), playHit.name),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem da playlist
            Container(
              height: DesignTokens.playhitsCardWidth, // Quadrado perfeito
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                image: DecorationImage(
                  image: NetworkImage(playHit.cover),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            const SizedBox(height: DesignTokens.spaceSM),
            
            // Título da playlist
            Text(
              _capitalizeTitle(playHit.name),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPlaylist(BuildContext context, String playlistId, String playlistName) {
    context.pushNamed(
      'playlist-detail',
      pathParameters: {'playlistId': playlistId},
      extra: playlistName,
    );
  }

  /// Capitaliza o título deixando apenas a primeira letra maiúscula
  String _capitalizeTitle(String title) {
    if (title.isEmpty) return title;
    
    return title.toLowerCase().split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}