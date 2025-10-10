// features/music_library/presentation/controllers/music_library_controller.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/song.dart';
import '../../domain/entities/album.dart';

class MusicLibraryController extends ChangeNotifier {
  List<Song> _recentlyPlayed = [];
  List<Album> _featuredAlbums = [];
  List<String> _artists = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Song> get recentlyPlayed => _recentlyPlayed;
  List<Album> get featuredAlbums => _featuredAlbums;
  List<String> get artists => _artists;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with mock data
  void initialize() {
    _loadMockData();
  }

  void _loadMockData() {
    _isLoading = true;
    notifyListeners();

    // Mock recently played songs
    _recentlyPlayed = [
      Song(
        id: '1',
        title: 'Leão',
        artist: 'Marilia Mendonça',
        album: 'Decretos Reais',
        albumArtUrl: 'https://via.placeholder.com/60x60',
        duration: const Duration(minutes: 3, seconds: 45),
        audioUrl: '',
        releaseDate: DateTime.now(),
      ),
      Song(
        id: '2',
        title: 'Me Ame Mais',
        artist: 'Marilia Mendonça',
        album: 'Decretos Reais',
        albumArtUrl: 'https://via.placeholder.com/60x60',
        duration: const Duration(minutes: 4, seconds: 12),
        audioUrl: '',
        releaseDate: DateTime.now(),
      ),
      Song(
        id: '3',
        title: 'Uma Vida A Mais',
        artist: 'Marilia Mendonça',
        album: 'Decretos Reais',
        albumArtUrl: 'https://via.placeholder.com/60x60',
        duration: const Duration(minutes: 3, seconds: 28),
        audioUrl: '',
        releaseDate: DateTime.now(),
      ),
    ];

    // Mock featured albums
    _featuredAlbums = [
      Album(
        id: '1',
        title: 'Sertanejo Esquenta',
        artist: 'Vários artistas',
        albumArtUrl: 'https://via.placeholder.com/200x200',
        releaseDate: DateTime.now(),
        trackCount: 15,
        totalDuration: const Duration(minutes: 57),
      ),
      Album(
        id: '2',
        title: 'Pote',
        artist: 'Artista',
        albumArtUrl: 'https://via.placeholder.com/200x200',
        releaseDate: DateTime.now(),
        trackCount: 12,
        totalDuration: const Duration(minutes: 45),
      ),
    ];

    // Mock artists
    _artists = ['Matheus & Kouen', 'Murilo Huff', 'Gusttavo Lima'];

    _isLoading = false;
    notifyListeners();
  }

  void refresh() {
    _loadMockData();
  }

  void search(String query) {
    // TODO: Implement search functionality
  }
}