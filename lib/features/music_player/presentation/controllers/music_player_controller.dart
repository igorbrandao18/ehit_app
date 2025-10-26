import 'package:flutter/foundation.dart';
enum PlayerState { stopped, playing, paused, loading }
class MusicPlayerController extends ChangeNotifier {
  PlayerState _state = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = const Duration(minutes: 4, seconds: 19);
  bool _isShuffled = false;
  bool _isRepeating = false;
  PlayerState get state => _state;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get isPlaying => _state == PlayerState.playing;
  bool get isPaused => _state == PlayerState.paused;
  bool get isLoading => _state == PlayerState.loading;
  bool get isShuffled => _isShuffled;
  bool get isRepeating => _isRepeating;
  void togglePlayPause() {
    if (_state == PlayerState.playing) {
      pause();
    } else if (_state == PlayerState.paused) {
      resume();
    } else {
      play();
    }
  }
  void play() {
    _state = PlayerState.playing;
    notifyListeners();
    _simulatePlayback();
  }
  void pause() {
    _state = PlayerState.paused;
    notifyListeners();
  }
  void resume() {
    _state = PlayerState.playing;
    notifyListeners();
    _simulatePlayback();
  }
  void stop() {
    _state = PlayerState.stopped;
    _position = Duration.zero;
    notifyListeners();
  }
  void seekTo(Duration position) {
    _position = position;
    notifyListeners();
  }
  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    notifyListeners();
  }
  void toggleRepeat() {
    _isRepeating = !_isRepeating;
    notifyListeners();
  }
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
