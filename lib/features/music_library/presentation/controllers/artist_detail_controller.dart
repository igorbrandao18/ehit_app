import 'package:flutter/foundation.dart';
import '../../domain/entities/artist.dart';
import '../../domain/entities/song.dart';
import '../../domain/usecases/get_artists_usecase.dart';
import '../../domain/usecases/get_songs_usecase.dart';
import '../../../../core/utils/result.dart';
class ArtistDetailController extends ChangeNotifier {
  final GetArtistsUseCase _getArtistsUseCase;
  final GetSongsUseCase _getSongsUseCase;
  bool _isLoading = true;
  String? _error;
  Artist? _artist;
  List<Song> _songs = [];
  ArtistDetailController({
    required GetArtistsUseCase getArtistsUseCase,
    required GetSongsUseCase getSongsUseCase,
  }) : _getArtistsUseCase = getArtistsUseCase,
       _getSongsUseCase = getSongsUseCase;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Artist? get artist => _artist;
  List<Song> get songs => _songs;
  bool get hasData => _artist != null && _songs.isNotEmpty;
  Future<void> loadArtistData(String artistId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      debugPrint('ArtistDetailController: Loading artist with ID: $artistId');
      final artistsResult = await _getArtistsUseCase();
      artistsResult.when(
        success: (artists) {
          _artist = artists.where((a) => a.id.toString() == artistId).firstOrNull;
          if (_artist != null) {
            debugPrint('ArtistDetailController: Artist loaded: ${_artist!.name}');
          } else {
            _error = 'Artista não encontrado';
          }
        },
        error: (message, code) {
          _error = 'Erro ao carregar artista: $message';
          debugPrint('ArtistDetailController: Error loading artist: $message');
        },
      );
      if (_artist != null) {
        final songsResult = await _getSongsUseCase();
        songsResult.when(
          success: (songs) {
            _songs = songs.where((s) => s.artist == _artist!.name).toList();
            debugPrint('ArtistDetailController: Songs loaded: ${_songs.length} songs');
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
  void playSong(Song song) {
    debugPrint('Reproduzindo: ${song.title} - ${song.artist}');
  }
  void shufflePlay() {
    debugPrint('Reproduzindo músicas em ordem aleatória');
  }
  void repeatPlay() {
    debugPrint('Reproduzindo músicas em loop');
  }
  @override
  void dispose() {
    super.dispose();
  }
}
