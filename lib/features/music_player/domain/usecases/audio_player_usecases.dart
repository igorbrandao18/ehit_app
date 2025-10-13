// features/music_player/domain/usecases/audio_player_usecases.dart

import '../../../../core/utils/result.dart';
import '../entities/audio_state.dart';
import '../repositories/audio_player_repository.dart';

/// Use case para controlar reprodução (play/pause)
class TogglePlayPauseUseCase {
  final AudioPlayerRepository _audioPlayerRepository;

  TogglePlayPauseUseCase(this._audioPlayerRepository);

  /// Executa o use case para alternar entre play/pause
  Future<Result<void>> call() async {
    final isPlayingResult = await _audioPlayerRepository.isPlaying();
    
    return isPlayingResult.when(
      success: (isPlaying) async {
        if (isPlaying) {
          return await _audioPlayerRepository.pause();
        } else {
          return await _audioPlayerRepository.resume();
        }
      },
      error: (message, code) => Error<void>(message: message, code: code),
    );
  }
}

/// Use case para navegar para próxima música
class NextSongUseCase {
  final AudioPlayerRepository _audioPlayerRepository;

  NextSongUseCase(this._audioPlayerRepository);

  /// Executa o use case para próxima música
  Future<Result<void>> call() async {
    return await _audioPlayerRepository.next();
  }
}

/// Use case para navegar para música anterior
class PreviousSongUseCase {
  final AudioPlayerRepository _audioPlayerRepository;

  PreviousSongUseCase(this._audioPlayerRepository);

  /// Executa o use case para música anterior
  Future<Result<void>> call() async {
    return await _audioPlayerRepository.previous();
  }
}

/// Use case para buscar posição específica
class SeekToPositionUseCase {
  final AudioPlayerRepository _audioPlayerRepository;

  SeekToPositionUseCase(this._audioPlayerRepository);

  /// Executa o use case para buscar posição
  Future<Result<void>> call(Duration position) async {
    return await _audioPlayerRepository.seekTo(position);
  }
}

/// Use case para obter estado atual do player
class GetAudioStateUseCase {
  final AudioPlayerRepository _audioPlayerRepository;

  GetAudioStateUseCase(this._audioPlayerRepository);

  /// Executa o use case para obter estado atual
  Future<Result<AudioState>> call() async {
    return await _audioPlayerRepository.getCurrentState();
  }
}