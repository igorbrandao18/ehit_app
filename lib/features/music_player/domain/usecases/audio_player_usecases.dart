// features/music_player/domain/usecases/audio_player_usecases.dart

import '../../../../core/utils/result.dart';
import '../entities/audio_state.dart';
import '../repositories/audio_player_repository.dart';
import '../../../music_library/domain/entities/song.dart';

/// Use case para inicializar o player
class InitializeAudioPlayerUseCase {
  final AudioPlayerRepository repository;
  
  const InitializeAudioPlayerUseCase(this.repository);
  
  Future<Result<void>> call() async {
    return await repository.initialize();
  }
}

/// Use case para tocar uma música
class PlaySongUseCase {
  final AudioPlayerRepository repository;
  
  const PlaySongUseCase(this.repository);
  
  Future<Result<void>> call(Song song) async {
    return await repository.playSong(song);
  }
}

/// Use case para tocar uma fila de músicas
class PlayQueueUseCase {
  final AudioPlayerRepository repository;
  
  const PlayQueueUseCase(this.repository);
  
  Future<Result<void>> call(List<Song> songs, {int startIndex = 0}) async {
    if (songs.isEmpty) {
      return const Error(message: 'Fila não pode estar vazia');
    }
    
    if (startIndex < 0 || startIndex >= songs.length) {
      return const Error(message: 'Índice inicial inválido');
    }
    
    return await repository.playQueue(songs, startIndex: startIndex);
  }
}

/// Use case para pausar reprodução
class PausePlaybackUseCase {
  final AudioPlayerRepository repository;
  
  const PausePlaybackUseCase(this.repository);
  
  Future<Result<void>> call() async {
    return await repository.pause();
  }
}

/// Use case para resumir reprodução
class ResumePlaybackUseCase {
  final AudioPlayerRepository repository;
  
  const ResumePlaybackUseCase(this.repository);
  
  Future<Result<void>> call() async {
    return await repository.resume();
  }
}

/// Use case para parar reprodução
class StopPlaybackUseCase {
  final AudioPlayerRepository repository;
  
  const StopPlaybackUseCase(this.repository);
  
  Future<Result<void>> call() async {
    return await repository.stop();
  }
}

/// Use case para próxima música
class NextSongUseCase {
  final AudioPlayerRepository repository;
  
  const NextSongUseCase(this.repository);
  
  Future<Result<void>> call() async {
    return await repository.next();
  }
}

/// Use case para música anterior
class PreviousSongUseCase {
  final AudioPlayerRepository repository;
  
  const PreviousSongUseCase(this.repository);
  
  Future<Result<void>> call() async {
    return await repository.previous();
  }
}

/// Use case para buscar posição
class SeekToPositionUseCase {
  final AudioPlayerRepository repository;
  
  const SeekToPositionUseCase(this.repository);
  
  Future<Result<void>> call(Duration position) async {
    if (position.isNegative) {
      return const Error(message: 'Posição não pode ser negativa');
    }
    
    return await repository.seekTo(position);
  }
}

/// Use case para definir volume
class SetVolumeUseCase {
  final AudioPlayerRepository repository;
  
  const SetVolumeUseCase(this.repository);
  
  Future<Result<void>> call(double volume) async {
    if (volume < 0.0 || volume > 1.0) {
      return const Error(message: 'Volume deve estar entre 0.0 e 1.0');
    }
    
    return await repository.setVolume(volume);
  }
}

/// Use case para definir mute
class SetMutedUseCase {
  final AudioPlayerRepository repository;
  
  const SetMutedUseCase(this.repository);
  
  Future<Result<void>> call(bool muted) async {
    return await repository.setMuted(muted);
  }
}

/// Use case para definir shuffle
class SetShuffledUseCase {
  final AudioPlayerRepository repository;
  
  const SetShuffledUseCase(this.repository);
  
  Future<Result<void>> call(bool shuffled) async {
    return await repository.setShuffled(shuffled);
  }
}

/// Use case para definir modo de repetição
class SetRepeatModeUseCase {
  final AudioPlayerRepository repository;
  
  const SetRepeatModeUseCase(this.repository);
  
  Future<Result<void>> call(RepeatMode repeatMode) async {
    return await repository.setRepeatMode(repeatMode);
  }
}

/// Use case para obter estado atual
class GetCurrentStateUseCase {
  final AudioPlayerRepository repository;
  
  const GetCurrentStateUseCase(this.repository);
  
  Future<Result<AudioState>> call() async {
    return await repository.getCurrentState();
  }
}

/// Use case para adicionar música à fila
class AddToQueueUseCase {
  final AudioPlayerRepository repository;
  
  const AddToQueueUseCase(this.repository);
  
  Future<Result<void>> call(Song song) async {
    return await repository.addToQueue(song);
  }
}

/// Use case para remover música da fila
class RemoveFromQueueUseCase {
  final AudioPlayerRepository repository;
  
  const RemoveFromQueueUseCase(this.repository);
  
  Future<Result<void>> call(int index) async {
    return await repository.removeFromQueue(index);
  }
}

/// Use case para limpar fila
class ClearQueueUseCase {
  final AudioPlayerRepository repository;
  
  const ClearQueueUseCase(this.repository);
  
  Future<Result<void>> call() async {
    return await repository.clearQueue();
  }
}

/// Use case para obter fila atual
class GetQueueUseCase {
  final AudioPlayerRepository repository;
  
  const GetQueueUseCase(this.repository);
  
  Future<Result<List<Song>>> call() async {
    return await repository.getQueue();
  }
}

/// Use case para obter música atual
class GetCurrentSongUseCase {
  final AudioPlayerRepository repository;
  
  const GetCurrentSongUseCase(this.repository);
  
  Future<Result<Song?>> call() async {
    return await repository.getCurrentSong();
  }
}

/// Use case para obter progresso
class GetProgressUseCase {
  final AudioPlayerRepository repository;
  
  const GetProgressUseCase(this.repository);
  
  Future<Result<double>> call() async {
    return await repository.getProgress();
  }
}

/// Use case para verificar se pode ir para próxima
class CanGoNextUseCase {
  final AudioPlayerRepository repository;
  
  const CanGoNextUseCase(this.repository);
  
  Future<Result<bool>> call() async {
    return await repository.canGoNext();
  }
}

/// Use case para verificar se pode ir para anterior
class CanGoPreviousUseCase {
  final AudioPlayerRepository repository;
  
  const CanGoPreviousUseCase(this.repository);
  
  Future<Result<bool>> call() async {
    return await repository.canGoPrevious();
  }
}
