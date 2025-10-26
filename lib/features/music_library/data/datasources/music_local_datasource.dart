import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../models/song_model.dart';
import '../models/artist_model.dart';
abstract class MusicLocalDataSource {
  Future<List<SongModel>> getCachedSongs();
  Future<void> cacheSongs(List<SongModel> songs);
  Future<List<SongModel>> getFavoriteSongs();
  Future<void> addToFavorites(String songId);
  Future<void> removeFromFavorites(String songId);
  Future<bool> isFavorite(String songId);
  Future<List<SongModel>> getRecentSongs();
  Future<void> addToRecentSongs(String songId);
  Future<void> clearCache();
}
class MusicLocalDataSourceImpl implements MusicLocalDataSource {
  final SharedPreferences _prefs;
  const MusicLocalDataSourceImpl(this._prefs);
  @override
  Future<List<SongModel>> getCachedSongs() async {
    try {
      final songsJson = _prefs.getStringList(AppConstants.offlineSongsKey);
      if (songsJson == null) return [];
      return songsJson.map((json) => SongModel.fromJson(
        Map<String, dynamic>.from(json.split(',').asMap().map(
          (i, value) => MapEntry(['id', 'title', 'artist', 'album', 'duration', 'imageUrl', 'audioUrl'][i], value)
        ))
      )).toList();
    } catch (e) {
      throw CacheFailure(
        message: 'Erro ao buscar músicas do cache: $e',
      );
    }
  }
  @override
  Future<void> cacheSongs(List<SongModel> songs) async {
    try {
      final songsJson = songs.map((song) => song.toJson().toString()).toList();
      await _prefs.setStringList(AppConstants.offlineSongsKey, songsJson);
    } catch (e) {
      throw CacheFailure(
        message: 'Erro ao salvar músicas no cache: $e',
      );
    }
  }
  @override
  Future<List<SongModel>> getFavoriteSongs() async {
    try {
      final favoriteIds = _prefs.getStringList('favorite_songs') ?? [];
      final cachedSongs = await getCachedSongs();
      return cachedSongs.where((song) => favoriteIds.contains(song.id)).toList();
    } catch (e) {
      throw CacheFailure(
        message: 'Erro ao buscar músicas favoritas: $e',
      );
    }
  }
  @override
  Future<void> addToFavorites(String songId) async {
    try {
      final favoriteIds = _prefs.getStringList('favorite_songs') ?? [];
      if (!favoriteIds.contains(songId)) {
        favoriteIds.add(songId);
        await _prefs.setStringList('favorite_songs', favoriteIds);
      }
    } catch (e) {
      throw CacheFailure(
        message: 'Erro ao adicionar aos favoritos: $e',
      );
    }
  }
  @override
  Future<void> removeFromFavorites(String songId) async {
    try {
      final favoriteIds = _prefs.getStringList('favorite_songs') ?? [];
      favoriteIds.remove(songId);
      await _prefs.setStringList('favorite_songs', favoriteIds);
    } catch (e) {
      throw CacheFailure(
        message: 'Erro ao remover dos favoritos: $e',
      );
    }
  }
  @override
  Future<bool> isFavorite(String songId) async {
    try {
      final favoriteIds = _prefs.getStringList('favorite_songs') ?? [];
      return favoriteIds.contains(songId);
    } catch (e) {
      throw CacheFailure(
        message: 'Erro ao verificar favorito: $e',
      );
    }
  }
  @override
  Future<List<SongModel>> getRecentSongs() async {
    try {
      final recentIds = _prefs.getStringList('recent_songs') ?? [];
      final cachedSongs = await getCachedSongs();
      return recentIds.map((id) => 
        cachedSongs.firstWhere((song) => song.id == id)
      ).toList();
    } catch (e) {
      throw CacheFailure(
        message: 'Erro ao buscar músicas recentes: $e',
      );
    }
  }
  @override
  Future<void> addToRecentSongs(String songId) async {
    try {
      final recentIds = _prefs.getStringList('recent_songs') ?? [];
      recentIds.remove(songId); 
      recentIds.insert(0, songId); 
      if (recentIds.length > AppConstants.maxRecentSongs) {
        recentIds.removeRange(AppConstants.maxRecentSongs, recentIds.length);
      }
      await _prefs.setStringList('recent_songs', recentIds);
    } catch (e) {
      throw CacheFailure(
        message: 'Erro ao adicionar aos recentes: $e',
      );
    }
  }
  @override
  Future<void> clearCache() async {
    try {
      await _prefs.remove(AppConstants.offlineSongsKey);
      await _prefs.remove('favorite_songs');
      await _prefs.remove('recent_songs');
    } catch (e) {
      throw CacheFailure(
        message: 'Erro ao limpar cache: $e',
      );
    }
  }
}
