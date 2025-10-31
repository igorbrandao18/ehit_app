import '../../../../core/utils/result.dart';
import '../entities/song.dart';
import '../repositories/album_repository.dart';

class GetSongsByAlbumUseCase {
  final AlbumRepository _repository;

  GetSongsByAlbumUseCase(this._repository);

  Future<Result<List<Song>>> call(int albumId) async {
    return await _repository.getSongsByAlbum(albumId);
  }
}

