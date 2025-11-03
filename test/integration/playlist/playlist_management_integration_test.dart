import 'package:flutter_test/flutter_test.dart';
import 'package:ehit_app/core/audio/audio_player_service.dart';
import 'package:ehit_app/features/music_library/domain/entities/song.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('Playlist Management Integration Tests', () {
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
    }) {
      return Song(
        id: id,
        title: title,
        artist: artist,
        album: 'Test Album',
        duration: '03:30',
        imageUrl: 'https://via.placeholder.com/300',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$id.mp3',
        isExplicit: false,
        releaseDate: DateTime.now(),
        playCount: 0,
        genre: 'Pop',
      );
    }

    test('should maintain playlist state across multiple songs', () async {
      final songs = List.generate(
        5,
        (index) => _createTestSong(
          id: '${index + 1}',
          title: 'Song ${index + 1}',
          artist: 'Artist ${index + 1}',
        ),
      );

      await audioPlayerService.playPlaylist(songs);
      await Future.delayed(const Duration(milliseconds: 300));

      expect(audioPlayerService.playlist.length, 5);
      expect(audioPlayerService.currentIndex, 0);

      // Avançar algumas músicas
      for (int i = 0; i < 3; i++) {
        await audioPlayerService.next();
        await Future.delayed(const Duration(milliseconds: 200));
      }

      expect(audioPlayerService.currentIndex, 3);
      expect(audioPlayerService.currentSong?.id, '4');

      // Playlist deve ainda ter 5 músicas
      expect(audioPlayerService.playlist.length, 5);
    });

    test('should replace playlist when playing new song', () async {
      final initialSong = _createTestSong(id: '1', title: 'Initial Song', artist: 'Artist');
      await audioPlayerService.playSong(initialSong);
      await Future.delayed(const Duration(milliseconds: 200));

      expect(audioPlayerService.playlist.length, 1);
      expect(audioPlayerService.currentSong?.id, '1');

      final newSong = _createTestSong(id: '2', title: 'New Song', artist: 'Artist');
      await audioPlayerService.playSong(newSong);
      await Future.delayed(const Duration(milliseconds: 200));

      expect(audioPlayerService.playlist.length, 1);
      expect(audioPlayerService.currentSong?.id, '2');
      expect(audioPlayerService.playlist.first.id, '2');
    });

    test('should handle single song playlist correctly', () async {
      final song = _createTestSong(id: '1', title: 'Single Song', artist: 'Artist');
      await audioPlayerService.playSong(song);
      await Future.delayed(const Duration(milliseconds: 200));

      // Tentar avançar - não deve mudar
      await audioPlayerService.next();
      await Future.delayed(const Duration(milliseconds: 200));

      expect(audioPlayerService.currentSong?.id, '1');
      expect(audioPlayerService.currentIndex, 0);
      expect(audioPlayerService.isPlaying, false); // Deve parar por ser única
    });

    test('should start playlist from specified index', () async {
      final songs = List.generate(
        5,
        (index) => _createTestSong(
          id: '${index + 1}',
          title: 'Song ${index + 1}',
          artist: 'Artist',
        ),
      );

      await audioPlayerService.playPlaylist(songs, startIndex: 3);
      await Future.delayed(const Duration(milliseconds: 200));

      expect(audioPlayerService.currentIndex, 3);
      expect(audioPlayerService.currentSong?.id, '4');
    });

    test('should handle empty playlist gracefully', () async {
      await audioPlayerService.playPlaylist([]);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(audioPlayerService.playlist, isEmpty);
      expect(audioPlayerService.currentSong, isNull);
    });
  });
}
