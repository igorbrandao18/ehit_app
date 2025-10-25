// shared/widgets/music_components/song_list_item.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../features/music_library/domain/entities/song.dart';
import '../../../features/music_player/presentation/controllers/music_player_controller.dart';
import '../../design/design_tokens.dart';
import '../../utils/responsive_utils.dart';

/// Componente para item individual da lista de músicas
class SongListItem extends StatelessWidget {
  final Song song;
  final int index;
  final VoidCallback onTap;

  const SongListItem({
    super.key,
    required this.song,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveUtils.getResponsiveSpacing(context);
    final thumbnailSize = ResponsiveUtils.getResponsiveImageSize(context, 
      mobile: DesignTokens.songItemThumbnailMobile,
      tablet: DesignTokens.songItemThumbnailTablet,
      desktop: DesignTokens.songItemThumbnailDesktop,
    );
    final isMobile = ResponsiveUtils.getDeviceType(context) == DeviceType.mobile;
    
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? spacing * DesignTokens.mobileSpacingMultiplier : spacing,
          horizontal: isMobile ? spacing * DesignTokens.mobileHorizontalPaddingMultiplier : spacing,
        ),
        child: Row(
          children: [
            _buildAlbumArt(context, thumbnailSize),
            SizedBox(width: isMobile ? spacing * DesignTokens.mobileSpacingMultiplier * 1.5 : spacing * 1.5),
            Expanded(
              child: _buildSongInfo(context),
            ),
            _buildDownloadButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumArt(BuildContext context, double thumbnailSize) {
    final isMobile = ResponsiveUtils.getDeviceType(context) == DeviceType.mobile;
    final isTablet = ResponsiveUtils.getDeviceType(context) == DeviceType.tablet;
    
    return Container(
      width: thumbnailSize,
      height: thumbnailSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(DesignTokens.cardOverlayOpacity),
            blurRadius: isMobile ? DesignTokens.shadowBlurMobile : (isTablet ? DesignTokens.shadowBlurTablet : DesignTokens.shadowBlurDesktop),
            offset: const Offset(0, DesignTokens.cardShadowOffset),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          song.imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: isMobile ? DesignTokens.loadingStrokeMobile : DesignTokens.loadingStrokeDefault,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('❌ SongListItem: Error loading image: ${song.imageUrl}');
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.music_note,
                color: Colors.grey,
                size: thumbnailSize * DesignTokens.cardIconSizeRatio,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSongInfo(BuildContext context) {
    final fontSize = ResponsiveUtils.getResponsiveFontSize(context);
    final spacing = ResponsiveUtils.getResponsiveSpacing(context);
    final isMobile = ResponsiveUtils.getDeviceType(context) == DeviceType.mobile;
    final isTablet = ResponsiveUtils.getDeviceType(context) == DeviceType.tablet;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          song.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? fontSize * DesignTokens.mobileFontSizeMultiplier : fontSize,
            fontWeight: FontWeight.w600,
            height: DesignTokens.lineHeightNormal,
          ),
          maxLines: isMobile ? 1 : 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: isMobile ? spacing * DesignTokens.mobileSpacingSmallMultiplier : spacing * 0.4),
        GestureDetector(
          onTap: () => _navigateToArtist(context, song.artist),
          child: Text(
            song.artist,
            style: TextStyle(
              color: Colors.white70,
              fontSize: isMobile ? (fontSize - DesignTokens.fontSizeAdjustmentMedium) : (fontSize - DesignTokens.fontSizeAdjustmentSmall),
              fontWeight: FontWeight.w400,
              height: DesignTokens.lineHeightTight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isTablet || ResponsiveUtils.getDeviceType(context) == DeviceType.desktop) ...[
          SizedBox(height: spacing * 0.2),
          Text(
            '${song.duration} • ${song.genre}',
            style: TextStyle(
              color: Colors.white54,
              fontSize: fontSize - 4,
              fontWeight: FontWeight.w300,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    final iconSize = ResponsiveUtils.getResponsiveIconSize(context);
    final spacing = ResponsiveUtils.getResponsiveSpacing(context);
    final isMobile = ResponsiveUtils.getDeviceType(context) == DeviceType.mobile;
    
    return Consumer<MusicPlayerController>(
      builder: (context, playerController, child) {
        return FutureBuilder<bool>(
          future: _isSongAvailableOffline(),
          builder: (context, snapshot) {
            final isAvailableOffline = snapshot.data ?? false;
            
            return GestureDetector(
              onTap: () => _handleDownloadTap(context),
              child: Container(
                padding: EdgeInsets.all(isMobile ? spacing * 0.4 : spacing * 0.8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    isMobile ? DesignTokens.radiusSM : DesignTokens.radiusMD,
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: Icon(
                  isAvailableOffline ? Icons.check_circle : Icons.download,
                  color: isAvailableOffline ? Colors.green : Colors.white70,
                  size: isMobile ? iconSize * 0.7 : iconSize,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _isSongAvailableOffline() async {
    // TODO: Implementar verificação real usando AudioPlayerRepository
    return false;
  }

  void _handleDownloadTap(BuildContext context) async {
    // TODO: Implementar download usando OfflineAudioService
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Download de "${song.title}" iniciado'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToArtist(BuildContext context, String artistName) {
    debugPrint('🎤 Navegando para artista: $artistName');
    
    // Por enquanto, vamos usar um ID fictício baseado no nome do artista
    // Em uma implementação real, você teria uma busca por artista por nome
    final artistId = artistName.hashCode.abs().toString();
    
    // Navegar para a página de detalhes do artista
    context.pushNamed(
      'artist-detail',
      pathParameters: {'artistId': artistId},
      extra: artistName,
    );
  }
}
