import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/song_model.dart';
import '../models/playlist_model.dart';
abstract class MusicRemoteDataSource {
  Future<List<PlaylistModel>> getPlaylists();
  Future<List<PlaylistModel>> getFeaturedPlayHits();
}
class MusicRemoteDataSourceImpl implements MusicRemoteDataSource {
  final Dio _dio;
  static const String _baseUrl = 'https://prod.ehitapp.com.br/api';
  MusicRemoteDataSourceImpl(this._dio);
  @override
  Future<List<PlaylistModel>> getPlaylists() async {
    try {
      final response = await _dio.get('$_baseUrl/playlists/');
      if (response.statusCode == 200) {
        final data = response.data;
        final results = data['results'] as List;
        debugPrint('🎵 API retornou ${results.length} PlayHITS');
        return results.map((playlistData) {
          return PlaylistModel(
            id: playlistData['id'],
            name: playlistData['name'],
            cover: playlistData['cover'],
            musicsCount: playlistData['musics_count'],
            musicsData: _parseMusicsData(playlistData['musics_data']),
            createdAt: playlistData['created_at'],
            updatedAt: playlistData['updated_at'],
            isActive: playlistData['is_active'],
          );
        }).toList();
      } else {
        throw Exception('Failed to load playlists: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching playlists: $e');
    }
  }
  @override
  Future<List<PlaylistModel>> getFeaturedPlayHits() async {
    try {
      final response = await _dio.get('$_baseUrl/playlists/');
      if (response.statusCode == 200) {
        final data = response.data;
        final results = data['results'] as List;
        debugPrint('🎵 API retornou ${results.length} PlayHITS em destaque');
        return results.map((playlistData) {
          return PlaylistModel(
            id: playlistData['id'],
            name: playlistData['name'],
            cover: playlistData['cover'],
            musicsCount: playlistData['musics_count'],
            musicsData: _parseMusicsData(playlistData['musics_data']),
            createdAt: playlistData['created_at'],
            updatedAt: playlistData['updated_at'],
            isActive: playlistData['is_active'],
          );
        }).toList();
      } else {
        throw Exception('Failed to load featured playlists: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching featured playlists: $e');
    }
  }
  List<SongModel> _parseMusicsData(List<dynamic> musicsData) {
    return musicsData.map((musicData) {
      final coverUrl = musicData['cover'];
      debugPrint('🎵 Parsing música: ${musicData['title']}');
      debugPrint('🎵 Cover URL: $coverUrl');
      return SongModel(
        id: musicData['id'].toString(),
        title: musicData['title'],
        artist: musicData['artist_name'],
        album: musicData['album_data']?['title'] ?? 'Unknown Album',
        duration: musicData['duration_formatted'],
        imageUrl: coverUrl,
        audioUrl: musicData['file'],
        isExplicit: false, 
        releaseDate: DateTime.parse(musicData['release_date']),
        playCount: musicData['streams_count'] ?? 0,
        genre: musicData['genre_data']?['name'] ?? 'Unknown',
      );
    }).toList();
  }
}
