import '../../../../core/utils/result.dart';
import '../entities/genre.dart';

abstract class GenreRepository {
  Future<Result<List<Genre>>> getGenres();
}

