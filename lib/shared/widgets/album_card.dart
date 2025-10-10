// shared/widgets/album_card.dart
import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../themes/app_spacing.dart';
import '../themes/app_dimensions.dart';

class AlbumCard extends StatelessWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final VoidCallback? onTap;

  const AlbumCard({
    super.key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = AppDimensions.getAlbumCardWidth(context);
    final cardHeight = AppDimensions.getAlbumCardHeight(context);
    final spacing = AppDimensions.getCardSpacing(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Album cover - rectangular format
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.md),
                child: Image.network(
                  imageUrl,
                  width: cardWidth,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: cardWidth,
                      height: double.infinity,
                      color: AppColors.backgroundElevated,
                      child: Icon(
                        Icons.album,
                        color: AppColors.textTertiary,
                        size: cardWidth * 0.3,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            SizedBox(height: spacing),
            
            // Album info - Fixed height to prevent overflow
            Container(
              height: 40, // Fixed height for text area
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: AppDimensions.getBodySize(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: AppSpacing.xs),
                  
                  Text(
                    artist,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: AppDimensions.getBodySize(context) * 0.85,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
