// features/music_library/domain/usecases/get_songs_usecase.dart

import '../entities/song.dart';
import '../repositories/music_repository.dart';
import '../../../../core/utils/result.dart';

/// Use case para buscar todas as músicas
class GetSongsUseCase {
  final MusicRepository _repository;

  const GetSongsUseCase(this._repository);

  /// Executa a busca de músicas
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

/// Use case para buscar música por ID
class GetSongByIdUseCase {
  final MusicRepository _repository;

  const GetSongByIdUseCase(this._repository);

  /// Executa a busca de música por ID
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

/// Use case para buscar músicas por artista
class GetSongsByArtistUseCase {
  final MusicRepository _repository;

  const GetSongsByArtistUseCase(this._repository);

  /// Executa a busca de músicas por artista
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

/// Use case para buscar músicas populares
class GetPopularSongsUseCase {
  final MusicRepository _repository;

  const GetPopularSongsUseCase(this._repository);

  /// Executa a busca de músicas populares
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

/// Use case para buscar músicas recentes
class GetRecentSongsUseCase {
  final MusicRepository _repository;

  const GetRecentSongsUseCase(this._repository);

  /// Executa a busca de músicas recentes
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

/// Use case para buscar músicas (search)
class SearchSongsUseCase {
  final MusicRepository _repository;

  const SearchSongsUseCase(this._repository);

  /// Executa a busca de músicas
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
