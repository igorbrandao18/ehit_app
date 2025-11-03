import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/artist_model.dart';
import '../../../../core/constants/app_config.dart';

abstract class ArtistRemoteDataSource {
  Future<List<ArtistModel>> getArtists();
}
class ArtistRemoteDataSourceImpl implements ArtistRemoteDataSource {
  final Dio _dio;
  
  ArtistRemoteDataSourceImpl(this._dio);
  
  @override
  Future<List<ArtistModel>> getArtists() async {
    try {
      final response = await _dio.get(AppConfig.getApiEndpoint('artists/'));
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
