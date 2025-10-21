// shared/widgets/album_card.dart
import 'package:flutter/material.dart';
import '../design/app_colors.dart';
import '../design/app_text_styles.dart';
import '../utils/responsive_utils.dart';

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
    final deviceType = ResponsiveUtils.getDeviceType(context);
    final cardWidth = _getResponsiveCardWidth(deviceType);
    final cardHeight = _getResponsiveCardHeight(deviceType);
    final spacing = ResponsiveUtils.getResponsiveSpacing(context);
    final fontSize = ResponsiveUtils.getResponsiveFontSize(context);
    final iconSize = ResponsiveUtils.getResponsiveIconSize(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(spacing),
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
                borderRadius: BorderRadius.circular(spacing),
                child: Image.network(
                  imageUrl,
                  width: cardWidth,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: cardWidth,
                      height: double.infinity,
                      color: AppColors.backgroundCard,
                      child: Icon(
                        Icons.album,
                        color: AppColors.textTertiary,
                        size: iconSize * 2,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            SizedBox(height: spacing),
            
            // Album info - Responsive height
            Container(
              height: _getResponsiveTextHeight(deviceType),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: spacing / 2),
                  
                  Text(
                    artist,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: fontSize - 2,
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

  /// Retorna a largura responsiva do card baseada no tipo de dispositivo
  double _getResponsiveCardWidth(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 160.0; // Smaller width for mobile
      case DeviceType.tablet:
        return 180.0; // Medium width for tablet
      case DeviceType.desktop:
        return 200.0; // Larger width for desktop
    }
  }

  /// Retorna a altura responsiva do card baseada no tipo de dispositivo
  double _getResponsiveCardHeight(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 220.0; // Smaller height for mobile
      case DeviceType.tablet:
        return 260.0; // Medium height for tablet
      case DeviceType.desktop:
        return 300.0; // Larger height for desktop
    }
  }

  /// Retorna a altura responsiva da área de texto baseada no tipo de dispositivo
  double _getResponsiveTextHeight(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 40.0; // Smaller text area for mobile
      case DeviceType.tablet:
        return 50.0; // Medium text area for tablet
      case DeviceType.desktop:
        return 60.0; // Larger text area for desktop
    }
  }
}
