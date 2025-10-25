// features/music_library/data/datasources/music_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/song_model.dart';
import '../models/playlist_model.dart';

/// Data source remoto para dados de música
abstract class MusicRemoteDataSource {
  Future<List<PlaylistModel>> getPlaylists();
  Future<List<PlaylistModel>> getFeaturedPlayHits();
}

/// Implementação do data source remoto
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
    // Retorna dados mock para PlayHITS em destaque
    debugPrint('🎵 Retornando PlayHITS em destaque (mock)');
    
    return _getMockFeaturedPlayHits();
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
        isExplicit: false, // Não disponível na API
        releaseDate: DateTime.parse(musicData['release_date']),
        playCount: musicData['streams_count'] ?? 0,
        genre: musicData['genre_data']?['name'] ?? 'Unknown',
      );
    }).toList();
  }

  List<PlaylistModel> _getMockFeaturedPlayHits() {
    return [
      PlaylistModel(
        id: 1001,
        name: 'PlayHITS em Alta',
        cover: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
        musicsCount: 15,
        musicsData: [
          SongModel(
            id: '1',
            title: 'Chuva de Arroz',
            artist: 'Natanzinho Lima',
            album: 'Decretos Reais',
            duration: '3:14',
            imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
            audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
            isExplicit: false,
            releaseDate: DateTime(2023),
            playCount: 1500000,
            genre: 'Forró',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        isActive: true,
      ),
      PlaylistModel(
        id: 1002,
        name: 'Top Semanal',
        cover: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400',
        musicsCount: 20,
        musicsData: [
          SongModel(
            id: '2',
            title: 'Evidências',
            artist: 'Chitãozinho & Xororó',
            album: 'Evidências',
            duration: '4:20',
            imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400',
            audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
            isExplicit: false,
            releaseDate: DateTime(1990),
            playCount: 2500000,
            genre: 'Sertanejo',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        isActive: true,
      ),
      PlaylistModel(
        id: 1003,
        name: 'Trending Now',
        cover: 'https://images.unsplash.com/photo-1571330735066-03aaa9429d89?w=400',
        musicsCount: 18,
        musicsData: [
          SongModel(
            id: '3',
            title: 'Boate Azul',
            artist: 'João Neto & Frederico',
            album: 'Boate Azul',
            duration: '3:45',
            imageUrl: 'https://images.unsplash.com/photo-1571330735066-03aaa9429d89?w=400',
            audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
            isExplicit: false,
            releaseDate: DateTime(2018),
            playCount: 1800000,
            genre: 'Sertanejo',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        isActive: true,
      ),
    ];
  }
}
