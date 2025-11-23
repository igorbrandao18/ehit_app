import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../design/design_tokens.dart';
import '../../../../features/music_library/presentation/controllers/recommendations_controller.dart';
import '../../../../features/music_library/data/models/album_model.dart';
import '../../../../features/music_library/data/models/playlist_model.dart';
import '../section_title.dart';
import '../../base_components/cached_image.dart';

class EhitRecommendsSection extends StatefulWidget {
  const EhitRecommendsSection({super.key});

  @override
  State<EhitRecommendsSection> createState() => _EhitRecommendsSectionState();
}

class _EhitRecommendsSectionState extends State<EhitRecommendsSection> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final controller = context.read<RecommendationsController>();
      // Inicializar com contexto para usar estratégia automática
      controller.initialize(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecommendationsController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return _buildLoadingState(context);
        }

        if (controller.recommendations.isEmpty) {
          return _buildEmptyState(context);
        }

        return _buildContent(context, controller.recommendations);
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
    return const SizedBox.shrink();
  }

  Widget _buildContent(BuildContext context, List<RecommendationItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: AppLocalizations.of(context)!.ehitRecommends),
        const SizedBox(height: DesignTokens.spaceMD),
        SizedBox(
          height: DesignTokens.playhitsCardWidth + DesignTokens.spaceLG + 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildRecommendedCard(context, item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedCard(BuildContext context, RecommendationItem item) {
    String imageUrl = '';
    String title = '';
    String artist = '';
    
    if (item.type == 'album' && item.model is AlbumModel) {
      final album = item.model as AlbumModel;
      imageUrl = album.imageUrl;
      title = album.title;
      artist = album.artistName;
    } else if (item.type == 'playlist' && item.model is PlaylistModel) {
      final playlist = item.model as PlaylistModel;
      imageUrl = playlist.cover;
      title = playlist.name;
      if (playlist.musicsData.isNotEmpty) {
        artist = playlist.musicsData.first.artist;
      }
    } else {
      // Fallback para dados diretos
      imageUrl = item.data['cover'] ?? item.data['imageUrl'] ?? '';
      title = item.data['name'] ?? item.data['title'] ?? '';
      artist = item.data['artist_name'] ?? item.data['artistName'] ?? '';
    }
    
    final finalImageUrl = imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/300';
    
    return Container(
      width: DesignTokens.playhitsCardWidth,
      margin: const EdgeInsets.only(right: DesignTokens.spaceMD),
      child: GestureDetector(
        onTap: () => _navigateToItem(context, item),
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
                  imageUrl: finalImageUrl,
                  fit: BoxFit.cover,
                  width: DesignTokens.playhitsCardWidth,
                  height: DesignTokens.playhitsCardWidth,
                  cacheWidth: DesignTokens.playhitsCardWidth.toInt(),
                  cacheHeight: DesignTokens.playhitsCardWidth.toInt(),
                  errorWidget: Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.white54,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
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
              artist,
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

  void _navigateToItem(BuildContext context, RecommendationItem item) {
    if (item.type == 'album' && item.model is AlbumModel) {
      final album = item.model as AlbumModel;
      context.pushNamed(
        'album-detail',
        pathParameters: {'albumId': item.id.toString()},
        extra: album,
      );
    } else if (item.type == 'playlist' && item.model is PlaylistModel) {
      final playlist = item.model as PlaylistModel;
      context.pushNamed(
        'playlist-detail',
        pathParameters: {'playlistId': item.id.toString()},
        extra: playlist.name,
      );
    }
  }
}

