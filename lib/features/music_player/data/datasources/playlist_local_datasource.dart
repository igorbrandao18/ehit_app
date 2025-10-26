import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/playlist_model.dart';
import '../../../../core/errors/failures.dart';
abstract class PlaylistLocalDataSource {
  Future<List<PlaylistModel>> getLastCachedPlaylists();
  Future<void> cachePlaylists(List<PlaylistModel> playlists);
  Future<PlaylistModel?> getCachedPlaylistById(String playlistId);
  Future<void> cachePlaylist(PlaylistModel playlist);
  Future<void> removeCachedPlaylist(String playlistId);
  Future<List<PlaylistModel>> getCachedUserPlaylists();
  Future<void> cacheUserPlaylists(List<PlaylistModel> playlists);
  Future<List<PlaylistModel>> getCachedPublicPlaylists();
  Future<void> cachePublicPlaylists(List<PlaylistModel> playlists);
  Future<List<PlaylistModel>> getCachedPopularPlaylists();
  Future<void> cachePopularPlaylists(List<PlaylistModel> playlists);
  Future<List<PlaylistModel>> getCachedFollowedPlaylists();
  Future<void> cacheFollowedPlaylists(List<PlaylistModel> playlists);
  Future<void> clearAllCachedPlaylists();
  Future<bool> hasCachedPlaylists();
  Future<DateTime?> getLastCacheTime();
  Future<void> updateLastCacheTime();
}
class PlaylistLocalDataSourceImpl implements PlaylistLocalDataSource {
  final SharedPreferences sharedPreferences;
  PlaylistLocalDataSourceImpl({required this.sharedPreferences});
  static const String _cachedPlaylistsKey = 'cached_playlists';
  static const String _cachedUserPlaylistsKey = 'cached_user_playlists';
  static const String _cachedPublicPlaylistsKey = 'cached_public_playlists';
  static const String _cachedPopularPlaylistsKey = 'cached_popular_playlists';
  static const String _cachedFollowedPlaylistsKey = 'cached_followed_playlists';
  static const String _lastCacheTimeKey = 'playlists_last_cache_time';
  @override
  Future<List<PlaylistModel>> getLastCachedPlaylists() async {
    try {
      final jsonString = sharedPreferences.getString(_cachedPlaylistsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => PlaylistModel.fromJson(json)).toList();
      } else {
        throw CacheFailure(message: 'Nenhuma playlist em cache.');
      }
    } catch (e) {
      throw CacheFailure(message: 'Erro ao recuperar playlists do cache: $e');
    }
  }
  @override
  Future<void> cachePlaylists(List<PlaylistModel> playlists) async {
    try {
      final jsonString = json.encode(playlists.map((playlist) => playlist.toJson()).toList());
      await sharedPreferences.setString(_cachedPlaylistsKey, jsonString);
      await updateLastCacheTime();
    } catch (e) {
      throw CacheFailure(message: 'Erro ao salvar playlists no cache: $e');
    }
  }
  @override
  Future<PlaylistModel?> getCachedPlaylistById(String playlistId) async {
    try {
      final jsonString = sharedPreferences.getString('playlist_$playlistId');
      if (jsonString != null) {
        return PlaylistModel.fromJson(json.decode(jsonString));
      }
      return null;
    } catch (e) {
      throw CacheFailure(message: 'Erro ao recuperar playlist do cache: $e');
    }
  }
  @override
  Future<void> cachePlaylist(PlaylistModel playlist) async {
    try {
      final jsonString = json.encode(playlist.toJson());
      await sharedPreferences.setString('playlist_${playlist.id}', jsonString);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao salvar playlist no cache: $e');
    }
  }
  @override
  Future<void> removeCachedPlaylist(String playlistId) async {
    try {
      await sharedPreferences.remove('playlist_$playlistId');
    } catch (e) {
      throw CacheFailure(message: 'Erro ao remover playlist do cache: $e');
    }
  }
  @override
  Future<List<PlaylistModel>> getCachedUserPlaylists() async {
    try {
      final jsonString = sharedPreferences.getString(_cachedUserPlaylistsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => PlaylistModel.fromJson(json)).toList();
      } else {
        throw CacheFailure(message: 'Nenhuma playlist do usuário em cache.');
      }
    } catch (e) {
      throw CacheFailure(message: 'Erro ao recuperar playlists do usuário do cache: $e');
    }
  }
  @override
  Future<void> cacheUserPlaylists(List<PlaylistModel> playlists) async {
    try {
      final jsonString = json.encode(playlists.map((playlist) => playlist.toJson()).toList());
      await sharedPreferences.setString(_cachedUserPlaylistsKey, jsonString);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao salvar playlists do usuário no cache: $e');
    }
  }
  @override
  Future<List<PlaylistModel>> getCachedPublicPlaylists() async {
    try {
      final jsonString = sharedPreferences.getString(_cachedPublicPlaylistsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => PlaylistModel.fromJson(json)).toList();
      } else {
        throw CacheFailure(message: 'Nenhuma playlist pública em cache.');
      }
    } catch (e) {
      throw CacheFailure(message: 'Erro ao recuperar playlists públicas do cache: $e');
    }
  }
  @override
  Future<void> cachePublicPlaylists(List<PlaylistModel> playlists) async {
    try {
      final jsonString = json.encode(playlists.map((playlist) => playlist.toJson()).toList());
      await sharedPreferences.setString(_cachedPublicPlaylistsKey, jsonString);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao salvar playlists públicas no cache: $e');
    }
  }
  @override
  Future<List<PlaylistModel>> getCachedPopularPlaylists() async {
    try {
      final jsonString = sharedPreferences.getString(_cachedPopularPlaylistsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => PlaylistModel.fromJson(json)).toList();
      } else {
        throw CacheFailure(message: 'Nenhuma playlist popular em cache.');
      }
    } catch (e) {
      throw CacheFailure(message: 'Erro ao recuperar playlists populares do cache: $e');
    }
  }
  @override
  Future<void> cachePopularPlaylists(List<PlaylistModel> playlists) async {
    try {
      final jsonString = json.encode(playlists.map((playlist) => playlist.toJson()).toList());
      await sharedPreferences.setString(_cachedPopularPlaylistsKey, jsonString);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao salvar playlists populares no cache: $e');
    }
  }
  @override
  Future<List<PlaylistModel>> getCachedFollowedPlaylists() async {
    try {
      final jsonString = sharedPreferences.getString(_cachedFollowedPlaylistsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => PlaylistModel.fromJson(json)).toList();
      } else {
        throw CacheFailure(message: 'Nenhuma playlist seguida em cache.');
      }
    } catch (e) {
      throw CacheFailure(message: 'Erro ao recuperar playlists seguidas do cache: $e');
    }
  }
  @override
  Future<void> cacheFollowedPlaylists(List<PlaylistModel> playlists) async {
    try {
      final jsonString = json.encode(playlists.map((playlist) => playlist.toJson()).toList());
      await sharedPreferences.setString(_cachedFollowedPlaylistsKey, jsonString);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao salvar playlists seguidas no cache: $e');
    }
  }
  @override
  Future<void> clearAllCachedPlaylists() async {
    try {
      await sharedPreferences.remove(_cachedPlaylistsKey);
      await sharedPreferences.remove(_cachedUserPlaylistsKey);
      await sharedPreferences.remove(_cachedPublicPlaylistsKey);
      await sharedPreferences.remove(_cachedPopularPlaylistsKey);
      await sharedPreferences.remove(_cachedFollowedPlaylistsKey);
      await sharedPreferences.remove(_lastCacheTimeKey);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao limpar cache de playlists: $e');
    }
  }
  @override
  Future<bool> hasCachedPlaylists() async {
    try {
      return sharedPreferences.containsKey(_cachedPlaylistsKey);
    } catch (e) {
      return false;
    }
  }
  @override
  Future<DateTime?> getLastCacheTime() async {
    try {
      final timestamp = sharedPreferences.getInt(_lastCacheTimeKey);
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  @override
  Future<void> updateLastCacheTime() async {
    try {
      await sharedPreferences.setInt(_lastCacheTimeKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao atualizar timestamp do cache: $e');
    }
  }
}
