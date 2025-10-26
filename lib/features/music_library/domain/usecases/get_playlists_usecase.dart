import '../entities/playlist.dart';
import '../repositories/playlist_repository.dart';
import '../../../../core/utils/result.dart';
class GetPlaylistsUseCase {
  final PlaylistRepository repository;
  GetPlaylistsUseCase(this.repository);
  Future<Result<List<Playlist>>> call() async {
    return await repository.getPlaylists();
  }
}
