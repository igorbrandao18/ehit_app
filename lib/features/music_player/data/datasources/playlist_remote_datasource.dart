// features/music_player/data/datasources/playlist_remote_datasource.dart

import 'package:dio/dio.dart';
import '../models/playlist_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/constants/app_config.dart';

/// Interface para fonte de dados remota de playlists
abstract class PlaylistRemoteDataSource {
  Future<List<PlaylistModel>> getUserPlaylists();
  Future<PlaylistModel> getPlaylistById(String playlistId);
  Future<List<PlaylistModel>> getPublicPlaylists();
  Future<List<PlaylistModel>> getPopularPlaylists();
  Future<List<PlaylistModel>> getPlaylistsByGenre(String genre);
  Future<List<PlaylistModel>> searchPlaylists(String query);
  Future<PlaylistModel> createPlaylist(Map<String, dynamic> playlistData);
  Future<PlaylistModel> updatePlaylist(String playlistId, Map<String, dynamic> playlistData);
  Future<void> deletePlaylist(String playlistId);
  Future<PlaylistModel> addSongToPlaylist(String playlistId, String songId);
  Future<PlaylistModel> removeSongFromPlaylist(String playlistId, String songId);
  Future<PlaylistModel> reorderPlaylistSongs(String playlistId, int oldIndex, int newIndex);
  Future<void> followPlaylist(String playlistId);
  Future<void> unfollowPlaylist(String playlistId);
  Future<bool> isFollowingPlaylist(String playlistId);
  Future<List<PlaylistModel>> getFollowedPlaylists();
}

/// Implementação da fonte de dados remota de playlists
class PlaylistRemoteDataSourceImpl implements PlaylistRemoteDataSource {
  final Dio _dio;

  PlaylistRemoteDataSourceImpl(this._dio);

