// features/music_library/presentation/pages/genre_songs_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/layout/gradient_scaffold.dart';
import '../../../../shared/widgets/music_components/songs_list_section.dart';
import '../../../../shared/design/design_tokens.dart';
import '../controllers/music_library_controller.dart';
import '../../domain/entities/song.dart';
import '../../../music_player/presentation/controllers/audio_player_controller.dart';
import '../../../../core/utils/result.dart';

class GenreSongsPage extends StatelessWidget {
  final String genre;
  final String genreImageUrl;

  const GenreSongsPage({
    super.key,
    required this.genre,
    required this.genreImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          genre,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<MusicLibraryController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              // Hero section with genre image
              Container(
                height: 200,
                margin: const EdgeInsets.all(DesignTokens.screenPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(genreImageUrl),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      genre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Songs list
              Expanded(
                child: FutureBuilder(
                  future: controller.getSongsByGenre(genre),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Erro ao carregar músicas',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              snapshot.error.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    
                    final result = snapshot.data;
                    if (result is Success<List<Song>>) {
                      final songs = result.data;
                      if (songs.isEmpty) {
                        return const Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.music_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Nenhuma música encontrada',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      return SongsListSection(
                        songs: songs,
                        artistName: genre,
                        onSongTap: (song) => _onSongTap(context, song, songs),
                        onShuffleTap: () => _onShuffleTap(context, songs),
                        onRepeatTap: () => _onRepeatTap(context, songs),
                      );
                    } else if (result is Error<List<Song>>) {
                      return Center(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Erro ao carregar músicas',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(result.message),
                          ],
                        ),
                      );
                    }
                    
                    return const SizedBox.shrink();
                  },
                ),
              ),
              
              // Bottom padding for player
              const SizedBox(height: DesignTokens.miniPlayerHeight + 20),
            ],
          );
        },
      ),
    );
  }

  void _onSongTap(BuildContext context, Song song, List<Song> songs) {
    // Usa o AudioPlayerController para tocar a música
    final audioPlayer = Provider.of<AudioPlayerController>(context, listen: false);
    
    // Configura a playlist com todas as músicas do gênero antes de tocar
    if (songs.isNotEmpty) {
      audioPlayer.setPlaylist(songs);
      debugPrint('🎵 Playlist configurada com ${songs.length} músicas do gênero $genre');
    }
    
    audioPlayer.playSong(song);
    
    // Navegar para o player
    context.pushNamed('player');
  }

  void _onShuffleTap(BuildContext context, List<Song> songs) {
    // Usa o AudioPlayerController para tocar todas as músicas em ordem aleatória
    final audioPlayer = Provider.of<AudioPlayerController>(context, listen: false);
    if (songs.isNotEmpty) {
      // TODO: Implement shuffle functionality
      debugPrint('Shuffle play: ${songs.length} songs do gênero $genre');
      context.pushNamed('player');
    }
  }

  void _onRepeatTap(BuildContext context, List<Song> songs) {
    // Usa o AudioPlayerController para tocar todas as músicas
    final audioPlayer = Provider.of<AudioPlayerController>(context, listen: false);
    if (songs.isNotEmpty) {
      // TODO: Implement repeat functionality
      debugPrint('Repeat play: ${songs.length} songs do gênero $genre');
      context.pushNamed('player');
    }
  }
}
