import 'package:flutter/foundation.dart';
import '../../domain/entities/artist.dart';
import '../../domain/usecases/get_artists_usecase.dart';
import '../../../../core/utils/result.dart';
class ArtistsController extends ChangeNotifier {
  final GetArtistsUseCase _getArtistsUseCase;
  List<Artist> _artists = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;
  ArtistsController(this._getArtistsUseCase);
  List<Artist> get artists => _artists;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Future<void> initialize() async {
    await loadArtists();
  }
  Future<void> loadArtists() async {
    if (_isDisposed) return;
    _setLoading(true);
    _clearError();
    try {
      final result = await _getArtistsUseCase();
      if (_isDisposed) return;
      result.when(
        success: (artists) {
          debugPrint('🎤 Artistas carregados: ${artists.length}');
          for (int i = 0; i < artists.length; i++) {
            final artist = artists[i];
            debugPrint('🎤 Artista ${i + 1}: ${artist.name} (ID: ${artist.id}) - ${artist.genre}');
          }
          _artists = artists;
          notifyListeners();
        },
        error: (message, code) {
          debugPrint('❌ Erro ao carregar artistas: $message');
          _setError(message);
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _setError('Erro ao carregar artistas: $e');
      }
    } finally {
      if (!_isDisposed) {
        _setLoading(false);
      }
    }
  }
  Future<void> refresh() async {
    await loadArtists();
  }
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
