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
    // Como a API não tem endpoint direto para músicas do álbum,
    // precisamos buscar pelos álbuns de um artista e extrair as músicas do álbum desejado.
    // Primeiro, vamos tentar buscar o álbum específico para obter o artistId
    try {
      // Tentar buscar álbum específico para obter artistId
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
      
      // Se não conseguiu o artistId pelo endpoint do álbum, tentar buscar de todos os artistas
      // Mas isso seria muito custoso. Por enquanto, vamos usar uma abordagem diferente:
      // Tentar buscar pelo endpoint que já sabemos que funciona
      
      // Fallback: buscar por artistId se disponível, senão retornar lista vazia
      // Na prática, quando o álbum é clicado, ele já deveria ter o artistId
      if (artistId == null) {
        // Se não temos artistId, tentar endpoint alternativo
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
        
        // Se chegou aqui, não temos como buscar sem o artistId
        debugPrint('❌ Não foi possível obter artistId para buscar músicas do álbum $albumId');
        return [];
      }
      
      // Agora buscar os álbuns do artista (que já vem com as músicas)
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
        
        // Encontrar o álbum específico e extrair suas músicas
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
      // Usar cover do album_data se disponível, senão tentar cover direto
      String? coverUrl = musicData['album_data']?['cover'] as String? ?? 
                         musicData['cover'] as String? ?? '';
      if (coverUrl.isNotEmpty && !coverUrl.startsWith('http')) {
        coverUrl = '${AppConfig.resourcesBaseUrl}$coverUrl';
      }
      
      String? fileUrl = musicData['file'] as String? ?? '';
      // O campo 'file' já vem com URL completa da API conforme mostrado no exemplo
      
      return SongModel(
        id: musicData['id'].toString(),
        title: musicData['title'],
        artist: musicData['artist_name'] as String? ?? 'Unknown Artist',
        // API pode retornar 'album_name' ou 'album_data.name'
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

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }
}

