// features/music_player/domain/entities/audio_state.dart

import 'package:equatable/equatable.dart';
import '../../../music_library/domain/entities/song.dart';

/// Estados possíveis do player de áudio
enum AudioPlayerState {
  stopped,
  playing,
  paused,
  buffering,
  error,
}

/// Estados de repetição
enum RepeatMode {
  none,
  one,
  all,
}

/// Entidade que representa o estado atual do player de áudio
class AudioState extends Equatable {
  final AudioPlayerState playerState;
  final Song? currentSong;
  final Duration position;
  final Duration duration;
  final bool isShuffled;
  final RepeatMode repeatMode;
  final double volume;
  final bool isMuted;
  final List<Song> queue;
  final int currentIndex;
  final String? errorMessage;
  final bool isOfflineMode;

  const AudioState({
    required this.playerState,
    this.currentSong,
    required this.position,
    required this.duration,
    required this.isShuffled,
    required this.repeatMode,
    required this.volume,
    required this.isMuted,
    required this.queue,
    required this.currentIndex,
    this.errorMessage,
    required this.isOfflineMode,
  });

  /// Estado inicial do player
  static const AudioState initial = AudioState(
    playerState: AudioPlayerState.stopped,
    position: Duration.zero,
    duration: Duration.zero,
    isShuffled: false,
    repeatMode: RepeatMode.none,
    volume: 1.0,
    isMuted: false,
    queue: [],
    currentIndex: 0,
    isOfflineMode: false,
  );

  /// Cria uma cópia do estado com campos modificados
  AudioState copyWith({
    AudioPlayerState? playerState,
    Song? currentSong,
    Duration? position,
    Duration? duration,
    bool? isShuffled,
    RepeatMode? repeatMode,
    double? volume,
    bool? isMuted,
    List<Song>? queue,
    int? currentIndex,
    String? errorMessage,
    bool? isOfflineMode,
  }) {
    return AudioState(
      playerState: playerState ?? this.playerState,
      currentSong: currentSong ?? this.currentSong,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isShuffled: isShuffled ?? this.isShuffled,
      repeatMode: repeatMode ?? this.repeatMode,
      volume: volume ?? this.volume,
      isMuted: isMuted ?? this.isMuted,
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      errorMessage: errorMessage ?? this.errorMessage,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
    );
  }

  /// Verifica se há uma música atual
  bool get hasCurrentSong => currentSong != null;

  /// Verifica se há músicas na fila
  bool get hasQueue => queue.isNotEmpty;

  /// Verifica se pode ir para a próxima música
  bool get canGoNext {
    if (!hasQueue) return false;
    if (isShuffled) return true;
    if (repeatMode == RepeatMode.one) return true;
    return currentIndex < queue.length - 1;
  }

  /// Verifica se pode ir para a música anterior
  bool get canGoPrevious {
    if (!hasQueue) return false;
    if (isShuffled) return true;
    if (repeatMode == RepeatMode.one) return true;
    return currentIndex > 0;
  }

  /// Obtém a próxima música na fila
  Song? get nextSong {
    if (!hasQueue) return null;
    if (isShuffled) {
      final shuffledIndex = (currentIndex + 1) % queue.length;
      return queue[shuffledIndex];
    }
    if (repeatMode == RepeatMode.one) return currentSong;
    if (currentIndex < queue.length - 1) {
      return queue[currentIndex + 1];
    }
    if (repeatMode == RepeatMode.all) {
      return queue[0];
    }
    return null;
  }

  /// Obtém a música anterior na fila
  Song? get previousSong {
    if (!hasQueue) return null;
    if (isShuffled) {
      final shuffledIndex = currentIndex > 0 ? currentIndex - 1 : queue.length - 1;
      return queue[shuffledIndex];
    }
    if (repeatMode == RepeatMode.one) return currentSong;
    if (currentIndex > 0) {
      return queue[currentIndex - 1];
    }
    if (repeatMode == RepeatMode.all) {
      return queue[queue.length - 1];
    }
    return null;
  }

  /// Calcula o progresso da música (0.0 a 1.0)
  double get progress {
    if (duration.inMilliseconds == 0) return 0.0;
    return position.inMilliseconds / duration.inMilliseconds;
  }

  /// Verifica se está tocando
  bool get isPlaying => playerState == AudioPlayerState.playing;

  /// Verifica se está pausado
  bool get isPaused => playerState == AudioPlayerState.paused;

  /// Verifica se está parado
  bool get isStopped => playerState == AudioPlayerState.stopped;

  /// Verifica se está carregando
  bool get isBuffering => playerState == AudioPlayerState.buffering;

  /// Verifica se há erro
  bool get hasError => playerState == AudioPlayerState.error;

  @override
  List<Object?> get props => [
        playerState,
        currentSong,
        position,
        duration,
        isShuffled,
        repeatMode,
        volume,
        isMuted,
        queue,
        currentIndex,
        errorMessage,
        isOfflineMode,
      ];

  @override
  String toString() {
    return 'AudioState(playerState: $playerState, currentSong: ${currentSong?.title}, position: $position, duration: $duration)';
  }
}
