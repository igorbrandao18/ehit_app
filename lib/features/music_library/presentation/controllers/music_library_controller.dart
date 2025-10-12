// features/music_library/presentation/controllers/music_library_controller.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/song.dart';
import '../../domain/entities/artist.dart';
import '../../domain/usecases/get_songs_usecase.dart';
import '../../domain/usecases/get_artists_usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/constants/app_constants.dart';

class MusicLibraryController extends ChangeNotifier {
  final GetSongsUseCase _getSongsUseCase;
  final GetPopularSongsUseCase _getPopularSongsUseCase;
  final GetArtistsUseCase _getArtistsUseCase;
  final GetPopularArtistsUseCase _getPopularArtistsUseCase;

  // State
  List<Map<String, String>> _playHits = [];
  List<Artist> _artists = [];
  List<Artist> _categoryArtists = [];
  String _selectedCategory = '';
  bool _isLoading = false;
  String? _errorMessage;

  // Constructor
  MusicLibraryController({
    required GetSongsUseCase getSongsUseCase,
    required GetPopularSongsUseCase getPopularSongsUseCase,
    required GetArtistsUseCase getArtistsUseCase,
    required GetPopularArtistsUseCase getPopularArtistsUseCase,
  }) : _getSongsUseCase = getSongsUseCase,
       _getPopularSongsUseCase = getPopularSongsUseCase,
       _getArtistsUseCase = getArtistsUseCase,
       _getPopularArtistsUseCase = getPopularArtistsUseCase;

  // Getters
  List<Map<String, String>> get playHits => _playHits;
  List<Artist> get artists => _artists;
  List<Artist> get categoryArtists => _categoryArtists;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Inicializa o controller carregando dados
  Future<void> initialize() async {
    await loadData();
  }

  /// Carrega todos os dados necessários
  Future<void> loadData() async {
    _setLoading(true);
    _clearError();

    try {
      await Future.wait([
        _loadPlayHits(),
        _loadArtists(),
      ]);
    } catch (e) {
      _setError('Erro ao carregar dados: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Carrega PlayHITS (categorias musicais)
  Future<void> _loadPlayHits() async {
    final result = await _getPopularSongsUseCase();
    
    result.when(
      success: (songs) {
        _playHits = _convertSongsToPlayHits(songs);
      },
      error: (message, code) {
        _setError('Erro ao carregar PlayHITS: $message');
        // Fallback para dados mock em caso de erro
        _playHits = _getMockPlayHits();
      },
    );
  }

  /// Carrega artistas populares
  Future<void> _loadArtists() async {
    final result = await _getPopularArtistsUseCase();
    
    result.when(
      success: (artists) {
        _artists = artists;
      },
      error: (message, code) {
        _setError('Erro ao carregar artistas: $message');
        // Fallback para dados mock em caso de erro
        _artists = _getMockArtists();
      },
    );
  }

  /// Converte lista de músicas para formato PlayHITS
  List<Map<String, String>> _convertSongsToPlayHits(List<Song> songs) {
    // Agrupa músicas por gênero/artista para criar categorias
    final Map<String, List<Song>> groupedSongs = {};
    
    for (final song in songs) {
      final category = _getCategoryFromSong(song);
      groupedSongs.putIfAbsent(category, () => []).add(song);
    }

    return groupedSongs.entries.map((entry) {
      final category = entry.key;
      final categorySongs = entry.value;
      final artists = categorySongs.map((s) => s.artist).toSet().join(', ');
      
      return {
        'title': category,
        'artist': artists,
        'imageUrl': categorySongs.first.imageUrl,
      };
    }).toList();
  }

  /// Determina categoria baseada na música
  String _getCategoryFromSong(Song song) {
    // Lógica simples baseada no nome do artista
    final artist = song.artist.toLowerCase();
    
    if (artist.contains('marília') || artist.contains('zé neto') || artist.contains('gusttavo')) {
      return AppConstants.sertanejoCategory;
    } else if (artist.contains('mc') || artist.contains('anitta')) {
      return AppConstants.funkCategory;
    } else if (artist.contains('caetano') || artist.contains('gilberto') || artist.contains('chico')) {
      return AppConstants.mpbCategory;
    } else {
      return AppConstants.popCategory;
    }
  }

  /// Recarrega os dados
  Future<void> refresh() async {
    await loadData();
  }

  /// Força recarregamento completo dos dados
  Future<void> forceReload() async {
    _playHits.clear();
    _artists.clear();
    _categoryArtists.clear();
    await loadData();
  }

  /// Carrega artistas para uma categoria específica
  Future<void> loadCategoryArtists(String category) async {
    _setLoading(true);
    _selectedCategory = category;
    _clearError();
    notifyListeners();

    try {
      // Por enquanto, filtra artistas existentes por categoria
      // TODO: Implementar busca específica por categoria quando Use Case estiver disponível
      _categoryArtists = _filterArtistsByCategory(category);
    } catch (e) {
      _setError('Erro ao carregar artistas da categoria: $e');
      _categoryArtists = _getMockArtistsByCategory(category);
    } finally {
      _setLoading(false);
    }
  }

  /// Filtra artistas por categoria
  List<Artist> _filterArtistsByCategory(String category) {
    return _artists.where((artist) {
      return artist.genres.any((genre) => 
        genre.toLowerCase().contains(category.toLowerCase())
      ) || artist.name.toLowerCase().contains(category.toLowerCase());
    }).toList();
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // ============================================================================
  // MOCK DATA (fallback)
  // ============================================================================

  List<Map<String, String>> _getMockPlayHits() {
    return [
      {
        'title': AppConstants.sertanejoCategory,
        'artist': 'Marília Mendonça, Zé Neto, Cristiano',
        'imageUrl': 'https://www.cartacapital.com.br/wp-content/uploads/2021/11/pluralmusica.jpg',
      },
      {
        'title': AppConstants.funkCategory,
        'artist': 'MC Kevin, MC Livinho, Anitta',
        'imageUrl': 'https://cdn-images.dzcdn.net/images/artist/ea589fefdebdefd0624edda903d07672/1900x1900-000000-81-0-0.jpg',
      },
      {
        'title': AppConstants.mpbCategory,
        'artist': 'Caetano Veloso, Gilberto Gil, Chico Buarque',
        'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop',
      },
    ];
  }

  List<Artist> _getMockArtists() {
    return [
      Artist(
        id: '1',
        name: 'Matheus e Kauan',
        imageUrl: 'https://via.placeholder.com/120x120',
        bio: 'Dupla sertaneja',
        totalSongs: 80,
        totalDuration: '4:30:00',
        genres: [AppConstants.sertanejoCategory],
        followers: 1000000,
      ),
      Artist(
        id: '2',
        name: 'Murilo Huff',
        imageUrl: 'https://via.placeholder.com/120x120',
        bio: 'Cantor sertanejo',
        totalSongs: 60,
        totalDuration: '3:45:00',
        genres: [AppConstants.sertanejoCategory],
        followers: 800000,
      ),
      Artist(
        id: '3',
        name: 'Gusttavo Lima',
        imageUrl: 'https://via.placeholder.com/120x120',
        bio: 'Cantor sertanejo',
        totalSongs: 200,
        totalDuration: '12:00:00',
        genres: [AppConstants.sertanejoCategory],
        followers: 2000000,
      ),
    ];
  }

  List<Artist> _getMockArtistsByCategory(String category) {
    return _getMockArtists().where((artist) => 
      artist.genres.any((genre) => 
        genre.toLowerCase().contains(category.toLowerCase())
      )
    ).toList();
  }
}