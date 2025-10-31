import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../music_components/player/mini_player.dart';
import '../../../../core/audio/audio_player_service.dart';
import '../../utils/responsive_utils.dart';

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
        final safeAreaBottom = MediaQuery.of(context).padding.bottom;
        
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Conteúdo principal
            Padding(
              padding: EdgeInsets.only(
                bottom: hasMusic && !isOnPlayerPage 
                    ? ResponsiveUtils.getMiniPlayerHeight(context) + safeAreaBottom * 0.2
                    : 0.0,
              ),
              child: child,
            ),
            // MiniPlayer fixo na parte inferior
            if (!isOnPlayerPage && hasMusic)
              Positioned(
                left: 0,
                right: 0,
                bottom: safeAreaBottom * 0.5,
                child: Builder(
                  builder: (ctx) {
                    // Verificação adicional
                    final location = GoRouterState.of(ctx).uri.path;
                    if (location == '/player' || location.contains('/player')) {
                      return const SizedBox.shrink();
                    }
                    return const MiniPlayer();
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
