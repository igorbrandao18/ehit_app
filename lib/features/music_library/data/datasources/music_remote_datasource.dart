// features/music_library/data/datasources/music_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/supabase/supabase_music_service.dart';
import '../models/song_model.dart';
import '../models/artist_model.dart';

/// Data source remoto para dados de música
abstract class MusicRemoteDataSource {
  Future<List<SongModel>> getSongs();
  Future<SongModel> getSongById(String id);
  Future<List<SongModel>> getSongsByArtist(String artistId);
  Future<List<SongModel>> searchSongs(String query);
  Future<List<SongModel>> getPopularSongs();
  Future<List<SongModel>> getRecentSongs();
  
  Future<List<ArtistModel>> getArtists();
  Future<ArtistModel> getArtistById(String id);
  Future<List<ArtistModel>> getPopularArtists();
  Future<List<ArtistModel>> searchArtists(String query);
}

/// Implementação do data source remoto usando Supabase
class MusicRemoteDataSourceImpl implements MusicRemoteDataSource {
  final Dio _dio;
  final SupabaseMusicService _musicService;

  const MusicRemoteDataSourceImpl(this._dio) : _musicService = SupabaseMusicService();

  @override
  Future<List<SongModel>> getSongs() async {
    try {
      final result = await _musicService.getSongs();
      
      if (result is Error) {
        throw ServerFailure(
          message: result.message,
          code: result.code,
        );
      }

      final songs = (result as Success).data;
      return songs.map((song) => SongModel.fromEntity(song)).toList();
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure(
        message: 'Erro inesperado ao buscar músicas: $e',
      );
    }
  }

  @override
  Future<SongModel> getSongById(String id) async {
    try {
      final result = await _musicService.getSongById(id);
      
      if (result is Error) {
        throw ServerFailure(
          message: result.message,
          code: result.code,
        );
      }

      final song = (result as Success).data;
      return SongModel.fromEntity(song);
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure(
        message: 'Erro inesperado ao buscar música: $e',
      );
    }
  }

  @override
  Future<List<SongModel>> getSongsByArtist(String artistId) async {
    try {
      final result = await _musicService.getSongsByArtist(artistId);
      
      if (result is Error) {
        throw ServerFailure(
          message: result.message,
          code: result.code,
        );
      }

      final songs = (result as Success).data;
      return songs.map((song) => SongModel.fromEntity(song)).toList();
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure(
        message: 'Erro inesperado ao buscar músicas do artista: $e',
      );
    }
  }

  @override
  Future<List<SongModel>> searchSongs(String query) async {
    try {
      final result = await _musicService.searchSongs(query);
      
      if (result is Error) {
        throw ServerFailure(
          message: result.message,
          code: result.code,
        );
      }

      final songs = (result as Success).data;
      return songs.map((song) => SongModel.fromEntity(song)).toList();
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure(
        message: 'Erro inesperado ao buscar músicas: $e',
      );
    }
  }

  @override
  Future<List<SongModel>> getPopularSongs() async {
    try {
      final result = await _musicService.getPopularSongs();
      
      if (result is Error) {
        throw ServerFailure(
          message: result.message,
          code: result.code,
        );
      }

      final songs = (result as Success).data;
      return songs.map((song) => SongModel.fromEntity(song)).toList();
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure(
        message: 'Erro inesperado ao buscar músicas populares: $e',
      );
    }
  }

  @override
  Future<List<SongModel>> getRecentSongs() async {
    try {
      final result = await _musicService.getRecentSongs();
      
      if (result is Error) {
        throw ServerFailure(
          message: result.message,
          code: result.code,
        );
      }

      final songs = (result as Success).data;
      return songs.map((song) => SongModel.fromEntity(song)).toList();
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure(
        message: 'Erro inesperado ao buscar músicas recentes: $e',
      );
    }
  }

  @override
  Future<List<ArtistModel>> getArtists() async {
    try {
      final result = await _musicService.getArtists();
      
      if (result is Error) {
        throw ServerFailure(
          message: result.message,
          code: result.code,
        );
      }

      final artists = (result as Success).data;
      return artists.map((artist) => ArtistModel.fromEntity(artist)).toList();
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure(
        message: 'Erro inesperado ao buscar artistas: $e',
      );
    }
  }

  @override
  Future<ArtistModel> getArtistById(String id) async {
    try {
      final result = await _musicService.getArtistById(id);
      
      if (result is Error) {
        throw ServerFailure(
          message: result.message,
          code: result.code,
        );
      }

      final artist = (result as Success).data;
      return ArtistModel.fromEntity(artist);
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure(
        message: 'Erro inesperado ao buscar artista: $e',
      );
    }
  }

  @override
  Future<List<ArtistModel>> getPopularArtists() async {
    try {
      final result = await _musicService.getPopularArtists();
      
      if (result is Error) {
        throw ServerFailure(
          message: result.message,
          code: result.code,
        );
      }

      final artists = (result as Success).data;
      return artists.map((artist) => ArtistModel.fromEntity(artist)).toList();
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure(
        message: 'Erro inesperado ao buscar artistas populares: $e',
      );
    }
  }

  @override
  Future<List<ArtistModel>> searchArtists(String query) async {
    try {
      final result = await _musicService.searchArtists(query);
      
      if (result is Error) {
        throw ServerFailure(
          message: result.message,
          code: result.code,
        );
      }

      final artists = (result as Success).data;
      return artists.map((artist) => ArtistModel.fromEntity(artist)).toList();
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure(
        message: 'Erro inesperado ao buscar artistas: $e',
      );
    }
  }

  // ============================================================================
  // MOCK DATA (temporary until real API is implemented)
  // ============================================================================
  
  List<SongModel> _getMockSongs() {
    return [
      SongModel(
        id: '1',
        title: 'Leão',
        artist: 'Marília Mendonça',
        album: 'Decretos Reais',
        duration: '3:30',
        imageUrl: AppConfig.sampleAlbumCover1,
        audioUrl: AppConfig.getAudioUrl('1'),
        isExplicit: false,
        releaseDate: DateTime(2023),
        playCount: 1000000,
      ),
      SongModel(
        id: '2',
        title: 'Música 2',
        artist: 'Zé Neto & Cristiano',
        album: 'Álbum 2',
        duration: '4:15',
        imageUrl: AppConfig.sampleAlbumCover2,
        audioUrl: AppConfig.getAudioUrl('2'),
        isExplicit: false,
        releaseDate: DateTime(2023),
        playCount: 800000,
      ),
      // Adicionar mais músicas mock conforme necessário
    ];
  }

  List<ArtistModel> _getMockArtists() {
    return [
      ArtistModel(
        id: '1',
        name: 'Marília Mendonça',
        imageUrl: AppConfig.sampleArtistImage1,
        bio: 'Cantora sertaneja brasileira',
        totalSongs: 150,
        totalDuration: '8:45:30',
        genres: [AppConstants.sertanejoCategory],
        followers: 5000000,
      ),
      ArtistModel(
        id: '2',
        name: 'Zé Neto & Cristiano',
        imageUrl: AppConfig.sampleArtistImage2,
        bio: 'Dupla sertaneja brasileira',
        totalSongs: 120,
        totalDuration: '7:20:15',
        genres: [AppConstants.sertanejoCategory],
        followers: 3000000,
      ),
      // Adicionar mais artistas mock conforme necessário
    ];
  }
}
