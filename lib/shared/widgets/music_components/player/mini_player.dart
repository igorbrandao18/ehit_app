import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/audio/audio_player_service.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../design/app_colors.dart';
import '../../../design/design_tokens.dart';
import '../../../utils/responsive_utils.dart';
import '../../base_components/cached_image.dart';

class MiniPlayer extends StatefulWidget {
  final bool forceShow;
  
  final bool autoHideOnPlayerPage;

  const MiniPlayer({
    super.key,
    this.forceShow = false,
    this.autoHideOnPlayerPage = true,
  });

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }


  String? _getCurrentPath(BuildContext context) {
    try {
      return GoRouterState.of(context).uri.path;
    } catch (e) {
      try {
        final router = GoRouter.of(context);
        return router.routerDelegate.currentConfiguration.uri.path;
      } catch (e2) {
        return null;
      }
    }
  }

  bool _isPlayerRouteActive(BuildContext context) {
    try {
      final router = GoRouter.of(context);
      
      final mainUri = router.routerDelegate.currentConfiguration.uri.path;
      if (mainUri == AppRoutes.player || 
          mainUri == '/player' ||
          (mainUri.contains('/player') && !mainUri.contains('/playlist'))) {
        return true;
      }
      
      final matches = router.routerDelegate.currentConfiguration.matches;
      for (final match in matches) {
        final path = match.matchedLocation;
        if (path == AppRoutes.player || 
            path == '/player' ||
            (path.contains('/player') && !path.contains('/playlist'))) {
          return true;
        }
      }
      
      try {
        final state = GoRouterState.of(context);
        final statePath = state.uri.path;
        if (statePath == AppRoutes.player || 
            statePath == '/player' ||
            (statePath.contains('/player') && !statePath.contains('/playlist'))) {
          return true;
        }
      } catch (e) {
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (builderContext) {
        final isOnPlayerPage = _isPlayerRouteActive(builderContext);
        
        try {
          final router = GoRouter.of(builderContext);
          final currentPath = router.routerDelegate.currentConfiguration.uri.path;
          debugPrint('🎵 MiniPlayer build - Rota principal: $currentPath, isOnPlayerPage: $isOnPlayerPage, forceShow: ${widget.forceShow}, autoHide: ${widget.autoHideOnPlayerPage}');
        } catch (e) {
          debugPrint('🎵 MiniPlayer build - isOnPlayerPage: $isOnPlayerPage');
        }
        
        if (widget.autoHideOnPlayerPage && isOnPlayerPage) {
          debugPrint('🎵 MiniPlayer - OCULTANDO na página do player');
          return const SizedBox.shrink();
        }
    
        if (widget.forceShow) {
          return _buildMiniPlayerContent(builderContext);
        }
        
        return _buildMiniPlayerContent(builderContext);
      },
    );
  }
  
  Widget _buildMiniPlayerContent(BuildContext context) {
    if (widget.autoHideOnPlayerPage && _isPlayerRouteActive(context)) {
      debugPrint('🎵 MiniPlayer _buildMiniPlayerContent - OCULTANDO na página do player');
      return const SizedBox.shrink();
    }
    
    return Consumer<AudioPlayerService>(
      builder: (context, audioPlayer, child) {
        if (widget.autoHideOnPlayerPage && _isPlayerRouteActive(context)) {
          debugPrint('🎵 MiniPlayer Consumer - OCULTANDO na página do player');
          return const SizedBox.shrink();
        }
        
        if (audioPlayer.currentSong == null) {
          return const SizedBox.shrink();
        }
        
        final miniPlayerHeight = ResponsiveUtils.getMiniPlayerHeight(context);
        return Container(
          height: miniPlayerHeight,
          decoration: BoxDecoration(
            color: AppColors.solidBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(DesignTokens.opacityShadow),
                blurRadius: DesignTokens.miniPlayerShadowBlur,
                offset: const Offset(0, -DesignTokens.miniPlayerShadowOffset),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.pushNamed('player');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spaceMD,
                  vertical: DesignTokens.spaceXS,
                ),
                child: Row(
                  children: [
                    _buildAlbumArt(context, audioPlayer),
                    const SizedBox(width: DesignTokens.spaceMD),
                    Expanded(
                      child: _buildSongInfo(context, audioPlayer),
                    ),
                    _buildControls(context, audioPlayer),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _buildAlbumArt(BuildContext context, AudioPlayerService audioPlayer) {
    final albumSize = ResponsiveUtils.getMiniPlayerAlbumSize(context);
    return Container(
      width: albumSize,
      height: albumSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
          color: Colors.black.withOpacity(DesignTokens.opacityShadow),
          blurRadius: DesignTokens.miniPlayerShadowBlur,
          offset: const Offset(0, DesignTokens.miniPlayerShadowOffset),
          ),
        ],
      ),
        child: ClipOval(
          child: audioPlayer.currentSong != null && audioPlayer.currentSong!.imageUrl.isNotEmpty
              ? CachedImage(
                  imageUrl: audioPlayer.currentSong!.imageUrl,
                  fit: BoxFit.cover,
                  width: ResponsiveUtils.getMiniPlayerAlbumSize(context),
                  height: ResponsiveUtils.getMiniPlayerAlbumSize(context),
                  cacheWidth: ResponsiveUtils.getMiniPlayerAlbumSize(context).toInt(),
                  cacheHeight: ResponsiveUtils.getMiniPlayerAlbumSize(context).toInt(),
                  errorWidget: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: ResponsiveUtils.getMiniPlayerIconSize(context) * 0.8,
                    ),
                  ),
                )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: ResponsiveUtils.getMiniPlayerIconSize(context) * 0.8,
                ),
              ),
      ),
    );
  }
  Widget _buildSongInfo(BuildContext context, AudioPlayerService audioPlayer) {
    if (audioPlayer.currentSong == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          audioPlayer.currentSong!.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveUtils.getResponsiveFontSize(
              context,
              mobile: DesignTokens.fontSizeSM,
              tablet: DesignTokens.fontSizeMD,
              desktop: DesignTokens.fontSizeMD,
            ),
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 1),
        Text(
          audioPlayer.currentSong!.artist,
          style: TextStyle(
            color: Colors.white70,
            fontSize: ResponsiveUtils.getResponsiveFontSize(
              context,
              mobile: DesignTokens.fontSizeXS,
              tablet: DesignTokens.fontSizeSM,
              desktop: DesignTokens.fontSizeSM,
            ),
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          '${_formatDuration(audioPlayer.position)} / ${_formatDuration(audioPlayer.duration)}',
          style: TextStyle(
            color: Colors.white60,
            fontSize: ResponsiveUtils.getResponsiveFontSize(
              context,
              mobile: 10.0,
              tablet: DesignTokens.fontSizeXS,
              desktop: DesignTokens.fontSizeXS,
            ),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
  Widget _buildControls(BuildContext context, AudioPlayerService audioPlayer) {
    final buttonSize = ResponsiveUtils.getMiniPlayerButtonSize(context);
    final iconSize = ResponsiveUtils.getMiniPlayerIconSize(context);
    final smallIconSize = ResponsiveUtils.getMiniPlayerSmallIconSize(context);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            audioPlayer.togglePlayPause();
          },
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: const BoxDecoration(
              color: AppColors.primaryRed,
              shape: BoxShape.circle,
            ),
            child: Icon(
              audioPlayer.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: iconSize,
            ),
          ),
        ),
        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(
          context,
          mobile: DesignTokens.spaceXS,
          tablet: DesignTokens.spaceSM,
          desktop: DesignTokens.spaceSM,
        )),
        GestureDetector(
          onTap: () {
            audioPlayer.next();
          },
          child: Container(
            width: buttonSize * 0.8,
            height: buttonSize * 0.8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(DesignTokens.opacityOverlayLight),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.skip_next,
              color: Colors.white,
              size: smallIconSize,
            ),
          ),
        ),
      ],
    );
  }
}

