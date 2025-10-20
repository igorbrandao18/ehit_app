// shared/widgets/music_components/playhits_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../design/design_tokens.dart';
import '../../design/app_colors.dart';
import '../layout/section_header.dart';
import '../layout/loading_section.dart';
import '../playhits_card.dart';
import '../../../features/music_library/presentation/controllers/music_library_controller.dart';
import '../../../core/routing/app_routes.dart';

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

        // Usar playlists como PlayHITS temporariamente
        final playHits = controller.playlists.take(5).toList();

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
                itemCount: playHits.length,
                itemBuilder: (context, index) {
                  final playlist = playHits[index];
                  return Container(
                    margin: EdgeInsets.only(
                      right: index < playHits.length - 1 ? DesignTokens.cardSpacing : 0,
                    ),
                    child: PlayHitsCard(
                      title: playlist.name,
                      artist: 'Ehit App',
                      imageUrl: playlist.cover,
                      isLarge: index == 0, // First card is large
                      onTap: onCardTap ?? () {
                        // Default navigation logic
                        _navigateToPlaylist(context, playlist);
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

  void _navigateToPlaylist(BuildContext context, playlist) {
    // Navigate to playlist detail page
    context.pushNamed(
      'playlist-detail',
      pathParameters: {'playlistId': playlist.id.toString()},
      extra: playlist.name,
    );
  }
}
