// features/music_library/presentation/controllers/music_library_controller.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/usecases/get_playlists_usecase.dart';
import '../../../../core/utils/result.dart';

class MusicLibraryController extends ChangeNotifier {
  final GetPlaylistsUseCase _getPlaylistsUseCase;

  // State
  List<Playlist> _playlists = [];
  List<Playlist> _featuredPlayHits = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  // Constructor
  MusicLibraryController({
    required GetPlaylistsUseCase getPlaylistsUseCase,
  }) : _getPlaylistsUseCase = getPlaylistsUseCase;

  // Getters
  List<Playlist> get playlists => _playlists;
  List<Playlist> get featuredPlayHits => _featuredPlayHits;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Inicializa o controller carregando dados
  Future<void> initialize() async {
    await loadPlaylists();
    await loadFeaturedPlayHits();
  }

  /// Carrega as playlists
  Future<void> loadPlaylists() async {
    if (_isDisposed) return;
    
    _setLoading(true);
    _clearError();

    try {
      final result = await _getPlaylistsUseCase();
      
      if (_isDisposed) return;
      
      result.when(
        success: (playlists) {
          debugPrint('🎵 PlayHITS carregadas: ${playlists.length}');
          for (int i = 0; i < playlists.length; i++) {
            final playlist = playlists[i];
            debugPrint('🎵 PlayHIT ${i + 1}: ${playlist.name} (ID: ${playlist.id}) - ${playlist.musicsCount} músicas');
          }
          _playlists = playlists;
          notifyListeners();
        },
        error: (message, code) {
          debugPrint('❌ Erro ao carregar PlayHITS: $message');
          _setError(message);
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _setError('Erro ao carregar playlists: $e');
      }
    } finally {
      if (!_isDisposed) {
        _setLoading(false);
      }
    }
  }

  /// Carrega PlayHITS em destaque
  Future<void> loadFeaturedPlayHits() async {
    if (_isDisposed) return;
    
    try {
      // Por enquanto, usar dados mock diretamente
      // Em produção, isso viria de um use case específico
      _featuredPlayHits = [
        Playlist(
          id: 1001,
          name: 'PlayHITS em Alta',
          cover: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
          musicsCount: 15,
          musicsData: [],
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          updatedAt: DateTime.now(),
          isActive: true,
        ),
        Playlist(
          id: 1002,
          name: 'Top Semanal',
          cover: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400',
          musicsCount: 20,
          musicsData: [],
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now(),
          isActive: true,
        ),
        Playlist(
          id: 1003,
          name: 'Trending Now',
          cover: 'https://images.unsplash.com/photo-1571330735066-03aaa9429d89?w=400',
          musicsCount: 18,
          musicsData: [],
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          updatedAt: DateTime.now(),
          isActive: true,
        ),
      ];
      
      debugPrint('🎵 PlayHITS em destaque carregados: ${_featuredPlayHits.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erro ao carregar PlayHITS em destaque: $e');
    }
  }

  /// Recarrega os dados
  Future<void> refresh() async {
    await loadPlaylists();
    await loadFeaturedPlayHits();
  }

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

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}