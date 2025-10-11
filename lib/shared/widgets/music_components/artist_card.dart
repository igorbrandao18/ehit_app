// shared/widgets/music_components/artist_card.dart
import 'package:flutter/material.dart';
import '../../design/app_colors.dart';
import '../../design/app_text_styles.dart';
import '../../design/design_tokens.dart';

/// Card circular para exibir artistas
class ArtistCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback? onTap;
  final double? size;

  const ArtistCard({
    super.key,
    required this.name,
    required this.imageUrl,
    this.onTap,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final cardSize = size ?? DesignTokens.artistCardSize;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardSize,
        height: cardSize,
        child: Column(
          children: [
            // Circular image
            Container(
              width: cardSize,
              height: cardSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.backgroundCard,
                      child: Icon(
                        Icons.person,
                        color: AppColors.textTertiary,
                        size: cardSize * 0.3,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Artist name
            const SizedBox(height: DesignTokens.spaceSM),
            Text(
              name,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
