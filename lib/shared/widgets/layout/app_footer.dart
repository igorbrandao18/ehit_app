import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../music_components/player/mini_player.dart';
import '../../../../core/audio/audio_player_service.dart';
import '../../../../core/routing/app_routes.dart';
import '../../utils/responsive_utils.dart';
import 'bottom_navigation_menu.dart';

/// Footer do app que contém o menu de navegação e o mini player
/// Gerencia o posicionamento e visibilidade de ambos os componentes
class AppFooter extends StatelessWidget {
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

  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    const menuHeight = 70.0;
    
    // Verificar se está na página do player
    final isOnPlayerPage = _isPlayerRouteActive(context);
    
    return Consumer<AudioPlayerService>(
      builder: (context, audioPlayer, _) {
        final hasMusic = audioPlayer.currentSong != null;
        final miniPlayerHeight = hasMusic 
            ? ResponsiveUtils.getMiniPlayerHeight(context)
            : 0.0;
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // MiniPlayer - aparece acima do menu quando há música e não está na página do player
            if (hasMusic && !isOnPlayerPage)
              const MiniPlayer(),
            // Menu de navegação - sempre aparece nas rotas principais
            Padding(
              padding: EdgeInsets.only(bottom: safeAreaBottom),
              child: const BottomNavigationMenu(),
            ),
          ],
        );
      },
    );
  }
}
