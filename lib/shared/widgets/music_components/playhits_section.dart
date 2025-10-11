// shared/widgets/music_components/playhits_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design/app_constants.dart';
import '../../design/design_tokens.dart';
import '../../design/app_colors.dart';
import '../layout/section_header.dart';
import '../layout/loading_section.dart';
import '../playhits_card.dart';
import '../../../features/music_library/presentation/controllers/music_library_controller.dart';

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
                itemCount: controller.playHits.length,
                itemBuilder: (context, index) {
                  final playHit = controller.playHits[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: DesignTokens.cardSpacing),
                    child: PlayHitsCard(
                      title: playHit['title']!,
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
    // TODO: Implement navigation to playlist
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navegando para: ${playHit['title']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
