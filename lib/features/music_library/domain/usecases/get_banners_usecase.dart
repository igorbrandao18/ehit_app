import '../entities/banner.dart';
import '../repositories/banner_repository.dart';

class GetBannersUseCase {
  final BannerRepository _repository;

  GetBannersUseCase(this._repository);

  Future<List<Banner>> call() async {
    return await _repository.getBanners();
  }
}

