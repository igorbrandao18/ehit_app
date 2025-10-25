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

        // Usar playlists como PlayHITS
        final playHits = controller.playlists.take(6).toList(); // 4 para grid + 2 individuais
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título da seção
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: LayoutTokens.paddingMD),
              child: Text(
                'PlayHITS para você',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: LayoutTokens.paddingMD),
            
            // Layout com grid 2x2 + 2 playlists individuais
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: LayoutTokens.paddingMD),
              child: Row(
                children: [
                  // Grid 2x2 "PlayHITS pra você"
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Grid 2x2 sem borda
                        Container(
                          height: LayoutTokens.playlistCardSize,
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _buildGridCard(
                                        playHits.length > 0 ? playHits[0].name : 'PlayHIT 1',
                                        playHits.length > 0 ? playHits[0].cover : 'https://via.placeholder.com/150x150/FF6B6B/FFFFFF?text=PlayHIT+1',
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildGridCard(
                                        playHits.length > 1 ? playHits[1].name : 'PlayHIT 2',
                                        playHits.length > 1 ? playHits[1].cover : 'https://via.placeholder.com/150x150/4ECDC4/FFFFFF?text=PlayHIT+2',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _buildGridCard(
                                        playHits.length > 2 ? playHits[2].name : 'PlayHIT 3',
                                        playHits.length > 2 ? playHits[2].cover : 'https://via.placeholder.com/150x150/45B7D1/FFFFFF?text=PlayHIT+3',
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildGridCard(
                                        playHits.length > 3 ? playHits[3].name : 'PlayHIT 4',
                                        playHits.length > 3 ? playHits[3].cover : 'https://via.placeholder.com/150x150/96CEB4/FFFFFF?text=PlayHIT+4',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Texto "PlayHITS pra você"
                        const SizedBox(height: LayoutTokens.paddingSM),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'PlayHITS pra você',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: LayoutTokens.cardMargin),
                  
                  // PlayHIT adicional (se disponível)
                  if (playHits.length > 4)
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildPlayHitCard(
                            playHits[4].name,
                            playHits[4].cover,
                          ),
                          const SizedBox(height: LayoutTokens.paddingSM),
                          Text(
                            playHits[4].name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(width: LayoutTokens.cardMargin),
                  
                  // PlayHIT adicional (se disponível)
                  if (playHits.length > 5)
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildPlayHitCard(
                            playHits[5].name,
                            playHits[5].cover,
                          ),
                          const SizedBox(height: LayoutTokens.paddingSM),
                          Text(
                            playHits[5].name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGridCard(String title, String imageUrl) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(LayoutTokens.radiusSM),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPlayHitCard(String title, String imageUrl) {
    return Container(
      height: LayoutTokens.playlistCardSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(LayoutTokens.radiusLG),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}