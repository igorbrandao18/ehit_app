import 'package:flutter/foundation.dart';
import 'dart:async';
import '../../../../core/utils/result.dart';
import '../../../../features/music_library/domain/entities/song.dart';
import '../../domain/usecases/play_song_usecase.dart';
import '../../domain/usecases/audio_player_usecases.dart';
import '../../domain/repositories/audio_player_repository.dart';
class AudioPlayerController extends ChangeNotifier {
  final PlaySongUseCase _playSongUseCase;
  final TogglePlayPauseUseCase _togglePlayPauseUseCase;
  final NextSongUseCase _nextSongUseCase;
  final GetCurrentSongUseCase _getCurrentSongUseCase;
  final IsPlayingUseCase _isPlayingUseCase;
  final GetProgressUseCase _getProgressUseCase;
  final GetCurrentPositionUseCase _getCurrentPositionUseCase;
  final GetDurationUseCase _getDurationUseCase;
  final AudioPlayerRepository _repository;
  Song? _currentSong;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _progress = 0.0;
  String? _errorMessage;
  bool _isLoading = false;
  StreamSubscription<Song?>? _currentSongSubscription;
  StreamSubscription<bool>? _isPlayingSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<double>? _progressSubscription;
  AudioPlayerController({
    required PlaySongUseCase playSongUseCase,
    required TogglePlayPauseUseCase togglePlayPauseUseCase,
    required NextSongUseCase nextSongUseCase,
    required GetCurrentSongUseCase getCurrentSongUseCase,
    required IsPlayingUseCase isPlayingUseCase,
    required GetProgressUseCase getProgressUseCase,
    required GetCurrentPositionUseCase getCurrentPositionUseCase,
    required GetDurationUseCase getDurationUseCase,
    required AudioPlayerRepository repository,
  }) : _playSongUseCase = playSongUseCase,
       _togglePlayPauseUseCase = togglePlayPauseUseCase,
       _nextSongUseCase = nextSongUseCase,
       _getCurrentSongUseCase = getCurrentSongUseCase,
       _isPlayingUseCase = isPlayingUseCase,
       _getProgressUseCase = getProgressUseCase,
       _getCurrentPositionUseCase = getCurrentPositionUseCase,
       _getDurationUseCase = getDurationUseCase,
       _repository = repository {
    _initializeState();
  }
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  double get progress => _progress;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  void _initializeState() {
    _currentSongSubscription = _repository.currentSongStream.listen((song) {
      _currentSong = song;
      notifyListeners();
    });
    _isPlayingSubscription = _repository.isPlayingStream.listen((playing) {
      _isPlaying = playing;
      notifyListeners();
    });
    _positionSubscription = _repository.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });
    _durationSubscription = _repository.durationStream.listen((duration) {
      _duration = duration;
      notifyListeners();
    });
    _progressSubscription = _repository.progressStream.listen((progress) {
      _progress = progress;
      notifyListeners();
    });
    _loadCurrentState();
  }
  Future<void> _loadCurrentState() async {
    final songResult = await _getCurrentSongUseCase();
    final playingResult = await _isPlayingUseCase();
    final positionResult = await _getCurrentPositionUseCase();
    final durationResult = await _getDurationUseCase();
    final progressResult = await _getProgressUseCase();
    songResult.when(
      success: (song) => _currentSong = song,
      error: (message, code) => _errorMessage = message,
    );
    playingResult.when(
      success: (playing) => _isPlaying = playing,
      error: (message, code) => _errorMessage = message,
    );
    positionResult.when(
      success: (pos) => _position = pos,
      error: (message, code) => _errorMessage = message,
    );
    durationResult.when(
      success: (dur) => _duration = dur,
      error: (message, code) => _errorMessage = message,
    );
    progressResult.when(
      success: (prog) => _progress = prog,
      error: (message, code) => _errorMessage = message,
    );
    notifyListeners();
  }
  Future<void> playSong(Song song) async {
    _setLoading(true);
    _clearError();
    final result = await _playSongUseCase(song);
    result.when(
      success: (_) {
        _currentSong = song;
        notifyListeners();
      },
      error: (message, code) {
        _errorMessage = message;
        notifyListeners();
      },
    );
    _setLoading(false);
  }
  Future<void> togglePlayPause() async {
    _clearError();
    final result = await _togglePlayPauseUseCase();
    result.when(
      success: (_) {
        _isPlaying = !_isPlaying;
        notifyListeners();
      },
      error: (message, code) {
        _errorMessage = message;
        notifyListeners();
      },
    );
  }
  Future<void> next() async {
    _clearError();
    final result = await _nextSongUseCase();
    result.when(
      success: (_) {
      },
      error: (message, code) {
        _errorMessage = message;
        notifyListeners();
      },
    );
  }
  Future<void> previous() async {
    _clearError();
    final result = await _repository.previous();
    result.when(
      success: (_) {
      },
      error: (message, code) {
        _errorMessage = message;
        notifyListeners();
      },
    );
  }
  Future<void> seekTo(Duration position) async {
    _clearError();
    final result = await _repository.seekTo(position);
    result.when(
      success: (_) {
      },
      error: (message, code) {
        _errorMessage = message;
        notifyListeners();
      },
    );
  }
  Future<void> setPlaylist(List<Song> songs) async {
    _clearError();
    final result = await _repository.setPlaylist(songs);
    result.when(
      success: (_) {
        debugPrint('AudioPlayerController: Playlist set with ${songs.length} songs');
      },
      error: (message, code) {
        _errorMessage = message;
        notifyListeners();
      },
    );
  }
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  void _clearError() {
    _errorMessage = null;
  }
  @override
  void dispose() {
    _currentSongSubscription?.cancel();
    _isPlayingSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _progressSubscription?.cancel();
    super.dispose();
  }
}
