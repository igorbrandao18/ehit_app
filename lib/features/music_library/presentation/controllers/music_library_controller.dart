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
}