import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../features/music_library/domain/entities/song.dart';
import '../utils/audio_position_helper.dart';
import '../routing/app_router.dart';
import '../routing/app_routes.dart';
import 'media_notification_service.dart';
import 'ios_media_controls_service.dart';
import 'ios_now_playing_service.dart';

class AudioPlayerService extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? _currentSong;
  List<Song> _playlist = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  String? _currentPlaylistName;
  Timer? _simulationTimer;
  Timer? _positionPollTimer;
  AudioPositionHelper? _positionHelper;
  final MediaNotificationService _notificationService = MediaNotificationService();
  final IOSMediaControlsService _iosMediaControls = IOSMediaControlsService();
  final IOSNowPlayingService _iosNowPlaying = IOSNowPlayingService();

  Song? get currentSong => _currentSong;
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  String? get currentPlaylistName => _currentPlaylistName;
  double get progress => _duration.inMilliseconds > 0 
      ? _position.inMilliseconds / _duration.inMilliseconds 
      : 0.0;

  AudioPlayerService() {
    _init();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize(
      onAction: _handleNotificationAction,
    );
    // Inicializar controles de mídia do iOS
    await _iosMediaControls.initialize();
    await _iosNowPlaying.initialize();
    
    // Configurar callbacks para comandos de mídia remota do iOS
    _iosNowPlaying.setCommandCallbacks(
      onPlay: resume,
      onPause: pause,
      onNext: next,
      onPrevious: previous,
    );
  }

  void _handleNotificationAction(String actionId) {
    switch (actionId) {
      case 'play_pause':
        togglePlayPause();
        break;
      case 'next':
        next();
        break;
      case 'previous':
        previous();
        break;
      default:
        debugPrint('📱 Ação desconhecida: $actionId');
    }
  }

  Future<void> _updateNotification() async {
    await updateMediaNotification();
  }

  Future<void> updateMediaNotification() async {
    if (_currentSong != null) {
      // Atualizar notificação local
      await _notificationService.updateMediaNotification(
        song: _currentSong!,
        isPlaying: _isPlaying,
      );
      
      // Atualizar controles de mídia nativos do iOS
      await _iosMediaControls.updateNowPlayingInfo(
        song: _currentSong!,
        isPlaying: _isPlaying,
        position: _position,
        duration: _duration,
      );
    }
  }

  Future<void> _showNotification() async {
    await showMediaNotification();
  }

  Future<void> showMediaNotification() async {
    if (_currentSong != null) {
      // Mostrar notificação local (Android e iOS)
      await _notificationService.showMediaNotification(
        song: _currentSong!,
        isPlaying: _isPlaying,
        onPlayPause: togglePlayPause,
        onNext: next,
        onPrevious: previous,
      );
      
      // Atualizar controles de mídia nativos do iOS
      await _iosMediaControls.updateNowPlayingInfo(
        song: _currentSong!,
        isPlaying: _isPlaying,
        position: _position,
        duration: _duration,
      );
    }
  }

  Future<void> _hideNotification() async {
    await _notificationService.hideMediaNotification();
    await _iosMediaControls.clearNowPlayingInfo();
  }

  void _init() {
    _audioPlayer.playerStateStream.listen((state) {
      final wasPlaying = _isPlaying;
      _isPlaying = state.playing;
      
      if (_isPlaying && !wasPlaying) {
        if (_positionHelper != null) {
          debugPrint('🔄 playerStateStream: Retomando helper existente na posição: ${_positionHelper!.position.inSeconds}s');
          _positionHelper!.resume();
        } else {
          debugPrint('🔄 playerStateStream: Criando novo helper na posição: ${_position.inSeconds}s');
          _startPositionPolling();
        }
      } else if (!_isPlaying && wasPlaying) {
        if (_positionHelper != null) {
          final currentPos = _positionHelper!.position;
          _positionHelper!.pause();
          _position = _positionHelper!.position;
          debugPrint('⏸️ playerStateStream: Pausado - posição preservada: ${_position.inSeconds}s (era: ${currentPos.inSeconds}s)');
          
          if (_position == Duration.zero && currentPos != Duration.zero) {
            _position = currentPos;
            debugPrint('⚠️ playerStateStream: Corrigindo posição de 0s para ${currentPos.inSeconds}s');
          }
        }
      }
      
      _updateNotification();
      notifyListeners();
      if (state.processingState == ProcessingState.completed) {
        if (_positionHelper != null) {
          _positionHelper!.stop();
          _position = _duration; 
          debugPrint('✅ Música terminou - posição fixada em: ${_duration.inSeconds}s');
          notifyListeners();
        }
        next();
      }
    });
    
    _audioPlayer.positionStream.listen(
      (position) {
        if (_positionHelper != null) {
          return;
        }
        
        if (position != _position) {
          _position = position;
          notifyListeners();
        }
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
        _positionHelper?.setMaxDuration(_duration);
        // Atualizar controles de mídia do iOS quando a duração mudar
        if (_currentSong != null) {
          _iosMediaControls.updateNowPlayingInfo(
            song: _currentSong!,
            isPlaying: _isPlaying,
            position: _position,
            duration: _duration,
          );
        }
        notifyListeners();
      }
    });
  }
  
  void _startPositionPolling() {
    _stopPositionPolling();
    
    if (_positionHelper != null) {
      _positionHelper!.stop();
      _positionHelper = null;
    }
    
    _positionHelper = AudioPositionHelper(
      onPositionUpdate: (position) {
        if (_duration.inMilliseconds > 0 && position > _duration) {
          _position = _duration;
        } else {
          _position = position;
        }
        notifyListeners();
      },
      maxDuration: _duration.inMilliseconds > 0 ? _duration : null,
    );
    _positionHelper!.start(initialPosition: _position);
    
    debugPrint('🔄 PositionHelper iniciado - posição inicial: ${_position.inSeconds}s');
  }
  
  void _stopPositionPolling() {
    _positionPollTimer?.cancel();
    _positionPollTimer = null;
  }

  Future<void> playSong(Song song) async {
    try {
      debugPrint('🎵 Tocando: ${song.title} - ${song.artist}');
      debugPrint('🎵 URL: ${song.audioUrl}');
      debugPrint('🎵 Duração da API: ${song.duration}');
      _currentSong = song;
      _playlist = [song];
      _currentIndex = 0;
      _currentPlaylistName = null; 
      _preloadDuration(song);
      if (kIsWeb || !await _isAudioPlayerAvailable()) {
        debugPrint('⚠️ Plugin de áudio não disponível, simulando reprodução...');
        _simulatePlayback();
        return;
      }
      await _audioPlayer.setUrl(song.audioUrl);
      
      _stopPositionPolling();
      _positionHelper?.stop();
      _positionHelper = null;
      _position = Duration.zero;
      
      await _audioPlayer.play();
      _startPositionPolling();
      
      await _showNotification();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erro ao tocar música: $e');
      _simulatePlayback();
    }
  }

  Future<void> playPlaylist(List<Song> songs, {int startIndex = 0, String? playlistName}) async {
    if (songs.isEmpty) return;
    try {
      _playlist = songs;
      _currentIndex = startIndex;
      _currentSong = songs[startIndex];
      _currentPlaylistName = playlistName;
      debugPrint('🎵 Tocando playlist: ${songs.length} músicas');
      debugPrint('🎵 Nome da playlist/álbum: ${playlistName ?? "Não especificado"}');
      debugPrint('🎵 Começando em: ${_currentSong!.title}');
      debugPrint('🎵 Duração da API: ${_currentSong!.duration}');
      debugPrint('🎵 ImageUrl da música atual: ${_currentSong!.imageUrl}');
      _preloadDuration(_currentSong!);
      if (kIsWeb || !await _isAudioPlayerAvailable()) {
        debugPrint('⚠️ Plugin de áudio não disponível, simulando playlist...');
        _simulatePlayback();
        return;
      }
      await _audioPlayer.setUrl(_currentSong!.audioUrl);
      
      _stopPositionPolling();
      _positionHelper?.stop();
      _positionHelper = null;
      _position = Duration.zero;
      
      await _audioPlayer.play();
      _startPositionPolling();
      
      await _showNotification();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erro ao tocar playlist: $e');
      _simulatePlayback();
    }
  }

  Future<void> pause() async {
    Duration? savedPosition;
    if (_positionHelper != null) {
      savedPosition = _positionHelper!.position;
      _position = savedPosition;
      debugPrint('⏸️ Pausando na posição: ${_position.inSeconds}s (helper: ${savedPosition.inSeconds}s)');
    } else {
      savedPosition = _position;
      debugPrint('⏸️ Pausando na posição: ${_position.inSeconds}s (sem helper)');
    }
    
    await _audioPlayer.pause();
    _isPlaying = false; 
    
    if (_positionHelper != null) {
      _positionHelper!.pause();
      _position = _positionHelper!.position;
      debugPrint('⏸️ Posição após pausar helper: ${_position.inSeconds}s');
    } else {
      _position = savedPosition ?? Duration.zero;
      debugPrint('⏸️ Posição preservada (sem helper): ${_position.inSeconds}s');
    }
    
    if (_position == Duration.zero && savedPosition != null && savedPosition != Duration.zero) {
      _position = savedPosition;
      debugPrint('⚠️ Corrigindo posição de 0s para ${savedPosition.inSeconds}s');
    }
    
    await _updateNotification();
    notifyListeners();
  }

  Future<void> resume() async {
    await _audioPlayer.play();
    _isPlaying = true; 
    _positionHelper?.resume();
    await _updateNotification();
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
    await _hideNotification();
    notifyListeners();
  }

  Future<void> next() async {
    if (_playlist.isEmpty) {
      _navigateToHome();
      return;
    }
    if (_playlist.length == 1) {
      debugPrint('⏭️ Única música na playlist, parando reprodução');
      _isPlaying = false;
      _position = _duration;
      notifyListeners();
      _navigateToHome();
      return;
    }
    
    final nextIndex = (_currentIndex + 1) % _playlist.length;
    if (nextIndex == 0 && _currentIndex == _playlist.length - 1) {
      debugPrint('⏭️ Última música da playlist, voltando para home');
      _isPlaying = false;
      _position = _duration;
      notifyListeners();
      _navigateToHome();
      return;
    }
    
    _currentIndex = nextIndex;
    _currentSong = _playlist[_currentIndex];
    debugPrint('⏭️ Próxima música: ${_currentSong!.title}');
    _preloadDuration(_currentSong!);
    try {
      if (kIsWeb || !await _isAudioPlayerAvailable()) {
        _simulatePlayback();
        return;
      }
      await _audioPlayer.setUrl(_currentSong!.audioUrl);
      
      _stopPositionPolling();
      _positionHelper?.stop();
      _positionHelper = null;
      _position = Duration.zero;
      
      await _audioPlayer.play();
      _startPositionPolling();
      await _updateNotification();
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
      
      _stopPositionPolling();
      _positionHelper?.stop();
      _positionHelper = null;
      _position = Duration.zero;
      
      await _audioPlayer.play();
      _startPositionPolling();
      await _updateNotification();
    } catch (e) {
      debugPrint('❌ Erro ao tocar música anterior: $e');
      _simulatePlayback();
    }
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
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
      }
    }
  }

  Future<Duration> calculateTotalDuration(List<Song> songs) async {
    if (songs.isEmpty) return Duration.zero;
    int totalSeconds = 0;
    
    for (final song in songs) {
      if (song.duration.isEmpty) continue;
      
      Duration? parsedDuration;
      final durationParts = song.duration.split(':');
      if (durationParts.length == 2) {
        final minutes = int.tryParse(durationParts[0]) ?? 0;
        final seconds = int.tryParse(durationParts[1]) ?? 0;
        parsedDuration = Duration(minutes: minutes, seconds: seconds);
      } else if (durationParts.length == 3) {
        final hours = int.tryParse(durationParts[0]) ?? 0;
        final minutes = int.tryParse(durationParts[1]) ?? 0;
        final seconds = int.tryParse(durationParts[2]) ?? 0;
        parsedDuration = Duration(hours: hours, minutes: minutes, seconds: seconds);
      } else {
        final seconds = int.tryParse(song.duration);
        if (seconds != null && seconds > 0) {
          parsedDuration = Duration(seconds: seconds);
        }
      }
      
      if (parsedDuration != null && parsedDuration.inSeconds > 0) {
        totalSeconds += parsedDuration.inSeconds;
      }
    }
    
    return Duration(seconds: totalSeconds);
  }

  void _preloadDuration(Song song) {
    try {
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
        _duration = parsedDuration;
        debugPrint('🎵 Duração pré-carregada: ${song.title} - ${song.duration} (${parsedDuration.inSeconds}s) = ${parsedDuration.inMinutes}:${(parsedDuration.inSeconds % 60).toString().padLeft(2, '0')}');
        notifyListeners();
      } else {
        debugPrint('⚠️ Formato de duração inválido ou vazio: "${song.duration}"');
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
  
  void _navigateToHome() {
    try {
      AppRouter.router.go(AppRoutes.home);
      debugPrint('🏠 Navegando para home após término da playlist');
    } catch (e) {
      debugPrint('❌ Erro ao navegar para home: $e');
    }
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

