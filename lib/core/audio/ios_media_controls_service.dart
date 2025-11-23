import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:audio_session/audio_session.dart';
import 'ios_now_playing_service.dart';
import '../../features/music_library/domain/entities/song.dart';

class IOSMediaControlsService {
  static final IOSMediaControlsService _instance = IOSMediaControlsService._internal();
  factory IOSMediaControlsService() => _instance;
  IOSMediaControlsService._internal();

  AudioSession? _audioSession;
  final IOSNowPlayingService _nowPlayingService = IOSNowPlayingService();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!Platform.isIOS || _isInitialized) return;

    try {
      _audioSession = await AudioSession.instance;
      await _audioSession!.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: false,
      ));

      await _nowPlayingService.initialize();
      _isInitialized = true;
      debugPrint('✅ IOSMediaControlsService inicializado');
    } catch (e) {
      debugPrint('❌ Erro ao inicializar IOSMediaControlsService: $e');
    }
  }

  Future<void> updateNowPlayingInfo({
    required Song song,
    required bool isPlaying,
    Duration? position,
    Duration? duration,
  }) async {
    if (!Platform.isIOS || !_isInitialized) {
      debugPrint('⚠️ IOSMediaControlsService: Não inicializado ou não é iOS');
      return;
    }

    try {
      // Garantir que o audio session está ativo
      await _audioSession?.setActive(true);
      
      // Atualizar MPNowPlayingInfoCenter através do método nativo
      await _nowPlayingService.updateNowPlayingInfo(
        song: song,
        isPlaying: isPlaying,
        position: position,
        duration: duration,
      );
      
      debugPrint('📱 MPNowPlayingInfoCenter atualizado: ${song.title}');
    } catch (e) {
      debugPrint('❌ Erro ao atualizar MPNowPlayingInfoCenter: $e');
    }
  }

  Future<void> clearNowPlayingInfo() async {
    if (!Platform.isIOS || !_isInitialized) return;

    try {
      await _nowPlayingService.clearNowPlayingInfo();
      debugPrint('📱 MPNowPlayingInfoCenter limpo');
    } catch (e) {
      debugPrint('❌ Erro ao limpar MPNowPlayingInfoCenter: $e');
    }
  }
}

