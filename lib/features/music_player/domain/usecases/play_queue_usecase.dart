// features/music_player/domain/usecases/play_queue_usecase.dart

import '../../../../core/utils/result.dart';
import '../../../music_library/domain/entities/song.dart';
import '../repositories/audio_player_repository.dart';

/// Use case para tocar uma lista de músicas
class PlayQueueUseCase {
  final AudioPlayerRepository _audioPlayerRepository;

  PlayQueueUseCase(this._audioPlayerRepository);

  /// Executa o use case para tocar uma lista de músicas
  Future<Result<void>> call(List<Song> songs, {int startIndex = 0}) async {
    return await _audioPlayerRepository.playQueue(songs, startIndex: startIndex);
  }
}
