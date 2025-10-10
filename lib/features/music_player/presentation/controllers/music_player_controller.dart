// features/music_player/presentation/controllers/music_player_controller.dart
import 'package:flutter/foundation.dart';

enum PlayerState { stopped, playing, paused, loading }

class MusicPlayerController extends ChangeNotifier {
  PlayerState _state = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = const Duration(minutes: 4, seconds: 19);
  bool _isShuffled = false;
  bool _isRepeating = false;

  // Getters
  PlayerState get state => _state;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get isPlaying => _state == PlayerState.playing;
  bool get isPaused => _state == PlayerState.paused;
  bool get isLoading => _state == PlayerState.loading;
  bool get isShuffled => _isShuffled;
  bool get isRepeating => _isRepeating;

  // Play/Pause toggle
  void togglePlayPause() {
    if (_state == PlayerState.playing) {
      pause();
    } else if (_state == PlayerState.paused) {
      resume();
    } else {
      play();
    }
  }

  // Play
  void play() {
    _state = PlayerState.playing;
    notifyListeners();
    _simulatePlayback();
  }

  // Pause
  void pause() {
    _state = PlayerState.paused;
    notifyListeners();
  }

  // Resume
  void resume() {
    _state = PlayerState.playing;
    notifyListeners();
    _simulatePlayback();
  }

  // Stop
  void stop() {
    _state = PlayerState.stopped;
    _position = Duration.zero;
    notifyListeners();
  }

  // Seek to position
  void seekTo(Duration position) {
    _position = position;
    notifyListeners();
  }

  // Toggle shuffle
  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    notifyListeners();
  }

  // Toggle repeat
  void toggleRepeat() {
    _isRepeating = !_isRepeating;
    notifyListeners();
  }

  // Simulate playback progress
  void _simulatePlayback() {
    if (_state != PlayerState.playing) return;
    
    Future.delayed(const Duration(seconds: 1), () {
      if (_state == PlayerState.playing) {
        _position = Duration(seconds: _position.inSeconds + 1);
        
        if (_position >= _duration) {
          if (_isRepeating) {
            _position = Duration.zero;
          } else {
            stop();
            return;
          }
        }
        
        notifyListeners();
        _simulatePlayback();
      }
    });
  }
}