import '../../../../core/utils/result.dart';
import '../entities/artist.dart';
import '../repositories/artist_repository.dart';
class GetArtistsUseCase {
  final ArtistRepository _artistRepository;
  GetArtistsUseCase(this._artistRepository);
  Future<Result<List<Artist>>> call() async {
    return await _artistRepository.getArtists();
  }
}
