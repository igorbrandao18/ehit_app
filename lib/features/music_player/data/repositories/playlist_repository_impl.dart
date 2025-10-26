import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/repositories/playlist_repository.dart';
import '../datasources/playlist_local_datasource.dart';
import '../datasources/playlist_remote_datasource.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final PlaylistRemoteDataSource remoteDataSource;
  final PlaylistLocalDataSource localDataSource;

  PlaylistRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<List<Playlist>>> getUserPlaylists() async {
    try {
      final remotePlaylists = await remoteDataSource.getPlaylists();
      localDataSource.cacheUserPlaylists(remotePlaylists); 
      return Success(remotePlaylists.map((model) => model.toEntity()).toList());
    } on ServerFailure catch (e) {
      try {
        final localPlaylists = await localDataSource.getCachedUserPlaylists();
        return Success(localPlaylists.map((model) => model.toEntity()).toList());
      } on CacheFailure {
        return Error(message: e.message, code: e.code);
      }
    }
  }

  @override
  Future<Result<Playlist>> getPlaylistById(String playlistId) async {
    return Error(message: 'Not implemented yet');
  }

  @override
  Future<Result<List<Playlist>>> getPublicPlaylists() async {
    try {
      final remotePlaylists = await remoteDataSource.getPlaylists();
      localDataSource.cachePublicPlaylists(remotePlaylists); 
      return Success(remotePlaylists.map((model) => model.toEntity()).toList());
    } on ServerFailure catch (e) {
      try {
        final localPlaylists = await localDataSource.getCachedPublicPlaylists();
        return Success(localPlaylists.map((model) => model.toEntity()).toList());
      } on CacheFailure {
        return Error(message: e.message, code: e.code);
      }
    }
  }

  @override
  Future<Result<List<Playlist>>> getPopularPlaylists() async {
    try {
      final remotePlaylists = await remoteDataSource.getPlaylists();
      localDataSource.cachePopularPlaylists(remotePlaylists); 
      return Success(remotePlaylists.map((model) => model.toEntity()).toList());
    } on ServerFailure catch (e) {
      try {
        final localPlaylists = await localDataSource.getCachedPopularPlaylists();
        return Success(localPlaylists.map((model) => model.toEntity()).toList());
      } on CacheFailure {
        return Error(message: e.message, code: e.code);
      }
    }
  }

  @override
  Future<Result<List<Playlist>>> getPlaylistsByGenre(String genre) async {
    return Error(message: 'Not implemented yet');
  }

  @override
  Future<Result<List<Playlist>>> searchPlaylists(String query) async {
    return Error(message: 'Not implemented yet');
  }

  @override
  Future<Result<Playlist>> createPlaylist({
    required String name,
    required String description,
    required bool isPublic,
    required bool isCollaborative,
  }) async {
    return Error(message: 'Not implemented yet');
  }

  @override
  Future<Result<Playlist>> updatePlaylist({
    required String playlistId,
    String? name,
    String? description,
    bool? isPublic,
    bool? isCollaborative,
  }) async {
    return Error(message: 'Not implemented yet');
  }

  @override
  Future<Result<void>> deletePlaylist(String playlistId) async {
    return Error(message: 'Not implemented yet');
  }

  @override
  Future<Result<Playlist>> addSongToPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    return Error(message: 'Not implemented yet');
  }

  @override
  Future<Result<Playlist>> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    return Error(message: 'Not implemented yet');
  }

  @override
  Future<Result<Playlist>> reorderPlaylistSongs({
    required String playlistId,
    required int oldIndex,
    required int newIndex,
  }) async {
    return Error(message: 'Not implemented yet');
  }

  @override
  Future<Result<void>> followPlaylist(String playlistId) async {
    return Error(message: 'Not implemented yet');
  }

  @override
  Future<Result<void>> unfollowPlaylist(String playlistId) async {
    return Error(message: 'Not implemented yet');
  }

  @override
  Future<Result<bool>> isFollowingPlaylist(String playlistId) async {
    return Error(message: 'Not implemented yet');
  }

  @override
  Future<Result<List<Playlist>>> getFollowedPlaylists() async {
    return Error(message: 'Not implemented yet');
  }
}
