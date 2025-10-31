import 'package:flutter/foundation.dart';
import '../../domain/entities/album.dart';
import '../../domain/entities/song.dart';
import '../../domain/usecases/get_songs_by_album_usecase.dart';
import '../../../../core/utils/result.dart';

class AlbumDetailController extends ChangeNotifier {
  final GetSongsByAlbumUseCase _getSongsByAlbumUseCase;
  
  bool _isLoading = true;
  String? _error;
  Album? _album;
  List<Song> _songs = [];

  AlbumDetailController({
    required GetSongsByAlbumUseCase getSongsByAlbumUseCase,
  }) : _getSongsByAlbumUseCase = getSongsByAlbumUseCase;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Album? get album => _album;
  List<Song> get songs => _songs;
  bool get hasData => _album != null && _songs.isNotEmpty;

  Future<void> loadAlbumData(int albumId, Album? album) async {
    try {
      _isLoading = true;
      _error = null;
      _album = album;
      notifyListeners();

      debugPrint('AlbumDetailController: Loading album with ID: $albumId');
      
      final songsResult = await _getSongsByAlbumUseCase(albumId);
      songsResult.when(
        success: (songs) {
          _songs = songs;
          debugPrint('AlbumDetailController: Songs loaded: ${_songs.length} songs');
        },
        error: (message, code) {
          _error = 'Erro ao carregar músicas: $message';
          debugPrint('AlbumDetailController: Error loading songs: $message');
        },
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar dados do álbum: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

