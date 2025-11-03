import 'package:flutter/material.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_text_styles.dart';
import '../../../utils/responsive_utils.dart';
import '../../base_components/cached_image.dart';
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(spacing),
          child: CachedImage(
            imageUrl: imageUrl,
            width: cardWidth,
            height: cardHeight,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(spacing),
            errorWidget: Container(
              width: cardWidth,
              height: cardHeight,
              color: AppColors.backgroundCard,
              child: Icon(
                Icons.album,
                color: AppColors.textTertiary,
                size: iconSize * 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
  double _getResponsiveCardWidth(DeviceType deviceType) {
    // Tamanho será calculado via MediaQuery no componente pai
    return double.infinity; // Usa toda a largura disponível
  }
  double _getResponsiveCardHeight(DeviceType deviceType) {
    // Altura será calculada no componente pai
    return double.infinity; // Usa toda a altura disponível
  }
  double _getResponsiveTextHeight(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 40.0; 
      case DeviceType.tablet:
        return 50.0; 
      case DeviceType.desktop:
        return 60.0; 
    }
  }
}
