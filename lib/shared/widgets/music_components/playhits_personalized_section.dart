// shared/widgets/music_components/personalized_playlists_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../design/design_tokens.dart';
import '../../../features/music_library/presentation/controllers/music_library_controller.dart';

class PlayHitsPersonalizedSection extends StatelessWidget {
  const PlayHitsPersonalizedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicLibraryController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }

        if (controller.playlists.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum PlayHIT encontrado',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          );
        }

        // Usar todas as playlists como PlayHITS scrolláveis
        final playHits = controller.playlists;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título da seção
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'PlayHITS para você',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: DesignTokens.screenPadding),
            
            // Lista horizontal scrollável
            SizedBox(
              height: 160, // Reduzido de 200px para 160px
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
                itemCount: playHits.length,
                itemBuilder: (context, index) {
                  final playHit = playHits[index];
                  return Container(
                    width: 120, // Reduzido de 150px para 120px
                    margin: const EdgeInsets.only(right: DesignTokens.cardMargin),
                    child: _buildSquareCard(
                      context,
                      playHit.name,
                      playHit.cover,
                      playHit.id.toString(),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSquareCard(BuildContext context, String title, String imageUrl, String playlistId) {
    return GestureDetector(
      onTap: () => _navigateToPlaylist(context, playlistId, title),
      child: Column(
        children: [
          // Quadrado com imagem
          AspectRatio(
            aspectRatio: 1.0, // Quadrado perfeito
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DesignTokens.radiusLG),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Texto abaixo do quadrado
          const SizedBox(height: DesignTokens.paddingSM),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _navigateToPlaylist(BuildContext context, String playlistId, String playlistName) {
    // Navegar para a página de detalhes da playlist
    context.pushNamed(
      'playlist-detail',
      pathParameters: {'playlistId': playlistId},
      extra: playlistName,
    );
  }
}