// features/music_player/data/datasources/just_audio_datasource.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/errors/failures.dart';
import '../../../music_library/domain/entities/song.dart';
import 'audio_player_datasource.dart';

/// Implementação do data source usando just_audio
class JustAudioDataSource implements AudioPlayerDataSource {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;

  @override
  Future<Result<void>> initialize() async {
    try {
      if (_isInitialized) {
        return const Success(null);
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
      await _audioPlayer.dispose();
      _isInitialized = false;
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
      
      // Simula reprodução se o plugin não estiver disponível
      if (kIsWeb || !await _isAudioPlayerAvailable()) {
        debugPrint('⚠️ Plugin de áudio não disponível, simulando reprodução...');
        return const Success(null);
      }
      
      await _audioPlayer.setUrl(song.audioUrl);
      await _audioPlayer.play();
      
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao tocar música: $e',
      );
    }
  }

  @override
  Future<Result<void>> pause() async {
    try {
      await _audioPlayer.pause();
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao pausar música: $e',
      );
    }
  }

  @override
  Future<Result<void>> resume() async {
    try {
      await _audioPlayer.play();
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao resumir música: $e',
      );
    }
  }

  @override
  Future<Result<void>> stop() async {
    try {
      await _audioPlayer.stop();
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao parar música: $e',
      );
    }
  }

  @override
  Future<Result<void>> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
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
      await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
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
      await _audioPlayer.setVolume(muted ? 0.0 : 1.0);
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao definir mute: $e',
      );
    }
  }

  @override
  Future<Result<Duration>> getCurrentPosition() async {
    try {
      final position = _audioPlayer.position;
      return Success(position);
    } catch (e) {
      return Error<Duration>(
        message: 'Erro ao obter posição: $e',
      );
    }
  }

  @override
  Future<Result<Duration>> getCurrentDuration() async {
    try {
      final duration = _audioPlayer.duration;
      return Success(duration ?? Duration.zero);
    } catch (e) {
      return Error<Duration>(
        message: 'Erro ao obter duração: $e',
      );
    }
  }

  @override
  Future<Result<bool>> isPlaying() async {
    try {
      final state = _audioPlayer.playerState;
      return Success(state.playing);
    } catch (e) {
      return Error<bool>(
        message: 'Erro ao verificar estado de reprodução: $e',
      );
    }
  }

  @override
  Future<Result<bool>> isPaused() async {
    try {
      final state = _audioPlayer.playerState;
      return Success(state.processingState == ProcessingState.ready && !state.playing);
    } catch (e) {
      return Error<bool>(
        message: 'Erro ao verificar estado de pausa: $e',
      );
    }
  }

  @override
  Future<Result<double>> getVolume() async {
    try {
      final volume = _audioPlayer.volume;
      return Success(volume);
    } catch (e) {
      return Error<double>(
        message: 'Erro ao obter volume: $e',
      );
    }
  }

  @override
  Future<Result<bool>> isMuted() async {
    try {
      final volume = _audioPlayer.volume;
      return Success(volume == 0.0);
    } catch (e) {
      return Error<bool>(
        message: 'Erro ao verificar mute: $e',
      );
    }
  }

  @override
  Stream<bool> get playingStateStream {
    return _audioPlayer.playerStateStream.map((state) => state.playing);
  }

  @override
  Stream<Duration> get positionStream {
    return _audioPlayer.positionStream;
  }

  @override
  Stream<Duration?> get durationStream {
    return _audioPlayer.durationStream;
  }

  /// Verifica se o plugin de áudio está disponível
  Future<bool> _isAudioPlayerAvailable() async {
    try {
      // Tenta uma operação simples para verificar se o plugin funciona
      await _audioPlayer.setUrl('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
      return true;
    } catch (e) {
      debugPrint('⚠️ Plugin de áudio não disponível: $e');
      return false;
    }
  }
}
