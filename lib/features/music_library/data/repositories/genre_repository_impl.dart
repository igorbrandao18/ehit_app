import 'package:flutter/foundation.dart';
import '../../domain/entities/genre.dart';
import '../../domain/repositories/genre_repository.dart';
import '../datasources/genre_remote_datasource.dart';
import '../../../../core/utils/result.dart';

class GenreRepositoryImpl implements GenreRepository {
  final GenreRemoteDataSource _remoteDataSource;

  GenreRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Genre>>> getGenres() async {
    try {
      debugPrint('🎵 Buscando gêneros...');
      final genreModels = await _remoteDataSource.getGenres();
      final genres = genreModels.map((model) => model.toEntity()).toList();
      debugPrint('🎵 Gêneros carregados: ${genres.length}');
      for (int i = 0; i < genres.length; i++) {
        final genre = genres[i];
        debugPrint('🎵 Gênero ${i + 1}: ${genre.name} (ID: ${genre.id})');
      }
      return Success(genres);
    } catch (e) {
      debugPrint('❌ Erro ao carregar gêneros: $e');
      return Error<List<Genre>>(
        message: 'Erro ao carregar gêneros: $e',
      );
    }
  }
}

