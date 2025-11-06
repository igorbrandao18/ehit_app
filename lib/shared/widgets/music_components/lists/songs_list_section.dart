import 'package:flutter/material.dart';
import '../../../../features/music_library/domain/entities/song.dart';
import '../../../design/design_tokens.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_text_styles.dart';
import '../../../utils/responsive_utils.dart';
import 'song_list_item.dart';
class SongsListSection extends StatelessWidget {
  final List<Song> songs;
  final String artistName;
  final Function(Song) onSongTap;
  final VoidCallback onShuffleTap;
  final VoidCallback onRepeatTap;
  final String? playlistCoverUrl;
  final bool hideArtist;
  const SongsListSection({
    super.key,
    required this.songs,
    required this.artistName,
    required this.onSongTap,
    required this.onShuffleTap,
    required this.onRepeatTap,
    this.playlistCoverUrl,
    this.hideArtist = false,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context),
        SizedBox(
          height: MediaQuery.of(context).size.height * DesignTokens.songsListHeightPercentage,
          child: _buildSongsList(context),
        ),
      ],
    );
  }
  Widget _buildSectionHeader(BuildContext context) {
    final padding = ResponsiveUtils.getResponsivePadding(context);
    final spacing = ResponsiveUtils.getResponsiveSpacing(context);
    final fontSize = ResponsiveUtils.getResponsiveFontSize(context);
    
    return Padding(
      padding: EdgeInsets.only(
        left: padding.left,
        right: padding.right,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Lista de sons',
            style: AppTextStyles.headlineSmall.copyWith(
              fontSize: fontSize + 4,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              _buildActionButton(context, icon: Icons.shuffle, onTap: onShuffleTap),
              SizedBox(width: spacing),
              _buildActionButton(context, icon: Icons.repeat, onTap: onRepeatTap),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildActionButton(BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final spacing = ResponsiveUtils.getResponsiveSpacing(context);
    final iconSize = ResponsiveUtils.getResponsiveIconSize(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
      child: Container(
        padding: EdgeInsets.all(spacing * 0.75),
        child: Icon(
          icon,
          color: AppColors.textPrimary,
          size: iconSize,
        ),
      ),
    );
  }
  Widget _buildSongsList(BuildContext context) {
    if (songs.isEmpty) {
      return _buildEmptyState(context);
    }
    return _buildSongsListView(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    final fontSize = ResponsiveUtils.getResponsiveFontSize(context);
    
    return Center(
      child: Text(
        'Nenhuma música encontrada',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          fontSize: fontSize,
        ),
      ),
    );
  }

  Widget _buildSongsListView(BuildContext context) {
    final padding = ResponsiveUtils.getResponsivePadding(context);
    
    return ListView.builder(
      padding: EdgeInsets.only(
        top: padding.top,
        left: padding.left,
        right: padding.right,
      ),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return SongListItem(
          song: song,
          index: index + 1,
          onTap: () => onSongTap(song),
          playlistCoverUrl: playlistCoverUrl,
          hideArtist: hideArtist,
        );
      },
    );
  }
}
