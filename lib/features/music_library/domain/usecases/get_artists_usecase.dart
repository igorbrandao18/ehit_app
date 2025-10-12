// features/music_library/domain/usecases/get_artists_usecase.dart

import '../entities/artist.dart';
import '../repositories/music_repository.dart';
import '../../../../core/utils/result.dart';

/// Use case para buscar todos os artistas
class GetArtistsUseCase {
  final ArtistRepository _repository;

  const GetArtistsUseCase(this._repository);

  /// Executa a busca de artistas
  Future<Result<List<Artist>>> call() async {
    try {
      return await _repository.getArtists();
    } catch (e) {
      return Error<List<Artist>>(
        message: 'Erro ao buscar artistas: $e',
      );
    }
  }
}

/// Use case para buscar artista por ID
class GetArtistByIdUseCase {
  final ArtistRepository _repository;

  const GetArtistByIdUseCase(this._repository);

  /// Executa a busca de artista por ID
  Future<Result<Artist>> call(String id) async {
    if (id.isEmpty) {
      return const Error<Artist>(
        message: 'ID do artista não pode estar vazio',
      );
    }

    try {
      return await _repository.getArtistById(id);
    } catch (e) {
      return Error<Artist>(
        message: 'Erro ao buscar artista: $e',
      );
    }
  }
}

/// Use case para buscar artistas populares
class GetPopularArtistsUseCase {
  final ArtistRepository _repository;

  const GetPopularArtistsUseCase(this._repository);

  /// Executa a busca de artistas populares
  Future<Result<List<Artist>>> call() async {
    try {
      return await _repository.getPopularArtists();
    } catch (e) {
      return Error<List<Artist>>(
        message: 'Erro ao buscar artistas populares: $e',
      );
    }
  }
}

/// Use case para buscar artistas por gênero
class GetArtistsByGenreUseCase {
  final ArtistRepository _repository;

  const GetArtistsByGenreUseCase(this._repository);

  /// Executa a busca de artistas por gênero
  Future<Result<List<Artist>>> call(String genre) async {
    if (genre.isEmpty) {
      return const Error<List<Artist>>(
        message: 'Gênero não pode estar vazio',
      );
    }

    try {
      return await _repository.getArtistsByGenre(genre);
    } catch (e) {
      return Error<List<Artist>>(
        message: 'Erro ao buscar artistas por gênero: $e',
      );
    }
  }
}

/// Use case para buscar artistas (search)
class SearchArtistsUseCase {
  final ArtistRepository _repository;

  const SearchArtistsUseCase(this._repository);

  /// Executa a busca de artistas
  Future<Result<List<Artist>>> call(String query) async {
    if (query.isEmpty) {
      return const Error<List<Artist>>(
        message: 'Query de busca não pode estar vazia',
      );
    }

    if (query.length < 2) {
      return const Error<List<Artist>>(
        message: 'Query deve ter pelo menos 2 caracteres',
      );
    }

    try {
      return await _repository.searchArtists(query);
    } catch (e) {
      return Error<List<Artist>>(
        message: 'Erro ao buscar artistas: $e',
      );
    }
  }
}
