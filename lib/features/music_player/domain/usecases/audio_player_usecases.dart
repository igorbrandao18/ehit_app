import '../../../../core/utils/result.dart';
import '../../../../features/music_library/domain/entities/song.dart';
import '../repositories/audio_player_repository.dart';
class TogglePlayPauseUseCase {
  final AudioPlayerRepository _repository;
  const TogglePlayPauseUseCase(this._repository);
  Future<Result<void>> call() async {
    return await _repository.togglePlayPause();
  }
}
class NextSongUseCase {
  final AudioPlayerRepository _repository;
  const NextSongUseCase(this._repository);
  Future<Result<void>> call() async {
    return await _repository.next();
  }
}
class GetCurrentSongUseCase {
  final AudioPlayerRepository _repository;
  const GetCurrentSongUseCase(this._repository);
  Future<Result<Song?>> call() async {
    return await _repository.getCurrentSong();
  }
}
class IsPlayingUseCase {
  final AudioPlayerRepository _repository;
  const IsPlayingUseCase(this._repository);
  Future<Result<bool>> call() async {
    return await _repository.isPlaying();
  }
}
class GetProgressUseCase {
  final AudioPlayerRepository _repository;
  const GetProgressUseCase(this._repository);
  Future<Result<double>> call() async {
    return await _repository.getProgress();
  }
}
class GetCurrentPositionUseCase {
  final AudioPlayerRepository _repository;
  const GetCurrentPositionUseCase(this._repository);
  Future<Result<Duration>> call() async {
    return await _repository.getCurrentPosition();
  }
}
class GetDurationUseCase {
  final AudioPlayerRepository _repository;
  const GetDurationUseCase(this._repository);
  Future<Result<Duration>> call() async {
    return await _repository.getDuration();
  }
}
