import '../entities/song.dart';
import '../entities/artist.dart';
import '../../../../core/utils/result.dart';
abstract class MusicRepository {
  Future<Result<List<Song>>> getSongs();
  Future<Result<Song>> getSongById(String id);
  Future<Result<List<Song>>> getSongsByArtist(String artistId);
  Future<Result<List<Song>>> getSongsByAlbum(String albumId);
  Future<Result<List<Song>>> getSongsByGenre(String genre);
  Future<Result<List<Song>>> searchSongs(String query);
  Future<Result<List<Song>>> getPopularSongs();
  Future<Result<List<Song>>> getRecentSongs();
  Future<Result<void>> addToFavorites(String songId);
  Future<Result<void>> removeFromFavorites(String songId);
  Future<Result<bool>> isFavorite(String songId);
  Future<Result<List<Song>>> getFavoriteSongs();
}
abstract class ArtistRepository {
  Future<Result<List<Artist>>> getArtists();
  Future<Result<Artist>> getArtistById(String id);
  Future<Result<List<Artist>>> getArtistsByGenre(String genre);
  Future<Result<List<Artist>>> getPopularArtists();
  Future<Result<List<Artist>>> searchArtists(String query);
  Future<Result<void>> followArtist(String artistId);
  Future<Result<void>> unfollowArtist(String artistId);
  Future<Result<bool>> isFollowing(String artistId);
  Future<Result<List<Artist>>> getFollowedArtists();
}
abstract class PlaylistRepository {
  Future<Result<List<Map<String, String>>>> getPlaylists();
  Future<Result<Map<String, String>>> getPlaylistById(String id);
  Future<Result<String>> createPlaylist(String name, String description);
  Future<Result<void>> addSongToPlaylist(String playlistId, String songId);
  Future<Result<void>> removeSongFromPlaylist(String playlistId, String songId);
  Future<Result<void>> deletePlaylist(String playlistId);
  Future<Result<List<Map<String, String>>>> getUserPlaylists();
  Future<Result<List<Map<String, String>>>> getPublicPlaylists();
}
