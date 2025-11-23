import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';
import '../../features/music_library/domain/entities/song.dart';

class MediaNotificationService {
  static final MediaNotificationService _instance = MediaNotificationService._internal();
  factory MediaNotificationService() => _instance;
  MediaNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  Song? _currentSong;
  bool _isPlaying = false;
  Function(String)? _onActionCallback;

  Future<void> initialize({Function(String)? onAction}) async {
    if (_isInitialized) {
      _onActionCallback = onAction;
      return;
    }

    _onActionCallback = onAction;

    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    final initialized = await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    debugPrint('📱 Notificações inicializadas: $initialized');

    // Solicitar permissões explicitamente
    if (Platform.isAndroid) {
      final androidImplementation = _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        final granted = await androidImplementation.requestNotificationsPermission();
        debugPrint('📱 Permissão Android: $granted');
      }
    } else if (Platform.isIOS) {
      final iosImplementation = _notifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      if (iosImplementation != null) {
        final granted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        debugPrint('📱 Permissão iOS: $granted');
      }
    }

    // Configurar canal Android para notificações de mídia
    if (Platform.isAndroid) {
      const androidChannel = AndroidNotificationChannel(
        'media_playback',
        'Reprodução de Música',
        description: 'Notificações de controle de reprodução de música',
        importance: Importance.high,
        playSound: false,
        enableVibration: false,
      );

      await _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    }

    _isInitialized = true;
    debugPrint('✅ MediaNotificationService inicializado');
  }

  void _onNotificationTap(NotificationResponse response) {
    final actionId = response.actionId ?? '';
    debugPrint('📱 Notificação tocada: $actionId');
    if (_onActionCallback != null && actionId.isNotEmpty) {
      _onActionCallback!(actionId);
    }
  }

  Future<void> showMediaNotification({
    required Song song,
    required bool isPlaying,
    Function()? onPlayPause,
    Function()? onNext,
    Function()? onPrevious,
  }) async {
    debugPrint('🔔 showMediaNotification chamado: ${song.title}, isPlaying: $isPlaying');
    
    if (!_isInitialized) {
      debugPrint('⚠️ Serviço não inicializado, inicializando...');
      await initialize();
    }

    _currentSong = song;
    _isPlaying = isPlaying;

    final androidDetails = AndroidNotificationDetails(
      'media_playback',
      'Reprodução de Música',
      channelDescription: 'Controles de reprodução de música',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      playSound: false,
      enableVibration: false,
      visibility: NotificationVisibility.public,
      actions: [
        AndroidNotificationAction(
          'previous',
          'Anterior',
          showsUserInterface: false,
        ),
        AndroidNotificationAction(
          'play_pause',
          isPlaying ? 'Pausar' : 'Reproduzir',
          showsUserInterface: false,
        ),
        AndroidNotificationAction(
          'next',
          'Próxima',
          showsUserInterface: false,
        ),
      ],
      styleInformation: const MediaStyleInformation(),
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
      categoryIdentifier: 'media_controls',
      interruptionLevel: InterruptionLevel.active,
      threadIdentifier: 'media_playback',
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.show(
        1,
        song.title,
        song.artist,
        details,
        payload: song.id,
      );
      debugPrint('✅ Notificação de mídia exibida com sucesso: ${song.title}');
      
      // No iOS, garantir que a notificação seja persistente
      if (Platform.isIOS) {
        // A notificação já foi exibida, mas vamos garantir que está visível
        debugPrint('📱 iOS: Notificação deve aparecer na tela bloqueada');
      }
    } catch (e) {
      debugPrint('❌ Erro ao exibir notificação: $e');
      rethrow;
    }
  }

  Future<void> updateMediaNotification({
    required Song song,
    required bool isPlaying,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    _currentSong = song;
    _isPlaying = isPlaying;

    final androidDetails = AndroidNotificationDetails(
      'media_playback',
      'Reprodução de Música',
      channelDescription: 'Controles de reprodução de música',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      playSound: false,
      enableVibration: false,
      visibility: NotificationVisibility.public,
      actions: [
        const AndroidNotificationAction(
          'previous',
          'Anterior',
          showsUserInterface: false,
        ),
        AndroidNotificationAction(
          'play_pause',
          isPlaying ? 'Pausar' : 'Reproduzir',
          showsUserInterface: false,
        ),
        const AndroidNotificationAction(
          'next',
          'Próxima',
          showsUserInterface: false,
        ),
      ],
      styleInformation: const MediaStyleInformation(),
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
      categoryIdentifier: 'media_controls',
      interruptionLevel: InterruptionLevel.active,
      threadIdentifier: 'media_playback',
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      1,
      song.title,
      song.artist,
      details,
      payload: song.id,
    );
  }

  Future<void> hideMediaNotification() async {
    if (!_isInitialized) return;
    await _notifications.cancel(1);
    debugPrint('📱 Notificação de mídia ocultada');
  }

  Future<void> handleNotificationAction(String actionId) async {
    debugPrint('🎮 Ação de notificação: $actionId');
    // As ações serão tratadas pelo AudioPlayerService
  }
}

