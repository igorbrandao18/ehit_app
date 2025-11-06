import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/layout/app_layout.dart';
import '../../../../shared/design/design_tokens.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../../shared/widgets/base_components/cached_image.dart';
import '../controllers/music_library_controller.dart';
import '../../domain/entities/playlist.dart';
class CategoryDetailPage extends StatelessWidget {
  final String categoryTitle;
  final String categoryArtists;
  const CategoryDetailPage({
    super.key,
    required this.categoryTitle,
    required this.categoryArtists,
  });
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: _buildAppBar(context),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.solidBackground,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: DesignTokens.spaceMD),
              _buildPlaylistsSection(),
              SizedBox(height: DesignTokens.miniPlayerHeight + DesignTokens.spaceLG),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Gênero ($categoryTitle)',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeaderSection() {
    return const SizedBox.shrink();
  }
  Widget _buildPlaylistsSection() {
    return Consumer<MusicLibraryController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return Container(
            height: 200,
            padding: const EdgeInsets.all(24),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDA3637)),
              ),
            ),
          );
        }
        
        final filteredPlaylists = controller.playlists.where((playlist) {
          return playlist.musicsData.any((song) {
            return song.genre.toLowerCase().contains(categoryTitle.toLowerCase()) ||
                   categoryTitle.toLowerCase().contains(song.genre.toLowerCase());
          });
        }).toList();
        
        if (filteredPlaylists.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(DesignTokens.screenPadding),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.music_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: DesignTokens.spaceMD),
                  Text(
                    'Nenhuma playlist encontrada para este gênero',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        
        return Padding(
          padding: EdgeInsets.only(
            left: DesignTokens.screenPadding,
            right: DesignTokens.screenPadding,
            bottom: DesignTokens.spaceMD,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...filteredPlaylists.asMap().entries.map((entry) {
                final index = entry.key;
                final playlist = entry.value;
                return Column(
                  children: [
                    _buildPlaylistListItem(context, playlist),
                    if (index < filteredPlaylists.length - 1)
                      SizedBox(height: DesignTokens.spaceSM),
                  ],
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
  Widget _buildPlaylistListItem(BuildContext context, Playlist playlist) {
    final imageSize = ResponsiveUtils.getResponsiveImageSize(
      context,
      mobile: 64,
      tablet: 72,
      desktop: 80,
    );

    final padding = ResponsiveUtils.getResponsiveSpacing(
      context,
      mobile: DesignTokens.spaceMD,
      tablet: DesignTokens.spaceLG,
      desktop: DesignTokens.spaceXL,
    );

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'playlist-detail',
          pathParameters: {
            'playlistId': playlist.id.toString(),
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
              child: CachedImage(
                imageUrl: playlist.cover,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                cacheWidth: imageSize.toInt(),
                cacheHeight: imageSize.toInt(),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
                errorWidget: Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
                  ),
                  child: Icon(
                    Icons.music_note,
                    color: Colors.grey.shade400,
                    size: imageSize * 0.4,
                  ),
                ),
              ),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(
              context,
              mobile: DesignTokens.spaceMD,
              tablet: DesignTokens.spaceLG,
              desktop: DesignTokens.spaceXL,
            )),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    playlist.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        mobile: DesignTokens.fontSizeMD,
                        tablet: DesignTokens.fontSizeLG,
                        desktop: DesignTokens.fontSizeLG + DesignTokens.fontSizeAdjustmentSmall,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsiveUtils.getResponsiveSpacing(
                    context,
                    mobile: DesignTokens.spaceXS,
                    tablet: DesignTokens.spaceSM,
                    desktop: DesignTokens.spaceSM,
                  )),
                  Text(
                    '${playlist.musicsCount} músicas',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        mobile: DesignTokens.fontSizeSM,
                        tablet: DesignTokens.fontSizeMD,
                        desktop: DesignTokens.fontSizeMD,
                      ),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
