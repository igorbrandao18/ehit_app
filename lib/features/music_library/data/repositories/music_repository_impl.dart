// features/music_library/data/repositories/music_repository_impl.dart

import '../../domain/entities/song.dart';
import '../../domain/entities/artist.dart';
import '../../domain/repositories/music_repository.dart';
import '../datasources/music_remote_datasource.dart';
import '../datasources/music_local_datasource.dart';
import '../models/song_model.dart';
import '../models/artist_model.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/errors/failures.dart';

/// Implementação do repositório de música
class MusicRepositoryImpl implements MusicRepository {
  final MusicRemoteDataSource _remoteDataSource;
  final MusicLocalDataSource _localDataSource;

  const MusicRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Result<List<Song>>> getSongs() async {
    try {
      // Try to get from cache first
      final cachedSongs = await _localDataSource.getCachedSongs();
      if (cachedSongs.isNotEmpty) {
        return Success(cachedSongs.map((model) => model.toEntity()).toList());
      }

      // If no cache, get from remote
      final remoteSongs = await _remoteDataSource.getSongs();
      
      // Cache the results
      await _localDataSource.cacheSongs(remoteSongs);
      
      return Success(remoteSongs.map((model) => model.toEntity()).toList());
    } on ServerFailure catch (e) {
      return Error<List<Song>>(
        message: e.message,
        code: e.code,
      );
    } on CacheFailure catch (e) {
      return Error<List<Song>>(
        message: e.message,
        code: e.code,
      );
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro desconhecido ao buscar músicas: $e',
      );
    }
  }

  @override
  Future<Result<Song>> getSongById(String id) async {
    try {
      final songModel = await _remoteDataSource.getSongById(id);
      return Success(songModel.toEntity());
    } on ServerFailure catch (e) {
      return Error<Song>(
        message: e.message,
        code: e.code,
      );
    } catch (e) {
      return Error<Song>(
        message: 'Erro ao buscar música: $e',
      );
    }
  }

  @override
  Future<Result<List<Song>>> getSongsByArtist(String artistId) async {
    try {
      final songs = await _remoteDataSource.getSongsByArtist(artistId);
      return Success(songs.map((model) => model.toEntity()).toList());
    } on ServerFailure catch (e) {
      return Error<List<Song>>(
        message: e.message,
        code: e.code,
      );
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao buscar músicas do artista: $e',
      );
    }
  }

  @override
  Future<Result<List<Song>>> getSongsByAlbum(String albumId) async {
    try {
      // TODO: Implementar busca por álbum
      return const Success([]);
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao buscar músicas do álbum: $e',
      );
    }
  }

  @override
  Future<Result<List<Song>>> getSongsByGenre(String genre) async {
    try {
      // TODO: Implementar busca por gênero
      return const Success([]);
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao buscar músicas por gênero: $e',
      );
    }
  }

  @override
  Future<Result<List<Song>>> searchSongs(String query) async {
    try {
      final songs = await _remoteDataSource.searchSongs(query);
      return Success(songs.map((model) => model.toEntity()).toList());
    } on ServerFailure catch (e) {
      return Error<List<Song>>(
        message: e.message,
        code: e.code,
      );
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao buscar músicas: $e',
      );
    }
  }

  @override
  Future<Result<List<Song>>> getPopularSongs() async {
    try {
      final songs = await _remoteDataSource.getPopularSongs();
      return Success(songs.map((model) => model.toEntity()).toList());
    } on ServerFailure catch (e) {
      return Error<List<Song>>(
        message: e.message,
        code: e.code,
      );
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao buscar músicas populares: $e',
      );
    }
  }

  @override
  Future<Result<List<Song>>> getRecentSongs() async {
    try {
      final songs = await _localDataSource.getRecentSongs();
      return Success(songs.map((model) => model.toEntity()).toList());
    } on CacheFailure catch (e) {
      return Error<List<Song>>(
        message: e.message,
        code: e.code,
      );
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao buscar músicas recentes: $e',
      );
    }
  }

  @override
  Future<Result<void>> addToFavorites(String songId) async {
    try {
      await _localDataSource.addToFavorites(songId);
      return const Success(null);
    } on CacheFailure catch (e) {
      return Error<void>(
        message: e.message,
        code: e.code,
      );
    } catch (e) {
      return Error<void>(
        message: 'Erro ao adicionar aos favoritos: $e',
      );
    }
  }

  @override
  Future<Result<void>> removeFromFavorites(String songId) async {
    try {
      await _localDataSource.removeFromFavorites(songId);
      return const Success(null);
    } on CacheFailure catch (e) {
      return Error<void>(
        message: e.message,
        code: e.code,
      );
    } catch (e) {
      return Error<void>(
        message: 'Erro ao remover dos favoritos: $e',
      );
    }
  }

  @override
  Future<Result<bool>> isFavorite(String songId) async {
    try {
      final isFav = await _localDataSource.isFavorite(songId);
      return Success(isFav);
    } on CacheFailure catch (e) {
      return Error<bool>(
        message: e.message,
        code: e.code,
      );
    } catch (e) {
      return Error<bool>(
        message: 'Erro ao verificar favorito: $e',
      );
    }
  }

  @override
  Future<Result<List<Song>>> getFavoriteSongs() async {
    try {
      final songs = await _localDataSource.getFavoriteSongs();
      return Success(songs.map((model) => model.toEntity()).toList());
    } on CacheFailure catch (e) {
      return Error<List<Song>>(
        message: e.message,
        code: e.code,
      );
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao buscar músicas favoritas: $e',
      );
    }
  }
}

