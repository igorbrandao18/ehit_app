import 'package:flutter/foundation.dart';
import '../../domain/entities/album.dart';
import '../../data/datasources/album_remote_datasource.dart';
import '../../../../core/utils/result.dart';

class FeaturedAlbumsController extends ChangeNotifier {
  final AlbumRemoteDataSource _albumRemoteDataSource;
  
  List<Album> _albums = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  FeaturedAlbumsController(this._albumRemoteDataSource);

  List<Album> get albums => _albums;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    await loadFeaturedAlbums();
  }

  Future<void> loadFeaturedAlbums() async {
    if (_isDisposed) return;
    _setLoading(true);
    _clearError();
    
    try {
      final albumModels = await _albumRemoteDataSource.getFeaturedAlbums();
      if (_isDisposed) return;
      
      _albums = albumModels.map((model) => model.toEntity()).toList();
      debugPrint('💿 Álbuns em destaque carregados: ${_albums.length}');
      notifyListeners();
    } catch (e) {
      if (!_isDisposed) {
        debugPrint('❌ Erro ao carregar álbuns em destaque: $e');
        _setError('Erro ao carregar lançamentos: $e');
      }
    } finally {
      if (!_isDisposed) {
        _setLoading(false);
      }
    }
  }

  Future<void> refresh() async {
    await loadFeaturedAlbums();
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

