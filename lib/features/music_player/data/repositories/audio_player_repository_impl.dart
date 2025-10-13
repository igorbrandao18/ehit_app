// features/music_player/data/repositories/audio_player_repository_impl.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/audio_state.dart';
import '../../domain/repositories/audio_player_repository.dart';
import '../../../music_library/domain/entities/song.dart';
import '../datasources/audio_player_datasource.dart';

/// Implementação do repositório de player de áudio
class AudioPlayerRepositoryImpl implements AudioPlayerRepository {
  final AudioPlayerDataSource _audioDataSource;
  
  // Estado interno do player
  AudioState _currentState = AudioState.initial;
  bool _isInitialized = false;
  
  // Timer para simular progresso da música
  Timer? _progressTimer;
  
  // Stream controllers para notificar mudanças
  final StreamController<AudioState> _audioStateController = StreamController<AudioState>.broadcast();

  AudioPlayerRepositoryImpl(this._audioDataSource);

  @override
  Future<Result<void>> initialize() async {
    try {
      if (_isInitialized) {
        return const Success(null);
      }
      
      final result = await _audioDataSource.initialize();
      if (result is Error) {
        return Error<void>(
          message: 'Erro ao inicializar data source: ${result.message}',
        );
      }
      
      _isInitialized = true;
      _setupStreams();
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao inicializar player: $e',
      );
    }
  }

  @override
  Future<Result<void>> dispose() async {
    try {
      _progressTimer?.cancel();
      _progressTimer = null;
      _isInitialized = false;
      _currentState = AudioState.initial;
      
      final result = await _audioDataSource.dispose();
      await _audioStateController.close();
      
      return result;
    } catch (e) {
      return Error<void>(
        message: 'Erro ao liberar player: $e',
      );
    }
  }

  @override
  Future<Result<void>> playSong(Song song) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      
      _currentState = _currentState.copyWith(
        playerState: AudioPlayerState.playing,
        currentSong: song,
        position: Duration.zero,
        duration: _parseDuration(song.duration),
        queue: [song],
        currentIndex: 0,
        errorMessage: null,
      );
      
      _notifyStateChange();
      
      final result = await _audioDataSource.playSong(song);
      if (result is Error) {
        _currentState = _currentState.copyWith(
          playerState: AudioPlayerState.error,
          errorMessage: result.message,
        );
        _notifyStateChange();
        return result;
      }
      
      _startProgressTimer();
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao tocar música: $e',
      );
    }
  }

  @override
  Future<Result<void>> playQueue(List<Song> songs, {int startIndex = 0}) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      
      if (songs.isEmpty) {
        return Error<void>(
          message: 'Lista de músicas vazia',
        );
      }
      
      final index = startIndex.clamp(0, songs.length - 1);
      final currentSong = songs[index];
      
      _currentState = _currentState.copyWith(
        playerState: AudioPlayerState.playing,
        currentSong: currentSong,
        position: Duration.zero,
        duration: _parseDuration(currentSong.duration),
        queue: songs,
        currentIndex: index,
        errorMessage: null,
      );
      
      _notifyStateChange();
      
      final result = await _audioDataSource.playSong(currentSong);
      if (result is Error) {
        _currentState = _currentState.copyWith(
          playerState: AudioPlayerState.error,
          errorMessage: result.message,
        );
        _notifyStateChange();
        return result;
      }
      
      _startProgressTimer();
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao tocar fila: $e',
      );
    }
  }

  @override
  Future<Result<void>> pause() async {
    try {
      final result = await _audioDataSource.pause();
      if (result is Success) {
        _currentState = _currentState.copyWith(
          playerState: AudioPlayerState.paused,
        );
        _notifyStateChange();
      }
      return result;
    } catch (e) {
      return Error<void>(
        message: 'Erro ao pausar música: $e',
      );
    }
  }

  @override
  Future<Result<void>> resume() async {
    try {
      final result = await _audioDataSource.resume();
      if (result is Success) {
        _currentState = _currentState.copyWith(
          playerState: AudioPlayerState.playing,
        );
        _notifyStateChange();
        _startProgressTimer();
      }
      return result;
    } catch (e) {
      return Error<void>(
        message: 'Erro ao resumir música: $e',
      );
    }
  }

  @override
  Future<Result<void>> stop() async {
    try {
      final result = await _audioDataSource.stop();
      if (result is Success) {
        _currentState = _currentState.copyWith(
          playerState: AudioPlayerState.stopped,
          position: Duration.zero,
        );
        _notifyStateChange();
        _progressTimer?.cancel();
      }
      return result;
    } catch (e) {
      return Error<void>(
        message: 'Erro ao parar música: $e',
      );
    }
  }

  @override
  Future<Result<void>> next() async {
    try {
      if (_currentState.queue.isEmpty) {
        return Error<void>(message: 'Fila vazia');
      }
      
      final nextIndex = (_currentState.currentIndex + 1) % _currentState.queue.length;
      final nextSong = _currentState.queue[nextIndex];
      
      _currentState = _currentState.copyWith(
        currentSong: nextSong,
        currentIndex: nextIndex,
        position: Duration.zero,
        duration: _parseDuration(nextSong.duration),
      );
      
      _notifyStateChange();
      
      final result = await _audioDataSource.playSong(nextSong);
      if (result is Error) {
        _currentState = _currentState.copyWith(
          playerState: AudioPlayerState.error,
          errorMessage: result.message,
        );
        _notifyStateChange();
        return result;
      }
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao tocar próxima música: $e',
      );
    }
  }

  @override
  Future<Result<void>> previous() async {
    try {
      if (_currentState.queue.isEmpty) {
        return Error<void>(message: 'Fila vazia');
      }
      
      final prevIndex = (_currentState.currentIndex - 1 + _currentState.queue.length) % _currentState.queue.length;
      final prevSong = _currentState.queue[prevIndex];
      
      _currentState = _currentState.copyWith(
        currentSong: prevSong,
        currentIndex: prevIndex,
        position: Duration.zero,
        duration: _parseDuration(prevSong.duration),
      );
      
      _notifyStateChange();
      
      final result = await _audioDataSource.playSong(prevSong);
      if (result is Error) {
        _currentState = _currentState.copyWith(
          playerState: AudioPlayerState.error,
          errorMessage: result.message,
        );
        _notifyStateChange();
        return result;
      }
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao tocar música anterior: $e',
      );
    }
  }

  @override
  Future<Result<void>> seekTo(Duration position) async {
    try {
      final result = await _audioDataSource.seekTo(position);
      if (result is Success) {
        _currentState = _currentState.copyWith(position: position);
        _notifyStateChange();
      }
      return result;
    } catch (e) {
      return Error<void>(
        message: 'Erro ao buscar posição: $e',
      );
    }
  }

  @override
  Future<Result<void>> setVolume(double volume) async {
    try {
      final result = await _audioDataSource.setVolume(volume);
      if (result is Success) {
        _currentState = _currentState.copyWith(volume: volume);
        _notifyStateChange();
      }
      return result;
    } catch (e) {
      return Error<void>(
        message: 'Erro ao definir volume: $e',
      );
    }
  }

  @override
  Future<Result<void>> setMuted(bool muted) async {
    try {
      final result = await _audioDataSource.setMuted(muted);
      if (result is Success) {
        _currentState = _currentState.copyWith(isMuted: muted);
        _notifyStateChange();
      }
      return result;
    } catch (e) {
      return Error<void>(
        message: 'Erro ao definir mute: $e',
      );
    }
  }

  @override
  Future<Result<void>> setShuffled(bool shuffled) async {
    try {
      _currentState = _currentState.copyWith(isShuffled: shuffled);
      _notifyStateChange();
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao definir shuffle: $e',
      );
    }
  }

  @override
  Future<Result<void>> setRepeatMode(RepeatMode repeatMode) async {
    try {
      _currentState = _currentState.copyWith(repeatMode: repeatMode);
      _notifyStateChange();
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao definir modo de repetição: $e',
      );
    }
  }

  @override
  Future<Result<AudioState>> getCurrentState() async {
    return Success(_currentState);
  }

  @override
  Future<Result<Duration>> getCurrentPosition() async {
    return await _audioDataSource.getCurrentPosition();
  }

  @override
  Future<Result<Duration>> getCurrentDuration() async {
    return await _audioDataSource.getCurrentDuration();
  }

  @override
  Future<Result<bool>> isPlaying() async {
    return await _audioDataSource.isPlaying();
  }

  @override
  Future<Result<bool>> isPaused() async {
    return await _audioDataSource.isPaused();
  }

  @override
  Future<Result<double>> getVolume() async {
    return await _audioDataSource.getVolume();
  }

  @override
  Future<Result<bool>> isMuted() async {
    return await _audioDataSource.isMuted();
  }

  @override
  Future<Result<bool>> isShuffled() async {
    return Success(_currentState.isShuffled);
  }

  @override
  Future<Result<RepeatMode>> getRepeatMode() async {
    return Success(_currentState.repeatMode);
  }

  @override
  Stream<AudioState> get audioStateStream => _audioStateController.stream;

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  void _setupStreams() {
    // Listener para mudanças no estado de reprodução
    _audioDataSource.playingStateStream.listen((isPlaying) {
      _currentState = _currentState.copyWith(
        playerState: isPlaying ? AudioPlayerState.playing : AudioPlayerState.paused,
      );
      _notifyStateChange();
    });
    
    // Listener para mudanças na posição
    _audioDataSource.positionStream.listen((position) {
      _currentState = _currentState.copyWith(position: position);
      _notifyStateChange();
    });
    
    // Listener para mudanças na duração
    _audioDataSource.durationStream.listen((duration) {
      if (duration != null) {
        _currentState = _currentState.copyWith(duration: duration);
        _notifyStateChange();
      }
    });
  }

  void _notifyStateChange() {
    _audioStateController.add(_currentState);
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentState.playerState != AudioPlayerState.playing) {
        timer.cancel();
        return;
      }
      
      // Simula progresso se necessário
      if (kIsWeb) {
        _currentState = _currentState.copyWith(
          position: _currentState.position + const Duration(seconds: 1),
        );
        _notifyStateChange();
        
        if (_currentState.position >= _currentState.duration) {
          timer.cancel();
          next(); // Toca próxima música automaticamente
        }
      }
    });
  }

  Duration _parseDuration(String durationString) {
    try {
      final parts = durationString.split(':');
      if (parts.length == 2) {
        final minutes = int.parse(parts[0]);
        final seconds = int.parse(parts[1]);
        return Duration(minutes: minutes, seconds: seconds);
      }
    } catch (e) {
      debugPrint('Erro ao fazer parse da duração: $durationString');
    }
    return const Duration(minutes: 3, seconds: 30); // Duração padrão
  }
}