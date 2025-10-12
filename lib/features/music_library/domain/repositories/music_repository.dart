// features/music_library/domain/repositories/music_repository.dart

import '../entities/song.dart';
import '../entities/artist.dart';
import '../../../../core/utils/result.dart';

/// Interface do repositório de música
abstract class MusicRepository {
  /// Busca todas as músicas
  Future<Result<List<Song>>> getSongs();
  
  /// Busca música por ID
  Future<Result<Song>> getSongById(String id);
  
  /// Busca músicas por artista
  Future<Result<List<Song>>> getSongsByArtist(String artistId);
  
  /// Busca músicas por álbum
  Future<Result<List<Song>>> getSongsByAlbum(String albumId);
  
  /// Busca músicas por gênero
  Future<Result<List<Song>>> getSongsByGenre(String genre);
  
  /// Busca músicas (search)
  Future<Result<List<Song>>> searchSongs(String query);
  
  /// Busca músicas populares
  Future<Result<List<Song>>> getPopularSongs();
  
  /// Busca músicas recentes
  Future<Result<List<Song>>> getRecentSongs();
  
  /// Adiciona música aos favoritos
  Future<Result<void>> addToFavorites(String songId);
  
  /// Remove música dos favoritos
  Future<Result<void>> removeFromFavorites(String songId);
  
  /// Verifica se música está nos favoritos
  Future<Result<bool>> isFavorite(String songId);
  
  /// Busca músicas favoritas
  Future<Result<List<Song>>> getFavoriteSongs();
}

/// Interface do repositório de artistas
abstract class ArtistRepository {
  /// Busca todos os artistas
  Future<Result<List<Artist>>> getArtists();
  
  /// Busca artista por ID
  Future<Result<Artist>> getArtistById(String id);
  
  /// Busca artistas por gênero
  Future<Result<List<Artist>>> getArtistsByGenre(String genre);
  
  /// Busca artistas populares
  Future<Result<List<Artist>>> getPopularArtists();
  
  /// Busca artistas (search)
  Future<Result<List<Artist>>> searchArtists(String query);
  
  /// Segue um artista
  Future<Result<void>> followArtist(String artistId);
  
  /// Deixa de seguir um artista
  Future<Result<void>> unfollowArtist(String artistId);
  
  /// Verifica se está seguindo um artista
  Future<Result<bool>> isFollowing(String artistId);
  
  /// Busca artistas seguidos
  Future<Result<List<Artist>>> getFollowedArtists();
}

/// Interface do repositório de playlists
abstract class PlaylistRepository {
  /// Busca todas as playlists
  Future<Result<List<Map<String, String>>>> getPlaylists();
  
  /// Busca playlist por ID
  Future<Result<Map<String, String>>> getPlaylistById(String id);
  
  /// Cria nova playlist
  Future<Result<String>> createPlaylist(String name, String description);
  
  /// Adiciona música à playlist
  Future<Result<void>> addSongToPlaylist(String playlistId, String songId);
  
  /// Remove música da playlist
  Future<Result<void>> removeSongFromPlaylist(String playlistId, String songId);
  
  /// Deleta playlist
  Future<Result<void>> deletePlaylist(String playlistId);
  
  /// Busca playlists do usuário
  Future<Result<List<Map<String, String>>>> getUserPlaylists();
  
  /// Busca playlists públicas
  Future<Result<List<Map<String, String>>>> getPublicPlaylists();
}
