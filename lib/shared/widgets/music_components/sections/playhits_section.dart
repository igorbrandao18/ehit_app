// shared/widgets/music_components/playhits_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../design/design_tokens.dart';
import '../../../design/app_colors.dart';
import '../../layout/section_header.dart';
import '../../layout/loading_section.dart';
import '../cards/playhits_card.dart';
import '../../../../features/music_library/presentation/controllers/music_library_controller.dart';
import '../../../../core/routing/app_routes.dart';

/// Seção PlayHITS da semana componentizada
class PlayHitsSection extends StatelessWidget {
  final VoidCallback? onCardTap;
  final VoidCallback? onViewAllTap;

  const PlayHitsSection({
    super.key,
    this.onCardTap,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicLibraryController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const LoadingSection(message: 'Carregando PlayHITS...');
        }

        // Usar playlists como PlayHITS (1 card por playlist)
        final playHits = <Map<String, String>>[];
        
        // Coletar playlists para criar PlayHITS
        for (final playlist in controller.playlists) {
          if (playlist.musicsData.isNotEmpty) {
            final firstSong = playlist.musicsData.first;
            playHits.add({
              'title': playlist.name,
              'artist': firstSong.artist,
              'imageUrl': playlist.cover, // Usar cover da playlist
              'songId': firstSong.id,
              'playlistId': playlist.id.toString(),
              'playlistName': playlist.name,
            });
          }
        }
        
        // Limitar a 12 PlayHITS como era antes
        final limitedPlayHits = playHits.take(12).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: AppConstants.playHitsTitle,
              action: onViewAllTap != null
                  ? const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textPrimary,
                      size: 20,
                    )
                  : null,
              onActionTap: onViewAllTap,
            ),
            SizedBox(
              height: DesignTokens.musicCardHeightLarge + 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.screenPadding,
                ),
                itemCount: limitedPlayHits.length,
                itemBuilder: (context, index) {
                  final playHit = limitedPlayHits[index];
                  return Container(
                    margin: EdgeInsets.only(
                      right: index < limitedPlayHits.length - 1 ? DesignTokens.cardSpacing : 0,
                    ),
                    child: PlayHitsCard(
                      title: playHit['playlistName']!, // Usar nome da playlist em vez do nome da música
                      artist: playHit['artist']!,
                      imageUrl: playHit['imageUrl']!,
                      isLarge: index == 0, // First card is large
                      onTap: onCardTap ?? () {
                        // Default navigation logic
                        _navigateToPlaylist(context, playHit);
                      },
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

  void _navigateToPlaylist(BuildContext context, Map<String, String> playHit) {
    // Navegar para a página de detalhes da playlist
    context.pushNamed(
      'playlist-detail',
      pathParameters: {'playlistId': playHit['playlistId']!},
      extra: playHit['playlistName'],
    );
  }
}
