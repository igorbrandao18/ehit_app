// features/music_library/domain/repositories/artist_repository.dart

import '../../../../core/utils/result.dart';
import '../entities/artist.dart';

/// Interface do repositório de artistas
abstract class ArtistRepository {
  /// Busca todos os artistas
  Future<Result<List<Artist>>> getArtists();
}
