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
  Map<String, String> _categoryImages = {}; // Cache das imagens das categorias
  String _selectedCategory = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

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
        _loadCategoryImages(),
      ]);
    } catch (e) {
      _setError('Erro ao carregar dados: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Carrega PlayHITS (gêneros musicais)
  Future<void> _loadPlayHits() async {
    final result = await _getPopularSongsUseCase();
    
    result.when(
      success: (songs) {
        _playHits = _convertSongsToPlayHits(songs);
      },
      error: (message, code) {
        _setError('Erro ao carregar PlayHITS: $message');
        _playHits = [];
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
        _artists = [];
      },
    );
  }

  /// Carrega imagens das categorias do Supabase
  Future<void> _loadCategoryImages() async {
    try {
      // Simula busca das categorias (em um app real, você criaria um use case para isso)
      _categoryImages = {
        'pop': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=400&fit=crop',
        'rock': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400&h=400&fit=crop',
        'hip-hop': 'https://images.unsplash.com/photo-1471478331149-c72f17e33c73?w=400&h=400&fit=crop',
      };
      debugPrint('📸 Imagens das categorias carregadas: ${_categoryImages.keys.join(', ')}');
    } catch (e) {
      debugPrint('❌ Erro ao carregar imagens das categorias: $e');
      _categoryImages = {};
    }
  }

  /// Converte lista de músicas para formato PlayHITS agrupadas por GÊNERO
  List<Map<String, String>> _convertSongsToPlayHits(List<Song> songs) {
    debugPrint('🎵 Processando ${songs.length} músicas para criar PlayHITS por GÊNERO...');
    
    // Agrupa músicas por GÊNERO (não categoria)
    final Map<String, List<Song>> groupedByGenre = {};
    
    for (final song in songs) {
      final genre = _getGenreFromSong(song);
      groupedByGenre.putIfAbsent(genre, () => []).add(song);
    }

    debugPrint('📊 Gêneros encontrados: ${groupedByGenre.keys.join(', ')}');

    return groupedByGenre.entries.map((entry) {
      final genre = entry.key;
      final genreSongs = entry.value;
      final artists = genreSongs.map((s) => s.artist).toSet().join(', ');
      
      debugPrint('🎯 Criando PlayHit para GÊNERO: $genre com ${genreSongs.length} músicas');
      
      return {
        'title': genre,  // Nome do gênero musical
        'artist': artists,  // Artistas desse gênero
        'imageUrl': _getGenreImageUrl(genre, genreSongs),
      };
    }).toList();
  }

  /// Obtém o gênero musical da música (vem diretamente do Supabase)
  String _getGenreFromSong(Song song) {
    debugPrint('🎵 "${song.title}" por ${song.artist} → ${song.genre} (do Supabase)');
    return song.genre;
  }

  /// Obtém URL da imagem para o gênero musical (agora busca das categorias)
  String _getGenreImageUrl(String genre, List<Song> genreSongs) {
    debugPrint('🖼️ Buscando imagem para gênero: $genre');
    
    // Primeiro, tenta buscar a imagem da categoria
    if (_categoryImages.containsKey(genre) && _categoryImages[genre]!.isNotEmpty) {
      debugPrint('✅ Imagem encontrada na categoria: ${_categoryImages[genre]}');
      return _categoryImages[genre]!;
    }
    
    // Fallback: tenta encontrar um artista representativo do gênero
    final genreArtist = _artists.firstWhere(
      (artist) => artist.genres.contains(genre),
      orElse: () => Artist(
        id: '', name: '', imageUrl: '', bio: '', totalSongs: 0,
        totalDuration: '', genres: [], followers: 0,
      ),
    );

    // Se encontrou um artista com imagem, usa a imagem do artista
    if (genreArtist.imageUrl.isNotEmpty) {
      debugPrint('✅ Imagem encontrada no artista: ${genreArtist.name}');
      return genreArtist.imageUrl;
    }

    // Senão, usa a imagem da música mais popular do gênero
    if (genreSongs.isNotEmpty) {
      genreSongs.sort((a, b) => b.playCount.compareTo(a.playCount));
      debugPrint('✅ Imagem encontrada na música: ${genreSongs.first.title}');
      return genreSongs.first.imageUrl;
    }

    // Fallback para uma imagem padrão
    debugPrint('⚠️ Usando imagem padrão para gênero: $genre');
    return 'https://via.placeholder.com/300x300/333333/ffffff?text=${genre.toUpperCase()}';
  }

  /// Recarrega os dados (limpa cache e busca dados novos)
  Future<void> refresh() async {
    await forceReload();
  }

  /// Força recarregamento completo dos dados
  Future<void> forceReload() async {
    debugPrint('🔄 Limpando cache e recarregando dados...');
    _playHits.clear();
    _artists.clear();
    _categoryArtists.clear();
    _categoryImages.clear(); // Limpa cache das imagens das categorias
    notifyListeners(); // Notifica que os dados foram limpos
    await loadData();
  }

  /// Limpa apenas o cache (sem recarregar)
  void clearCache() {
    debugPrint('🗑️ Limpando cache...');
    _playHits.clear();
    _artists.clear();
    _categoryArtists.clear();
    _categoryImages.clear(); // Limpa cache das imagens das categorias
    notifyListeners();
  }

  /// Carrega artistas para um gênero específico
  Future<void> loadCategoryArtists(String genre) async {
    _setLoading(true);
    _selectedCategory = genre;
    _clearError();
    notifyListeners();

    try {
      // Filtra artistas existentes por gênero
      _categoryArtists = _filterArtistsByGenre(genre);
    } catch (e) {
      _setError('Erro ao carregar artistas do gênero: $e');
      _categoryArtists = [];
    } finally {
      _setLoading(false);
    }
  }

  /// Filtra artistas por gênero
  List<Artist> _filterArtistsByGenre(String genre) {
    return _artists.where((artist) {
      return artist.genres.contains(genre);
    }).toList();
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  void _setLoading(bool loading) {
    if (_isDisposed) return;
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    if (_isDisposed) return;
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    if (_isDisposed) return;
    _errorMessage = null;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}