import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../music_components/player/mini_player.dart';
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
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: child,
          ),
          if (!isOnPlayerPage) const MiniPlayer(),
        ],
      ),
    );
  }
}
