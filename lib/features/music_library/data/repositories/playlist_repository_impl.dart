import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/repositories/playlist_repository.dart';
import '../datasources/music_remote_datasource.dart';
class PlaylistRepositoryImpl implements PlaylistRepository {
  final MusicRemoteDataSource _remoteDataSource;
  PlaylistRepositoryImpl(this._remoteDataSource);
  @override
  Future<Result<List<Playlist>>> getPlaylists() async {
    try {
      final playlistModels = await _remoteDataSource.getPlaylists();
      final playlists = playlistModels.map((model) => model.toEntity()).toList();
      return Success(playlists);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    } catch (e) {
      return Error(message: 'Erro inesperado ao buscar playlists: $e');
    }
  }
}
