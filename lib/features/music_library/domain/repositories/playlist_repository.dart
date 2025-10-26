import '../entities/playlist.dart';
import '../../../../core/utils/result.dart';
abstract class PlaylistRepository {
  Future<Result<List<Playlist>>> getPlaylists();
}