  @override
  Future<List<PlaylistModel>> getUserPlaylists() async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      return _getMockUserPlaylists();
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar playlists do usuário: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao buscar playlists: $e');
    }
  }

  @override
  Future<PlaylistModel> getPlaylistById(String playlistId) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(milliseconds: 500));
      return _getMockPlaylistById(playlistId);
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar playlist: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao buscar playlist: $e');
    }
  }

  @override
  Future<List<PlaylistModel>> getPublicPlaylists() async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
      return _getMockPublicPlaylists();
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar playlists públicas: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao buscar playlists públicas: $e');
    }
  }

  @override
  Future<List<PlaylistModel>> getPopularPlaylists() async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
      return _getMockPopularPlaylists();
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar playlists populares: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao buscar playlists populares: $e');
    }
  }

  @override
  Future<List<PlaylistModel>> getPlaylistsByGenre(String genre) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
      return _getMockPlaylistsByGenre(genre);
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar playlists por gênero: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao buscar playlists por gênero: $e');
    }
  }

  @override
  Future<List<PlaylistModel>> searchPlaylists(String query) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
      return _getMockSearchPlaylists(query);
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar playlists: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao buscar playlists: $e');
    }
  }

  @override
  Future<PlaylistModel> createPlaylist(Map<String, dynamic> playlistData) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
      return _getMockCreatePlaylist(playlistData);
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao criar playlist: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao criar playlist: $e');
    }
  }

  @override
  Future<PlaylistModel> updatePlaylist(String playlistId, Map<String, dynamic> playlistData) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
      return _getMockUpdatePlaylist(playlistId, playlistData);
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao atualizar playlist: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao atualizar playlist: $e');
    }
  }

  @override
  Future<void> deletePlaylist(String playlistId) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao deletar playlist: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao deletar playlist: $e');
    }
  }

  @override
  Future<PlaylistModel> addSongToPlaylist(String playlistId, String songId) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
      return _getMockPlaylistById(playlistId);
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao adicionar música à playlist: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao adicionar música à playlist: $e');
    }
  }

  @override
  Future<PlaylistModel> removeSongFromPlaylist(String playlistId, String songId) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
      return _getMockPlaylistById(playlistId);
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao remover música da playlist: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao remover música da playlist: $e');
    }
  }

  @override
  Future<PlaylistModel> reorderPlaylistSongs(String playlistId, int oldIndex, int newIndex) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
      return _getMockPlaylistById(playlistId);
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao reordenar músicas da playlist: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao reordenar músicas da playlist: $e');
    }
  }

  @override
  Future<void> followPlaylist(String playlistId) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao seguir playlist: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao seguir playlist: $e');
    }
  }

  @override
  Future<void> unfollowPlaylist(String playlistId) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao parar de seguir playlist: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao parar de seguir playlist: $e');
    }
  }

  @override
  Future<bool> isFollowingPlaylist(String playlistId) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(milliseconds: 500));
      return false; // Mock response
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao verificar se está seguindo playlist: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao verificar se está seguindo playlist: $e');
    }
  }

  @override
  Future<List<PlaylistModel>> getFollowedPlaylists() async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
      return _getMockFollowedPlaylists();
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar playlists seguidas: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao buscar playlists seguidas: $e');
    }
  }

  // Mock data methods
  List<PlaylistModel> _getMockUserPlaylists() {
    return [
      PlaylistModel(
        id: 'user_playlist_1',
        name: 'Minhas Favoritas',
        description: 'Músicas que eu mais gosto',
        imageUrl: AppConfig.defaultPlaylistImageUrl,
        ownerId: 'user_123',
        ownerName: 'Usuário',
        isPublic: false,
        isCollaborative: false,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        songs: [],
        totalSongs: 0,
        totalDuration: '0:00',
        followersCount: 0,
        isFollowing: false,
      ),
      PlaylistModel(
        id: 'user_playlist_2',
        name: 'Workout Mix',
        description: 'Para treinar com energia',
        imageUrl: AppConfig.defaultPlaylistImageUrl,
        ownerId: 'user_123',
        ownerName: 'Usuário',
        isPublic: true,
        isCollaborative: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        songs: [],
        totalSongs: 0,
        totalDuration: '0:00',
        followersCount: 5,
        isFollowing: false,
      ),
    ];
  }

  PlaylistModel _getMockPlaylistById(String playlistId) {
    return PlaylistModel(
      id: playlistId,
      name: 'Playlist Mock',
      description: 'Descrição da playlist mock',
      imageUrl: AppConfig.defaultPlaylistImageUrl,
      ownerId: 'user_123',
      ownerName: 'Usuário Mock',
      isPublic: true,
      isCollaborative: false,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
      songs: [],
      totalSongs: 0,
      totalDuration: '0:00',
      followersCount: 10,
      isFollowing: false,
    );
  }

  List<PlaylistModel> _getMockPublicPlaylists() {
    return [
      PlaylistModel(
        id: 'public_playlist_1',
        name: 'Top Hits 2024',
        description: 'Os maiores sucessos do ano',
        imageUrl: AppConfig.defaultPlaylistImageUrl,
        ownerId: 'admin_123',
        ownerName: 'ÊHIT',
        isPublic: true,
        isCollaborative: false,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
        songs: [],
        totalSongs: 0,
        totalDuration: '0:00',
        followersCount: 1000,
        isFollowing: false,
      ),
    ];
  }

  List<PlaylistModel> _getMockPopularPlaylists() {
    return [
      PlaylistModel(
        id: 'popular_playlist_1',
        name: 'PlayHITS da Semana',
        description: 'As músicas mais tocadas esta semana',
        imageUrl: AppConfig.defaultPlaylistImageUrl,
        ownerId: 'admin_123',
        ownerName: 'ÊHIT',
        isPublic: true,
        isCollaborative: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
        songs: [],
        totalSongs: 0,
        totalDuration: '0:00',
        followersCount: 5000,
        isFollowing: false,
      ),
    ];
  }

  List<PlaylistModel> _getMockPlaylistsByGenre(String genre) {
    return [
      PlaylistModel(
        id: 'genre_playlist_1',
        name: 'Best of $genre',
        description: 'Os melhores de $genre',
        imageUrl: AppConfig.defaultPlaylistImageUrl,
        ownerId: 'admin_123',
        ownerName: 'ÊHIT',
        isPublic: true,
        isCollaborative: false,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now(),
        songs: [],
        totalSongs: 0,
        totalDuration: '0:00',
        followersCount: 500,
        isFollowing: false,
      ),
    ];
  }

  List<PlaylistModel> _getMockSearchPlaylists(String query) {
    return [
      PlaylistModel(
        id: 'search_playlist_1',
        name: 'Search Results for "$query"',
        description: 'Resultados da busca por $query',
        imageUrl: AppConfig.defaultPlaylistImageUrl,
        ownerId: 'user_123',
        ownerName: 'Usuário',
        isPublic: true,
        isCollaborative: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now(),
        songs: [],
        totalSongs: 0,
        totalDuration: '0:00',
        followersCount: 50,
        isFollowing: false,
      ),
    ];
  }

  PlaylistModel _getMockCreatePlaylist(Map<String, dynamic> playlistData) {
    return PlaylistModel(
      id: 'new_playlist_${DateTime.now().millisecondsSinceEpoch}',
      name: playlistData['name'] as String,
      description: playlistData['description'] as String,
      imageUrl: AppConfig.defaultPlaylistImageUrl,
      ownerId: 'user_123',
      ownerName: 'Usuário',
      isPublic: playlistData['isPublic'] as bool,
      isCollaborative: playlistData['isCollaborative'] as bool,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      songs: [],
      totalSongs: 0,
      totalDuration: '0:00',
      followersCount: 0,
      isFollowing: false,
    );
  }

  PlaylistModel _getMockUpdatePlaylist(String playlistId, Map<String, dynamic> playlistData) {
    return PlaylistModel(
      id: playlistId,
      name: playlistData['name'] as String? ?? 'Updated Playlist',
      description: playlistData['description'] as String? ?? 'Updated description',
      imageUrl: AppConfig.defaultPlaylistImageUrl,
      ownerId: 'user_123',
      ownerName: 'Usuário',
      isPublic: playlistData['isPublic'] as bool? ?? true,
      isCollaborative: playlistData['isCollaborative'] as bool? ?? false,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
      songs: [],
      totalSongs: 0,
      totalDuration: '0:00',
      followersCount: 10,
      isFollowing: false,
    );
  }

  List<PlaylistModel> _getMockFollowedPlaylists() {
    return [
      PlaylistModel(
        id: 'followed_playlist_1',
        name: 'Seguindo Esta',
        description: 'Playlist que estou seguindo',
        imageUrl: AppConfig.defaultPlaylistImageUrl,
        ownerId: 'user_456',
        ownerName: 'Outro Usuário',
        isPublic: true,
        isCollaborative: false,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
        songs: [],
        totalSongs: 0,
        totalDuration: '0:00',
        followersCount: 100,
        isFollowing: true,
      ),
    ];
  }
}
