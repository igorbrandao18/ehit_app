import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/genre_model.dart';
import '../../../../core/constants/app_config.dart';

abstract class GenreRemoteDataSource {
  Future<List<GenreModel>> getGenres();
}

class GenreRemoteDataSourceImpl implements GenreRemoteDataSource {
  final Dio _dio;

  GenreRemoteDataSourceImpl(this._dio);

  @override
  Future<List<GenreModel>> getGenres() async {
    try {
      final response = await _dio.get(AppConfig.getApiEndpoint('genres/genres/'));
      if (response.statusCode == 200) {
        final data = response.data;
        
        // A API pode retornar um array direto ou um objeto com 'results'
        List<dynamic> results;
        if (data is List) {
          results = data;
        } else if (data is Map && data.containsKey('results')) {
          results = data['results'] as List;
        } else {
          results = [];
        }
        
        debugPrint('🎵 API retornou ${results.length} gêneros');
        return results.map((genreData) {
          return GenreModel.fromJson(genreData as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('Failed to load genres: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Erro ao buscar gêneros: $e');
      throw Exception('Error fetching genres: $e');
    }
  }
}

