// features/music_library/data/repositories/artist_repository_impl.dart

import 'package:flutter/foundation.dart';
import '../../domain/entities/artist.dart';
import '../../domain/repositories/artist_repository.dart';
import '../datasources/artist_remote_datasource.dart';
import '../../../../core/utils/result.dart';

/// Implementação do repositório de artistas
class ArtistRepositoryImpl implements ArtistRepository {
  final ArtistRemoteDataSource _remoteDataSource;

  ArtistRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Artist>>> getArtists() async {
    try {
      debugPrint('🎤 Buscando artistas...');
      
      final artistModels = await _remoteDataSource.getArtists();
      final artists = artistModels.map((model) => model.toEntity()).toList();
      
      debugPrint('🎤 Artistas carregados: ${artists.length}');
      for (int i = 0; i < artists.length; i++) {
        final artist = artists[i];
        debugPrint('🎤 Artista ${i + 1}: ${artist.name} (ID: ${artist.id}) - ${artist.genre}');
      }
      
      return Success(artists);
    } catch (e) {
      debugPrint('❌ Erro ao carregar artistas: $e');
      return Error<List<Artist>>(
        message: 'Erro ao carregar artistas: $e',
      );
    }
  }
}
