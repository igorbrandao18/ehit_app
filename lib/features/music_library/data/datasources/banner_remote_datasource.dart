import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/banner_model.dart';

abstract class BannerRemoteDataSource {
  Future<List<BannerModel>> getBanners();
}

class BannerRemoteDataSourceImpl implements BannerRemoteDataSource {
  final Dio _dio;
  static const String _baseUrl = 'https://prod.ehitapp.com.br/api';

  BannerRemoteDataSourceImpl(this._dio);

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      debugPrint('🎯 Buscando banners...');
      final response = await _dio.get('$_baseUrl/banners/');
      
      if (response.statusCode == 200) {
        final data = response.data;
        final results = data['results'] as List;
        debugPrint('🎯 API retornou ${results.length} banners');
        
        return results.map((bannerData) {
          return BannerModel(
            id: bannerData['id'].toString(),
            name: bannerData['name'] ?? '',
            image: bannerData['image'] ?? '',
            link: bannerData['link'] ?? '',
            isActive: bannerData['is_active'] ?? false,
            targetId: bannerData['target_id']?.toString(),
            targetType: bannerData['target_type'],
          );
        }).toList();
      } else {
        throw Exception('Failed to load banners: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Erro ao buscar banners: $e');
      throw Exception('Error fetching banners: $e');
    }
  }
}

