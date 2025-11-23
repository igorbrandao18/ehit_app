import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/datasources/recommendations_remote_datasource.dart';
import '../../data/models/album_model.dart';
import '../../data/models/playlist_model.dart';
import '../../domain/services/recommendations_strategy.dart';
import '../../data/datasources/music_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> initialize(BuildContext? context) async {
    if (context != null && _strategy != null) {
      // Usar estratégia automática
      await loadRecommendationsAuto(context);
    } else {
      // Usar valores padrão
      await loadRecommendations();
    }
  }

  /// Carrega recomendações usando estratégia automática
  Future<void> loadRecommendationsAuto(BuildContext context) async {
    if (_strategy == null) {
      await loadRecommendations();
      return;
    }
    
    try {
      final params = await _strategy!.calculateParams(context);
      await loadRecommendations(
        limit: params.limit,
        includeAlbums: params.includeAlbums,
        includePlaylists: params.includePlaylists,
        includeMusic: params.includeMusic,
        preferredGenres: params.preferredGenres,
        prioritizePopular: params.prioritizePopular,
      );
    } catch (e) {
      debugPrint('⚠️ Erro ao calcular parâmetros automáticos: $e');
      // Fallback para valores padrão
      await loadRecommendations();
    }
  }

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
        // Converter type de forma segura (pode vir como int ou String)
        final typeValue = item['type'];
        final type = typeValue is String 
            ? typeValue 
            : (typeValue is int ? typeValue.toString() : 'album');
        
        // Converter id de forma segura (pode vir como String ou int)
        final idValue = item['id'];
        final id = idValue is int 
            ? idValue 
            : (idValue is String ? int.tryParse(idValue) ?? 0 : 0);
        
        final data = item['data'] as Map<String, dynamic>? ?? {};
        
        dynamic model;
        try {
          if (type == 'album') {
            model = AlbumModel.fromJson(data);
          } else if (type == 'playlist') {
            model = PlaylistModel.fromJson(data);
          }
        } catch (e) {
          debugPrint('❌ Erro ao criar modelo para $type: $e');
        }
        
        return RecommendationItem(
          type: type,
          id: id,
          data: data,
          model: model,
        );
      }).toList();
      
      debugPrint('🎯 Recomendações carregadas: ${_recommendations.length}');
      notifyListeners();
    } catch (e) {
      if (!_isDisposed) {
        debugPrint('❌ Erro ao carregar recomendações: $e');
        _setError('Erro ao carregar recomendações: $e');
      }
    } finally {
      if (!_isDisposed) {
        _setLoading(false);
      }
    }
  }

  Future<void> refresh() async {
    await loadRecommendations();
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

