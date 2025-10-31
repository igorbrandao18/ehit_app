import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/music_library/presentation/pages/home_page.dart';
import '../../features/music_library/presentation/pages/artist_detail_page.dart';
import '../../features/music_library/presentation/pages/album_detail_page.dart';
import '../../features/music_library/presentation/pages/category_detail_page.dart';
import '../../features/music_library/presentation/pages/playlist_detail_page.dart';
import '../../features/music_library/presentation/controllers/music_library_controller.dart';
import '../../features/music_player/presentation/pages/player_page.dart';
import '../../shared/design/app_theme.dart';
import '../../shared/design/app_colors.dart';
import '../../shared/widgets/layout/gradient_scaffold.dart';
import 'app_routes.dart';
class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: AppRoutes.library,
        name: 'library',
        builder: (context, state) => const LibraryPage(),
      ),
      GoRoute(
        path: AppRoutes.radios,
        name: 'radios',
        builder: (context, state) => const RadiosPage(),
      ),
      GoRoute(
        path: AppRoutes.more,
        name: 'more',
        builder: (context, state) => const MorePage(),
      ),
      GoRoute(
        path: AppRoutes.categoryDetailPath(':categoryTitle'),
        name: 'category-detail',
        builder: (context, state) {
          final categoryTitle = state.pathParameters['categoryTitle']!;
          final categoryArtists = state.extra as String? ?? '';
          return CategoryDetailPage(
            categoryTitle: categoryTitle,
            categoryArtists: categoryArtists,
          );
        },
      ),
      GoRoute(
        path: '/artist/:artistId',
        name: 'artist-detail',
        builder: (context, state) {
          final artistId = state.pathParameters['artistId']!;
          return ArtistDetailPage(artistId: artistId);
        },
      ),
      GoRoute(
        path: AppRoutes.albumDetailPath(':albumId'),
        name: 'album-detail',
        builder: (context, state) {
          final albumId = state.pathParameters['albumId']!;
          final album = state.extra;
          return AlbumDetailPage(
            albumId: albumId,
            album: album,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.playlistDetailPath(':playlistId'),
        name: 'playlist-detail',
        builder: (context, state) {
          final playlistId = state.pathParameters['playlistId']!;
          return PlaylistDetailPage(playlistId: playlistId);
        },
      ),
      GoRoute(
        path: AppRoutes.player,
        name: 'player',
        builder: (context, state) => const PlayerPage(),
      ),
      GoRoute(
        path: AppRoutes.queue,
        name: 'queue',
        builder: (context, state) => const QueuePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Página não encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'A rota "${state.uri}" não existe.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Voltar ao Início'),
            ),
          ],
        ),
      ),
    ),
  );
  static GoRouter get router => _router;
}
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Buscar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Página de Busca'),
      ),
    );
  }
}
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Sua Biblioteca'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Página da Biblioteca'),
      ),
    );
  }
}
class RadiosPage extends StatelessWidget {
  const RadiosPage({super.key});
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Rádios'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Página de Rádios'),
      ),
    );
  }
}
class MorePage extends StatelessWidget {
  const MorePage({super.key});
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Mais'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Página Mais'),
      ),
    );
  }
}
class QueuePage extends StatelessWidget {
  const QueuePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fila de Reprodução'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Página da Fila'),
      ),
    );
  }
}
