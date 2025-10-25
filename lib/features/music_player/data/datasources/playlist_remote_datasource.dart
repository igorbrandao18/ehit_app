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

/// Implementação da fonte de dados remota de playlists usando mock data
class PlaylistRemoteDataSourceImpl implements PlaylistRemoteDataSource {
  final Dio _dio;

  PlaylistRemoteDataSourceImpl(this._dio);

  @override
  Future<List<PlaylistModel>> getUserPlaylists() async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockUserPlaylists();
  }

  @override
  Future<PlaylistModel> getPlaylistById(String playlistId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockPlaylistById(playlistId);
  }

  @override
  Future<List<PlaylistModel>> getPublicPlaylists() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _getMockPublicPlaylists();
  }

  @override
  Future<List<PlaylistModel>> getPopularPlaylists() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _getMockPopularPlaylists();
  }

  @override
  Future<List<PlaylistModel>> getPlaylistsByGenre(String genre) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _getMockPlaylistsByGenre(genre);
  }

  @override
  Future<List<PlaylistModel>> searchPlaylists(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _getMockSearchPlaylists(query);
  }

  @override
  Future<PlaylistModel> createPlaylist(Map<String, dynamic> playlistData) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _getMockCreatePlaylist(playlistData);
  }

  @override
  Future<PlaylistModel> updatePlaylist(String playlistId, Map<String, dynamic> playlistData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockUpdatePlaylist(playlistId, playlistData);
  }

  @override
  Future<void> deletePlaylist(String playlistId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Mock delete - não faz nada
  }

  @override
  Future<PlaylistModel> addSongToPlaylist(String playlistId, String songId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockPlaylistById(playlistId);
  }

  @override
  Future<PlaylistModel> removeSongFromPlaylist(String playlistId, String songId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockPlaylistById(playlistId);
  }

  @override
  Future<PlaylistModel> reorderPlaylistSongs(String playlistId, int oldIndex, int newIndex) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockPlaylistById(playlistId);
  }

  @override
  Future<void> followPlaylist(String playlistId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Mock follow - não faz nada
  }

  @override
  Future<void> unfollowPlaylist(String playlistId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Mock unfollow - não faz nada
  }

  @override
  Future<bool> isFollowingPlaylist(String playlistId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return false; // Mock - sempre retorna false
  }

  @override
  Future<List<PlaylistModel>> getFollowedPlaylists() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _getMockFollowedPlaylists();
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