import 'package:flutter/foundation.dart';
import '../../domain/entities/album.dart';
import '../../domain/entities/song.dart';
import '../../domain/repositories/album_repository.dart';
import '../datasources/album_remote_datasource.dart';
import '../../../../core/utils/result.dart';

class AlbumRepositoryImpl implements AlbumRepository {
  final AlbumRemoteDataSource _remoteDataSource;

  AlbumRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Album>>> getAlbumsByArtist(int artistId) async {
    try {
      debugPrint('💿 Buscando álbuns do artista $artistId...');
      final albumModels = await _remoteDataSource.getAlbumsByArtist(artistId);
      final albums = albumModels.map((model) => model.toEntity()).toList();
      debugPrint('💿 Álbuns carregados: ${albums.length}');
      return Success(albums);
    } catch (e) {
      debugPrint('❌ Erro ao carregar álbuns: $e');
      return Error<List<Album>>(
        message: 'Erro ao carregar álbuns: $e',
      );
    }
  }

  @override
  Future<Result<List<Song>>> getSongsByAlbum(int albumId) async {
    try {
      debugPrint('🎵 Buscando músicas do álbum $albumId...');
      final songModels = await _remoteDataSource.getSongsByAlbum(albumId);
      final songs = songModels.map((model) => model.toEntity()).toList();
      debugPrint('🎵 Músicas carregadas: ${songs.length}');
      return Success(songs);
    } catch (e) {
      debugPrint('❌ Erro ao carregar músicas do álbum: $e');
      return Error<List<Song>>(
        message: 'Erro ao carregar músicas do álbum: $e',
      );
    }
  }
}

