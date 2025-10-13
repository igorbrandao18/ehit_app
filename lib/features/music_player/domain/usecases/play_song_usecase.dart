// features/music_player/domain/usecases/play_song_usecase.dart

import '../../../../core/utils/result.dart';
import '../../../music_library/domain/entities/song.dart';
import '../repositories/audio_player_repository.dart';

/// Use case para tocar uma música específica
class PlaySongUseCase {
  final AudioPlayerRepository _audioPlayerRepository;

  PlaySongUseCase(this._audioPlayerRepository);

  /// Executa o use case para tocar uma música
  Future<Result<void>> call(Song song) async {
    return await _audioPlayerRepository.playSong(song);
  }
}
