// features/music_library/presentation/controllers/music_library_controller.dart
import 'package:flutter/foundation.dart';

class MusicLibraryController extends ChangeNotifier {
  List<Map<String, String>> _playHits = [];
  List<Map<String, String>> _artists = [];
  bool _isLoading = false;

  // Getters
  List<Map<String, String>> get playHits => _playHits;
  List<Map<String, String>> get artists => _artists;
  bool get isLoading => _isLoading;

  // Initialize with mock data
  void initialize() {
    _loadMockData();
  }

  void _loadMockData() {
    _isLoading = true;
    notifyListeners();

    // Mock PlayHITS data
    _playHits = [
      {
        'title': 'Sertanejo Esquenta',
        'artist': 'Vários artistas',
        'imageUrl': 'https://via.placeholder.com/280x200',
      },
      {
        'title': 'Potên',
        'artist': 'Artista',
        'imageUrl': 'https://via.placeholder.com/200x200',
      },
    ];

    // Mock artists data
    _artists = [
      {
        'name': 'Matheus e Kauan',
        'imageUrl': 'https://via.placeholder.com/120x120',
      },
      {
        'name': 'Murilo Huff',
        'imageUrl': 'https://via.placeholder.com/120x120',
      },
      {
        'name': 'Gusttavo Lima',
        'imageUrl': 'https://via.placeholder.com/120x120',
      },
    ];

    _isLoading = false;
    notifyListeners();
  }

  void refresh() {
    _loadMockData();
  }
}