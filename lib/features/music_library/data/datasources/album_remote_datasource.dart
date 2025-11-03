import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/album_model.dart';
import '../models/song_model.dart';
import '../../../../core/constants/app_config.dart';

abstract class AlbumRemoteDataSource {
  Future<List<AlbumModel>> getAlbumsByArtist(int artistId);
  Future<List<SongModel>> getSongsByAlbum(int albumId);
}

class AlbumRemoteDataSourceImpl implements AlbumRemoteDataSource {
  final Dio _dio;

  AlbumRemoteDataSourceImpl(this._dio);

  @override
  Future<List<AlbumModel>> getAlbumsByArtist(int artistId) async {
    try {
      final response = await _dio.get(AppConfig.getApiEndpoint('artists/$artistId/albums/'));
      if (response.statusCode == 200) {
        final data = response.data;
        // Suporta múltiplos formatos de resposta: List direta ou Map com chaves comuns
        List<dynamic> results;
        if (data is List) {
          results = data;
        } else if (data is Map<String, dynamic>) {
          // Priorizar 'albums' já que é o formato retornado pela API
          if (data['albums'] is List) {
            results = data['albums'] as List;
          } else if (data['results'] is List) {
            results = data['results'] as List;
          } else if (data['data'] is List) {
            results = data['data'] as List;
          } else {
            results = const [];
          }
        } else {
          results = const [];
        }
        debugPrint('💿 API retornou ${results.length} álbuns para o artista $artistId');
        return results.map((albumData) {
          return AlbumModel.fromJson(albumData);
        }).toList();
      } else {
        throw Exception('Failed to load albums: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching albums: $e');
    }
  }

  @override
  Future<List<SongModel>> getSongsByAlbum(int albumId) async {
    try {
      final response = await _dio.get(AppConfig.getApiEndpoint('artists/albums/$albumId/musics/'));
      if (response.statusCode == 200) {
        final data = response.data;
        // Suporta múltiplos formatos de resposta: List direta ou Map com chaves comuns
        List<dynamic> results;
        if (data is List) {
          results = data;
        } else if (data is Map<String, dynamic>) {
          if (data['results'] is List) {
            results = data['results'] as List;
          } else if (data['musics'] is List) {
            results = data['musics'] as List;
          } else if (data['songs'] is List) {
            results = data['songs'] as List;
          } else if (data['data'] is List) {
            results = data['data'] as List;
          } else {
            results = const [];
          }
        } else {
          results = const [];
        }
        debugPrint('🎵 API retornou ${results.length} músicas para o álbum $albumId');
        return results.map((musicData) {
          // Tratar duration que pode ser null, int ou string
          String durationFormatted = '0:00';
          final duration = musicData['duration'];
          if (duration != null) {
            if (duration is int) {
              durationFormatted = _formatDuration(duration);
            } else if (duration is String) {
              durationFormatted = duration;
            }
          }

          // Helper para concatenar URL completa
          String? coverUrl = musicData['cover'] as String? ?? '';
          if (coverUrl.isNotEmpty && !coverUrl.startsWith('http')) {
            coverUrl = '${AppConfig.resourcesBaseUrl}$coverUrl';
          }
          
          String? fileUrl = musicData['file'] as String? ?? '';
          if (fileUrl.isNotEmpty && !fileUrl.startsWith('http')) {
            fileUrl = '${AppConfig.resourcesBaseUrl}$fileUrl';
          }
          
          return SongModel(
            id: musicData['id'].toString(),
            title: musicData['title'],
            artist: musicData['artist_name'] as String? ?? 'Unknown Artist',
            // API pode retornar 'album_name' ou 'album_data.name' ao invés de 'album_data.title'
            album: musicData['album_name'] as String? ?? 
                   musicData['album_data']?['name'] as String? ?? 
                   musicData['album_data']?['title'] as String? ?? 
                   'Unknown Album',
            duration: durationFormatted,
            imageUrl: coverUrl,
            audioUrl: fileUrl,
            isExplicit: false,
            releaseDate: musicData['release_date'] != null
                ? DateTime.parse(musicData['release_date'] as String)
                : DateTime.now(),
            playCount: musicData['streams_count'] as int? ?? 0,
            genre: musicData['genre_data']?['name'] as String? ?? 'Unknown',
          );
        }).toList();
      } else {
        throw Exception('Failed to load songs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching songs: $e');
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }
}

