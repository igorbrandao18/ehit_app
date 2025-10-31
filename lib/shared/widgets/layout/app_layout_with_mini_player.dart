import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../music_components/player/mini_player.dart';
import 'bottom_navigation_menu.dart';
import '../../../../core/audio/audio_player_service.dart';

class AppLayoutWithMiniPlayer extends StatelessWidget {
  final Widget child;
  const AppLayoutWithMiniPlayer({
    super.key,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final isOnPlayerPage = currentLocation == '/player';
    
    return Consumer<AudioPlayerService>(
      builder: (context, audioPlayer, _) {
        final hasMusic = audioPlayer.currentSong != null;
        
        return Stack(
          children: [
            // Conteúdo principal
            child,
            // Menu fixo por cima da safe area
            Positioned(
              left: 0,
              right: 0,
              bottom: hasMusic && !isOnPlayerPage 
                  ? 90 
                  : MediaQuery.of(context).padding.bottom * 0.2,
              child: const BottomNavigationMenu(),
            ),
            // MiniPlayer por cima da safe area
            if (!isOnPlayerPage && hasMusic)
              Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).padding.bottom,
                child: const MiniPlayer(),
              ),
          ],
        );
      },
    );
  }
}
