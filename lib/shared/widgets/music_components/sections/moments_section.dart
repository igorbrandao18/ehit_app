import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../design/design_tokens.dart';
import '../../../../features/music_library/presentation/controllers/moments_controller.dart';
import '../../../../features/music_library/data/models/playlist_model.dart';
import '../section_title.dart';
import '../../base_components/cached_image.dart';

class MomentsSection extends StatefulWidget {
  const MomentsSection({super.key});

  @override
  State<MomentsSection> createState() => _MomentsSectionState();
}

class _MomentsSectionState extends State<MomentsSection> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final controller = context.read<MomentsController>();
      controller.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MomentsController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return _buildLoadingState(context);
        }

        if (controller.moments.isEmpty) {
          return _buildEmptyState(context);
        }

        return _buildContent(context, controller.moments);
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

  Widget _buildContent(BuildContext context, List<PlaylistModel> moments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: AppLocalizations.of(context)?.moments ?? 'Momentos'),
        const SizedBox(height: DesignTokens.spaceMD),
        SizedBox(
          height: DesignTokens.playhitsCardWidth + DesignTokens.spaceLG + 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
            itemCount: moments.length,
            itemBuilder: (context, index) {
              final moment = moments[index];
              return _buildMomentCard(context, moment);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMomentCard(BuildContext context, PlaylistModel moment) {
    final imageUrl = moment.cover.isNotEmpty 
        ? moment.cover 
        : 'https://via.placeholder.com/300';
    
    return Container(
      width: DesignTokens.playhitsCardWidth,
      margin: const EdgeInsets.only(right: DesignTokens.spaceMD),
      child: GestureDetector(
        onTap: () => _navigateToPlaylist(context, moment),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
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
                          Icons.music_note,
                          color: Colors.white54,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                // Badge de conteúdo explícito
                if (moment.isExplicit)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'EXPLÍCITO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              moment.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
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

  void _navigateToPlaylist(BuildContext context, PlaylistModel moment) {
    context.pushNamed(
      'playlist-detail',
      pathParameters: {'playlistId': moment.id.toString()},
      extra: moment.name,
    );
  }
}

