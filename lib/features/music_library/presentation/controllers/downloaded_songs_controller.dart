import 'package:flutter/foundation.dart';
import '../../domain/entities/song.dart';
import '../../../../core/storage/downloaded_songs_storage.dart';

class DownloadedSongsController extends ChangeNotifier {
  final DownloadedSongsStorage _downloadedStorage;

  DownloadedSongsController({
    required DownloadedSongsStorage downloadedStorage,
  }) : _downloadedStorage = downloadedStorage;

  List<Song> _downloadedSongs = [];
  bool _isLoading = false;
  String? _error;

  List<Song> get downloadedSongs => _downloadedSongs;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasSongs => _downloadedSongs.isNotEmpty;
  int get songsCount => _downloadedSongs.length;

  Future<void> loadDownloadedSongs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Carregar diretamente do Hive (banco offline)
      final songs = await _downloadedStorage.getDownloadedSongs();
      
      debugPrint('🎵 DownloadedSongsController: ${songs.length} músicas carregadas do Hive');
      _downloadedSongs = songs;
    } catch (e) {
      _error = 'Erro ao carregar músicas baixadas: $e';
      debugPrint('❌ $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeSong(Song song) async {
    try {
      await _downloadedStorage.removeDownloadedSong(song.id);
      _downloadedSongs.removeWhere((s) => s.id == song.id);
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao remover música: $e';
      notifyListeners();
    }
  }

  void refresh() {
    loadDownloadedSongs();
  }
}

