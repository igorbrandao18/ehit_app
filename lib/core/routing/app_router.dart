// core/routing/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/music_library/presentation/pages/home_page.dart';
import '../../features/music_library/presentation/pages/category_detail_page.dart';
import '../../features/music_library/presentation/pages/artist_detail_page.dart';
import '../../features/music_library/presentation/controllers/music_library_controller.dart';
import '../../features/music_player/presentation/controllers/music_player_controller.dart';
import '../../shared/design/app_theme.dart';
import 'app_routes.dart';

/// Configuração principal do roteamento da aplicação
class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      // Home route
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      
      // Search route
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),
      
      // Library route
      GoRoute(
        path: AppRoutes.library,
        name: 'library',
        builder: (context, state) => const LibraryPage(),
      ),
      
      // Profile route
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),

      // Category detail route (full screen)
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

      // Artist detail route
      GoRoute(
        path: '/artist/:artistId',
        name: 'artist-detail',
        builder: (context, state) {
          final artistId = state.pathParameters['artistId']!;
          return ArtistDetailPage(artistId: artistId);
        },
      ),

      // Album detail route
      GoRoute(
        path: AppRoutes.albumDetailPath(':albumId'),
        name: 'album-detail',
        builder: (context, state) {
          final albumId = state.pathParameters['albumId']!;
          return AlbumDetailPage(albumId: albumId);
        },
      ),

      // Playlist detail route
      GoRoute(
        path: AppRoutes.playlistDetailPath(':playlistId'),
        name: 'playlist-detail',
        builder: (context, state) {
          final playlistId = state.pathParameters['playlistId']!;
          return PlaylistDetailPage(playlistId: playlistId);
        },
      ),

      // Player route (full screen)
      GoRoute(
        path: AppRoutes.player,
        name: 'player',
        builder: (context, state) => const PlayerPage(),
      ),

      // Queue route
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

/// Página principal com navegação inferior
class MainPage extends StatefulWidget {
  final Widget child;

  const MainPage({super.key, required this.child});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home,
      label: 'Início',
      route: AppRoutes.home,
    ),
    NavigationItem(
      icon: Icons.search,
      label: 'Buscar',
      route: AppRoutes.search,
    ),
    NavigationItem(
      icon: Icons.library_music,
      label: 'Sua Biblioteca',
      route: AppRoutes.library,
    ),
    NavigationItem(
      icon: Icons.person,
      label: 'Perfil',
      route: AppRoutes.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          context.go(_navigationItems[index].route);
        },
        items: _navigationItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

// Placeholder pages - to be implemented
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return Scaffold(
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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Página do Perfil'),
      ),
    );
  }
}


class AlbumDetailPage extends StatelessWidget {
  final String albumId;

  const AlbumDetailPage({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Álbum: $albumId'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Text('Detalhes do Álbum: $albumId'),
      ),
    );
  }
}

class PlaylistDetailPage extends StatelessWidget {
  final String playlistId;

  const PlaylistDetailPage({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist: $playlistId'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Text('Detalhes da Playlist: $playlistId'),
      ),
    );
  }
}

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayerController>(
      builder: (context, playerController, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF8B0000), // Vermelho escuro como na imagem
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF8B0000), // Vermelho escuro
                    Color(0xFF4B0000), // Vermelho mais escuro
                    Colors.black,
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Header com seta para voltar e título
                  _buildHeader(context),
                  
                  // Conteúdo principal
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.06, // 6% da largura
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04), // 4% da altura
                          
                          // Album Art
                          _buildAlbumArt(context),
                          
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04), // 4% da altura
                          
                          // Informações da música
                          _buildSongInfo(context),
                          
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04), // 4% da altura
                          
                          // Progress bar
                          _buildProgressBar(context, playerController),
                          
                          const Spacer(),
                          
                          // Controles do player
                          _buildPlayerControls(context, playerController),
                          
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04), // 4% da altura
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.08; // 8% da largura
    final fontSize = screenWidth * 0.045; // 4.5% da largura
    final padding = screenWidth * 0.04; // 4% da largura
    
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: iconSize,
            ),
          ),
          Expanded(
            child: Text(
              'Decretos Reais',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: iconSize), // Espaço para balancear o layout
        ],
      ),
    );
  }

  Widget _buildAlbumArt(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final albumSize = screenWidth * 0.6; // 60% da largura da tela
    
    return Container(
      width: albumSize,
      height: albumSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          'https://example.com/album-art.jpg', // URL temporária
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.music_note,
                color: Colors.white,
                size: albumSize * 0.3, // 30% do tamanho do album
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSongInfo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth * 0.06; // 6% da largura
    final artistFontSize = screenWidth * 0.045; // 4.5% da largura
    
    return Column(
      children: [
        Text(
          'Leão',
          style: TextStyle(
            color: Colors.white,
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenWidth * 0.02), // 2% da largura
        Text(
          'Marília Mendonça',
          style: TextStyle(
            color: Colors.white70,
            fontSize: artistFontSize,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context, MusicPlayerController controller) {
    final progress = controller.duration.inMilliseconds > 0
        ? controller.position.inMilliseconds / controller.duration.inMilliseconds
        : 0.0;
    
    final remaining = controller.duration - controller.position;
    
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white30,
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
          ),
          child: Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (value) {
              final newPosition = Duration(
                milliseconds: (value * controller.duration.inMilliseconds).round(),
              );
              controller.seekTo(newPosition);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(controller.position),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Text(
                '-${_formatDuration(remaining)}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerControls(BuildContext context, MusicPlayerController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Botão anterior
        _buildControlButton(
          context: context,
          icon: Icons.skip_previous,
          onTap: () {
            // TODO: Implementar música anterior
          },
        ),
        
        // Botão play/pause principal
        _buildMainControlButton(context, controller),
        
        // Botão próximo
        _buildControlButton(
          context: context,
          icon: Icons.skip_next,
          onTap: () {
            // TODO: Implementar próxima música
          },
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth * 0.14; // 14% da largura
    final iconSize = screenWidth * 0.07; // 7% da largura
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.black,
          size: iconSize,
        ),
      ),
    );
  }

  Widget _buildMainControlButton(BuildContext context, MusicPlayerController controller) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth * 0.2; // 20% da largura
    final iconSize = screenWidth * 0.1; // 10% da largura
    
    return GestureDetector(
      onTap: () {
        controller.togglePlayPause();
      },
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: const BoxDecoration(
          color: Color(0xFF8B0000), // Vermelho como na imagem
          shape: BoxShape.circle,
        ),
        child: Icon(
          controller.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: iconSize,
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
