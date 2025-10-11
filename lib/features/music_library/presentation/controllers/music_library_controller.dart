// features/music_library/presentation/controllers/music_library_controller.dart
import 'package:flutter/foundation.dart';

class MusicLibraryController extends ChangeNotifier {
  List<Map<String, String>> _playHits = [];
  List<Map<String, String>> _artists = [];
  List<Map<String, String>> _categoryArtists = [];
  String _selectedCategory = '';
  bool _isLoading = false;

  // Getters
  List<Map<String, String>> get playHits => _playHits;
  List<Map<String, String>> get artists => _artists;
  List<Map<String, String>> get categoryArtists => _categoryArtists;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  // Initialize with mock data
  void initialize() {
    _loadMockData();
  }

  void _loadMockData() {
    _isLoading = true;
    notifyListeners();

    // Mock PlayHITS data - Categorias musicais brasileiras
    _playHits = [
      {
        'title': 'Sertanejo Esquenta',
        'artist': 'Marília Mendonça, Zé Neto, Cristiano',
        'imageUrl': 'https://www.cartacapital.com.br/wp-content/uploads/2021/11/pluralmusica.jpg',
      },
      {
        'title': 'Funk Nacional',
        'artist': 'MC Kevin, MC Livinho, Anitta',
        'imageUrl': 'https://cdn-images.dzcdn.net/images/artist/ea589fefdebdefd0624edda903d07672/1900x1900-000000-81-0-0.jpg',
      },
      {
        'title': 'MPB Clássica',
        'artist': 'Caetano Veloso, Gilberto Gil, Chico Buarque',
        'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop',
      },
      {
        'title': 'Pagode Romântico',
        'artist': 'Péricles, Ferrugem, Thiaguinho',
        'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400&h=300&fit=crop',
      },
      {
        'title': 'Rock Brasileiro',
        'artist': 'Legião Urbana, CPM 22, Charlie Brown Jr.',
        'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop',
      },
      {
        'title': 'Forró Pé de Serra',
        'artist': 'Luiz Gonzaga, Dominguinhos, Elba Ramalho',
        'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400&h=300&fit=crop',
      },
      {
        'title': 'Samba de Raiz',
        'artist': 'Cartola, Noel Rosa, Clara Nunes',
        'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop',
      },
      {
        'title': 'Axé Music',
        'artist': 'Ivete Sangalo, Daniela Mercury, Chiclete com Banana',
        'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400&h=300&fit=crop',
      },
      {
        'title': 'Rap Nacional',
        'artist': 'Racionais MCs, Emicida, Criolo',
        'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop',
      },
      {
        'title': 'Bossa Nova',
        'artist': 'João Gilberto, Tom Jobim, Vinicius de Moraes',
        'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400&h=300&fit=crop',
      },
      {
        'title': 'Reggae Brasileiro',
        'artist': 'Natiruts, Planta e Raiz, Cidade Negra',
        'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop',
      },
      {
        'title': 'Pop Nacional',
        'artist': 'Lulu Santos, Rita Lee, Cazuza',
        'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400&h=300&fit=crop',
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
    print('PlayHITS loaded: ${_playHits.length} items');
    notifyListeners();
  }

  void refresh() {
    _loadMockData();
  }

  // Force reload data
  void forceReload() {
    _playHits.clear();
    _artists.clear();
    _loadMockData();
  }

  // Load artists for specific category
  void loadCategoryArtists(String category) {
    _isLoading = true;
    _selectedCategory = category;
    notifyListeners();

    // Mock artists data by category
    _categoryArtists = _getArtistsByCategory(category);

    _isLoading = false;
    notifyListeners();
  }

  List<Map<String, String>> _getArtistsByCategory(String category) {
    switch (category) {
      case 'Sertanejo Esquenta':
        return [
          {'name': 'Marília Mendonça', 'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop'},
          {'name': 'Zé Neto & Cristiano', 'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=300&h=300&fit=crop'},
          {'name': 'Gusttavo Lima', 'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop'},
          {'name': 'Matheus & Kauan', 'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=300&h=300&fit=crop'},
          {'name': 'Murilo Huff', 'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop'},
        ];
      case 'Funk Nacional':
        return [
          {'name': 'MC Kevin', 'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=300&h=300&fit=crop'},
          {'name': 'MC Livinho', 'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop'},
          {'name': 'Anitta', 'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=300&h=300&fit=crop'},
          {'name': 'MC Fioti', 'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop'},
          {'name': 'MC Poze do Rodo', 'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=300&h=300&fit=crop'},
        ];
      case 'MPB Clássica':
        return [
          {'name': 'Caetano Veloso', 'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop'},
          {'name': 'Gilberto Gil', 'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=300&h=300&fit=crop'},
          {'name': 'Chico Buarque', 'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop'},
          {'name': 'Milton Nascimento', 'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=300&h=300&fit=crop'},
          {'name': 'Djavan', 'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop'},
        ];
      case 'Pagode Romântico':
        return [
          {'name': 'Péricles', 'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=300&h=300&fit=crop'},
          {'name': 'Ferrugem', 'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop'},
          {'name': 'Thiaguinho', 'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=300&h=300&fit=crop'},
          {'name': 'Sorriso Maroto', 'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop'},
          {'name': 'Exaltasamba', 'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=300&h=300&fit=crop'},
        ];
      case 'Rock Brasileiro':
        return [
          {'name': 'Legião Urbana', 'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop'},
          {'name': 'CPM 22', 'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=300&h=300&fit=crop'},
          {'name': 'Charlie Brown Jr.', 'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop'},
          {'name': 'Titãs', 'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=300&h=300&fit=crop'},
          {'name': 'Engenheiros do Hawaii', 'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop'},
        ];
      default:
        return [
          {'name': 'Artista 1', 'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop'},
          {'name': 'Artista 2', 'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=300&h=300&fit=crop'},
          {'name': 'Artista 3', 'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop'},
        ];
    }
  }
}