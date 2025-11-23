import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/music_library/presentation/pages/home_page.dart';
import '../../features/music_library/presentation/pages/search_page.dart';
import '../../features/music_library/presentation/pages/library_page.dart';
import '../../features/music_library/presentation/pages/radios_page.dart';
import '../../features/music_library/presentation/pages/more_page.dart';
import '../../features/music_library/presentation/pages/artist_detail_page.dart';
import '../../features/music_library/presentation/pages/album_detail_page.dart';
import '../../features/music_library/presentation/pages/category_detail_page.dart';
import '../../features/music_library/presentation/pages/playlist_detail_page.dart';
import '../../features/music_library/presentation/pages/event_detail_page.dart';
import '../../features/music_player/presentation/pages/player_page.dart';
import '../../features/music_player/presentation/pages/queue_page.dart';
import '../../features/music_library/presentation/controllers/downloaded_songs_controller.dart';
import '../../features/music_library/presentation/controllers/genres_controller.dart';
import '../../core/injection/injection_container.dart' as di;
import '../../shared/widgets/layout/app_shell.dart';
import 'app_routes.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,
    routes: [
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.search,
            name: 'search',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SearchPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.library,
            name: 'library',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: ChangeNotifierProvider.value(
                value: di.sl<DownloadedSongsController>(),
                child: const LibraryPage(),
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.radios,
            name: 'radios',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const RadiosPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.more,
            name: 'more',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const MorePage(),
            ),
          ),
        ],
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
        path: AppRoutes.eventDetailPath(':eventId'),
        name: 'event-detail',
        builder: (context, state) {
          final eventId = state.pathParameters['eventId']!;
          return EventDetailPage(eventId: eventId);
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
