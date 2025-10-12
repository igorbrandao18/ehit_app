// features/music_library/data/datasources/music_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/errors/failures.dart';
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

/// Implementação do data source remoto
class MusicRemoteDataSourceImpl implements MusicRemoteDataSource {
  final Dio _dio;

  const MusicRemoteDataSourceImpl(this._dio);

  @override
  Future<List<SongModel>> getSongs() async {
    try {
      // TODO: Implementar chamada real para API
      // Por enquanto, retorna dados mock
      return _getMockSongs();
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar músicas: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(
        message: 'Erro desconhecido ao buscar músicas: $e',
      );
    }
  }

  @override
  Future<SongModel> getSongById(String id) async {
    try {
      // TODO: Implementar chamada real para API
      final songs = await getSongs();
      final song = songs.firstWhere((song) => song.id == id);
      return song;
    } on StateError {
      throw ServerFailure(
        message: 'Música não encontrada',
        code: 404,
      );
    } catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar música: $e',
      );
    }
  }

  @override
  Future<List<SongModel>> getSongsByArtist(String artistId) async {
    try {
      // TODO: Implementar chamada real para API
      final songs = await getSongs();
      return songs.where((song) => song.artist == artistId).toList();
    } catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar músicas do artista: $e',
      );
    }
  }

  @override
  Future<List<SongModel>> searchSongs(String query) async {
    try {
      // TODO: Implementar chamada real para API
      final songs = await getSongs();
      return songs.where((song) => 
        song.title.toLowerCase().contains(query.toLowerCase()) ||
        song.artist.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar músicas: $e',
      );
    }
  }

  @override
  Future<List<SongModel>> getPopularSongs() async {
    try {
      // TODO: Implementar chamada real para API
      final songs = await getSongs();
      return songs.take(10).toList(); // Primeiras 10 como populares
    } catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar músicas populares: $e',
      );
    }
  }

  @override
  Future<List<SongModel>> getRecentSongs() async {
    try {
      // TODO: Implementar chamada real para API
      final songs = await getSongs();
      return songs.take(5).toList(); // Primeiras 5 como recentes
    } catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar músicas recentes: $e',
      );
    }
  }

  @override
  Future<List<ArtistModel>> getArtists() async {
    try {
      // TODO: Implementar chamada real para API
      return _getMockArtists();
    } catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar artistas: $e',
      );
    }
  }

  @override
  Future<ArtistModel> getArtistById(String id) async {
    try {
      // TODO: Implementar chamada real para API
      final artists = await getArtists();
      final artist = artists.firstWhere((artist) => artist.id == id);
      return artist;
    } on StateError {
      throw ServerFailure(
        message: 'Artista não encontrado',
        code: 404,
      );
    } catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar artista: $e',
      );
    }
  }

  @override
  Future<List<ArtistModel>> getPopularArtists() async {
    try {
      // TODO: Implementar chamada real para API
      final artists = await getArtists();
      return artists.take(6).toList(); // Primeiros 6 como populares
    } catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar artistas populares: $e',
      );
    }
  }

  @override
  Future<List<ArtistModel>> searchArtists(String query) async {
    try {
      // TODO: Implementar chamada real para API
      final artists = await getArtists();
      return artists.where((artist) => 
        artist.name.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      throw ServerFailure(
        message: 'Erro ao buscar artistas: $e',
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
