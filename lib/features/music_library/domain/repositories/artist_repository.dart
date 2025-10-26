import '../../../../core/utils/result.dart';
import '../entities/artist.dart';
abstract class ArtistRepository {
  Future<Result<List<Artist>>> getArtists();
}
