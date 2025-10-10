// shared/widgets/song_card.dart
import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../themes/app_spacing.dart';
import '../themes/app_dimensions.dart';

class SongCard extends StatelessWidget {
  final String title;
  final String artist;
  final String album;
  final String imageUrl;
  final Duration duration;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const SongCard({
    super.key,
    required this.title,
    required this.artist,
    required this.album,
    required this.imageUrl,
    required this.duration,
    this.onTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardHeight = AppDimensions.getSongCardHeight(context);
    final imageSize = cardHeight - 16; // Account for padding
    final spacing = AppDimensions.getListSpacing(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: Container(
        height: cardHeight,
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        child: Row(
          children: [
            // Album art
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              child: Image.network(
                imageUrl,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: imageSize,
                    height: imageSize,
                    color: AppColors.backgroundElevated,
                    child: Icon(
                      Icons.music_note,
                      color: AppColors.textTertiary,
                      size: imageSize * 0.4,
                    ),
                  );
                },
              ),
            ),
            
            SizedBox(width: spacing),
            
            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.songTitle.copyWith(
                      fontSize: AppDimensions.getBodySize(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    artist,
                    style: AppTextStyles.artistName.copyWith(
                      fontSize: AppDimensions.getBodySize(context) * 0.85,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Duration
            Text(
              _formatDuration(duration),
              style: AppTextStyles.caption.copyWith(
                fontSize: AppDimensions.getBodySize(context) * 0.75,
              ),
            ),
            
            SizedBox(width: spacing),
            
            // More button
            IconButton(
              onPressed: onMoreTap,
              icon: Icon(
                Icons.more_vert,
                color: AppColors.textTertiary,
                size: AppDimensions.getSmallIconSize(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
