// shared/widgets/artist_card.dart
import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../themes/app_spacing.dart';
import '../themes/app_dimensions.dart';

class ArtistCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback? onTap;

  const ArtistCard({
    super.key,
    required this.name,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardSize = AppDimensions.getArtistCardSize(context);
    final spacing = AppDimensions.getCardSpacing(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: Container(
        width: cardSize,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Artist image
            ClipRRect(
              borderRadius: BorderRadius.circular(cardSize / 2),
              child: Image.network(
                imageUrl,
                width: cardSize,
                height: cardSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: cardSize,
                    height: cardSize,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundElevated,
                      borderRadius: BorderRadius.circular(cardSize / 2),
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.textTertiary,
                      size: cardSize * 0.4,
                    ),
                  );
                },
              ),
            ),
            
            SizedBox(height: spacing),
            
            // Artist name - Flexible to prevent overflow
            Flexible(
              child: Text(
                name,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: AppDimensions.getBodySize(context) * 0.8,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
