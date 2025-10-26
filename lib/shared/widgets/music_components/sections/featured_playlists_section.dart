import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../design/layout_tokens.dart';
import '../../../design/app_colors.dart';
import '../../../../features/music_library/presentation/controllers/music_library_controller.dart';
class FeaturedPlaylistsSection extends StatelessWidget {
  const FeaturedPlaylistsSection({super.key});
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
          return const SizedBox.shrink();
        }
        final featuredPlayHits = controller.playlists.skip(6).take(3).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: LayoutTokens.paddingMD),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'PlayHITS em destaque',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: LayoutTokens.paddingMD),
            SizedBox(
              height: LayoutTokens.playlistCardSize + LayoutTokens.paddingLG,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: LayoutTokens.paddingMD),
                itemCount: featuredPlayHits.length,
                itemBuilder: (context, index) {
                  final playHit = featuredPlayHits[index];
                  return GestureDetector(
                    onTap: () => _navigateToPlaylist(context, playHit.id.toString(), playHit.name),
                    child: Container(
                      width: LayoutTokens.playlistCardSize,
                      margin: const EdgeInsets.only(right: LayoutTokens.cardMargin),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(LayoutTokens.radiusLG),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(LayoutTokens.radiusLG),
                                topRight: Radius.circular(LayoutTokens.radiusLG),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(playHit.cover),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(LayoutTokens.radiusLG),
                                  topRight: Radius.circular(LayoutTokens.radiusLG),
                                ),
                                color: Colors.black.withOpacity(0.2),
                              ),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(LayoutTokens.paddingSM),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryRed,
                                    borderRadius: BorderRadius.circular(LayoutTokens.radiusCircular),
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(LayoutTokens.paddingSM),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  playHit.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${playHit.musicsCount} músicas',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
  void _navigateToPlaylist(BuildContext context, String playlistId, String playlistName) {
    context.pushNamed(
      'playlist-detail',
      pathParameters: {'playlistId': playlistId},
      extra: playlistName,
    );
  }
}
