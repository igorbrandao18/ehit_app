import 'package:flutter/material.dart';
import '../../../../features/music_library/domain/entities/artist.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_text_styles.dart';
import '../../../design/design_tokens.dart';
import '../../../utils/responsive_utils.dart';
import '../../base_components/cached_image.dart';
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
    final deviceType = ResponsiveUtils.getDeviceType(context);
    final cardSize = size ?? _getResponsiveCardSize(deviceType);
    final imageSize = cardSize * 0.85; 
    final spacing = ResponsiveUtils.getResponsiveSpacing(context);
    final fontSize = ResponsiveUtils.getResponsiveFontSize(context);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardSize,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    ? CachedImage(
                        imageUrl: artist.imageUrl,
                        fit: BoxFit.cover,
                        width: imageSize,
                        height: imageSize,
                        cacheWidth: imageSize.toInt(),
                        cacheHeight: imageSize.toInt(),
                        errorWidget: Container(
                          color: AppColors.backgroundCard,
                          child: Icon(
                            Icons.person,
                            color: AppColors.textTertiary,
                            size: imageSize * 0.3,
                          ),
                        ),
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
  double _getResponsiveCardSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 90.0; 
      case DeviceType.tablet:
        return 110.0; 
      case DeviceType.desktop:
        return 130.0; 
    }
  }
}
