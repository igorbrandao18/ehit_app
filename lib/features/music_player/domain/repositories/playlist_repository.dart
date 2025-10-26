import '../../../../core/utils/result.dart';
import '../entities/playlist.dart';
import '../../../music_library/domain/entities/song.dart';
abstract class PlaylistRepository {
  Future<Result<List<Playlist>>> getUserPlaylists();
  Future<Result<Playlist>> getPlaylistById(String playlistId);
  Future<Result<List<Playlist>>> getPublicPlaylists();
  Future<Result<List<Playlist>>> getPopularPlaylists();
  Future<Result<List<Playlist>>> getPlaylistsByGenre(String genre);
  Future<Result<List<Playlist>>> searchPlaylists(String query);
  Future<Result<Playlist>> createPlaylist({
    required String name,
    required String description,
    required bool isPublic,
    required bool isCollaborative,
  });
  Future<Result<Playlist>> updatePlaylist({
    required String playlistId,
    String? name,
    String? description,
    bool? isPublic,
    bool? isCollaborative,
  });
  Future<Result<void>> deletePlaylist(String playlistId);
  Future<Result<Playlist>> addSongToPlaylist({
    required String playlistId,
    required String songId,
  });
  Future<Result<Playlist>> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  });
  Future<Result<Playlist>> reorderPlaylistSongs({
    required String playlistId,
    required int oldIndex,
    required int newIndex,
  });
  Future<Result<void>> followPlaylist(String playlistId);
  Future<Result<void>> unfollowPlaylist(String playlistId);
  Future<Result<bool>> isFollowingPlaylist(String playlistId);
  Future<Result<List<Playlist>>> getFollowedPlaylists();
}
