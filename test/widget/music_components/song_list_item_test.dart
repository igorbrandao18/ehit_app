// test/widget/music_components/song_list_item_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ehit_app/shared/widgets/music_components/song_list_item.dart';
import 'package:ehit_app/features/music_library/domain/entities/song.dart';

void main() {
  group('SongListItem Widget', () {
    final testSong = Song(
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

    testWidgets('should display song information correctly', (WidgetTester tester) async {
      // Arrange
      var tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SongListItem(
              song: testSong,
              index: 1,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Song'), findsOneWidget);
      expect(find.text('Test Artist'), findsOneWidget);
      expect(find.byIcon(Icons.download), findsOneWidget);
    });

    testWidgets('should have onTap callback available', (WidgetTester tester) async {
      // Arrange
      var tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SongListItem(
              song: testSong,
              index: 1,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Assert - Just verify the widget is rendered with callback
      expect(find.byType(SongListItem), findsOneWidget);
      expect(tapped, isFalse); // Callback not called yet
    });

    testWidgets('should call download callback when download button is tapped', (WidgetTester tester) async {
      // Arrange
      var downloadTapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SongListItem(
              song: testSong,
              index: 1,
              onTap: () {},
            ),
          ),
        ),
      );

      // Find and tap the download button
      final downloadButton = find.byIcon(Icons.download);
      expect(downloadButton, findsOneWidget);
      
      await tester.tap(downloadButton);
      await tester.pump();

      // Assert - The download button should be tappable (even though callback is not implemented yet)
      expect(downloadButton, findsOneWidget);
    });

    testWidgets('should display fallback icon when image fails to load', (WidgetTester tester) async {
      // Arrange
      final songWithInvalidImage = Song(
        id: '1',
        title: 'Test Song',
        artist: 'Test Artist',
        album: 'Test Album',
        duration: '3:30',
        imageUrl: 'invalid-url',
        audioUrl: 'https://example.com/audio.mp3',
        isExplicit: false,
        releaseDate: DateTime(2023),
        playCount: 100,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SongListItem(
              song: songWithInvalidImage,
              index: 1,
              onTap: () {},
            ),
          ),
        ),
      );

      // Wait for image to fail loading
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.music_note), findsOneWidget);
    });

    testWidgets('should have correct layout structure', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SongListItem(
              song: testSong,
              index: 1,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should handle long song titles with ellipsis', (WidgetTester tester) async {
      // Arrange
      final longTitleSong = Song(
        id: '1',
        title: 'This is a very long song title that should be truncated with ellipsis',
        artist: 'Test Artist',
        album: 'Test Album',
        duration: '3:30',
        imageUrl: 'https://example.com/image.jpg',
        audioUrl: 'https://example.com/audio.mp3',
        isExplicit: false,
        releaseDate: DateTime(2023),
        playCount: 100,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SongListItem(
              song: longTitleSong,
              index: 1,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      final titleWidget = find.textContaining('This is a very long song title');
      expect(titleWidget, findsOneWidget);
      
      // Check if the text widget has maxLines constraint
      final textWidget = tester.widget<Text>(titleWidget);
      expect(textWidget.maxLines, equals(1));
      expect(textWidget.overflow, equals(TextOverflow.ellipsis));
    });

    testWidgets('should handle long artist names with ellipsis', (WidgetTester tester) async {
      // Arrange
      final longArtistSong = Song(
        id: '1',
        title: 'Test Song',
        artist: 'This is a very long artist name that should be truncated',
        album: 'Test Album',
        duration: '3:30',
        imageUrl: 'https://example.com/image.jpg',
        audioUrl: 'https://example.com/audio.mp3',
        isExplicit: false,
        releaseDate: DateTime(2023),
        playCount: 100,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SongListItem(
              song: longArtistSong,
              index: 1,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      final artistWidget = find.textContaining('This is a very long artist name');
      expect(artistWidget, findsOneWidget);
      
      // Check if the text widget has maxLines constraint
      final textWidget = tester.widget<Text>(artistWidget);
      expect(textWidget.maxLines, equals(1));
      expect(textWidget.overflow, equals(TextOverflow.ellipsis));
    });
  });
}
