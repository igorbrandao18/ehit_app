// features/music_player/presentation/controllers/audio_player_controller.dart

import 'package:flutter/foundation.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/audio_state.dart';
import '../../domain/usecases/play_song_usecase.dart';
import '../../domain/usecases/play_queue_usecase.dart';
import '../../domain/usecases/audio_player_usecases.dart';
import '../../domain/repositories/audio_player_repository.dart';
import '../../../music_library/domain/entities/song.dart';

/// Controller responsável por gerenciar o estado do player de áudio
class AudioPlayerController extends ChangeNotifier {
  final PlaySongUseCase _playSongUseCase;
  final PlayQueueUseCase _playQueueUseCase;
  final TogglePlayPauseUseCase _togglePlayPauseUseCase;
  final NextSongUseCase _nextSongUseCase;
  final PreviousSongUseCase _previousSongUseCase;
  final SeekToPositionUseCase _seekToPositionUseCase;
  final GetAudioStateUseCase _getAudioStateUseCase;
  final AudioPlayerRepository _audioPlayerRepository;

  // Estado interno
  AudioState _currentState = AudioState.initial;
  bool _isDisposed = false;

  AudioPlayerController({
    required PlaySongUseCase playSongUseCase,
    required PlayQueueUseCase playQueueUseCase,
    required TogglePlayPauseUseCase togglePlayPauseUseCase,
    required NextSongUseCase nextSongUseCase,
    required PreviousSongUseCase previousSongUseCase,
    required SeekToPositionUseCase seekToPositionUseCase,
    required GetAudioStateUseCase getAudioStateUseCase,
    required AudioPlayerRepository audioPlayerRepository,
  }) : _playSongUseCase = playSongUseCase,
       _playQueueUseCase = playQueueUseCase,
       _togglePlayPauseUseCase = togglePlayPauseUseCase,
       _nextSongUseCase = nextSongUseCase,
       _previousSongUseCase = previousSongUseCase,
       _seekToPositionUseCase = seekToPositionUseCase,
       _getAudioStateUseCase = getAudioStateUseCase,
       _audioPlayerRepository = audioPlayerRepository {
    _initialize();
  }

  // Getters
  AudioState get currentState => _currentState;
  Song? get currentSong => _currentState.currentSong;
  List<Song> get playlist => _currentState.queue;
  int get currentIndex => _currentState.currentIndex;
  bool get isPlaying => _currentState.playerState == AudioPlayerState.playing;
  bool get isPaused => _currentState.playerState == AudioPlayerState.paused;
  bool get isLoading => _currentState.playerState == AudioPlayerState.buffering;
  Duration get position => _currentState.position;
  Duration get duration => _currentState.duration;
  double get progress => _currentState.duration.inMilliseconds > 0 
      ? _currentState.position.inMilliseconds / _currentState.duration.inMilliseconds 
      : 0.0;
  double get volume => _currentState.volume;
  bool get isMuted => _currentState.isMuted;
  bool get isShuffled => _currentState.isShuffled;
  RepeatMode get repeatMode => _currentState.repeatMode;
  String? get errorMessage => _currentState.errorMessage;

  /// Inicializa o controller
  Future<void> _initialize() async {
    try {
      // Escuta mudanças no estado do player
      _audioPlayerRepository.audioStateStream.listen((state) {
        if (_isDisposed) return;
        _currentState = state;
        notifyListeners();
      });
      
      // Obtém estado inicial
      final result = await _getAudioStateUseCase();
      result.when(
        success: (state) {
          if (_isDisposed) return;
          _currentState = state;
          notifyListeners();
        },
        error: (message, code) {
          debugPrint('Erro ao obter estado inicial: $message');
        },
      );
    } catch (e) {
      debugPrint('Erro ao inicializar AudioPlayerController: $e');
    }
  }

