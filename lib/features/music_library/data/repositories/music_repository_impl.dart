// features/music_library/data/repositories/music_repository_impl.dart

import '../../domain/entities/playlist.dart';
import '../../domain/repositories/playlist_repository.dart';
import '../datasources/music_remote_datasource.dart';
import '../models/playlist_model.dart';
import '../../../../core/utils/result.dart';

/// Implementação do repositório de playlists
class PlaylistRepositoryImpl implements PlaylistRepository {
  final MusicRemoteDataSource _remoteDataSource;

  const PlaylistRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Playlist>>> getPlaylists() async {
    try {
      final playlistModels = await _remoteDataSource.getPlaylists();
      return Success(playlistModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Error<List<Playlist>>(
        message: 'Erro ao buscar playlists: $e',
      );
    }
  }
}
