// features/music_player/data/repositories/audio_player_repository_impl.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/repositories/audio_player_repository.dart';
import '../../domain/entities/audio_state.dart';
import '../../../music_library/domain/entities/song.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/audio/offline_audio_service.dart';

/// Implementação do repositório de player de áudio
class AudioPlayerRepositoryImpl implements AudioPlayerRepository {
  // Estado interno do player
  AudioState _currentState = AudioState.initial;
  bool _isInitialized = false;
  
  // Timer para simular progresso da música
  Timer? _progressTimer;
  
  // Serviço offline
  final OfflineAudioService _offlineService = OfflineAudioService();

  @override
  Future<Result<void>> initialize() async {
    try {
      if (_isInitialized) {
        return const Success(null);
      }
      
      // Inicializa o serviço offline
      final offlineResult = await _offlineService.initialize();
      if (offlineResult is Error) {
        return Error<void>(
          message: 'Erro ao inicializar serviço offline: ${offlineResult.message}',
        );
      }
      
      // Simula inicialização do player
      await Future.delayed(const Duration(milliseconds: 100));
      _isInitialized = true;
      
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
      
      // Libera recursos do serviço offline
      _offlineService.dispose();
      
      return const Success(null);
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
      _progressTimer?.cancel();
      _currentState = _currentState.copyWith(
        playerState: AudioPlayerState.paused,
      );
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao pausar: $e',
      );
    }
  }

  @override
  Future<Result<void>> resume() async {
    try {
      _currentState = _currentState.copyWith(
        playerState: AudioPlayerState.playing,
      );
      
      _startProgressTimer();
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao retomar: $e',
      );
    }
  }

  @override
  Future<Result<void>> stop() async {
    try {
      _progressTimer?.cancel();
      _currentState = _currentState.copyWith(
        playerState: AudioPlayerState.stopped,
        position: Duration.zero,
        currentSong: null,
        queue: [],
        currentIndex: 0,
      );
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao parar: $e',
      );
    }
  }

  @override
  Future<Result<void>> next() async {
    try {
      if (!_currentState.hasQueue) {
        return Error<void>(
          message: 'Nenhuma música na fila',
        );
      }
      
      final nextSong = _currentState.nextSong;
      if (nextSong == null) {
        return Error<void>(
          message: 'Não há próxima música',
        );
      }
      
      final nextIndex = _currentState.isShuffled 
          ? _getNextShuffledIndex()
          : (_currentState.currentIndex + 1) % _currentState.queue.length;
      
      _currentState = _currentState.copyWith(
        currentSong: nextSong,
        currentIndex: nextIndex,
        position: Duration.zero,
        duration: _parseDuration(nextSong.duration),
      );
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao ir para próxima música: $e',
      );
    }
  }

  @override
  Future<Result<void>> previous() async {
    try {
      if (!_currentState.hasQueue) {
        return Error<void>(
          message: 'Nenhuma música na fila',
        );
      }
      
      final previousSong = _currentState.previousSong;
      if (previousSong == null) {
        return Error<void>(
          message: 'Não há música anterior',
        );
      }
      
      final previousIndex = _currentState.isShuffled 
          ? _getPreviousShuffledIndex()
          : (_currentState.currentIndex - 1 + _currentState.queue.length) % _currentState.queue.length;
      
      _currentState = _currentState.copyWith(
        currentSong: previousSong,
        currentIndex: previousIndex,
        position: Duration.zero,
        duration: _parseDuration(previousSong.duration),
      );
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao ir para música anterior: $e',
      );
    }
  }

  @override
  Future<Result<void>> seekTo(Duration position) async {
    try {
      if (_currentState.currentSong == null) {
        return Error<void>(
          message: 'Nenhuma música tocando',
        );
      }
      
      final clampedPosition = Duration(
        milliseconds: position.inMilliseconds.clamp(
          0,
          _currentState.duration.inMilliseconds,
        ),
      );
      
      _currentState = _currentState.copyWith(
        position: clampedPosition,
      );
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao buscar posição: $e',
      );
    }
  }

  @override
  Future<Result<void>> setVolume(double volume) async {
    try {
      final clampedVolume = volume.clamp(0.0, 1.0);
      
      _currentState = _currentState.copyWith(
        volume: clampedVolume,
      );
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao definir volume: $e',
      );
    }
  }

  @override
  Future<Result<void>> setMuted(bool muted) async {
    try {
      _currentState = _currentState.copyWith(
        isMuted: muted,
      );
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao definir mute: $e',
      );
    }
  }

  @override
  Future<Result<void>> setShuffled(bool shuffled) async {
    try {
      _currentState = _currentState.copyWith(
        isShuffled: shuffled,
      );
      
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
      _currentState = _currentState.copyWith(
        repeatMode: repeatMode,
      );
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao definir modo de repetição: $e',
      );
    }
  }

  @override
  Future<Result<AudioState>> getCurrentState() async {
    try {
      return Success(_currentState);
    } catch (e) {
      return Error<AudioState>(
        message: 'Erro ao obter estado atual: $e',
      );
    }
  }

  @override
  Future<Result<Duration>> getCurrentPosition() async {
    try {
      return Success(_currentState.position);
    } catch (e) {
      return Error<Duration>(
        message: 'Erro ao obter posição atual: $e',
      );
    }
  }

  @override
  Future<Result<Duration>> getCurrentDuration() async {
    try {
      return Success(_currentState.duration);
    } catch (e) {
      return Error<Duration>(
        message: 'Erro ao obter duração atual: $e',
      );
    }
  }

  @override
  Future<Result<bool>> isPlaying() async {
    try {
      return Success(_currentState.isPlaying);
    } catch (e) {
      return Error<bool>(
        message: 'Erro ao verificar se está tocando: $e',
      );
    }
  }

  @override
  Future<Result<bool>> isPaused() async {
    try {
      return Success(_currentState.isPaused);
    } catch (e) {
      return Error<bool>(
        message: 'Erro ao verificar se está pausado: $e',
      );
    }
  }

  @override
  Future<Result<double>> getVolume() async {
    try {
      return Success(_currentState.volume);
    } catch (e) {
      return Error<double>(
        message: 'Erro ao obter volume: $e',
      );
    }
  }

  @override
  Future<Result<bool>> isMuted() async {
    try {
      return Success(_currentState.isMuted);
    } catch (e) {
      return Error<bool>(
        message: 'Erro ao verificar se está mutado: $e',
      );
    }
  }

  @override
  Future<Result<bool>> isShuffled() async {
    try {
      return Success(_currentState.isShuffled);
    } catch (e) {
      return Error<bool>(
        message: 'Erro ao verificar se está em shuffle: $e',
      );
    }
  }

  @override
  Future<Result<RepeatMode>> getRepeatMode() async {
    try {
      return Success(_currentState.repeatMode);
    } catch (e) {
      return Error<RepeatMode>(
        message: 'Erro ao obter modo de repetição: $e',
      );
    }
  }

  @override
  Future<Result<void>> addToQueue(Song song) async {
    try {
      final newQueue = List<Song>.from(_currentState.queue)..add(song);
      
      _currentState = _currentState.copyWith(
        queue: newQueue,
      );
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao adicionar à fila: $e',
      );
    }
  }

  @override
  Future<Result<void>> removeFromQueue(int index) async {
    try {
      if (index < 0 || index >= _currentState.queue.length) {
        return Error<void>(
          message: 'Índice inválido',
        );
      }
      
      final newQueue = List<Song>.from(_currentState.queue)..removeAt(index);
      int newIndex = _currentState.currentIndex;
      
      // Ajusta o índice atual se necessário
      if (index < _currentState.currentIndex) {
        newIndex--;
      } else if (index == _currentState.currentIndex && newQueue.isNotEmpty) {
        newIndex = 0;
      }
      
      _currentState = _currentState.copyWith(
        queue: newQueue,
        currentIndex: newIndex,
      );
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao remover da fila: $e',
      );
    }
  }

  @override
  Future<Result<void>> clearQueue() async {
    try {
      _currentState = _currentState.copyWith(
        queue: [],
        currentIndex: 0,
        currentSong: null,
        playerState: AudioPlayerState.stopped,
      );
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao limpar fila: $e',
      );
    }
  }

  @override
  Future<Result<List<Song>>> getQueue() async {
    try {
      return Success(_currentState.queue);
    } catch (e) {
      return Error<List<Song>>(
        message: 'Erro ao obter fila: $e',
      );
    }
  }

  @override
  Future<Result<int>> getCurrentIndex() async {
    try {
      return Success(_currentState.currentIndex);
    } catch (e) {
      return Error<int>(
        message: 'Erro ao obter índice atual: $e',
      );
    }
  }

  @override
  Future<Result<void>> setCurrentIndex(int index) async {
    try {
      if (index < 0 || index >= _currentState.queue.length) {
        return Error<void>(
          message: 'Índice inválido',
        );
      }
      
      final song = _currentState.queue[index];
      
      _currentState = _currentState.copyWith(
        currentIndex: index,
        currentSong: song,
        position: Duration.zero,
        duration: _parseDuration(song.duration),
      );
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao definir índice atual: $e',
      );
    }
  }

  @override
  Future<Result<Song?>> getCurrentSong() async {
    try {
      return Success(_currentState.currentSong);
    } catch (e) {
      return Error<Song?>(
        message: 'Erro ao obter música atual: $e',
      );
    }
  }

  @override
  Future<Result<Song?>> getNextSong() async {
    try {
      return Success(_currentState.nextSong);
    } catch (e) {
      return Error<Song?>(
        message: 'Erro ao obter próxima música: $e',
      );
    }
  }

  @override
  Future<Result<Song?>> getPreviousSong() async {
    try {
      return Success(_currentState.previousSong);
    } catch (e) {
      return Error<Song?>(
        message: 'Erro ao obter música anterior: $e',
      );
    }
  }

  @override
  Future<Result<bool>> canGoNext() async {
    try {
      return Success(_currentState.nextSong != null);
    } catch (e) {
      return Error<bool>(
        message: 'Erro ao verificar se pode ir para próxima: $e',
      );
    }
  }

  @override
  Future<Result<bool>> canGoPrevious() async {
    try {
      return Success(_currentState.previousSong != null);
    } catch (e) {
      return Error<bool>(
        message: 'Erro ao verificar se pode ir para anterior: $e',
      );
    }
  }

  @override
  Future<Result<double>> getProgress() async {
    try {
      return Success(_currentState.progress);
    } catch (e) {
      return Error<double>(
        message: 'Erro ao obter progresso: $e',
      );
    }
  }

  @override
  Future<Result<bool>> hasError() async {
    try {
      return Success(_currentState.hasError);
    } catch (e) {
      return Error<bool>(
        message: 'Erro ao verificar se há erro: $e',
      );
    }
  }

  @override
  Future<Result<String?>> getErrorMessage() async {
    try {
      return Success(_currentState.errorMessage);
    } catch (e) {
      return Error<String?>(
        message: 'Erro ao obter mensagem de erro: $e',
      );
    }
  }

  @override
  Future<Result<void>> clearError() async {
    try {
      _currentState = _currentState.copyWith(
        errorMessage: null,
        playerState: _currentState.playerState == AudioPlayerState.error 
            ? AudioPlayerState.stopped 
            : _currentState.playerState,
      );
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao limpar erro: $e',
      );
    }
  }

  @override
  Future<Result<bool>> isOfflineMode() async {
    try {
      return Success(_currentState.isOfflineMode);
    } catch (e) {
      return Error<bool>(
        message: 'Erro ao verificar modo offline: $e',
      );
    }
  }

  @override
  Future<Result<void>> setOfflineMode(bool offline) async {
    try {
      _currentState = _currentState.copyWith(
        isOfflineMode: offline,
      );
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao definir modo offline: $e',
      );
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getCurrentSongMetadata() async {
    try {
      final song = _currentState.currentSong;
      if (song == null) {
        return Error<Map<String, dynamic>>(
          message: 'Nenhuma música tocando',
        );
      }
      
      return Success({
        'id': song.id,
        'title': song.title,
        'artist': song.artist,
        'album': song.album,
        'duration': _parseDuration(song.duration).inMilliseconds,
        'imageUrl': song.imageUrl,
        'audioUrl': song.audioUrl,
            'genre': 'Unknown',
        'year': song.releaseDate.year,
        'isFavorite': false, // TODO: Implementar favoritos
      });
    } catch (e) {
      return Error<Map<String, dynamic>>(
        message: 'Erro ao obter metadados da música atual: $e',
      );
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getSongMetadata(Song song) async {
    try {
      return Success({
        'id': song.id,
        'title': song.title,
        'artist': song.artist,
        'album': song.album,
        'duration': _parseDuration(song.duration).inMilliseconds,
        'imageUrl': song.imageUrl,
        'audioUrl': song.audioUrl,
            'genre': 'Unknown',
        'year': song.releaseDate.year,
        'isFavorite': false, // TODO: Implementar favoritos
      });
    } catch (e) {
      return Error<Map<String, dynamic>>(
        message: 'Erro ao obter metadados da música: $e',
      );
    }
  }

  @override
  Future<Result<bool>> isSongAvailableOffline(Song song) async {
    try {
      return await _offlineService.isSongAvailableOffline(song);
    } catch (e) {
      return Error<bool>(
        message: 'Erro ao verificar disponibilidade offline: $e',
      );
    }
  }

  @override
  Future<Result<String?>> getOfflineSongPath(Song song) async {
    try {
      return await _offlineService.getOfflineSongPath(song);
    } catch (e) {
      return Error<String?>(
        message: 'Erro ao obter caminho offline: $e',
      );
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getPlaybackStats() async {
    try {
      return Success({
        'totalPlayTime': _currentState.position.inMilliseconds,
        'currentSongDuration': _currentState.duration.inMilliseconds,
        'queueLength': _currentState.queue.length,
        'currentIndex': _currentState.currentIndex,
        'isShuffled': _currentState.isShuffled,
        'repeatMode': _currentState.repeatMode.name,
        'volume': _currentState.volume,
        'isMuted': _currentState.isMuted,
        'isOfflineMode': _currentState.isOfflineMode,
      });
    } catch (e) {
      return Error<Map<String, dynamic>>(
        message: 'Erro ao obter estatísticas de reprodução: $e',
      );
    }
  }

  // Métodos auxiliares privados
  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_currentState.isPlaying && _currentState.currentSong != null) {
        final newPosition = Duration(
          milliseconds: _currentState.position.inMilliseconds + 100,
        );
        
        if (newPosition >= _currentState.duration) {
          // Música terminou, vai para próxima ou para
          timer.cancel();
          _handleSongEnd();
        } else {
          _currentState = _currentState.copyWith(position: newPosition);
        }
      }
    });
  }

  void _handleSongEnd() {
    if (_currentState.repeatMode == RepeatMode.one) {
      // Repete a mesma música
      _currentState = _currentState.copyWith(position: Duration.zero);
      _startProgressTimer();
    } else if (_currentState.nextSong != null) {
      // Vai para próxima música
      next();
    } else if (_currentState.repeatMode == RepeatMode.all && _currentState.queue.isNotEmpty) {
      // Volta para primeira música
      setCurrentIndex(0);
    } else {
      // Para a reprodução
      stop();
    }
  }

  int _getNextShuffledIndex() {
    // Implementação simples de shuffle
    final availableIndices = List.generate(
      _currentState.queue.length,
      (index) => index,
    )..remove(_currentState.currentIndex);
    
    if (availableIndices.isEmpty) return _currentState.currentIndex;
    
    return availableIndices[DateTime.now().millisecondsSinceEpoch % availableIndices.length];
  }

  int _getPreviousShuffledIndex() {
    // Implementação simples de shuffle reverso
    final availableIndices = List.generate(
      _currentState.queue.length,
      (index) => index,
    )..remove(_currentState.currentIndex);
    
    if (availableIndices.isEmpty) return _currentState.currentIndex;
    
    return availableIndices[DateTime.now().millisecondsSinceEpoch % availableIndices.length];
  }

  /// Converte string de duração (ex: "3:45") para Duration
  Duration _parseDuration(String durationString) {
    try {
      final parts = durationString.split(':');
      if (parts.length == 2) {
        final minutes = int.parse(parts[0]);
        final seconds = int.parse(parts[1]);
        return Duration(minutes: minutes, seconds: seconds);
      }
      return const Duration(minutes: 0);
    } catch (e) {
      return const Duration(minutes: 0);
    }
  }

  @override
  Future<Result<void>> savePlaybackStats(Map<String, dynamic> stats) async {
    try {
      // TODO: Implementar salvamento de estatísticas de reprodução
      // Por enquanto, apenas simula o salvamento
      await Future.delayed(const Duration(milliseconds: 100));
      return const Success(null);
    } catch (e) {
      return Error(message: 'Failed to save playback stats: $e');
    }
  }
}
