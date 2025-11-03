import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../features/music_library/domain/entities/song.dart';
import '../utils/audio_position_helper.dart';

class AudioPlayerService extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? _currentSong;
  List<Song> _playlist = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  Timer? _simulationTimer;
  Timer? _positionPollTimer;
  AudioPositionHelper? _positionHelper;

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
      final wasPlaying = _isPlaying;
      _isPlaying = state.playing;
      
      // Gerenciar positionHelper baseado no estado de reprodução
      if (_isPlaying && !wasPlaying) {
        // Começou a tocar - iniciar positionHelper
        _startPositionPolling();
      } else if (!_isPlaying && wasPlaying) {
        // Pausou - pausar positionHelper
        _positionHelper?.pause();
      }
      
      notifyListeners();
      if (state.processingState == ProcessingState.completed) {
        next();
      }
    });
    
    // O positionStream do just_audio DEVERIA atualizar automaticamente
    // Ele é a fonte principal da posição. O timer só força notifyListeners()
    _audioPlayer.positionStream.listen(
      (position) {
        final oldPosition = _position;
        _position = position;
        
        // Log quando mudar significativamente para debug
        if (position.inSeconds != oldPosition.inSeconds) {
          debugPrint('📡 PositionStream: ${oldPosition.inSeconds}s -> ${position.inSeconds}s');
        }
        
        // Notificar sempre que o stream emitir
        notifyListeners();
      },
      onError: (error) {
        debugPrint('❌ PositionStream error: $error');
      },
      cancelOnError: false,
    );
    
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null && duration.inSeconds > 0) {
        if (_duration != duration) {
          debugPrint('🎵 Duração atualizada: ${_duration.inSeconds}s -> ${duration.inSeconds}s');
        }
        _duration = duration;
        notifyListeners();
      }
    });
  }
  
  void _startPositionPolling() {
    _stopPositionPolling();
    
    // Usar AudioPositionHelper para calcular posição manualmente
    // já que o positionStream não funciona durante reprodução no iOS
    _positionHelper?.dispose();
    _positionHelper = AudioPositionHelper(
      onPositionUpdate: (position) {
        _position = position;
        notifyListeners();
      },
    );
    _positionHelper!.start(initialPosition: _position);
    
    debugPrint('🔄 PositionHelper iniciado - posição inicial: ${_position.inSeconds}s');
  }
  
  void _stopPositionPolling() {
    _positionPollTimer?.cancel();
    _positionPollTimer = null;
    _positionHelper?.pause();
  }

  Future<void> playSong(Song song) async {
    try {
      debugPrint('🎵 Tocando: ${song.title} - ${song.artist}');
      debugPrint('🎵 URL: ${song.audioUrl}');
      debugPrint('🎵 Duração da API: ${song.duration}');
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
      
      // Resetar posição e iniciar positionHelper
      _position = Duration.zero;
      _startPositionPolling();
      
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
      debugPrint('🎵 Duração da API: ${_currentSong!.duration}');
      _preloadDuration(_currentSong!);
      if (kIsWeb || !await _isAudioPlayerAvailable()) {
        debugPrint('⚠️ Plugin de áudio não disponível, simulando playlist...');
        _simulatePlayback();
        return;
      }
      await _audioPlayer.setUrl(_currentSong!.audioUrl);
      await _audioPlayer.play();
      
      // Resetar posição e iniciar positionHelper
      _position = Duration.zero;
      _startPositionPolling();
      
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
    // Retomar positionHelper
    _positionHelper?.resume();
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
    // Se há apenas uma música na playlist, não há próxima música para tocar
    if (_playlist.length == 1) {
      debugPrint('⏭️ Única música na playlist, parando reprodução');
      _isPlaying = false;
      _position = _duration;
      notifyListeners();
      return;
    }
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
      
      // Resetar posição e reiniciar positionHelper
      _position = Duration.zero;
      _startPositionPolling();
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
      
      // Resetar posição e reiniciar positionHelper
      _position = Duration.zero;
      _startPositionPolling();
    } catch (e) {
      debugPrint('❌ Erro ao tocar música anterior: $e');
      _simulatePlayback();
    }
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
    // Atualizar positionHelper após seek
    _positionHelper?.seek(position);
    _position = position;
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

  Future<Duration?> getSongDuration(String audioUrlOrPath) async {
    AudioPlayer? tempPlayer;
    StreamSubscription<Duration?>? subscription;
    try {
      if (audioUrlOrPath.startsWith('file://')) {
        final filePath = audioUrlOrPath.substring(7);
        if (!await File(filePath).exists()) {
          debugPrint('⚠️ Arquivo não existe: $filePath');
          return null;
        }
      }
      
      tempPlayer = AudioPlayer();
      await tempPlayer.setUrl(audioUrlOrPath);
      
      Duration? duration;
      final completer = Completer<Duration?>();
      
      subscription = tempPlayer.durationStream.timeout(
        const Duration(seconds: 10),
        onTimeout: (sink) {
          sink.close();
          completer.complete(null);
        },
      ).listen((d) {
        if (d != null) {
          duration = d;
          completer.complete(d);
          subscription?.cancel();
        }
      });
      
      await Future.any([
        completer.future,
        Future.delayed(const Duration(seconds: 11)),
      ]);
      
      return duration;
    } catch (e) {
      if (e.toString().contains('(-11800)')) {
        debugPrint('⚠️ Erro iOS ao obter duração (pode ser temporário): $audioUrlOrPath');
      } else {
        debugPrint('❌ Erro ao obter duração da música: $e');
      }
      return null;
    } finally {
      try {
        await subscription?.cancel();
        await tempPlayer?.stop();
        await tempPlayer?.dispose();
      } catch (e) {
        // Ignorar erros ao liberar recursos
      }
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
        // Fallback para duração da API se não conseguir obter do arquivo
        Duration? parsedDuration;
        final durationParts = song.duration.split(':');
        if (durationParts.length == 2) {
          final minutes = int.tryParse(durationParts[0]) ?? 0;
          final seconds = int.tryParse(durationParts[1]) ?? 0;
          parsedDuration = Duration(minutes: minutes, seconds: seconds);
        } else {
          final seconds = int.tryParse(song.duration);
          if (seconds != null && seconds > 0) {
            parsedDuration = Duration(seconds: seconds);
          }
        }
        
        if (parsedDuration != null && parsedDuration.inSeconds > 0) {
          totalSeconds += parsedDuration.inSeconds;
          debugPrint('🎵 Duração fallback de "${song.title}": ${song.duration} (${parsedDuration.inSeconds}s)');
        } else {
          totalSeconds += 210; // Duração padrão
          debugPrint('🎵 Duração padrão para "${song.title}": 3:30');
        }
      }
    }
    return Duration(seconds: totalSeconds);
  }

  void _preloadDuration(Song song) {
    try {
      Duration? parsedDuration;
      
      // Tentar parsear a duração da API (formato MM:SS ou segundos como int)
      final durationParts = song.duration.split(':');
      if (durationParts.length == 2) {
        final minutes = int.tryParse(durationParts[0]) ?? 0;
        final seconds = int.tryParse(durationParts[1]) ?? 0;
        parsedDuration = Duration(minutes: minutes, seconds: seconds);
      } else {
        // Tentar parsear como segundos diretos
        final seconds = int.tryParse(song.duration);
        if (seconds != null && seconds > 0) {
          parsedDuration = Duration(seconds: seconds);
        }
      }
      
      if (parsedDuration != null && parsedDuration.inSeconds > 0) {
        _duration = parsedDuration;
        debugPrint('🎵 Duração pré-carregada: ${song.title} - ${song.duration} (${parsedDuration.inSeconds}s) = ${parsedDuration.inMinutes}:${(parsedDuration.inSeconds % 60).toString().padLeft(2, '0')}');
        notifyListeners();
      } else {
        debugPrint('⚠️ Formato de duração inválido ou vazio: "${song.duration}"');
        // Se a duração não puder ser parseada, aguardar o durationStream do just_audio
      }
    } catch (e) {
      debugPrint('❌ Erro ao pré-carregar duração: $e');
    }
  }

  void _simulatePlayback() {
    _simulationTimer?.cancel();
    
    _isPlaying = true;
    _position = Duration.zero;
    if (_duration == Duration.zero) {
      _duration = const Duration(minutes: 3, seconds: 30);
    }
    _simulationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPlaying) {
        timer.cancel();
        _simulationTimer = null;
        return;
      }
      _position += const Duration(seconds: 1);
      if (_position >= _duration) {
        _position = _duration;
        _isPlaying = false;
        timer.cancel();
        _simulationTimer = null;
        notifyListeners();
        next();
        return;
      }
      notifyListeners();
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _stopPositionPolling();
    _positionHelper?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
