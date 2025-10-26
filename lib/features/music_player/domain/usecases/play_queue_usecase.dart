import '../../../../core/utils/result.dart';
import '../../../music_library/domain/entities/song.dart';
import '../repositories/audio_player_repository.dart';
class PlayQueueUseCase {
  final AudioPlayerRepository _audioPlayerRepository;
  PlayQueueUseCase(this._audioPlayerRepository);
  Future<Result<void>> call(List<Song> songs, {int startIndex = 0}) async {
    return await _audioPlayerRepository.setPlaylist(songs, startIndex: startIndex);
  }
}
