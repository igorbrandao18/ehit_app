import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/audio/audio_player_service.dart';
import '../../../../core/routing/app_routes.dart';
import '../../utils/responsive_utils.dart';
import 'app_footer.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({
    super.key,
    required this.child,
  });

  bool _isMainRoute(String path) {
    return path == AppRoutes.home ||
           path == AppRoutes.search ||
           path == AppRoutes.library ||
           path == AppRoutes.radios ||
           path == AppRoutes.more;
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
      
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    var currentPath = router.routerDelegate.currentConfiguration.uri.path;
    
    if (currentPath != null && currentPath.contains('?')) {
      currentPath = currentPath.split('?').first;
    }
    
    debugPrint('🔷 AppShell build - Rota: $currentPath');
    
    final isOnPlayerPage = _isPlayerRouteActive(context) || 
                          currentPath == AppRoutes.queue;
    
    if (isOnPlayerPage) {
      debugPrint('🔷 AppShell - Rota é /player (ou player está na stack), retornando SEM mini player');
      return Scaffold(body: child);
    }
    
    final showMiniPlayer = _isMainRoute(currentPath);
    
    if (!showMiniPlayer) {
      return Scaffold(body: child);
    }

    return Consumer<AudioPlayerService>(
      builder: (context, audioPlayer, _) {
        final hasMusic = audioPlayer.currentSong != null;
        final safeAreaBottom = MediaQuery.of(context).padding.bottom;
        
        const menuHeight = 70.0;
        
        final miniPlayerHeight = hasMusic && !_isPlayerRouteActive(context)
            ? ResponsiveUtils.getMiniPlayerHeight(context)
            : 0.0;
        
        final footerHeight = menuHeight + miniPlayerHeight + safeAreaBottom;

        return Scaffold(
          extendBody: true,
          backgroundColor: Colors.black,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: footerHeight),
                child: child,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: const AppFooter(),
              ),
            ],
          ),
        );
      },
    );
  }
}

