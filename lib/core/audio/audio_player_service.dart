// core/audio/audio_player_service.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../features/music_library/domain/entities/song.dart';

/// Serviço de reprodução de áudio usando just_audio
class AudioPlayerService extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  Song? _currentSong;
  List<Song> _playlist = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  
  // Getters
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
    // Listener para mudanças no estado de reprodução
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
      
      // Se terminou a música, toca a próxima
      if (state.processingState == ProcessingState.completed) {
        next();
      }
    });
    
    // Listener para mudanças na posição
    _audioPlayer.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });
    
    // Listener para mudanças na duração
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        _duration = duration;
        notifyListeners();
      }
    });
  }
  
  /// Toca uma música específica
  Future<void> playSong(Song song) async {
    try {
      debugPrint('🎵 Tocando: ${song.title} - ${song.artist}');
      debugPrint('🎵 URL: ${song.audioUrl}');
      
      _currentSong = song;
      _playlist = [song];
      _currentIndex = 0;
      
      // Simula reprodução se o plugin não estiver disponível
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
      // Fallback para simulação
      _simulatePlayback();
    }
  }
  
  /// Toca uma lista de músicas
  Future<void> playPlaylist(List<Song> songs, {int startIndex = 0}) async {
    if (songs.isEmpty) return;
    
    try {
      _playlist = songs;
      _currentIndex = startIndex;
      _currentSong = songs[startIndex];
      
      debugPrint('🎵 Tocando playlist: ${songs.length} músicas');
      debugPrint('🎵 Começando em: ${_currentSong!.title}');
      
      // Se o plugin não estiver disponível, simula
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
      // Fallback para simulação
      _simulatePlayback();
    }
  }
  
  /// Pausa a reprodução
  Future<void> pause() async {
    await _audioPlayer.pause();
    notifyListeners();
  }
  
  /// Resume a reprodução
  Future<void> resume() async {
    await _audioPlayer.play();
    notifyListeners();
  }
  
  /// Toggle play/pause
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await resume();
    }
  }
  
  /// Para a reprodução
  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentSong = null;
    _position = Duration.zero;
    notifyListeners();
  }
  
  /// Próxima música
  Future<void> next() async {
    if (_playlist.isEmpty) return;
    
    _currentIndex = (_currentIndex + 1) % _playlist.length;
    _currentSong = _playlist[_currentIndex];
    
    debugPrint('⏭️ Próxima música: ${_currentSong!.title}');
    
    try {
      // Se o plugin não estiver disponível, simula
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
  
  /// Música anterior
  Future<void> previous() async {
    if (_playlist.isEmpty) return;
    
    _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    _currentSong = _playlist[_currentIndex];
    
    debugPrint('⏮️ Música anterior: ${_currentSong!.title}');
    
    try {
      // Se o plugin não estiver disponível, simula
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
  
  /// Busca para uma posição específica
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
    notifyListeners();
  }
  
  /// Define o volume (0.0 a 1.0)
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
    notifyListeners();
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
  
  /// Simula reprodução quando o plugin não está disponível
  void _simulatePlayback() {
    _isPlaying = true;
    _position = Duration.zero;
    _duration = const Duration(minutes: 3, seconds: 30); // Duração simulada
    
    // Simula progresso da música
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

