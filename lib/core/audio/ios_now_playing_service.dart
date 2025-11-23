import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../features/music_library/domain/entities/song.dart';

class IOSNowPlayingService {
  static final IOSNowPlayingService _instance = IOSNowPlayingService._internal();
  factory IOSNowPlayingService() => _instance;
  IOSNowPlayingService._internal();

  static const MethodChannel _channel = MethodChannel('com.ehitapp/now_playing');
  bool _isInitialized = false;
  Function()? _onPlay;
  Function()? _onPause;
  Function()? _onNext;
  Function()? _onPrevious;

  Future<void> initialize() async {
    if (!Platform.isIOS || _isInitialized) return;

    try {
      // Configurar listeners para comandos de mídia remota
      _channel.setMethodCallHandler(_handleMethodCall);
      _isInitialized = true;
      debugPrint('✅ IOSNowPlayingService inicializado');
    } catch (e) {
      debugPrint('❌ Erro ao inicializar IOSNowPlayingService: $e');
    }
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    debugPrint('📱 Comando de mídia recebido: ${call.method}');
    
    switch (call.method) {
      case 'play':
        _onPlay?.call();
        break;
      case 'pause':
        _onPause?.call();
        break;
      case 'next':
        _onNext?.call();
        break;
      case 'previous':
        _onPrevious?.call();
        break;
    }
    
    return null;
  }

  Future<void> updateNowPlayingInfo({
    required Song song,
    required bool isPlaying,
    Duration? position,
    Duration? duration,
  }) async {
    if (!Platform.isIOS || !_isInitialized) return;

    try {
      await _channel.invokeMethod('updateNowPlaying', {
        'title': song.title,
        'artist': song.artist,
        'album': song.album ?? '',
        'artworkUrl': song.imageUrl,
        'isPlaying': isPlaying,
        'position': position?.inMilliseconds ?? 0,
        'duration': duration?.inMilliseconds ?? 0,
      });
      debugPrint('📱 MPNowPlayingInfoCenter atualizado: ${song.title}');
    } catch (e) {
      debugPrint('❌ Erro ao atualizar MPNowPlayingInfoCenter: $e');
    }
  }

  Future<void> clearNowPlayingInfo() async {
    if (!Platform.isIOS || !_isInitialized) return;

    try {
      await _channel.invokeMethod('clearNowPlaying');
      debugPrint('📱 MPNowPlayingInfoCenter limpo');
    } catch (e) {
      debugPrint('❌ Erro ao limpar MPNowPlayingInfoCenter: $e');
    }
  }

  void setCommandCallbacks({
    Function()? onPlay,
    Function()? onPause,
    Function()? onNext,
    Function()? onPrevious,
  }) {
    _onPlay = onPlay;
    _onPause = onPause;
    _onNext = onNext;
    _onPrevious = onPrevious;
    debugPrint('✅ Callbacks de comandos de mídia configurados');
  }
}

