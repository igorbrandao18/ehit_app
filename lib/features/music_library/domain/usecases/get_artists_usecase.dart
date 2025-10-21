// features/music_library/domain/usecases/get_artists_usecase.dart

import '../../../../core/utils/result.dart';
import '../entities/artist.dart';
import '../repositories/artist_repository.dart';

/// Use case para buscar artistas
class GetArtistsUseCase {
  final ArtistRepository _artistRepository;

  GetArtistsUseCase(this._artistRepository);

  /// Executa o use case para buscar artistas
  Future<Result<List<Artist>>> call() async {
    return await _artistRepository.getArtists();
  }
}