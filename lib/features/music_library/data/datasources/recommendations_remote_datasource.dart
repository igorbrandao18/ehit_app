import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_config.dart';

abstract class RecommendationsRemoteDataSource {
  Future<Map<String, dynamic>> getRecommendations({
    int limit = 5,
    bool includeAlbums = true,
    bool includePlaylists = true,
    bool includeMusic = false,
    List<String>? preferredGenres,
    bool prioritizePopular = true,
  });
}

class RecommendationsRemoteDataSourceImpl implements RecommendationsRemoteDataSource {
  final Dio _dio;

  RecommendationsRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> getRecommendations({
    int limit = 5,
    bool includeAlbums = true,
    bool includePlaylists = true,
    bool includeMusic = false,
    List<String>? preferredGenres,
    bool prioritizePopular = true,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit.toString(),
        'include_albums': includeAlbums.toString(),
        'include_playlists': includePlaylists.toString(),
        'include_music': includeMusic.toString(),
        'prioritize_popular': prioritizePopular.toString(),
      };
      
      // Adicionar gêneros preferidos se houver
      if (preferredGenres != null && preferredGenres.isNotEmpty) {
        queryParams['genres'] = preferredGenres.join(',');
      }

      final response = await _dio.get(
        AppConfig.getApiEndpoint('recommendations/'),
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        debugPrint('✅ Recomendações carregadas: ${data['count'] ?? 0} itens (estratégia: ${data['strategy'] ?? 'featured'})');
        return data;
      } else {
        throw Exception('Failed to load recommendations: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('❌ Erro ao buscar recomendações: ${e.message}');
      if (e.response != null) {
        debugPrint('   Status: ${e.response?.statusCode}');
        debugPrint('   Data: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      debugPrint('❌ Erro inesperado ao buscar recomendações: $e');
      rethrow;
    }
  }
}

