// features/music_player/domain/repositories/playlist_repository.dart

import '../../../../core/utils/result.dart';
import '../entities/playlist.dart';
import '../../../music_library/domain/entities/song.dart';

/// Interface para operações relacionadas a playlists
abstract class PlaylistRepository {
  /// Obtém todas as playlists do usuário
  Future<Result<List<Playlist>>> getUserPlaylists();
  
  /// Obtém uma playlist por ID
  Future<Result<Playlist>> getPlaylistById(String playlistId);
  
  /// Obtém playlists públicas
  Future<Result<List<Playlist>>> getPublicPlaylists();
  
  /// Obtém playlists populares
  Future<Result<List<Playlist>>> getPopularPlaylists();
  
  /// Obtém playlists por gênero
  Future<Result<List<Playlist>>> getPlaylistsByGenre(String genre);
  
  /// Busca playlists por nome
  Future<Result<List<Playlist>>> searchPlaylists(String query);
  
  /// Cria uma nova playlist
  Future<Result<Playlist>> createPlaylist({
    required String name,
    required String description,
    required bool isPublic,
    required bool isCollaborative,
  });
  
  /// Atualiza uma playlist
  Future<Result<Playlist>> updatePlaylist({
    required String playlistId,
    String? name,
    String? description,
    bool? isPublic,
    bool? isCollaborative,
  });
  
  /// Remove uma playlist
  Future<Result<void>> deletePlaylist(String playlistId);
  
  /// Adiciona música à playlist
  Future<Result<Playlist>> addSongToPlaylist({
    required String playlistId,
    required String songId,
  });
  
  /// Remove música da playlist
  Future<Result<Playlist>> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  });
  
  /// Reordena músicas na playlist
  Future<Result<Playlist>> reorderPlaylistSongs({
    required String playlistId,
    required int oldIndex,
    required int newIndex,
  });
  
  /// Segue uma playlist
  Future<Result<void>> followPlaylist(String playlistId);
  
  /// Para de seguir uma playlist
  Future<Result<void>> unfollowPlaylist(String playlistId);
  
  /// Verifica se está seguindo uma playlist
  Future<Result<bool>> isFollowingPlaylist(String playlistId);
  
  /// Obtém playlists seguidas
  Future<Result<List<Playlist>>> getFollowedPlaylists();
}
