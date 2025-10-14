// features/music_player/data/repositories/audio_player_repository_impl.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/errors/failures.dart';
import '../../../../features/music_library/domain/entities/song.dart';
import '../../domain/repositories/audio_player_repository.dart';

/// Implementation of AudioPlayerRepository
/// Follows Clean Architecture - Data Layer
class AudioPlayerRepositoryImpl implements AudioPlayerRepository {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  Song? _currentSong;
  List<Song> _playlist = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  
  // Stream controllers for state management
  final StreamController<Song?> _currentSongController = StreamController<Song?>.broadcast();
  final StreamController<bool> _isPlayingController = StreamController<bool>.broadcast();
  final StreamController<Duration> _positionController = StreamController<Duration>.broadcast();
  final StreamController<Duration> _durationController = StreamController<Duration>.broadcast();
  final StreamController<double> _progressController = StreamController<double>.broadcast();
  
  // Getters for streams
  Stream<Song?> get currentSongStream => _currentSongController.stream;
  Stream<bool> get isPlayingStream => _isPlayingController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<double> get progressStream => _progressController.stream;
  
  AudioPlayerRepositoryImpl() {
    _init();
  }
  
  void _init() {
    // Listener para mudanças no estado de reprodução
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      _isPlayingController.add(_isPlaying);
      
      // Se terminou a música, toca a próxima
      if (state.processingState == ProcessingState.completed) {
        next();
      }
    });
    
    // Listener para mudanças na posição
    _audioPlayer.positionStream.listen((position) {
      _position = position;
      _positionController.add(_position);
      
      // Calcular progresso
      if (_duration.inMilliseconds > 0) {
        final progress = _position.inMilliseconds / _duration.inMilliseconds;
        _progressController.add(progress);
      }
    });
    
    // Listener para mudanças na duração
    _audioPlayer.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      _durationController.add(_duration);
    });
  }
  
  @override
  Future<Result<void>> playSong(Song song) async {
    try {
      print('🎵 Tocando: ${song.title} - ${song.artist}');
      print('🎵 URL: ${song.audioUrl}');
      
      _currentSong = song;
      _currentSongController.add(_currentSong);
      
      await _audioPlayer.setUrl(song.audioUrl);
      await _audioPlayer.play();
      
      return const Success(null);
    } catch (e) {
      print('❌ Erro ao tocar música: $e');
      return Error<void>(
        message: 'Erro ao reproduzir música: $e',
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
        message: 'Erro ao retomar música: $e',
      );
    }
  }
  
  @override
  Future<Result<void>> stop() async {
    try {
      await _audioPlayer.stop();
      _currentSong = null;
      _currentSongController.add(_currentSong);
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao parar música: $e',
      );
    }
  }
  
  @override
  Future<Result<void>> next() async {
    try {
      if (_playlist.isNotEmpty && _currentIndex < _playlist.length - 1) {
        _currentIndex++;
        final nextSong = _playlist[_currentIndex];
        return await playSong(nextSong);
      }
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao avançar música: $e',
      );
    }
  }
  
  @override
  Future<Result<void>> previous() async {
    try {
      if (_playlist.isNotEmpty && _currentIndex > 0) {
        _currentIndex--;
        final previousSong = _playlist[_currentIndex];
        return await playSong(previousSong);
      }
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao retroceder música: $e',
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
  Future<Result<void>> togglePlayPause() async {
    try {
      if (_isPlaying) {
        return await pause();
      } else {
        return await resume();
      }
    } catch (e) {
      return Error<void>(
        message: 'Erro ao alternar reprodução: $e',
      );
    }
  }
  
  @override
  Future<Result<Song?>> getCurrentSong() async {
    return Success(_currentSong);
  }
  
  @override
  Future<Result<Duration>> getCurrentPosition() async {
    return Success(_position);
  }
  
  @override
  Future<Result<Duration>> getDuration() async {
    return Success(_duration);
  }
  
  @override
  Future<Result<double>> getProgress() async {
    final progress = _duration.inMilliseconds > 0 
        ? _position.inMilliseconds / _duration.inMilliseconds 
        : 0.0;
    return Success(progress);
  }
  
  @override
  Future<Result<bool>> isPlaying() async {
    return Success(_isPlaying);
  }
  
  @override
  Future<Result<void>> setPlaylist(List<Song> songs, {int startIndex = 0}) async {
    try {
      _playlist = songs;
      _currentIndex = startIndex;
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao definir playlist: $e',
      );
    }
  }
  
  @override
  Future<Result<void>> addToQueue(Song song) async {
    try {
      _playlist.add(song);
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao adicionar à fila: $e',
      );
    }
  }
  
  @override
  Future<Result<void>> clearQueue() async {
    try {
      _playlist.clear();
      _currentIndex = 0;
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao limpar fila: $e',
      );
    }
  }
  
  /// Dispose resources
  void dispose() {
    _audioPlayer.dispose();
    _currentSongController.close();
    _isPlayingController.close();
    _positionController.close();
    _durationController.close();
    _progressController.close();
  }
}