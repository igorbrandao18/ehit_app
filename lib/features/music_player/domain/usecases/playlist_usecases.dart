import '../../../../core/utils/result.dart';
import '../entities/playlist.dart';
import '../repositories/playlist_repository.dart';
class GetUserPlaylistsUseCase {
  final PlaylistRepository repository;
  const GetUserPlaylistsUseCase(this.repository);
  Future<Result<List<Playlist>>> call() async {
    return await repository.getUserPlaylists();
  }
}
class GetPlaylistByIdUseCase {
  final PlaylistRepository repository;
  const GetPlaylistByIdUseCase(this.repository);
  Future<Result<Playlist>> call(String playlistId) async {
    return await repository.getPlaylistById(playlistId);
  }
}
class GetPublicPlaylistsUseCase {
  final PlaylistRepository repository;
  const GetPublicPlaylistsUseCase(this.repository);
  Future<Result<List<Playlist>>> call() async {
    return await repository.getPublicPlaylists();
  }
}
class GetPopularPlaylistsUseCase {
  final PlaylistRepository repository;
  const GetPopularPlaylistsUseCase(this.repository);
  Future<Result<List<Playlist>>> call() async {
    return await repository.getPopularPlaylists();
  }
}
class SearchPlaylistsUseCase {
  final PlaylistRepository repository;
  const SearchPlaylistsUseCase(this.repository);
  Future<Result<List<Playlist>>> call(String query) async {
    if (query.trim().isEmpty) {
      return const Error(message: 'Query não pode estar vazia');
    }
    return await repository.searchPlaylists(query);
  }
}
class CreatePlaylistUseCase {
  final PlaylistRepository repository;
  const CreatePlaylistUseCase(this.repository);
  Future<Result<Playlist>> call({
    required String name,
    required String description,
    required bool isPublic,
    required bool isCollaborative,
  }) async {
    if (name.trim().isEmpty) {
      return const Error(message: 'Nome da playlist não pode estar vazio');
    }
    return await repository.createPlaylist(
      name: name.trim(),
      description: description.trim(),
      isPublic: isPublic,
      isCollaborative: isCollaborative,
    );
  }
}
class UpdatePlaylistUseCase {
  final PlaylistRepository repository;
  const UpdatePlaylistUseCase(this.repository);
  Future<Result<Playlist>> call({
    required String playlistId,
    String? name,
    String? description,
    bool? isPublic,
    bool? isCollaborative,
  }) async {
    if (name != null && name.trim().isEmpty) {
      return const Error(message: 'Nome da playlist não pode estar vazio');
    }
    return await repository.updatePlaylist(
      playlistId: playlistId,
      name: name?.trim(),
      description: description?.trim(),
      isPublic: isPublic,
      isCollaborative: isCollaborative,
    );
  }
}
class DeletePlaylistUseCase {
  final PlaylistRepository repository;
  const DeletePlaylistUseCase(this.repository);
  Future<Result<void>> call(String playlistId) async {
    return await repository.deletePlaylist(playlistId);
  }
}
class AddSongToPlaylistUseCase {
  final PlaylistRepository repository;
  const AddSongToPlaylistUseCase(this.repository);
  Future<Result<Playlist>> call({
    required String playlistId,
    required String songId,
  }) async {
    return await repository.addSongToPlaylist(
      playlistId: playlistId,
      songId: songId,
    );
  }
}
class RemoveSongFromPlaylistUseCase {
  final PlaylistRepository repository;
  const RemoveSongFromPlaylistUseCase(this.repository);
  Future<Result<Playlist>> call({
    required String playlistId,
    required String songId,
  }) async {
    return await repository.removeSongFromPlaylist(
      playlistId: playlistId,
      songId: songId,
    );
  }
}
class FollowPlaylistUseCase {
  final PlaylistRepository repository;
  const FollowPlaylistUseCase(this.repository);
  Future<Result<void>> call(String playlistId) async {
    return await repository.followPlaylist(playlistId);
  }
}
class UnfollowPlaylistUseCase {
  final PlaylistRepository repository;
  const UnfollowPlaylistUseCase(this.repository);
  Future<Result<void>> call(String playlistId) async {
    return await repository.unfollowPlaylist(playlistId);
  }
}
