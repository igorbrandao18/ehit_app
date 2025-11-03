import 'package:flutter_test/flutter_test.dart';
import 'package:ehit_app/core/audio/audio_player_service.dart';
import 'package:ehit_app/features/music_library/domain/entities/song.dart';

/// Testes End-to-End para fluxo completo de reprodução de música
/// Estes testes simulam o comportamento real do usuário
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('Music Playback E2E Tests', () {
    late AudioPlayerService audioPlayerService;

    setUp(() {
      audioPlayerService = AudioPlayerService();
    });

    tearDown(() {
      audioPlayerService.dispose();
    });

    Song _createTestSong({
      required String id,
      required String title,
      required String artist,
      String duration = '03:30',
    }) {
      return Song(
        id: id,
        title: title,
        artist: artist,
        album: 'Test Album',
        duration: duration,
        imageUrl: 'https://via.placeholder.com/300',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$id.mp3',
        isExplicit: false,
        releaseDate: DateTime.now(),
        playCount: 0,
        genre: 'Pop',
      );
    }

    test('Complete flow: play -> pause -> resume -> next -> stop', () async {
      final songs = [
        _createTestSong(id: '1', title: 'First Song', artist: 'Artist'),
        _createTestSong(id: '2', title: 'Second Song', artist: 'Artist'),
      ];

      // 1. Iniciar reprodução da playlist
      await audioPlayerService.playPlaylist(songs);
      await Future.delayed(const Duration(milliseconds: 300));

      expect(audioPlayerService.currentSong?.id, '1');
      expect(audioPlayerService.isPlaying, true);
      expect(audioPlayerService.playlist.length, 2);

      // 2. Pausar
      await audioPlayerService.pause();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(audioPlayerService.isPlaying, false);
      final pausedPosition = audioPlayerService.position;
      expect(pausedPosition, greaterThanOrEqualTo(Duration.zero));

      // 3. Aguardar um pouco pausado
      await Future.delayed(const Duration(milliseconds: 200));
      expect(audioPlayerService.position.inMilliseconds, closeTo(pausedPosition.inMilliseconds, 100));

      // 4. Retomar
      await audioPlayerService.resume();
      await Future.delayed(const Duration(milliseconds: 200));

      expect(audioPlayerService.isPlaying, true);
      expect(audioPlayerService.currentSong?.id, '1');

      // 5. Avançar para próxima música
      await audioPlayerService.next();
      await Future.delayed(const Duration(milliseconds: 300));

      expect(audioPlayerService.currentSong?.id, '2');
      expect(audioPlayerService.currentIndex, 1);
      expect(audioPlayerService.isPlaying, true);

      // 6. Parar completamente
      await audioPlayerService.stop();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(audioPlayerService.currentSong, isNull);
      expect(audioPlayerService.isPlaying, false);
      expect(audioPlayerService.position, Duration.zero);
    });

    test('Complete flow: play -> seek -> pause -> resume -> previous', () async {
      final song = _createTestSong(
        id: '1',
        title: 'Long Song',
        artist: 'Artist',
        duration: '05:00',
      );

      // 1. Tocar música
      await audioPlayerService.playSong(song);
      await Future.delayed(const Duration(milliseconds: 300));

      expect(audioPlayerService.currentSong?.id, '1');
      expect(audioPlayerService.isPlaying, true);

      // 2. Buscar para posição específica
      await audioPlayerService.seek(const Duration(minutes: 2));
      await Future.delayed(const Duration(milliseconds: 200));

      final positionAfterSeek = audioPlayerService.position;
      expect(positionAfterSeek.inSeconds, greaterThanOrEqualTo(115));
      expect(positionAfterSeek.inSeconds, lessThan(130));

      // 3. Pausar
      await audioPlayerService.pause();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(audioPlayerService.isPlaying, false);
      final pausedPosition = audioPlayerService.position;

      // 4. Aguardar pausado
      await Future.delayed(const Duration(milliseconds: 200));
      expect(audioPlayerService.position.inMilliseconds, closeTo(pausedPosition.inMilliseconds, 100));

      // 5. Retomar
      await audioPlayerService.resume();
      await Future.delayed(const Duration(milliseconds: 200));

      expect(audioPlayerService.isPlaying, true);
      final resumedPosition = audioPlayerService.position;
      expect(resumedPosition.inMilliseconds, greaterThanOrEqualTo(pausedPosition.inMilliseconds));
    });

    test('Complete flow: playlist navigation in both directions', () async {
      final songs = List.generate(
        5,
        (index) => _createTestSong(
          id: '${index + 1}',
          title: 'Song ${index + 1}',
          artist: 'Artist',
        ),
      );

      // 1. Iniciar do meio da playlist
      await audioPlayerService.playPlaylist(songs, startIndex: 2);
      await Future.delayed(const Duration(milliseconds: 200));

      expect(audioPlayerService.currentIndex, 2);
      expect(audioPlayerService.currentSong?.id, '3');

      // 2. Avançar para o fim
      await audioPlayerService.next();
      await Future.delayed(const Duration(milliseconds: 200));
      expect(audioPlayerService.currentIndex, 3);
      expect(audioPlayerService.currentSong?.id, '4');

      await audioPlayerService.next();
      await Future.delayed(const Duration(milliseconds: 200));
      expect(audioPlayerService.currentIndex, 4);
      expect(audioPlayerService.currentSong?.id, '5');

      // 3. Avançar mais - deve fazer loop para o início
      await audioPlayerService.next();
      await Future.delayed(const Duration(milliseconds: 200));
      expect(audioPlayerService.currentIndex, 0);
      expect(audioPlayerService.currentSong?.id, '1');

      // 4. Voltar para o fim (loop reverso)
      await audioPlayerService.previous();
      await Future.delayed(const Duration(milliseconds: 200));
      expect(audioPlayerService.currentIndex, 4);
      expect(audioPlayerService.currentSong?.id, '5');

      // 5. Voltar algumas músicas
      await audioPlayerService.previous();
      await Future.delayed(const Duration(milliseconds: 200));
      expect(audioPlayerService.currentIndex, 3);

      await audioPlayerService.previous();
      await Future.delayed(const Duration(milliseconds: 200));
      expect(audioPlayerService.currentIndex, 2);
    });

    test('Real-world scenario: user listening session', () async {
      final songs = List.generate(
        3,
        (index) => _createTestSong(
          id: '${index + 1}',
          title: 'Song ${index + 1}',
          artist: 'Artist ${index + 1}',
        ),
      );

      // Simulação de uma sessão real de escuta:
      // 1. Usuário inicia playlist
      await audioPlayerService.playPlaylist(songs);
      await Future.delayed(const Duration(milliseconds: 300));

      expect(audioPlayerService.isPlaying, true);
      expect(audioPlayerService.currentSong?.id, '1');

      // 2. Música toca por um tempo
      await Future.delayed(const Duration(milliseconds: 300));
      final positionAfterPlaying = audioPlayerService.position;
      expect(positionAfterPlaying.inMilliseconds, greaterThan(0));

      // 3. Usuário pausa (ex: recebeu uma ligação)
      await audioPlayerService.pause();
      await Future.delayed(const Duration(milliseconds: 100));
      expect(audioPlayerService.isPlaying, false);

      // 4. Aguarda um tempo pausado
      await Future.delayed(const Duration(milliseconds: 500));

      // 5. Usuário retoma
      await audioPlayerService.resume();
      await Future.delayed(const Duration(milliseconds: 200));
      expect(audioPlayerService.isPlaying, true);

      // 6. Usuário pula para próxima música
      await audioPlayerService.next();
      await Future.delayed(const Duration(milliseconds: 300));
      expect(audioPlayerService.currentSong?.id, '2');

      // 7. Usuário busca uma posição específica
      await audioPlayerService.seek(const Duration(seconds: 30));
      await Future.delayed(const Duration(milliseconds: 200));
      expect(audioPlayerService.position.inSeconds, greaterThanOrEqualTo(25));

      // 8. Usuário volta para música anterior
      await audioPlayerService.previous();
      await Future.delayed(const Duration(milliseconds: 300));
      expect(audioPlayerService.currentSong?.id, '1');
    });

    test('Edge case: rapid pause/resume cycles', () async {
      final song = _createTestSong(id: '1', title: 'Test Song', artist: 'Artist');

      await audioPlayerService.playSong(song);
      await Future.delayed(const Duration(milliseconds: 200));

      // Múltiplos ciclos rápidos de pause/resume
      for (int i = 0; i < 5; i++) {
        await audioPlayerService.pause();
        await Future.delayed(const Duration(milliseconds: 50));
        expect(audioPlayerService.isPlaying, false);

        await audioPlayerService.resume();
        await Future.delayed(const Duration(milliseconds: 50));
        expect(audioPlayerService.isPlaying, true);
      }

      // Estado final deve ser válido
      expect(audioPlayerService.currentSong, isNotNull);
      expect(audioPlayerService.isPlaying, true);
    });
  });
}
