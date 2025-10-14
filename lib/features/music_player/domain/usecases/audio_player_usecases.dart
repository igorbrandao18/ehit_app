// features/music_player/domain/usecases/audio_player_usecases.dart

import '../../../../core/utils/result.dart';
import '../../../../features/music_library/domain/entities/song.dart';
import '../repositories/audio_player_repository.dart';

/// Use case for toggling play/pause
class TogglePlayPauseUseCase {
  final AudioPlayerRepository _repository;
  
  const TogglePlayPauseUseCase(this._repository);
  
  Future<Result<void>> call() async {
    return await _repository.togglePlayPause();
  }
}

/// Use case for playing next song
class NextSongUseCase {
  final AudioPlayerRepository _repository;
  
  const NextSongUseCase(this._repository);
  
  Future<Result<void>> call() async {
    return await _repository.next();
  }
}

/// Use case for getting current song
class GetCurrentSongUseCase {
  final AudioPlayerRepository _repository;
  
  const GetCurrentSongUseCase(this._repository);
  
  Future<Result<Song?>> call() async {
    return await _repository.getCurrentSong();
  }
}

/// Use case for checking if playing
class IsPlayingUseCase {
  final AudioPlayerRepository _repository;
  
  const IsPlayingUseCase(this._repository);
  
  Future<Result<bool>> call() async {
    return await _repository.isPlaying();
  }
}

/// Use case for getting playback progress
class GetProgressUseCase {
  final AudioPlayerRepository _repository;
  
  const GetProgressUseCase(this._repository);
  
  Future<Result<double>> call() async {
    return await _repository.getProgress();
  }
}

/// Use case for getting current position
class GetCurrentPositionUseCase {
  final AudioPlayerRepository _repository;
  
  const GetCurrentPositionUseCase(this._repository);
  
  Future<Result<Duration>> call() async {
    return await _repository.getCurrentPosition();
  }
}

/// Use case for getting duration
class GetDurationUseCase {
  final AudioPlayerRepository _repository;
  
  const GetDurationUseCase(this._repository);
  
  Future<Result<Duration>> call() async {
    return await _repository.getDuration();
  }
}