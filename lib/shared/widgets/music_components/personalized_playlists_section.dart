// shared/widgets/music_components/personalized_playlists_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design/layout_tokens.dart';
import '../../design/app_colors.dart';
import '../../../features/music_library/presentation/controllers/music_library_controller.dart';

class PersonalizedPlaylistsSection extends StatelessWidget {
  const PersonalizedPlaylistsSection({super.key});

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
              padding: const EdgeInsets.symmetric(horizontal: LayoutTokens.paddingMD),
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
            const SizedBox(height: LayoutTokens.paddingMD),
            
            // Lista horizontal scrollável
            SizedBox(
              height: 200, // Altura fixa para os quadrados + texto
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: LayoutTokens.paddingMD),
                itemCount: playHits.length,
                itemBuilder: (context, index) {
                  final playHit = playHits[index];
                  return Container(
                    width: 150, // Largura fixa para cada card
                    margin: const EdgeInsets.only(right: LayoutTokens.cardMargin),
                    child: _buildSquareCard(
                      playHit.name,
                      playHit.cover,
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

  Widget _buildSquareCard(String title, String imageUrl) {
    return Column(
      children: [
        // Quadrado com imagem
        AspectRatio(
          aspectRatio: 1.0, // Quadrado perfeito
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(LayoutTokens.radiusLG),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // Texto abaixo do quadrado
        const SizedBox(height: LayoutTokens.paddingSM),
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
    );
  }
}