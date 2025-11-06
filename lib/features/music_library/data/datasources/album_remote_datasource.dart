import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/album_model.dart';
import '../models/song_model.dart';
import '../../../../core/constants/app_config.dart';

abstract class AlbumRemoteDataSource {
  Future<List<AlbumModel>> getAlbumsByArtist(int artistId);
  Future<List<SongModel>> getSongsByAlbum(int albumId);
  Future<List<AlbumModel>> getFeaturedAlbums();
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
        List<dynamic> results;
        if (data is List) {
          results = data;
        } else if (data is Map<String, dynamic>) {
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
      int? artistId;
      try {
        final albumResponse = await _dio.get(AppConfig.getApiEndpoint('albums/$albumId/'));
        if (albumResponse.statusCode == 200) {
          final albumData = albumResponse.data;
          if (albumData is Map<String, dynamic>) {
            artistId = albumData['artist'] as int?;
          }
        }
      } catch (e) {
        debugPrint('⚠️ Não foi possível buscar dados do álbum: $e');
      }
      
      
      if (artistId == null) {
        try {
          final response = await _dio.get(AppConfig.getApiEndpoint('albums/$albumId/'));
          if (response.statusCode == 200) {
            final data = response.data;
            if (data is Map<String, dynamic> && data['musics'] is List) {
              final musics = data['musics'] as List;
              debugPrint('🎵 API retornou ${musics.length} músicas para o álbum $albumId via endpoint do álbum');
              return _parseMusicsList(musics);
            }
          }
        } catch (e) {
          debugPrint('⚠️ Endpoint do álbum também falhou: $e');
        }
        
        debugPrint('❌ Não foi possível obter artistId para buscar músicas do álbum $albumId');
        return [];
      }
      
      final response = await _dio.get(AppConfig.getApiEndpoint('artists/$artistId/albums/'));
      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> albums;
        if (data is Map<String, dynamic> && data['albums'] is List) {
          albums = data['albums'] as List;
        } else if (data is List) {
          albums = data;
        } else {
          albums = const [];
        }
        
        for (final albumData in albums) {
          if (albumData is Map<String, dynamic> && albumData['id'] == albumId) {
            final musics = albumData['musics'] as List<dynamic>? ?? [];
            debugPrint('🎵 Encontrado álbum $albumId com ${musics.length} músicas na lista de álbuns do artista');
            return _parseMusicsList(musics);
          }
        }
        
        debugPrint('⚠️ Álbum $albumId não encontrado na lista de álbuns do artista $artistId');
        return [];
      } else {
        throw Exception('Failed to load albums: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Erro ao buscar músicas do álbum $albumId: $e');
      throw Exception('Error fetching songs: $e');
    }
  }
  
  List<SongModel> _parseMusicsList(List<dynamic> musicsData) {
    return musicsData.map((musicData) {
      String durationFormatted = '0:00';
      final duration = musicData['duration'];
      if (duration != null) {
        if (duration is int) {
          durationFormatted = _formatDuration(duration);
        } else if (duration is String) {
          durationFormatted = duration;
        }
      }

      String? coverUrl = musicData['album_data']?['cover'] as String? ?? 
                         musicData['cover'] as String? ?? '';
      if (coverUrl.isNotEmpty && !coverUrl.startsWith('http')) {
        coverUrl = '${AppConfig.resourcesBaseUrl}$coverUrl';
      }
      
      String? fileUrl = musicData['file'] as String? ?? '';
      
      return SongModel(
        id: musicData['id'].toString(),
        title: musicData['title'],
        artist: musicData['artist_name'] as String? ?? 'Unknown Artist',
        album: musicData['album_name'] as String? ?? 
               musicData['album_data']?['name'] as String? ?? 
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
  }

  @override
  Future<List<AlbumModel>> getFeaturedAlbums() async {
    try {
      final response = await _dio.get(AppConfig.getApiEndpoint('artists/albums/featured/'));
      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> results;
        if (data is Map<String, dynamic>) {
          if (data['albums'] is List) {
            results = data['albums'] as List;
          } else if (data['results'] is List) {
            results = data['results'] as List;
          } else if (data['data'] is List) {
            results = data['data'] as List;
          } else {
            results = const [];
          }
        } else if (data is List) {
          results = data;
        } else {
          results = const [];
        }
        debugPrint('💿 API retornou ${results.length} álbuns em destaque');
        return results.map((albumData) {
          return AlbumModel.fromJson(albumData);
        }).toList();
      } else {
        throw Exception('Failed to load featured albums: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Erro ao buscar álbuns em destaque: $e');
      throw Exception('Error fetching featured albums: $e');
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }
}

