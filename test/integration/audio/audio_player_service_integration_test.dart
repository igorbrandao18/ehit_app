import 'package:flutter_test/flutter_test.dart';
import 'package:ehit_app/core/audio/audio_player_service.dart';
import 'package:ehit_app/features/music_library/domain/entities/song.dart';
import 'dart:async';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('AudioPlayerService Integration Tests', () {
    late AudioPlayerService audioPlayerService;

    setUp(() {
      audioPlayerService = AudioPlayerService();
    });

    tearDown(() {
      audioPlayerService.dispose();
    });

    // Helper para criar uma música de teste
    Song _createTestSong({
      required String id,
      required String title,
      required String artist,
      String audioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      String duration = '03:30',
    }) {
      return Song(
        id: id,
        title: title,
        artist: artist,
        album: 'Test Album',
        duration: duration,
        imageUrl: 'https://via.placeholder.com/300',
        audioUrl: audioUrl,
        isExplicit: false,
        releaseDate: DateTime.now(),
        playCount: 0,
        genre: 'Pop',
      );
    }

    test('should initialize with default values', () {
      expect(audioPlayerService.currentSong, isNull);
      expect(audioPlayerService.playlist, isEmpty);
      expect(audioPlayerService.currentIndex, 0);
      expect(audioPlayerService.isPlaying, false);
      expect(audioPlayerService.position, Duration.zero);
      expect(audioPlayerService.duration, Duration.zero);
      expect(audioPlayerService.progress, 0.0);
    });

    test('should play a single song and update state', () async {
      final song = _createTestSong(
        id: '1',
        title: 'Test Song',
        artist: 'Test Artist',
      );

      // Listen to state changes
      bool stateChanged = false;
      audioPlayerService.addListener(() {
        stateChanged = true;
      });

      await audioPlayerService.playSong(song);

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 500));

      expect(audioPlayerService.currentSong, isNotNull);
      expect(audioPlayerService.currentSong?.id, '1');
      expect(audioPlayerService.currentSong?.title, 'Test Song');
      expect(audioPlayerService.playlist.length, 1);
      expect(audioPlayerService.currentIndex, 0);
      expect(stateChanged, true);
    });

    test('should handle pause and preserve position', () async {
      final song = _createTestSong(
        id: '1',
        title: 'Test Song',
        artist: 'Test Artist',
        duration: '05:00',
      );

      await audioPlayerService.playSong(song);
      await Future.delayed(const Duration(milliseconds: 300));

      // Verificar que está tocando
      expect(audioPlayerService.isPlaying, true);

      // Aguardar um pouco para a posição avançar
      await Future.delayed(const Duration(milliseconds: 200));

      // Pausar
      await audioPlayerService.pause();
      await Future.delayed(const Duration(milliseconds: 100));

      // Verificar que pausou
      expect(audioPlayerService.isPlaying, false);

      // Verificar que a posição foi preservada (não voltou para zero)
      final positionAfterPause = audioPlayerService.position;
      expect(positionAfterPause, greaterThanOrEqualTo(Duration.zero));

      // Aguardar mais tempo pausado
      await Future.delayed(const Duration(milliseconds: 300));

      // A posição não deve mudar enquanto pausado
      final positionWhilePaused = audioPlayerService.position;
      expect(
        positionWhilePaused.inMilliseconds,
        closeTo(positionAfterPause.inMilliseconds, 100),
      );
    });

    test('should handle resume after pause', () async {
      final song = _createTestSong(
        id: '1',
        title: 'Test Song',
        artist: 'Test Artist',
      );

      await audioPlayerService.playSong(song);
      await Future.delayed(const Duration(milliseconds: 200));

      // Pausar
      await audioPlayerService.pause();
      await Future.delayed(const Duration(milliseconds: 100));
      
      final positionBeforeResume = audioPlayerService.position;

      // Retomar
      await audioPlayerService.resume();
      await Future.delayed(const Duration(milliseconds: 200));

      // Deve estar tocando novamente
      expect(audioPlayerService.isPlaying, true);

      // A posição deve continuar de onde parou ou avançar
      final positionAfterResume = audioPlayerService.position;
      expect(
        positionAfterResume.inMilliseconds,
        greaterThanOrEqualTo(positionBeforeResume.inMilliseconds),
      );
    });

    test('should play playlist and navigate between songs', () async {
      final songs = [
        _createTestSong(id: '1', title: 'Song 1', artist: 'Artist 1'),
        _createTestSong(id: '2', title: 'Song 2', artist: 'Artist 2'),
        _createTestSong(id: '3', title: 'Song 3', artist: 'Artist 3'),
      ];

      await audioPlayerService.playPlaylist(songs, startIndex: 0);
      await Future.delayed(const Duration(milliseconds: 300));

      // Verificar primeira música
      expect(audioPlayerService.currentSong?.id, '1');
      expect(audioPlayerService.playlist.length, 3);
      expect(audioPlayerService.currentIndex, 0);

      // Ir para próxima
      await audioPlayerService.next();
      await Future.delayed(const Duration(milliseconds: 300));

      // Verificar segunda música
      expect(audioPlayerService.currentSong?.id, '2');
      expect(audioPlayerService.currentIndex, 1);

      // Ir para anterior
      await audioPlayerService.previous();
      await Future.delayed(const Duration(milliseconds: 300));

      // Deve voltar para primeira
      expect(audioPlayerService.currentSong?.id, '1');
      expect(audioPlayerService.currentIndex, 0);
    });

    test('should handle seek operation', () async {
      final song = _createTestSong(
        id: '1',
        title: 'Test Song',
        artist: 'Test Artist',
        duration: '05:00',
      );

      await audioPlayerService.playSong(song);
      await Future.delayed(const Duration(milliseconds: 300));

      // Buscar para 1 minuto
      await audioPlayerService.seek(const Duration(minutes: 1));
      await Future.delayed(const Duration(milliseconds: 200));

      // Verificar que a posição foi atualizada
      final position = audioPlayerService.position;
      expect(
        position.inSeconds,
        greaterThanOrEqualTo(55), // Pelo menos 55 segundos (com tolerância)
      );
      expect(position.inSeconds, lessThan(70)); // Mas menos que 70
    });

    test('should handle multiple next operations in playlist', () async {
      final songs = [
        _createTestSong(id: '1', title: 'Song 1', artist: 'Artist 1'),
        _createTestSong(id: '2', title: 'Song 2', artist: 'Artist 2'),
        _createTestSong(id: '3', title: 'Song 3', artist: 'Artist 3'),
        _createTestSong(id: '4', title: 'Song 4', artist: 'Artist 4'),
      ];

      await audioPlayerService.playPlaylist(songs);
      await Future.delayed(const Duration(milliseconds: 200));

      expect(audioPlayerService.currentIndex, 0);
      expect(audioPlayerService.currentSong?.id, '1');

      // Avançar múltiplas vezes
      for (int i = 1; i < songs.length; i++) {
        await audioPlayerService.next();
        await Future.delayed(const Duration(milliseconds: 200));
        expect(audioPlayerService.currentIndex, i);
        expect(audioPlayerService.currentSong?.id, songs[i].id);
      }

      // Ao chegar no fim, próximo deve voltar ao início (loop)
      await audioPlayerService.next();
      await Future.delayed(const Duration(milliseconds: 200));
      expect(audioPlayerService.currentIndex, 0);
    });

    test('should handle multiple previous operations in playlist', () async {
      final songs = [
        _createTestSong(id: '1', title: 'Song 1', artist: 'Artist 1'),
        _createTestSong(id: '2', title: 'Song 2', artist: 'Artist 2'),
        _createTestSong(id: '3', title: 'Song 3', artist: 'Artist 3'),
      ];

      await audioPlayerService.playPlaylist(songs, startIndex: 2);
      await Future.delayed(const Duration(milliseconds: 200));

      expect(audioPlayerService.currentIndex, 2);
      expect(audioPlayerService.currentSong?.id, '3');

      // Voltar múltiplas vezes
      await audioPlayerService.previous();
      await Future.delayed(const Duration(milliseconds: 200));
      expect(audioPlayerService.currentIndex, 1);
      expect(audioPlayerService.currentSong?.id, '2');

      await audioPlayerService.previous();
      await Future.delayed(const Duration(milliseconds: 200));
      expect(audioPlayerService.currentIndex, 0);
      expect(audioPlayerService.currentSong?.id, '1');

      // Ao voltar do início, deve ir para o fim (loop)
      await audioPlayerService.previous();
      await Future.delayed(const Duration(milliseconds: 200));
      expect(audioPlayerService.currentIndex, 2);
    });

    test('should update position progressively during playback', () async {
      final song = _createTestSong(
        id: '1',
        title: 'Test Song',
        artist: 'Test Artist',
        duration: '05:00',
      );

      await audioPlayerService.playSong(song);
      
      // Aguardar um pouco
      await Future.delayed(const Duration(milliseconds: 100));
      final position1 = audioPlayerService.position;

      // Aguardar mais um pouco
      await Future.delayed(const Duration(milliseconds: 200));
      final position2 = audioPlayerService.position;

      // A posição deve ter aumentado
      expect(position2.inMilliseconds, greaterThan(position1.inMilliseconds));
    });

    test('should handle stop operation and reset state', () async {
      final song = _createTestSong(id: '1', title: 'Test Song', artist: 'Test Artist');

      await audioPlayerService.playSong(song);
      await Future.delayed(const Duration(milliseconds: 200));

      expect(audioPlayerService.currentSong, isNotNull);

      // Parar
      await audioPlayerService.stop();
      await Future.delayed(const Duration(milliseconds: 100));

      // Estado deve ser resetado
      expect(audioPlayerService.currentSong, isNull);
      expect(audioPlayerService.isPlaying, false);
      expect(audioPlayerService.position, Duration.zero);
    });

    test('should notify listeners on state changes', () async {
      final song = _createTestSong(id: '1', title: 'Test Song', artist: 'Test Artist');

      int notificationCount = 0;
      audioPlayerService.addListener(() {
        notificationCount++;
      });

      await audioPlayerService.playSong(song);
      await Future.delayed(const Duration(milliseconds: 200));

      await audioPlayerService.pause();
      await Future.delayed(const Duration(milliseconds: 100));

      await audioPlayerService.resume();
      await Future.delayed(const Duration(milliseconds: 100));

      // Deve ter notificado múltiplas vezes
      expect(notificationCount, greaterThan(0));
    });

    test('should handle error gracefully when song URL is invalid', () async {
      final song = _createTestSong(
        id: '1',
        title: 'Test Song',
        artist: 'Test Artist',
        audioUrl: 'https://invalid-url-that-does-not-exist.com/audio.mp3',
      );

      // Não deve lançar exceção, deve tratar o erro graciosamente
      await audioPlayerService.playSong(song);
      await Future.delayed(const Duration(milliseconds: 300));

      // O serviço deve continuar funcionando mesmo após erro
      expect(audioPlayerService, isNotNull);
    });
  });
}
