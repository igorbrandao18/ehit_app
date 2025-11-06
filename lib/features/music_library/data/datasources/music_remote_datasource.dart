import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/song_model.dart';
import '../models/playlist_model.dart';
import '../../../../core/constants/app_config.dart';

abstract class MusicRemoteDataSource {
  Future<List<PlaylistModel>> getPlaylists();
  Future<List<PlaylistModel>> getFeaturedPlayHits();
}
class MusicRemoteDataSourceImpl implements MusicRemoteDataSource {
  final Dio _dio;
  
  MusicRemoteDataSourceImpl(this._dio);
  
  @override
  Future<List<PlaylistModel>> getPlaylists() async {
    try {
      final response = await _dio.get(AppConfig.getApiEndpoint('playlists/'));
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
      final response = await _dio.get(AppConfig.getApiEndpoint('playlists/'));
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
      debugPrint('🎵 Parsing música: ${musicData['title']}');
      
      String durationFormatted = '0:00';
      final duration = musicData['duration'];
      if (duration != null) {
        if (duration is int) {
          durationFormatted = _formatDuration(duration);
        } else if (duration is String) {
          durationFormatted = duration;
        }
      }
      
      
      String audioUrl = musicData['file'] as String? ?? '';
      
      return SongModel(
        id: musicData['id'].toString(),
        title: musicData['title'],
        artist: musicData['artist_name'],
        album: musicData['album_data']?['name'] ?? musicData['album_name'] ?? 'Unknown Album',
        duration: durationFormatted,
        imageUrl: '', 
        audioUrl: audioUrl,
        isExplicit: false, 
        releaseDate: DateTime.parse(musicData['release_date']),
        playCount: musicData['streams_count'] ?? 0,
        genre: musicData['genre_data']?['name'] ?? 'Unknown',
      );
    }).toList();
  }
  
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }
}
