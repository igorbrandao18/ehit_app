// test/unit/domain/entities/song_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:ehit_app/features/music_library/domain/entities/song.dart';

void main() {
  group('Song Entity', () {
    final tSong = Song(
      id: '1',
      title: 'Test Song',
      artist: 'Test Artist',
      album: 'Test Album',
      duration: '3:30',
      imageUrl: 'https://example.com/image.jpg',
      audioUrl: 'https://example.com/audio.mp3',
      isExplicit: false,
      releaseDate: DateTime(2023),
      playCount: 100,
    );

    group('constructor', () {
      test('should create a Song with all properties', () {
        // Act
        final song = Song(
          id: '1',
          title: 'Test Song',
          artist: 'Test Artist',
          album: 'Test Album',
          duration: '3:30',
          imageUrl: 'https://example.com/image.jpg',
          audioUrl: 'https://example.com/audio.mp3',
          isExplicit: false,
          releaseDate: DateTime(2023),
          playCount: 100,
        );

        // Assert
        expect(song.id, equals('1'));
        expect(song.title, equals('Test Song'));
        expect(song.artist, equals('Test Artist'));
        expect(song.album, equals('Test Album'));
        expect(song.duration, equals('3:30'));
        expect(song.imageUrl, equals('https://example.com/image.jpg'));
        expect(song.audioUrl, equals('https://example.com/audio.mp3'));
        expect(song.isExplicit, equals(false));
        expect(song.releaseDate, equals(DateTime(2023)));
        expect(song.playCount, equals(100));
      });

      test('should create a Song with all required properties', () {
        // Act
        final song = Song(
          id: '1',
          title: 'Test Song',
          artist: 'Test Artist',
          album: 'Test Album',
          duration: '3:30',
          imageUrl: 'https://example.com/image.jpg',
          audioUrl: 'https://example.com/audio.mp3',
          isExplicit: false,
          releaseDate: DateTime(2023),
          playCount: 0,
        );

        // Assert
        expect(song.id, equals('1'));
        expect(song.title, equals('Test Song'));
        expect(song.artist, equals('Test Artist'));
        expect(song.album, equals('Test Album'));
        expect(song.duration, equals('3:30'));
        expect(song.imageUrl, equals('https://example.com/image.jpg'));
        expect(song.audioUrl, equals('https://example.com/audio.mp3'));
        expect(song.isExplicit, equals(false));
        expect(song.releaseDate, equals(DateTime(2023)));
        expect(song.playCount, equals(0));
      });
    });

    group('equality', () {
      test('should be equal when id is the same', () {
        // Arrange
        final song1 = Song(
          id: '1',
          title: 'Test Song',
          artist: 'Test Artist',
          album: 'Test Album',
          duration: '3:30',
          imageUrl: 'https://example.com/image.jpg',
          audioUrl: 'https://example.com/audio.mp3',
          isExplicit: false,
          releaseDate: DateTime(2023),
          playCount: 100,
        );

        final song2 = Song(
          id: '1',
          title: 'Different Song',
          artist: 'Different Artist',
          album: 'Different Album',
          duration: '4:00',
          imageUrl: 'https://example.com/different.jpg',
          audioUrl: 'https://example.com/different.mp3',
          isExplicit: true,
          releaseDate: DateTime(2024),
          playCount: 200,
        );

        // Assert - Songs are equal based on ID only
        expect(song1, equals(song2));
        expect(song1.hashCode, equals(song2.hashCode));
      });

      test('should not be equal when id is different', () {
        // Arrange
        final song1 = Song(
          id: '1',
          title: 'Test Song',
          artist: 'Test Artist',
          album: 'Test Album',
          duration: '3:30',
          imageUrl: 'https://example.com/image.jpg',
          audioUrl: 'https://example.com/audio.mp3',
          isExplicit: false,
          releaseDate: DateTime(2023),
          playCount: 100,
        );

        final song2 = Song(
          id: '2',
          title: 'Test Song',
          artist: 'Test Artist',
          album: 'Test Album',
          duration: '3:30',
          imageUrl: 'https://example.com/image.jpg',
          audioUrl: 'https://example.com/audio.mp3',
          isExplicit: false,
          releaseDate: DateTime(2023),
          playCount: 100,
        );

        // Assert
        expect(song1, isNot(equals(song2)));
      });
    });

    group('toString', () {
      test('should return string representation with key properties', () {
        // Act
        final result = tSong.toString();

        // Assert
        expect(result, contains('Song'));
        expect(result, contains('id: 1'));
        expect(result, contains('title: Test Song'));
        expect(result, contains('artist: Test Artist'));
        expect(result, contains('duration: 3:30'));
      });
    });

    group('copyWith', () {
      test('should create a copy with updated properties', () {
        // Act
        final updatedSong = tSong.copyWith(
          title: 'Updated Title',
          playCount: 200,
        );

        // Assert
        expect(updatedSong.id, equals(tSong.id));
        expect(updatedSong.title, equals('Updated Title'));
        expect(updatedSong.artist, equals(tSong.artist));
        expect(updatedSong.album, equals(tSong.album));
        expect(updatedSong.duration, equals(tSong.duration));
        expect(updatedSong.imageUrl, equals(tSong.imageUrl));
        expect(updatedSong.audioUrl, equals(tSong.audioUrl));
        expect(updatedSong.isExplicit, equals(tSong.isExplicit));
        expect(updatedSong.releaseDate, equals(tSong.releaseDate));
        expect(updatedSong.playCount, equals(200));
      });

      test('should create a copy with updated boolean values', () {
        // Act
        final updatedSong = tSong.copyWith(
          isExplicit: true,
        );

        // Assert
        expect(updatedSong.isExplicit, isTrue);
        expect(updatedSong.id, equals(tSong.id));
        expect(updatedSong.title, equals(tSong.title));
      });
    });
  });
}
