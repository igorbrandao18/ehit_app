import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/audio/audio_player_service.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../design/app_colors.dart';
import '../../../design/design_tokens.dart';
import '../../../utils/responsive_utils.dart';

/// Mini player reutilizável e controlável
/// Pode ser usado em qualquer lugar da aplicação
/// Por padrão, não aparece na página do player principal
class MiniPlayer extends StatefulWidget {
  /// Se true, força o mini player a aparecer mesmo na página do player
  final bool forceShow;
  
  /// Se true, verifica automaticamente se está na rota /player e oculta
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
    // Forçar reconstrução quando as dependências mudarem (mudança de rota)
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

  /// Verifica se a rota /player está ativa (mesmo que seja um push/modal)
  bool _isPlayerRouteActive(BuildContext context) {
    try {
      final router = GoRouter.of(context);
      
      // Verificar a URI principal
      final mainUri = router.routerDelegate.currentConfiguration.uri.path;
      if (mainUri == AppRoutes.player || 
          mainUri == '/player' ||
          (mainUri.contains('/player') && !mainUri.contains('/playlist'))) {
        return true;
      }
      
      // Verificar todas as rotas na stack (para detectar push/modal)
      final matches = router.routerDelegate.currentConfiguration.matches;
      for (final match in matches) {
        final path = match.matchedLocation;
        if (path == AppRoutes.player || 
            path == '/player' ||
            (path.contains('/player') && !path.contains('/playlist'))) {
          return true;
        }
      }
      
      // Verificar também no GoRouterState se disponível
      try {
        final state = GoRouterState.of(context);
        final statePath = state.uri.path;
        if (statePath == AppRoutes.player || 
            statePath == '/player' ||
            (statePath.contains('/player') && !statePath.contains('/playlist'))) {
          return true;
        }
      } catch (e) {
        // Ignorar erro
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // VERIFICAÇÃO ABSOLUTA PRIMEIRO: se está na página do player, NUNCA mostrar
    // Usar Builder para pegar o contexto correto da rota atual
    return Builder(
      builder: (builderContext) {
        // Verificar se a rota do player está ativa (incluindo modals/push)
        final isOnPlayerPage = _isPlayerRouteActive(builderContext);
        
        // DEBUG
        try {
          final router = GoRouter.of(builderContext);
          final currentPath = router.routerDelegate.currentConfiguration.uri.path;
          debugPrint('🎵 MiniPlayer build - Rota principal: $currentPath, isOnPlayerPage: $isOnPlayerPage, forceShow: ${widget.forceShow}, autoHide: ${widget.autoHideOnPlayerPage}');
        } catch (e) {
          debugPrint('🎵 MiniPlayer build - isOnPlayerPage: $isOnPlayerPage');
        }
        
        // SE estiver na rota /player e autoHideOnPlayerPage for true, NÃO mostrar
        if (widget.autoHideOnPlayerPage && isOnPlayerPage) {
          debugPrint('🎵 MiniPlayer - OCULTANDO na página do player');
          return const SizedBox.shrink();
        }
    
        // Se forceShow for true, mostrar sempre (mesmo na página do player)
        if (widget.forceShow) {
          return _buildMiniPlayerContent(builderContext);
        }
        
        // Mostrar o mini player normalmente
        return _buildMiniPlayerContent(builderContext);
      },
    );
  }
  
  /// Conteúdo do mini player (extraído para reutilização)
  Widget _buildMiniPlayerContent(BuildContext context) {
    // VERIFICAÇÃO ABSOLUTA ANTES DO CONSUMER
    // Se autoHideOnPlayerPage for true, verificar a rota PRIMEIRO
    if (widget.autoHideOnPlayerPage && _isPlayerRouteActive(context)) {
      debugPrint('🎵 MiniPlayer _buildMiniPlayerContent - OCULTANDO na página do player');
      return const SizedBox.shrink();
    }
    
    return Consumer<AudioPlayerService>(
      builder: (context, audioPlayer, child) {
        // Verificação DUPLA dentro do Consumer também (por segurança)
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
                // Usar go em vez de push para navegação mais limpa
                context.go(AppRoutes.player);
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
          child: audioPlayer.currentSong != null
              ? Image.network(
                  audioPlayer.currentSong!.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: ResponsiveUtils.getMiniPlayerIconSize(context) * 0.8,
                    ),
                  );
                },
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

