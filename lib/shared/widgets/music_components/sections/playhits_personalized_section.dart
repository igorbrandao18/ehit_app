import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../design/design_tokens.dart';
import '../../../../features/music_library/presentation/controllers/music_library_controller.dart';
import '../section_title.dart';

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
          return _buildEmptyState(context);
        }
        return _buildContent(context, controller);
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: DesignTokens.playhitsCardWidth + DesignTokens.spaceXL,
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: DesignTokens.playhitsCardWidth + DesignTokens.spaceXL,
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.noPlaylistsFound,
            style: const TextStyle(
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
        SectionTitle(title: AppLocalizations.of(context)!.playhits),
        const SizedBox(height: DesignTokens.spaceMD),
        SizedBox(
          height: DesignTokens.playhitsCardWidth + DesignTokens.spaceLG,
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
    final coverUrl = playHit.cover?.isNotEmpty == true ? playHit.cover : 'https://via.placeholder.com/300';
    return Container(
      width: DesignTokens.playhitsCardWidth,
      margin: const EdgeInsets.only(right: DesignTokens.spaceMD),
      child: GestureDetector(
        onTap: () => _navigateToPlaylist(context, playHit.id.toString(), playHit.name),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: DesignTokens.playhitsCardWidth, 
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                color: Colors.grey[800],
                image: DecorationImage(
                  image: NetworkImage(coverUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                  },
                ),
              ),
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
}
