// features/music_library/presentation/controllers/artist_detail_controller.dart

import 'package:flutter/foundation.dart';
import '../../domain/entities/artist.dart';
import '../../domain/entities/song.dart';
import '../../domain/usecases/get_artists_usecase.dart';
import '../../domain/usecases/get_songs_usecase.dart';
import '../../../../core/injection/injection_container.dart' as di;
import '../../../../core/utils/result.dart';

/// Controller responsável por gerenciar o estado da página de detalhes do artista
class ArtistDetailController extends ChangeNotifier {
  final GetArtistByIdUseCase _getArtistByIdUseCase;
  final GetSongsByArtistUseCase _getSongsByArtistUseCase;
  
  bool _isLoading = true;
  String? _error;
  Artist? _artist;
  List<Song> _songs = [];

  ArtistDetailController({
    required GetArtistByIdUseCase getArtistByIdUseCase,
    required GetSongsByArtistUseCase getSongsByArtistUseCase,
  }) : _getArtistByIdUseCase = getArtistByIdUseCase,
       _getSongsByArtistUseCase = getSongsByArtistUseCase;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  Artist? get artist => _artist;
  List<Song> get songs => _songs;
  bool get hasData => _artist != null && _songs.isNotEmpty;

  /// Carrega os dados do artista
  Future<void> loadArtistData(String artistId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      debugPrint('ArtistDetailController: Loading artist with ID: $artistId');

      // Busca artista do Supabase
      final artistResult = await _getArtistByIdUseCase(artistId);
      artistResult.when(
        success: (artist) {
          _artist = artist;
          debugPrint('ArtistDetailController: Artist loaded: ${artist.name}');
        },
        error: (message, code) {
          _error = 'Erro ao carregar artista: $message';
          debugPrint('ArtistDetailController: Error loading artist: $message');
        },
      );

      // Busca músicas do artista do Supabase
      if (_artist != null) {
        final songsResult = await _getSongsByArtistUseCase(artistId);
        songsResult.when(
          success: (songs) {
            _songs = songs;
            debugPrint('ArtistDetailController: Songs loaded: ${songs.length} songs');
          },
          error: (message, code) {
            _error = 'Erro ao carregar músicas: $message';
            debugPrint('ArtistDetailController: Error loading songs: $message');
          },
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar dados do artista: $e';
      _isLoading = false;
      notifyListeners();
    }
  }


  /// Reproduz uma música
  void playSong(Song song) {
    // A reprodução será feita pelo AudioPlayerService via Provider
    debugPrint('Reproduzindo: ${song.title} - ${song.artist}');
  }

  /// Reproduz todas as músicas em ordem aleatória
  void shufflePlay() {
    // A reprodução será feita pelo AudioPlayerService via Provider
    debugPrint('Reproduzindo músicas em ordem aleatória');
  }

  /// Reproduz todas as músicas em loop
  void repeatPlay() {
    // A reprodução será feita pelo AudioPlayerService via Provider
    debugPrint('Reproduzindo músicas em loop');
  }

  @override
  void dispose() {
    super.dispose();
  }
}
