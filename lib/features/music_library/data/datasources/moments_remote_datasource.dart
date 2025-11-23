import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_config.dart';
import '../models/playlist_model.dart';

abstract class MomentsRemoteDataSource {
  Future<List<PlaylistModel>> getMoments({int limit = 10});
}

class MomentsRemoteDataSourceImpl implements MomentsRemoteDataSource {
  final Dio _dio;

  MomentsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<PlaylistModel>> getMoments({int limit = 10}) async {
    try {
      final response = await _dio.get(
        AppConfig.getApiEndpoint('moments/'),
        queryParameters: {'limit': limit.toString()},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final momentsList = data['moments'] as List<dynamic>? ?? [];
        
        debugPrint('🎯 API retornou ${momentsList.length} momentos');
        
        return momentsList.map((momentData) {
          try {
            return PlaylistModel.fromJson(momentData as Map<String, dynamic>);
          } catch (e) {
            debugPrint('❌ Erro ao criar modelo de momento: $e');
            rethrow;
          }
        }).toList();
      } else {
        throw Exception('Failed to load moments: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Erro ao buscar momentos: $e');
      throw Exception('Error fetching moments: $e');
    }
  }
}

