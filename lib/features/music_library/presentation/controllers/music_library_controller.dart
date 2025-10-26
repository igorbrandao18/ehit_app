// features/music_library/presentation/controllers/music_library_controller.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/usecases/get_playlists_usecase.dart';
import '../../../../core/utils/result.dart';

class MusicLibraryController extends ChangeNotifier {
  final GetPlaylistsUseCase _getPlaylistsUseCase;

  // State
  List<Playlist> _playlists = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  // Constructor
  MusicLibraryController({
    required GetPlaylistsUseCase getPlaylistsUseCase,
  }) : _getPlaylistsUseCase = getPlaylistsUseCase;

  // Getters
  List<Playlist> get playlists => _playlists;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Inicializa o controller carregando dados
  Future<void> initialize() async {
    await loadPlaylists();
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

  /// Recarrega os dados
  Future<void> refresh() async {
    await loadPlaylists();
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