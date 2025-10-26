import '../../../../core/utils/result.dart';
import '../../../../features/music_library/domain/entities/song.dart';
import '../repositories/audio_player_repository.dart';
class PlaySongUseCase {
  final AudioPlayerRepository _repository;
  const PlaySongUseCase(this._repository);
  Future<Result<void>> call(Song song) async {
    return await _repository.playSong(song);
  }
}
