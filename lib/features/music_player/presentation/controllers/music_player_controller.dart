// features/music_player/presentation/controllers/music_player_controller.dart
import 'package:flutter/foundation.dart';
import '../../../music_library/domain/entities/song.dart';

enum PlayerState { stopped, playing, paused, loading }

class MusicPlayerController extends ChangeNotifier {
  Song? _currentSong;
  PlayerState _state = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isShuffled = false;
  bool _isRepeating = false;
  List<Song> _queue = [];
  int _currentIndex = 0;

  // Getters
  Song? get currentSong => _currentSong;
  PlayerState get state => _state;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get isPlaying => _state == PlayerState.playing;
  bool get isPaused => _state == PlayerState.paused;
  bool get isLoading => _state == PlayerState.loading;
  bool get isShuffled => _isShuffled;
  bool get isRepeating => _isRepeating;
  List<Song> get queue => _queue;
  int get currentIndex => _currentIndex;

  // Play a song
  void playSong(Song song) {
    _currentSong = song;
    _duration = song.duration;
    _position = Duration.zero;
    _state = PlayerState.playing;
    notifyListeners();
    
    // TODO: Implement actual audio playback
    _simulatePlayback();
  }

  // Play/Pause toggle
  void togglePlayPause() {
    if (_currentSong == null) return;
    
    if (_state == PlayerState.playing) {
      pause();
    } else if (_state == PlayerState.paused) {
      resume();
    }
  }

  // Pause playback
  void pause() {
    if (_state == PlayerState.playing) {
      _state = PlayerState.paused;
      notifyListeners();
    }
  }

  // Resume playback
  void resume() {
    if (_state == PlayerState.paused) {
      _state = PlayerState.playing;
      notifyListeners();
    }
  }

  // Stop playback
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

  // Skip to next song
  void skipNext() {
    if (_queue.isEmpty) return;
    
    _currentIndex = (_currentIndex + 1) % _queue.length;
    playSong(_queue[_currentIndex]);
  }

  // Skip to previous song
  void skipPrevious() {
    if (_queue.isEmpty) return;
    
    _currentIndex = _currentIndex > 0 ? _currentIndex - 1 : _queue.length - 1;
    playSong(_queue[_currentIndex]);
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

  // Set queue
  void setQueue(List<Song> songs, {int startIndex = 0}) {
    _queue = songs;
    _currentIndex = startIndex;
    if (songs.isNotEmpty) {
      playSong(songs[startIndex]);
    }
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
            skipNext();
            return;
          }
        }
        
        notifyListeners();
        _simulatePlayback();
      }
    });
  }
}
