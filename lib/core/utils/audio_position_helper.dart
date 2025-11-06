import 'dart:async';
import 'package:flutter/foundation.dart';

class AudioPositionHelper {
  DateTime? _startTime;
  Duration _startPosition = Duration.zero;
  Duration _currentPosition = Duration.zero;
  Duration? _maxDuration; 
  bool _isPlaying = false;
  Timer? _updateTimer;
  
  void Function(Duration position)? onPositionUpdate;

  AudioPositionHelper({this.onPositionUpdate, Duration? maxDuration}) 
      : _maxDuration = maxDuration;

  void start({Duration initialPosition = Duration.zero}) {
    _startTime = DateTime.now();
    _startPosition = initialPosition;
    _currentPosition = initialPosition;
    _isPlaying = true;
    
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isPlaying) return;
      
      final now = DateTime.now();
      if (_startTime != null) {
        final elapsed = now.difference(_startTime!);
        _currentPosition = _startPosition + elapsed;
        
        if (_maxDuration != null && _currentPosition >= _maxDuration!) {
          _currentPosition = _maxDuration!;
          _isPlaying = false; 
          timer.cancel();
          debugPrint('⏹️ Posição atingiu duração máxima: ${_maxDuration!.inSeconds}s');
        }
        
        onPositionUpdate?.call(_currentPosition);
      }
    });
  }

  void pause() {
    if (!_isPlaying) return; 
    
    _isPlaying = false;
    if (_startTime != null) {
      final now = DateTime.now();
      final elapsed = now.difference(_startTime!);
      _startPosition = _startPosition + elapsed;
      _currentPosition = _startPosition;
      
      onPositionUpdate?.call(_currentPosition);
    }
  }

  void resume() {
    if (!_isPlaying) {
      _startTime = DateTime.now();
      _isPlaying = true;
    }
  }

  void seek(Duration newPosition) {
    _startPosition = newPosition;
    if (_maxDuration != null && newPosition > _maxDuration!) {
      _currentPosition = _maxDuration!;
    } else {
      _currentPosition = newPosition;
    }
    _startTime = DateTime.now();
    onPositionUpdate?.call(_currentPosition);
  }
  
  void setMaxDuration(Duration? maxDuration) {
    _maxDuration = maxDuration;
    if (_maxDuration != null && _currentPosition > _maxDuration!) {
      _currentPosition = _maxDuration!;
      _isPlaying = false;
      _updateTimer?.cancel();
      onPositionUpdate?.call(_currentPosition);
    }
  }

  Duration get position => _currentPosition;

  void stop() {
    _isPlaying = false;
    _updateTimer?.cancel();
    _updateTimer = null;
    _startTime = null;
    _startPosition = Duration.zero;
    _currentPosition = Duration.zero;
  }

  void dispose() {
    stop();
    onPositionUpdate = null;
  }
}

