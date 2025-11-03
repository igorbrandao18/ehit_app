import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/layout/gradient_scaffold.dart';
import '../../../../shared/widgets/layout/page_content.dart';
import '../../../../shared/widgets/layout/section_header.dart';
import '../../../../shared/widgets/layout/loading_section.dart';
import '../../../../shared/widgets/music_components/cards/artist_card.dart';
import '../../../../shared/design/design_tokens.dart';
import '../../../../shared/design/app_colors.dart';
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
    return GradientScaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          categoryTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
            _buildPlaylistsSection(),
            SizedBox(height: DesignTokens.miniPlayerHeight + DesignTokens.spaceLG),
          ],
        ),
      ),
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
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.screenPadding,
            vertical: DesignTokens.spaceMD,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<MusicLibraryController>(
                builder: (context, controller, child) {
                  return Text(
                    '${controller.playlists.length} playlists',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              ...controller.playlists.asMap().entries.map((entry) {
                final index = entry.key;
                final playlist = entry.value;
                return Column(
                  children: [
                    _buildPlaylistListItem(context, playlist, index + 1),
                    if (index < controller.playlists.length - 1)
                      const SizedBox(height: 6),
                  ],
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
  Widget _buildPlaylistListItem(BuildContext context, Playlist playlist, int rank) {
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryRed.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryRed.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                playlist.cover,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.grey,
                      size: 28,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${playlist.musicsCount} músicas • Ehit App',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
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
