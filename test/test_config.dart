// test/test_config.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ehit_app/features/music_player/presentation/controllers/music_player_controller.dart';
import 'package:ehit_app/features/music_library/presentation/controllers/music_library_controller.dart';

/// Configuração comum para testes
class TestConfig {
  /// Cria um widget de teste com providers necessários
  static Widget createTestWidget({
    required Widget child,
    MusicPlayerController? playerController,
    MusicLibraryController? libraryController,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: playerController ?? MusicPlayerController(),
        ),
        ChangeNotifierProvider.value(
          value: libraryController ?? MusicLibraryController(),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }

  /// Cria um MusicPlayerController para testes
  static MusicPlayerController createPlayerController() {
    return MusicPlayerController();
  }

  /// Cria um MusicLibraryController para testes
  static MusicLibraryController createLibraryController() {
    return MusicLibraryController();
  }

  /// Configuração padrão para testes de widget
  static void setupWidgetTests() {
    // Configurações globais para testes de widget
    TestWidgetsFlutterBinding.ensureInitialized();
  }

  /// Configuração padrão para testes de integração
  static void setupIntegrationTests() {
    // Configurações globais para testes de integração
    TestWidgetsFlutterBinding.ensureInitialized();
  }

  /// Configuração padrão para testes E2E
  static void setupE2ETests() {
    // Configurações globais para testes E2E
    TestWidgetsFlutterBinding.ensureInitialized();
  }
}

/// Extensões úteis para testes
extension TestExtensions on WidgetTester {
  /// Aguarda a animação completar e verifica se não há erros
  Future<void> pumpAndSettleSafely() async {
    await pumpAndSettle();
    // Verifica se não há erros não tratados
    expect(takeException(), isNull);
  }

  /// Tapa em um widget e aguarda a animação
  Future<void> tapAndSettle(Finder finder) async {
    await tap(finder);
    await pumpAndSettleSafely();
  }

  /// Digita texto e aguarda a animação
  Future<void> enterTextAndSettle(Finder finder, String text) async {
    await enterText(finder, text);
    await pumpAndSettleSafely();
  }
}

/// Constantes para testes
class TestConstants {
  static const String testSongId = 'test-song-1';
  static const String testSongTitle = 'Test Song';
  static const String testArtistName = 'Test Artist';
  static const String testAlbumName = 'Test Album';
  static const String testImageUrl = 'https://example.com/test-image.jpg';
  static const String testAudioUrl = 'https://example.com/test-audio.mp3';
  static const Duration testDuration = Duration(minutes: 3, seconds: 30);
  
  static const String testArtistId = 'test-artist-1';
  static const String testArtistImageUrl = 'https://example.com/test-artist.jpg';
  
  // Timeouts para testes
  static const Duration shortTimeout = Duration(seconds: 1);
  static const Duration mediumTimeout = Duration(seconds: 5);
  static const Duration longTimeout = Duration(seconds: 10);
}

/// Helpers para criar dados de teste
class TestDataFactory {
  /// Cria uma música de teste
  static Map<String, dynamic> createTestSongData({
    String? id,
    String? title,
    String? artist,
    String? album,
    Duration? duration,
    String? imageUrl,
    String? audioUrl,
  }) {
    return {
      'id': id ?? TestConstants.testSongId,
      'title': title ?? TestConstants.testSongTitle,
      'artist': artist ?? TestConstants.testArtistName,
      'album': album ?? TestConstants.testAlbumName,
      'duration': duration ?? TestConstants.testDuration,
      'imageUrl': imageUrl ?? TestConstants.testImageUrl,
      'audioUrl': audioUrl ?? TestConstants.testAudioUrl,
    };
  }

  /// Cria um artista de teste
  static Map<String, dynamic> createTestArtistData({
    String? id,
    String? name,
    String? imageUrl,
  }) {
    return {
      'id': id ?? TestConstants.testArtistId,
      'name': name ?? TestConstants.testArtistName,
      'imageUrl': imageUrl ?? TestConstants.testArtistImageUrl,
    };
  }
}
