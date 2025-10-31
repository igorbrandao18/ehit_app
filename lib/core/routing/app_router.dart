import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/music_library/presentation/pages/home_page.dart';
import '../../features/music_library/presentation/pages/artist_detail_page.dart';
import '../../features/music_library/presentation/pages/album_detail_page.dart';
import '../../features/music_library/presentation/pages/category_detail_page.dart';
import '../../features/music_library/presentation/pages/playlist_detail_page.dart';
import '../../features/music_player/presentation/pages/player_page.dart';
import '../../features/music_library/presentation/controllers/downloaded_songs_controller.dart';
import '../../core/audio/audio_player_service.dart';
import '../../core/injection/injection_container.dart' as di;
import '../../shared/widgets/layout/app_shell.dart';
import '../../shared/widgets/layout/app_layout.dart';
import '../../shared/widgets/layout/app_header.dart';
import '../../shared/widgets/music_components/lists/song_list_item.dart';
import '../../shared/design/app_colors.dart';
import 'app_routes.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,
    routes: [
      // Shell route que mantém o menu fixo apenas nas rotas principais
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
      // Rotas de detalhes SEM shell (não mostram menu)
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
      // Rotas sem shell (player, queue, etc)
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

// Páginas simples
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: AppHeader(
        title: 'Buscar',
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.solidBackground,
        ),
        child: const Center(
          child: Text('Página de Busca'),
        ),
      ),
    );
  }
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  void initState() {
    super.initState();
    // Carregar músicas baixadas quando a página for aberta
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final controller = context.read<DownloadedSongsController>();
        controller.loadDownloadedSongs();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recarregar sempre que a página for visitada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final controller = context.read<DownloadedSongsController>();
        // Só recarregar se não estiver carregando
        if (!controller.isLoading) {
          controller.loadDownloadedSongs();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: AppHeader(
        title: 'Minhas Músicas',
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.solidBackground,
        ),
        child: Consumer<DownloadedSongsController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                ),
              );
            }

            if (controller.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white70,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.error!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => controller.loadDownloadedSongs(),
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              );
            }

            if (!controller.hasSongs) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.music_off,
                      color: Colors.white70,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nenhuma música baixada',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Baixe músicas para ouvir offline',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.loadDownloadedSongs(),
              color: AppColors.primaryRed,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.downloadedSongs.length,
                itemBuilder: (context, index) {
                  final song = controller.downloadedSongs[index];
                  return SongListItem(
                    song: song,
                    index: index,
                    onTap: () {
                      final audioPlayer = Provider.of<AudioPlayerService>(
                        context,
                        listen: false,
                      );
                      audioPlayer.playPlaylist(
                        controller.downloadedSongs,
                        startIndex: index,
                      );
                      context.pushNamed('player');
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class RadiosPage extends StatelessWidget {
  const RadiosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: AppHeader(
        title: 'Rádios',
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.solidBackground,
        ),
        child: const Center(
          child: Text('Página de Rádios'),
        ),
      ),
    );
  }
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: AppHeader(
        title: 'Mais',
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.solidBackground,
        ),
        child: const Center(
          child: Text('Página Mais'),
        ),
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
