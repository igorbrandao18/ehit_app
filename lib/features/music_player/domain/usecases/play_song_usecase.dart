// features/music_player/domain/usecases/play_song_usecase.dart

import '../../../../core/utils/result.dart';
import '../../../../features/music_library/domain/entities/song.dart';
import '../repositories/audio_player_repository.dart';

/// Use case for playing a specific song
/// Follows Clean Architecture - Domain Layer
class PlaySongUseCase {
  final AudioPlayerRepository _repository;
  
  const PlaySongUseCase(this._repository);
  
  /// Execute play song use case
  Future<Result<void>> call(Song song) async {
    return await _repository.playSong(song);
  }
}