/// Implementação do repositório de artistas
class ArtistRepositoryImpl implements ArtistRepository {
  final MusicRemoteDataSource _remoteDataSource;

  const ArtistRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Artist>>> getArtists() async {
    try {
      final artists = await _remoteDataSource.getArtists();
      return Success(artists.map((model) => model.toEntity()).toList());
    } on ServerFailure catch (e) {
      return Error<List<Artist>>(
        message: e.message,
        code: e.code,
      );
    } catch (e) {
      return Error<List<Artist>>(
        message: 'Erro ao buscar artistas: $e',
      );
    }
  }

  @override
  Future<Result<Artist>> getArtistById(String id) async {
    try {
      final artist = await _remoteDataSource.getArtistById(id);
      return Success(artist.toEntity());
    } on ServerFailure catch (e) {
      return Error<Artist>(
        message: e.message,
        code: e.code,
      );
    } catch (e) {
      return Error<Artist>(
        message: 'Erro ao buscar artista: $e',
      );
    }
  }

  @override
  Future<Result<List<Artist>>> getArtistsByGenre(String genre) async {
    try {
      // TODO: Implementar busca por gênero
      return const Success([]);
    } catch (e) {
      return Error<List<Artist>>(
        message: 'Erro ao buscar artistas por gênero: $e',
      );
    }
  }

  @override
  Future<Result<List<Artist>>> getPopularArtists() async {
    try {
      final artists = await _remoteDataSource.getPopularArtists();
      return Success(artists.map((model) => model.toEntity()).toList());
    } on ServerFailure catch (e) {
      return Error<List<Artist>>(
        message: e.message,
        code: e.code,
      );
    } catch (e) {
      return Error<List<Artist>>(
        message: 'Erro ao buscar artistas populares: $e',
      );
    }
  }

  @override
  Future<Result<List<Artist>>> searchArtists(String query) async {
    try {
      final artists = await _remoteDataSource.searchArtists(query);
      return Success(artists.map((model) => model.toEntity()).toList());
    } on ServerFailure catch (e) {
      return Error<List<Artist>>(
        message: e.message,
        code: e.code,
      );
    } catch (e) {
      return Error<List<Artist>>(
        message: 'Erro ao buscar artistas: $e',
      );
    }
  }

  @override
  Future<Result<void>> followArtist(String artistId) async {
    try {
      // TODO: Implementar seguir artista
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao seguir artista: $e',
      );
    }
  }

  @override
  Future<Result<void>> unfollowArtist(String artistId) async {
    try {
      // TODO: Implementar deixar de seguir artista
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao deixar de seguir artista: $e',
      );
    }
  }

  @override
  Future<Result<bool>> isFollowing(String artistId) async {
    try {
      // TODO: Implementar verificar se está seguindo
      return const Success(false);
    } catch (e) {
      return Error<bool>(
        message: 'Erro ao verificar se está seguindo: $e',
      );
    }
  }

  @override
  Future<Result<List<Artist>>> getFollowedArtists() async {
    try {
      // TODO: Implementar buscar artistas seguidos
      return const Success([]);
    } catch (e) {
      return Error<List<Artist>>(
        message: 'Erro ao buscar artistas seguidos: $e',
      );
    }
  }
}
