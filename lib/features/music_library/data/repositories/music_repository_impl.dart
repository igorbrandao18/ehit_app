import '../../domain/entities/playlist.dart';
import '../../domain/entities/song.dart';
import '../../domain/repositories/playlist_repository.dart' as playlist_repo;
import '../../domain/repositories/music_repository.dart';
import '../datasources/music_remote_datasource.dart';
import '../../../../core/utils/result.dart';
class PlaylistRepositoryImpl implements playlist_repo.PlaylistRepository {
  final MusicRemoteDataSource _remoteDataSource;
  const PlaylistRepositoryImpl(this._remoteDataSource);
  @override
  Future<Result<List<Playlist>>> getPlaylists() async {
    try {
      final playlistModels = await _remoteDataSource.getPlaylists();
      return Success(playlistModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Error<List<Playlist>>(
        message: 'Erro ao buscar playlists: $e',
      );
    }
  }
}
class MusicRepositoryImpl implements MusicRepository {
  final MusicRemoteDataSource _remoteDataSource;
  const MusicRepositoryImpl(this._remoteDataSource);
  @override
  Future<Result<List<Song>>> getSongs() async {
    try {
      final playlistModels = await _remoteDataSource.getPlaylists();
      final allSongs = <Song>[];
      for (final playlistModel in playlistModels) {
        final songs = playlistModel.musicsData.map((songModel) => songModel.toEntity()).toList();
        allSongs.addAll(songs);
      }
      return Success(allSongs);
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao buscar músicas: $e',
      );
    }
  }
  @override
  Future<Result<Song>> getSongById(String id) async {
    try {
      final songsResult = await getSongs();
      return songsResult.when(
        success: (songs) {
          final song = songs.where((s) => s.id == id).firstOrNull;
          if (song != null) {
            return Success(song);
          } else {
            return const Error<Song>(message: 'Música não encontrada');
          }
        },
        error: (message, code) => Error<Song>(message: message),
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
      final songsResult = await getSongs();
      return songsResult.when(
        success: (songs) {
          final artistSongs = songs.where((s) => s.artist.toLowerCase().contains(artistId.toLowerCase())).toList();
          return Success(artistSongs);
        },
        error: (message, code) => Error<List<Song>>(message: message),
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
      final songsResult = await getSongs();
      return songsResult.when(
        success: (songs) {
          final albumSongs = songs.where((s) => s.album.toLowerCase().contains(albumId.toLowerCase())).toList();
          return Success(albumSongs);
        },
        error: (message, code) => Error<List<Song>>(message: message),
      );
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao buscar músicas do álbum: $e',
      );
    }
  }
  @override
  Future<Result<List<Song>>> getSongsByGenre(String genre) async {
    try {
      final songsResult = await getSongs();
      return songsResult.when(
        success: (songs) {
          final genreSongs = songs.where((s) => s.genre.toLowerCase().contains(genre.toLowerCase())).toList();
          return Success(genreSongs);
        },
        error: (message, code) => Error<List<Song>>(message: message),
      );
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao buscar músicas por gênero: $e',
      );
    }
  }
  @override
  Future<Result<List<Song>>> searchSongs(String query) async {
    try {
      final songsResult = await getSongs();
      return songsResult.when(
        success: (songs) {
          final searchResults = songs.where((s) => 
            s.title.toLowerCase().contains(query.toLowerCase()) ||
            s.artist.toLowerCase().contains(query.toLowerCase()) ||
            s.album.toLowerCase().contains(query.toLowerCase())
          ).toList();
          return Success(searchResults);
        },
        error: (message, code) => Error<List<Song>>(message: message),
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
      final songsResult = await getSongs();
      return songsResult.when(
        success: (songs) {
          final sortedSongs = List<Song>.from(songs);
          sortedSongs.sort((a, b) => b.playCount.compareTo(a.playCount));
          return Success(sortedSongs.take(20).toList());
        },
        error: (message, code) => Error<List<Song>>(message: message),
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
      final songsResult = await getSongs();
      return songsResult.when(
        success: (songs) {
          final sortedSongs = List<Song>.from(songs);
          sortedSongs.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
          return Success(sortedSongs.take(20).toList());
        },
        error: (message, code) => Error<List<Song>>(message: message),
      );
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao buscar músicas recentes: $e',
      );
    }
  }
  @override
  Future<Result<void>> addToFavorites(String songId) async {
    return const Error<void>(message: 'Funcionalidade não implementada');
  }
  @override
  Future<Result<void>> removeFromFavorites(String songId) async {
    return const Error<void>(message: 'Funcionalidade não implementada');
  }
  @override
  Future<Result<bool>> isFavorite(String songId) async {
    return const Error<bool>(message: 'Funcionalidade não implementada');
  }
  @override
  Future<Result<List<Song>>> getFavoriteSongs() async {
    return const Error<List<Song>>(message: 'Funcionalidade não implementada');
  }
}
