import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_config.dart';

abstract class EventsRemoteDataSource {
  Future<Map<String, dynamic>> getEvents({
    int limit = 10,
    bool featured = true,
  });
}

class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  final Dio _dio;

  EventsRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> getEvents({
    int limit = 10,
    bool featured = true,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit.toString(),
        'featured': featured.toString(),
      };

      final response = await _dio.get(
        AppConfig.getApiEndpoint('events/'),
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        debugPrint('✅ Eventos carregados: ${data['count'] ?? 0} itens');
        return data;
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('❌ Erro ao buscar eventos: ${e.message}');
      if (e.response != null) {
        debugPrint('   Status: ${e.response?.statusCode}');
        debugPrint('   Data: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      debugPrint('❌ Erro inesperado ao buscar eventos: $e');
      rethrow;
    }
  }
}

