// shared/widgets/music_components/artist_card.dart
import 'package:flutter/material.dart';
import '../../../../features/music_library/domain/entities/artist.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_text_styles.dart';
import '../../../design/design_tokens.dart';
import '../../../utils/responsive_utils.dart';

/// Card circular para exibir artistas
class ArtistCard extends StatelessWidget {
  final Artist artist;
  final VoidCallback? onTap;
  final double? size;

  const ArtistCard({
    super.key,
    required this.artist,
    this.onTap,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive sizing based on device type
    final deviceType = ResponsiveUtils.getDeviceType(context);
    final cardSize = size ?? _getResponsiveCardSize(deviceType);
    final imageSize = cardSize * 0.85; // Make image slightly smaller to leave space for text
    final spacing = ResponsiveUtils.getResponsiveSpacing(context);
    final fontSize = ResponsiveUtils.getResponsiveFontSize(context);
    
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardSize,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Square image with rounded corners
            Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: ResponsiveUtils.getResponsiveSpacing(context, mobile: 4, tablet: 6, desktop: 8),
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                child: artist.imageUrl.isNotEmpty
                    ? Image.network(
                        artist.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.backgroundCard,
                            child: Icon(
                              Icons.person,
                              color: AppColors.textTertiary,
                              size: imageSize * 0.3,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: AppColors.backgroundCard,
                        child: Icon(
                          Icons.person,
                          color: AppColors.textTertiary,
                          size: imageSize * 0.3,
                        ),
                      ),
              ),
            ),
            
            // Artist name
            SizedBox(height: spacing / 2),
            Text(
              artist.name,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: fontSize - 1,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Retorna o tamanho responsivo do card baseado no tipo de dispositivo
  double _getResponsiveCardSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 90.0; // Smaller for mobile to match image
      case DeviceType.tablet:
        return 110.0; // Medium for tablet
      case DeviceType.desktop:
        return 130.0; // Larger for desktop
    }
  }
}
