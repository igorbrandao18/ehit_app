import 'package:flutter/material.dart';
import '../../data/datasources/recommendations_remote_datasource.dart';
import '../../data/models/album_model.dart';
import '../../data/models/playlist_model.dart';
import '../../domain/services/recommendations_strategy.dart';

/// Modelo para um item de recomendação
class RecommendationItem {
  final String type; // 'album', 'playlist', 'music'
  final int id;
  final Map<String, dynamic> data;
  final dynamic model; // AlbumModel, PlaylistModel, etc.

  RecommendationItem({
    required this.type,
    required this.id,
    required this.data,
    this.model,
  });
}

/// Controller para gerenciar recomendações
class RecommendationsController extends ChangeNotifier {
  final RecommendationsRemoteDataSource _dataSource;
  final RecommendationsStrategy? _strategy;
  
  List<RecommendationItem> _recommendations = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  RecommendationsController(
    this._dataSource, {
    RecommendationsStrategy? strategy,
  }) : _strategy = strategy;

  List<RecommendationItem> get recommendations => _recommendations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Inicializa o controller e carrega recomendações
  Future<void> initialize(BuildContext? context) async {
    if (context != null && _strategy != null) {
      await loadRecommendationsAuto(context);
    } else {
      await loadRecommendations();
    }
  }

  /// Carrega recomendações usando estratégia automática baseada no contexto
  Future<void> loadRecommendationsAuto(BuildContext context) async {
    if (_strategy == null) {
      await loadRecommendations();
      return;
    }
    
    try {
      final params = await _strategy.calculateParams(context);
      await loadRecommendations(
        limit: params.limit,
        includeAlbums: params.includeAlbums,
        includePlaylists: params.includePlaylists,
        includeMusic: params.includeMusic,
        preferredGenres: params.preferredGenres.isNotEmpty ? params.preferredGenres : null,
        prioritizePopular: params.prioritizePopular,
      );
    } catch (e) {
      debugPrint('⚠️ Erro ao calcular parâmetros automáticos: $e');
    await loadRecommendations();
    }
  }

  /// Carrega recomendações com parâmetros específicos
  Future<void> loadRecommendations({
    int limit = 5,
    bool includeAlbums = true,
    bool includePlaylists = true,
    bool includeMusic = false,
    List<String>? preferredGenres,
    bool prioritizePopular = true,
  }) async {
    if (_isDisposed) return;
    
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _dataSource.getRecommendations(
        limit: limit,
        includeAlbums: includeAlbums,
        includePlaylists: includePlaylists,
        includeMusic: includeMusic,
        preferredGenres: preferredGenres,
        prioritizePopular: prioritizePopular,
      );
      
      if (_isDisposed) return;
      
      final recommendationsList = response['recommendations'] as List<dynamic>? ?? [];
      
      _recommendations = recommendationsList.map((item) {
        final type = _parseString(item['type'], 'album');
        final id = _parseInt(item['id'], 0);
        final data = item['data'] as Map<String, dynamic>? ?? {};
        
        dynamic model;
        try {
        if (type == 'album') {
          model = AlbumModel.fromJson(data);
        } else if (type == 'playlist') {
          model = PlaylistModel.fromJson(data);
          }
        } catch (e) {
          debugPrint('⚠️ Erro ao criar modelo para $type: $e');
        }
        
        return RecommendationItem(
          type: type,
          id: id,
          data: data,
          model: model,
        );
      }).toList();
      
      debugPrint('✅ ${_recommendations.length} recomendações carregadas (estratégia: ${response['strategy'] ?? 'featured'})');
      notifyListeners();
    } catch (e) {
      if (!_isDisposed) {
        debugPrint('❌ Erro ao carregar recomendações: $e');
        _setError('Não foi possível carregar recomendações');
      }
    } finally {
      if (!_isDisposed) {
        _setLoading(false);
      }
    }
  }

  /// Recarrega as recomendações
  Future<void> refresh() async {
    await loadRecommendations();
  }

  /// Parse seguro de String
  String _parseString(dynamic value, String defaultValue) {
    if (value is String) return value;
    if (value is int) return value.toString();
    return defaultValue;
  }

  /// Parse seguro de int
  int _parseInt(dynamic value, int defaultValue) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
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

