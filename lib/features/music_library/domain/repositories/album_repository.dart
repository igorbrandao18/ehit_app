import '../../../../core/utils/result.dart';
import '../entities/album.dart';
import '../entities/song.dart';

abstract class AlbumRepository {
  Future<Result<List<Album>>> getAlbumsByArtist(int artistId);
  Future<Result<List<Song>>> getSongsByAlbum(int albumId);
}

