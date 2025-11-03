import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../features/music_library/domain/entities/song.dart';
import '../../../../features/music_player/presentation/controllers/music_player_controller.dart';
import '../../../../features/music_library/presentation/controllers/downloaded_songs_controller.dart';
import '../../../../core/audio/offline_audio_service.dart';
import '../../../../core/audio/audio_player_service.dart';
import '../../../../core/storage/downloaded_songs_storage.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/injection/injection_container.dart' as di;
import '../../../design/design_tokens.dart';
import '../../../utils/responsive_utils.dart';
class SongListItem extends StatelessWidget {
  final Song song;
  final int index;
  final VoidCallback onTap;
  final String? playlistCoverUrl; // URL da capa da playlist
  const SongListItem({
    super.key,
    required this.song,
    required this.index,
    required this.onTap,
    this.playlistCoverUrl,
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
    
    // Usar cover da playlist se song.imageUrl estiver vazio
    final imageUrl = (song.imageUrl.isNotEmpty) 
        ? song.imageUrl 
        : (playlistCoverUrl ?? '');
    
    // Se ainda estiver vazio, mostrar placeholder
    if (imageUrl.isEmpty) {
      return Container(
        width: thumbnailSize,
        height: thumbnailSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade800,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(DesignTokens.cardOverlayOpacity),
              blurRadius: isMobile ? DesignTokens.shadowBlurMobile : (isTablet ? DesignTokens.shadowBlurTablet : DesignTokens.shadowBlurDesktop),
              offset: const Offset(0, DesignTokens.cardShadowOffset),
            ),
          ],
        ),
        child: Icon(
          Icons.music_note,
          color: Colors.grey,
          size: thumbnailSize * DesignTokens.cardIconSizeRatio,
        ),
      );
    }
    
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
          imageUrl,
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
            print('❌ SongListItem: Error loading image: $imageUrl');
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
        Text(
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
    try {
      final downloadedStorage = di.sl<DownloadedSongsStorage>();
      final isDownloaded = await downloadedStorage.isDownloaded(song.id);
      return isDownloaded;
    } catch (e) {
      return false;
    }
  }
  
  void _handleDownloadTap(BuildContext context) async {
    final offlineService = OfflineAudioService();
    final downloadedStorage = di.sl<DownloadedSongsStorage>();
    
    // Verificar se já está baixada
    final isDownloaded = await _isSongAvailableOffline();
    if (isDownloaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${song.title}" já está baixada'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Mostrar feedback de início do download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Baixando "${song.title}"...'),
        duration: const Duration(seconds: 2),
      ),
    );

    // Fazer o download
    final result = await offlineService.downloadSong(song);
    
    result.when(
      success: (_) async {
        // Obter a duração real da música usando o mesmo método do player
        Song songToSave = song;
        try {
          final audioPlayerService = di.sl<AudioPlayerService>();
          final realDuration = await audioPlayerService.getSongDuration(song.audioUrl);
          
          if (realDuration != null) {
            // Formatar a duração para o formato MM:SS
            final minutes = realDuration.inMinutes;
            final seconds = realDuration.inSeconds % 60;
            final formattedDuration = '$minutes:${seconds.toString().padLeft(2, '0')}';
            
            debugPrint('✅ Duração real obtida para "${song.title}": $formattedDuration');
            
            // Criar uma cópia da música com a duração correta
            songToSave = song.copyWith(duration: formattedDuration);
          } else {
            debugPrint('⚠️ Não foi possível obter duração real para "${song.title}", usando duração original: ${song.duration}');
          }
        } catch (e) {
          debugPrint('❌ Erro ao obter duração real: $e, usando duração original: ${song.duration}');
        }
        
        // Salvar o objeto completo da música baixada (com duração correta se disponível)
        await downloadedStorage.addDownloadedSong(songToSave);
        
        // Notificar o controller para recarregar
        try {
          final downloadedController = di.sl<DownloadedSongsController>();
          debugPrint('🔄 Recarregando músicas baixadas...');
          await downloadedController.loadDownloadedSongs();
        } catch (e) {
          // Controller ainda não foi inicializado, será carregado quando a página for aberta
          debugPrint('⚠️ Controller não disponível ainda: $e');
        }
        
        // Mostrar feedback de sucesso
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"${song.title}" baixada com sucesso!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      error: (message, code) {
        // Mostrar feedback de erro
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao baixar: $message'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
    );
  }
}
