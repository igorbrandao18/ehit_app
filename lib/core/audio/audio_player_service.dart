import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../features/music_library/domain/entities/song.dart';
class AudioPlayerService extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? _currentSong;
  List<Song> _playlist = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  Song? get currentSong => _currentSong;
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  double get progress => _duration.inMilliseconds > 0 
      ? _position.inMilliseconds / _duration.inMilliseconds 
      : 0.0;
  AudioPlayerService() {
    _init();
  }
  void _init() {
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
      if (state.processingState == ProcessingState.completed) {
        next();
      }
    });
    _audioPlayer.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        _duration = duration;
        notifyListeners();
      }
    });
  }
  Future<void> playSong(Song song) async {
    try {
      debugPrint('🎵 Tocando: ${song.title} - ${song.artist}');
      debugPrint('🎵 URL: ${song.audioUrl}');
      _currentSong = song;
      _playlist = [song];
      _currentIndex = 0;
      _preloadDuration(song);
      if (kIsWeb || !await _isAudioPlayerAvailable()) {
        debugPrint('⚠️ Plugin de áudio não disponível, simulando reprodução...');
        _simulatePlayback();
        return;
      }
      await _audioPlayer.setUrl(song.audioUrl);
      await _audioPlayer.play();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erro ao tocar música: $e');
      _simulatePlayback();
    }
  }
  Future<void> playPlaylist(List<Song> songs, {int startIndex = 0}) async {
    if (songs.isEmpty) return;
    try {
      _playlist = songs;
      _currentIndex = startIndex;
      _currentSong = songs[startIndex];
      debugPrint('🎵 Tocando playlist: ${songs.length} músicas');
      debugPrint('🎵 Começando em: ${_currentSong!.title}');
      _preloadDuration(_currentSong!);
      if (kIsWeb || !await _isAudioPlayerAvailable()) {
        debugPrint('⚠️ Plugin de áudio não disponível, simulando playlist...');
        _simulatePlayback();
        return;
      }
      await _audioPlayer.setUrl(_currentSong!.audioUrl);
      await _audioPlayer.play();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erro ao tocar playlist: $e');
      _simulatePlayback();
    }
  }
  Future<void> pause() async {
    await _audioPlayer.pause();
    notifyListeners();
  }
  Future<void> resume() async {
    await _audioPlayer.play();
    notifyListeners();
  }
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await resume();
    }
  }
  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentSong = null;
    _position = Duration.zero;
    notifyListeners();
  }
  Future<void> next() async {
    if (_playlist.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _playlist.length;
    _currentSong = _playlist[_currentIndex];
    debugPrint('⏭️ Próxima música: ${_currentSong!.title}');
    _preloadDuration(_currentSong!);
    try {
      if (kIsWeb || !await _isAudioPlayerAvailable()) {
        _simulatePlayback();
        return;
      }
      await _audioPlayer.setUrl(_currentSong!.audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('❌ Erro ao tocar próxima música: $e');
      _simulatePlayback();
    }
    notifyListeners();
  }
  Future<void> previous() async {
    if (_playlist.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    _currentSong = _playlist[_currentIndex];
    debugPrint('⏮️ Música anterior: ${_currentSong!.title}');
    _preloadDuration(_currentSong!);
    try {
      if (kIsWeb || !await _isAudioPlayerAvailable()) {
        _simulatePlayback();
        return;
      }
      await _audioPlayer.setUrl(_currentSong!.audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('❌ Erro ao tocar música anterior: $e');
      _simulatePlayback();
    }
    notifyListeners();
  }
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
    notifyListeners();
  }
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
    notifyListeners();
  }
  Future<bool> _isAudioPlayerAvailable() async {
    try {
      if (kIsWeb) {
        debugPrint('⚠️ Executando em web, usando simulação de áudio');
        return false;
      }
      return true;
    } catch (e) {
      debugPrint('⚠️ Plugin de áudio não disponível: $e');
      return false;
    }
  }
  Future<Duration?> getSongDuration(String audioUrl) async {
    try {
      if (kIsWeb || !await _isAudioPlayerAvailable()) {
        debugPrint('⚠️ Plugin de áudio não disponível para obter duração');
        return null;
      }
      final tempPlayer = AudioPlayer();
      await tempPlayer.setUrl(audioUrl);
      Duration? duration;
      await for (final d in tempPlayer.durationStream) {
        if (d != null) {
          duration = d;
          break;
        }
      }
      await tempPlayer.dispose();
      return duration;
    } catch (e) {
      debugPrint('❌ Erro ao obter duração da música: $e');
      return null;
    }
  }
  Future<Duration> calculateTotalDuration(List<Song> songs) async {
    if (songs.isEmpty) return Duration.zero;
    int totalSeconds = 0;
    for (final song in songs) {
      final realDuration = await getSongDuration(song.audioUrl);
      if (realDuration != null) {
        totalSeconds += realDuration.inSeconds;
        debugPrint('🎵 Duração real de "${song.title}": ${realDuration.inMinutes}:${(realDuration.inSeconds % 60).toString().padLeft(2, '0')}');
      } else {
        final durationParts = song.duration.split(':');
        if (durationParts.length == 2) {
          final minutes = int.tryParse(durationParts[0]) ?? 0;
          final seconds = int.tryParse(durationParts[1]) ?? 0;
          totalSeconds += minutes * 60 + seconds;
          debugPrint('🎵 Duração fallback de "${song.title}": ${song.duration}');
        } else {
          totalSeconds += 210; 
          debugPrint('🎵 Duração padrão para "${song.title}": 3:30');
        }
      }
    }
    return Duration(seconds: totalSeconds);
  }
  void _preloadDuration(Song song) {
    try {
      final durationParts = song.duration.split(':');
      if (durationParts.length == 2) {
        final minutes = int.tryParse(durationParts[0]) ?? 0;
        final seconds = int.tryParse(durationParts[1]) ?? 0;
        _duration = Duration(minutes: minutes, seconds: seconds);
        debugPrint('🎵 Duração pré-carregada: ${song.title} - ${song.duration}');
        notifyListeners();
      } else {
        debugPrint('⚠️ Formato de duração inválido: ${song.duration}');
      }
    } catch (e) {
      debugPrint('❌ Erro ao pré-carregar duração: $e');
    }
  }
  void _simulatePlayback() {
    _isPlaying = true;
    _position = Duration.zero;
    if (_duration == Duration.zero) {
      _duration = const Duration(minutes: 3, seconds: 30);
    }
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPlaying) {
        timer.cancel();
        return;
      }
      _position += const Duration(seconds: 1);
      if (_position >= _duration) {
        _position = _duration;
        _isPlaying = false;
        timer.cancel();
      }
      notifyListeners();
    });
    notifyListeners();
  }
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
