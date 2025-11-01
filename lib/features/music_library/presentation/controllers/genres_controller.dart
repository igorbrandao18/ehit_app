import 'package:flutter/foundation.dart';
import '../../domain/entities/genre.dart';
import '../../domain/usecases/get_genres_usecase.dart';
import '../../../../core/utils/result.dart';

class GenresController extends ChangeNotifier {
  final GetGenresUseCase _getGenresUseCase;
  
  List<Genre> _genres = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  GenresController(this._getGenresUseCase);

  List<Genre> get genres => _genres;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    await loadGenres();
  }

  Future<void> loadGenres() async {
    if (_isDisposed) return;
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _getGenresUseCase();
      if (_isDisposed) return;
      
      result.when(
        success: (genres) {
          debugPrint('🎵 Gêneros carregados: ${genres.length}');
          for (int i = 0; i < genres.length; i++) {
            final genre = genres[i];
            debugPrint('🎵 Gênero ${i + 1}: ${genre.name} (ID: ${genre.id})');
          }
          _genres = genres;
          notifyListeners();
        },
        error: (message, code) {
          debugPrint('❌ Erro ao carregar gêneros: $message');
          _setError(message);
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _setError('Erro ao carregar gêneros: $e');
      }
    } finally {
      if (!_isDisposed) {
        _setLoading(false);
      }
    }
  }

  Future<void> refresh() async {
    await loadGenres();
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

