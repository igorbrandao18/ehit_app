import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../design/design_tokens.dart';
import '../../../../features/music_library/presentation/controllers/featured_albums_controller.dart';
import '../../base_components/cached_image.dart';
import '../section_title.dart';

class ReleasesSection extends StatelessWidget {
  const ReleasesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeaturedAlbumsController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return _buildLoadingState(context);
        }
        if (controller.albums.isEmpty) {
          return _buildEmptyState(context);
        }
        return _buildContent(context, controller);
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      height: DesignTokens.playhitsCardWidth + DesignTokens.spaceXL + 60,
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
      height: DesignTokens.playhitsCardWidth + DesignTokens.spaceXL + 60,
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
      child: Center(
        child: Text(
          'Nenhum lançamento encontrado',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, FeaturedAlbumsController controller) {
    final albums = controller.albums.take(10).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Lançamentos'),
        const SizedBox(height: DesignTokens.spaceMD),
        SizedBox(
          height: DesignTokens.playhitsCardWidth + DesignTokens.spaceLG + 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              return _buildAlbumCard(context, album);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAlbumCard(BuildContext context, dynamic album) {
    final imageUrl = album.imageUrl?.isNotEmpty == true ? album.imageUrl : 'https://via.placeholder.com/300';
    return Container(
      width: DesignTokens.playhitsCardWidth,
      margin: const EdgeInsets.only(right: DesignTokens.spaceMD),
      child: GestureDetector(
        onTap: () => _navigateToAlbum(context, album),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: DesignTokens.playhitsCardWidth,
              width: DesignTokens.playhitsCardWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                color: Colors.grey[800],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                child: CachedImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: DesignTokens.playhitsCardWidth,
                  height: DesignTokens.playhitsCardWidth,
                  cacheWidth: DesignTokens.playhitsCardWidth.toInt(),
                  cacheHeight: DesignTokens.playhitsCardWidth.toInt(),
                  errorWidget: Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.album,
                      color: Colors.white54,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              album.title ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              album.artistName ?? '',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAlbum(BuildContext context, dynamic album) {
    context.pushNamed(
      'album-detail',
      pathParameters: {'albumId': album.id.toString()},
      extra: album,
    );
  }
}

