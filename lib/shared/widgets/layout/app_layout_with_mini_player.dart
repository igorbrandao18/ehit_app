// shared/widgets/layout/app_layout_with_mini_player.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../music_components/mini_player.dart';

/// Layout principal que inclui o mini player quando necessário
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
          // Main content
          Expanded(
            child: child,
          ),
          
          // Mini player (só aparece quando não está na página do player)
          if (!isOnPlayerPage) const MiniPlayer(),
        ],
      ),
    );
  }
}
