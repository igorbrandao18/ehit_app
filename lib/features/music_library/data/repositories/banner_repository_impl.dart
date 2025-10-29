import 'package:flutter/foundation.dart';
import '../../domain/entities/banner.dart';
import '../../domain/repositories/banner_repository.dart';
import '../datasources/banner_remote_datasource.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDataSource _remoteDataSource;

  const BannerRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Banner>> getBanners() async {
    try {
      final bannerModels = await _remoteDataSource.getBanners();
      final banners = bannerModels.map((model) => model.toEntity()).toList();
      debugPrint('🎯 Banners convertidos: ${banners.length}');
      return banners;
    } catch (e) {
      debugPrint('❌ Erro ao buscar banners: $e');
      throw Exception('Erro ao buscar banners: $e');
    }
  }
}