  /// Toca uma música específica
  Future<void> playSong(Song song) async {
    if (_isDisposed) return;
    
    final result = await _playSongUseCase(song);
    result.when(
      success: (_) {
        debugPrint('🎵 Tocando: ${song.title} - ${song.artist}');
      },
      error: (message, code) {
        debugPrint('❌ Erro ao tocar música: $message');
      },
    );
  }

  /// Toca uma lista de músicas
  Future<void> playPlaylist(List<Song> songs, {int startIndex = 0}) async {
    if (_isDisposed) return;
    
    final result = await _playQueueUseCase(songs, startIndex: startIndex);
    result.when(
      success: (_) {
        debugPrint('🎵 Tocando playlist: ${songs.length} músicas');
      },
      error: (message, code) {
        debugPrint('❌ Erro ao tocar playlist: $message');
      },
    );
  }

  /// Alterna entre play/pause
  Future<void> togglePlayPause() async {
    if (_isDisposed) return;
    
    final result = await _togglePlayPauseUseCase();
    result.when(
      success: (_) {
        debugPrint('🔄 Toggle play/pause');
      },
      error: (message, code) {
        debugPrint('❌ Erro ao alternar play/pause: $message');
      },
    );
  }

  /// Próxima música
  Future<void> next() async {
    if (_isDisposed) return;
    
    final result = await _nextSongUseCase();
    result.when(
      success: (_) {
        debugPrint('⏭️ Próxima música');
      },
      error: (message, code) {
        debugPrint('❌ Erro ao tocar próxima música: $message');
      },
    );
  }

  /// Música anterior
  Future<void> previous() async {
    if (_isDisposed) return;
    
    final result = await _previousSongUseCase();
    result.when(
      success: (_) {
        debugPrint('⏮️ Música anterior');
      },
      error: (message, code) {
        debugPrint('❌ Erro ao tocar música anterior: $message');
      },
    );
  }

  /// Busca para uma posição específica
  Future<void> seek(Duration position) async {
    if (_isDisposed) return;
    
    final result = await _seekToPositionUseCase(position);
    result.when(
      success: (_) {
        debugPrint('⏩ Buscando para: ${position.inSeconds}s');
      },
      error: (message, code) {
        debugPrint('❌ Erro ao buscar posição: $message');
      },
    );
  }

  /// Define o volume
  Future<void> setVolume(double volume) async {
    if (_isDisposed) return;
    
    final result = await _audioPlayerRepository.setVolume(volume);
    result.when(
      success: (_) {
        debugPrint('🔊 Volume: ${(volume * 100).round()}%');
      },
      error: (message, code) {
        debugPrint('❌ Erro ao definir volume: $message');
      },
    );
  }

  /// Liga/desliga o mute
  Future<void> setMuted(bool muted) async {
    if (_isDisposed) return;
    
    final result = await _audioPlayerRepository.setMuted(muted);
    result.when(
      success: (_) {
        debugPrint('🔇 Mute: $muted');
      },
      error: (message, code) {
        debugPrint('❌ Erro ao definir mute: $message');
      },
    );
  }

  /// Ativa/desativa o modo shuffle
  Future<void> setShuffled(bool shuffled) async {
    if (_isDisposed) return;
    
    final result = await _audioPlayerRepository.setShuffled(shuffled);
    result.when(
      success: (_) {
        debugPrint('🔀 Shuffle: $shuffled');
      },
      error: (message, code) {
        debugPrint('❌ Erro ao definir shuffle: $message');
      },
    );
  }

  /// Define o modo de repetição
  Future<void> setRepeatMode(RepeatMode repeatMode) async {
    if (_isDisposed) return;
    
    final result = await _audioPlayerRepository.setRepeatMode(repeatMode);
    result.when(
      success: (_) {
        debugPrint('🔁 Repeat mode: $repeatMode');
      },
      error: (message, code) {
        debugPrint('❌ Erro ao definir repeat mode: $message');
      },
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
