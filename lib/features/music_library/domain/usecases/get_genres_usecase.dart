import '../../../../core/utils/result.dart';
import '../entities/genre.dart';
import '../repositories/genre_repository.dart';

class GetGenresUseCase {
  final GenreRepository _genreRepository;

  GetGenresUseCase(this._genreRepository);

  Future<Result<List<Genre>>> call() async {
    return await _genreRepository.getGenres();
  }
}

