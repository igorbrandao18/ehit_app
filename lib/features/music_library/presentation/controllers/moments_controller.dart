import 'package:flutter/foundation.dart';
import '../../data/datasources/moments_remote_datasource.dart';
import '../../data/models/playlist_model.dart';

class MomentsController extends ChangeNotifier {
  final MomentsRemoteDataSource _dataSource;
  
  List<PlaylistModel> _moments = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  MomentsController(this._dataSource);

  List<PlaylistModel> get moments => _moments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    await loadMoments();
  }

  Future<void> loadMoments({int limit = 10}) async {
    if (_isDisposed) return;
    _setLoading(true);
    _clearError();
    
    try {
      final moments = await _dataSource.getMoments(limit: limit);
      
      if (_isDisposed) return;
      
      _moments = moments;
      debugPrint('🎯 Momentos carregados: ${_moments.length}');
      notifyListeners();
    } catch (e) {
      if (!_isDisposed) {
        debugPrint('❌ Erro ao carregar momentos: $e');
        _setError('Erro ao carregar momentos: $e');
      }
    } finally {
      if (!_isDisposed) {
        _setLoading(false);
      }
    }
  }

  Future<void> refresh() async {
    await loadMoments();
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

