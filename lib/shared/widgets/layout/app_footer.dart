import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../music_components/player/mini_player.dart';
import '../../../../core/audio/audio_player_service.dart';
import '../../../../core/routing/app_routes.dart';
import '../../utils/responsive_utils.dart';
import 'bottom_navigation_menu.dart';

class AppFooter extends StatelessWidget {
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

  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    const menuHeight = 70.0;
    
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
            if (hasMusic && !isOnPlayerPage)
              const MiniPlayer(),
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
