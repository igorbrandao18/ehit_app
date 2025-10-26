import '../entities/song.dart';
import '../repositories/music_repository.dart';
import '../../../../core/utils/result.dart';
class GetSongsUseCase {
  final MusicRepository _repository;
  const GetSongsUseCase(this._repository);
  Future<Result<List<Song>>> call() async {
    try {
      return await _repository.getSongs();
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao buscar músicas: $e',
      );
    }
  }
}
class GetSongByIdUseCase {
  final MusicRepository _repository;
  const GetSongByIdUseCase(this._repository);
  Future<Result<Song>> call(String id) async {
    if (id.isEmpty) {
      return const Error<Song>(
        message: 'ID da música não pode estar vazio',
      );
    }
    try {
      return await _repository.getSongById(id);
    } catch (e) {
      return Error<Song>(
        message: 'Erro ao buscar música: $e',
      );
    }
  }
}
class GetSongsByArtistUseCase {
  final MusicRepository _repository;
  const GetSongsByArtistUseCase(this._repository);
  Future<Result<List<Song>>> call(String artistId) async {
    if (artistId.isEmpty) {
      return const Error<List<Song>>(
        message: 'ID do artista não pode estar vazio',
      );
    }
    try {
      return await _repository.getSongsByArtist(artistId);
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao buscar músicas do artista: $e',
      );
    }
  }
}
class GetPopularSongsUseCase {
  final MusicRepository _repository;
  const GetPopularSongsUseCase(this._repository);
  Future<Result<List<Song>>> call() async {
    try {
      return await _repository.getPopularSongs();
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao buscar músicas populares: $e',
      );
    }
  }
}
class GetRecentSongsUseCase {
  final MusicRepository _repository;
  const GetRecentSongsUseCase(this._repository);
  Future<Result<List<Song>>> call() async {
    try {
      return await _repository.getRecentSongs();
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao buscar músicas recentes: $e',
      );
    }
  }
}
class SearchSongsUseCase {
  final MusicRepository _repository;
  const SearchSongsUseCase(this._repository);
  Future<Result<List<Song>>> call(String query) async {
    if (query.isEmpty) {
      return const Error<List<Song>>(
        message: 'Query de busca não pode estar vazia',
      );
    }
    if (query.length < 2) {
      return const Error<List<Song>>(
        message: 'Query deve ter pelo menos 2 caracteres',
      );
    }
    try {
      return await _repository.searchSongs(query);
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao buscar músicas: $e',
      );
    }
  }
}
