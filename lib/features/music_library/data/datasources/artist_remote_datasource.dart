// features/music_library/data/datasources/artist_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/artist_model.dart';

/// Data source remoto para dados de artistas
abstract class ArtistRemoteDataSource {
  Future<List<ArtistModel>> getArtists();
}

/// Implementação do data source remoto para artistas
class ArtistRemoteDataSourceImpl implements ArtistRemoteDataSource {
  final Dio _dio;
  static const String _baseUrl = 'https://prod.ehitapp.com.br/api';

  ArtistRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ArtistModel>> getArtists() async {
    try {
      final response = await _dio.get('$_baseUrl/artists/');
      
      if (response.statusCode == 200) {
        final data = response.data;
        final results = data['results'] as List;
        
        debugPrint('🎤 API retornou ${results.length} artistas');
        
        return results.map((artistData) {
          return ArtistModel.fromJson(artistData);
        }).toList();
      } else {
        throw Exception('Failed to load artists: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching artists: $e');
    }
  }
}
