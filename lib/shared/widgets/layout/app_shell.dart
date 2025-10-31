import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../music_components/player/mini_player.dart';
import '../../../../core/audio/audio_player_service.dart';
import '../../../../core/routing/app_routes.dart';
import '../../utils/responsive_utils.dart';

/// Shell que envolve todas as rotas principais
/// Renderiza o mini player nas rotas principais quando há música tocando
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({
    super.key,
    required this.child,
  });

  /// Verifica se a rota atual é uma das rotas principais
  bool _isMainRoute(String path) {
    return path == AppRoutes.home ||
           path == AppRoutes.search ||
           path == AppRoutes.library ||
           path == AppRoutes.radios ||
           path == AppRoutes.more;
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
      
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    // Usar routerDelegate para pegar a rota atual real
    var currentPath = router.routerDelegate.currentConfiguration.uri.path;
    
    // Normalizar o path (remover query parameters)
    if (currentPath != null && currentPath.contains('?')) {
      currentPath = currentPath.split('?').first;
    }
    
    debugPrint('🔷 AppShell build - Rota: $currentPath');
    
    // PROTEÇÃO ABSOLUTA: Se estiver na página do player ou queue, retornar apenas o child SEM mini player
    // Verificar também se o player está na stack (modal/push)
    final isOnPlayerPage = _isPlayerRouteActive(context) || 
                          currentPath == AppRoutes.queue;
    
    if (isOnPlayerPage) {
      debugPrint('🔷 AppShell - Rota é /player (ou player está na stack), retornando SEM mini player');
      return Scaffold(body: child);
    }
    
    // Verificar se é uma rota principal
    final showMiniPlayer = _isMainRoute(currentPath);
    
    // Se não for uma rota principal, retornar apenas o child
    if (!showMiniPlayer) {
      return Scaffold(body: child);
    }

    return Consumer<AudioPlayerService>(
      builder: (context, audioPlayer, _) {
        final hasMusic = audioPlayer.currentSong != null;
        final safeAreaBottom = MediaQuery.of(context).padding.bottom;
        
        // Calcular altura do mini player se houver música
        final miniPlayerHeight = hasMusic 
            ? ResponsiveUtils.getMiniPlayerHeight(context)
            : 0.0;
        final bottomPadding = miniPlayerHeight + (safeAreaBottom * 0.2);

        return Scaffold(
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              // Conteúdo principal com padding inferior
              Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: child,
              ),
              // MiniPlayer fixo na parte inferior (só aparece se houver música)
              // O MiniPlayer já tem verificação interna, mas garantimos aqui também
              if (hasMusic && !isOnPlayerPage)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: safeAreaBottom * 0.5,
                  child: const MiniPlayer(),
                ),
            ],
          ),
        );
      },
    );
  }
}

