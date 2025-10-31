import '../../../../core/utils/result.dart';
import '../entities/album.dart';
import '../repositories/album_repository.dart';

class GetAlbumsByArtistUseCase {
  final AlbumRepository _repository;

  GetAlbumsByArtistUseCase(this._repository);

  Future<Result<List<Album>>> call(int artistId) async {
    return await _repository.getAlbumsByArtist(artistId);
  }
}

