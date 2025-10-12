// features/music_player/data/repositories/playlist_repository_impl.dart

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/repositories/playlist_repository.dart';
import '../datasources/playlist_local_datasource.dart';
import '../datasources/playlist_remote_datasource.dart';

/// Implementação do repositório de playlists
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
      final remotePlaylists = await remoteDataSource.getUserPlaylists();
      localDataSource.cacheUserPlaylists(remotePlaylists); // Cache new data
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
    try {
      final remotePlaylist = await remoteDataSource.getPlaylistById(playlistId);
      localDataSource.cachePlaylist(remotePlaylist); // Cache new data
      return Success(remotePlaylist.toEntity());
    } on ServerFailure catch (e) {
      try {
        final localPlaylist = await localDataSource.getCachedPlaylistById(playlistId);
        if (localPlaylist != null) {
          return Success(localPlaylist.toEntity());
        } else {
          return Error(message: e.message, code: e.code);
        }
      } on CacheFailure {
        return Error(message: e.message, code: e.code);
      }
    }
  }

  @override
  Future<Result<List<Playlist>>> getPublicPlaylists() async {
    try {
      final remotePlaylists = await remoteDataSource.getPublicPlaylists();
      localDataSource.cachePublicPlaylists(remotePlaylists); // Cache new data
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
      final remotePlaylists = await remoteDataSource.getPopularPlaylists();
      localDataSource.cachePopularPlaylists(remotePlaylists); // Cache new data
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
    try {
      final remotePlaylists = await remoteDataSource.getPlaylistsByGenre(genre);
      return Success(remotePlaylists.map((model) => model.toEntity()).toList());
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<List<Playlist>>> searchPlaylists(String query) async {
    try {
      final remotePlaylists = await remoteDataSource.searchPlaylists(query);
      return Success(remotePlaylists.map((model) => model.toEntity()).toList());
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<Playlist>> createPlaylist({
    required String name,
    required String description,
    required bool isPublic,
    required bool isCollaborative,
  }) async {
    try {
      final playlistData = {
        'name': name,
        'description': description,
        'isPublic': isPublic,
        'isCollaborative': isCollaborative,
      };
      
      final remotePlaylist = await remoteDataSource.createPlaylist(playlistData);
      localDataSource.cachePlaylist(remotePlaylist); // Cache new playlist
      return Success(remotePlaylist.toEntity());
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<Playlist>> updatePlaylist({
    required String playlistId,
    String? name,
    String? description,
    bool? isPublic,
    bool? isCollaborative,
  }) async {
    try {
      final playlistData = <String, dynamic>{};
      if (name != null) playlistData['name'] = name;
      if (description != null) playlistData['description'] = description;
      if (isPublic != null) playlistData['isPublic'] = isPublic;
      if (isCollaborative != null) playlistData['isCollaborative'] = isCollaborative;
      
      final remotePlaylist = await remoteDataSource.updatePlaylist(playlistId, playlistData);
      localDataSource.cachePlaylist(remotePlaylist); // Cache updated playlist
      return Success(remotePlaylist.toEntity());
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<void>> deletePlaylist(String playlistId) async {
    try {
      await remoteDataSource.deletePlaylist(playlistId);
      localDataSource.removeCachedPlaylist(playlistId); // Remove from cache
      return const Success(null);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<Playlist>> addSongToPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    try {
      final remotePlaylist = await remoteDataSource.addSongToPlaylist(playlistId, songId);
      localDataSource.cachePlaylist(remotePlaylist); // Cache updated playlist
      return Success(remotePlaylist.toEntity());
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<Playlist>> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    try {
      final remotePlaylist = await remoteDataSource.removeSongFromPlaylist(playlistId, songId);
      localDataSource.cachePlaylist(remotePlaylist); // Cache updated playlist
      return Success(remotePlaylist.toEntity());
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<Playlist>> reorderPlaylistSongs({
    required String playlistId,
    required int oldIndex,
    required int newIndex,
  }) async {
    try {
      final remotePlaylist = await remoteDataSource.reorderPlaylistSongs(playlistId, oldIndex, newIndex);
      localDataSource.cachePlaylist(remotePlaylist); // Cache updated playlist
      return Success(remotePlaylist.toEntity());
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<void>> followPlaylist(String playlistId) async {
    try {
      await remoteDataSource.followPlaylist(playlistId);
      return const Success(null);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<void>> unfollowPlaylist(String playlistId) async {
    try {
      await remoteDataSource.unfollowPlaylist(playlistId);
      return const Success(null);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<bool>> isFollowingPlaylist(String playlistId) async {
    try {
      final isFollowing = await remoteDataSource.isFollowingPlaylist(playlistId);
      return Success(isFollowing);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<List<Playlist>>> getFollowedPlaylists() async {
    try {
      final remotePlaylists = await remoteDataSource.getFollowedPlaylists();
      localDataSource.cacheFollowedPlaylists(remotePlaylists); // Cache new data
      return Success(remotePlaylists.map((model) => model.toEntity()).toList());
    } on ServerFailure catch (e) {
      try {
        final localPlaylists = await localDataSource.getCachedFollowedPlaylists();
        return Success(localPlaylists.map((model) => model.toEntity()).toList());
      } on CacheFailure {
        return Error(message: e.message, code: e.code);
      }
    }
  }
}
