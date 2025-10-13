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
}