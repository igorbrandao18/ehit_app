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

/// Widget que exibe a seção "ÉHIT Recomenda"
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
    if (!_initialized && mounted) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final controller = context.read<RecommendationsController>();
          controller.initialize(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecommendationsController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return _buildLoadingState();
        }

        if (controller.hasError) {
          return _buildErrorState(context, controller.errorMessage ?? 'Erro desconhecido');
        }

        if (controller.recommendations.isEmpty) {
          return const SizedBox.shrink();
        }

        return _buildContent(context, controller.recommendations);
      },
    );
  }

  Widget _buildLoadingState() {
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

  Widget _buildErrorState(BuildContext context, String error) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spaceMD),
      child: Center(
        child: Text(
          error,
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
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
              return _buildRecommendedCard(context, items[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedCard(BuildContext context, RecommendationItem item) {
    final cardData = _extractCardData(item);
    
    return Container(
      width: DesignTokens.playhitsCardWidth,
      margin: const EdgeInsets.only(right: DesignTokens.spaceMD),
      child: GestureDetector(
        onTap: () => _navigateToItem(context, item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardImage(cardData.imageUrl),
            const SizedBox(height: 8),
            _buildCardTitle(cardData.title),
            const SizedBox(height: 4),
            _buildCardSubtitle(cardData.subtitle),
          ],
        ),
      ),
    );
  }

  Widget _buildCardImage(String imageUrl) {
    final finalImageUrl = imageUrl.isNotEmpty 
        ? imageUrl 
        : 'https://via.placeholder.com/300';
    
    return Container(
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
    );
  }

  Widget _buildCardTitle(String title) {
    return Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCardSubtitle(String subtitle) {
    return Text(
      subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
    );
  }

  _CardData _extractCardData(RecommendationItem item) {
    if (item.type == 'album' && item.model is AlbumModel) {
      final album = item.model as AlbumModel;
      return _CardData(
        imageUrl: album.imageUrl,
        title: album.title,
        subtitle: album.artistName,
      );
    } else if (item.type == 'playlist' && item.model is PlaylistModel) {
      final playlist = item.model as PlaylistModel;
      final subtitle = playlist.musicsData.isNotEmpty
          ? playlist.musicsData.first.artist
          : 'Playlist';
      return _CardData(
        imageUrl: playlist.cover,
        title: playlist.name,
        subtitle: subtitle,
      );
    } else {
      // Fallback para dados diretos
      return _CardData(
        imageUrl: item.data['cover'] ?? item.data['imageUrl'] ?? '',
        title: item.data['name'] ?? item.data['title'] ?? 'Desconhecido',
        subtitle: item.data['artist_name'] ?? item.data['artistName'] ?? '',
    );
    }
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

/// Classe auxiliar para dados do card
class _CardData {
  final String imageUrl;
  final String title;
  final String subtitle;

  _CardData({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });
}

