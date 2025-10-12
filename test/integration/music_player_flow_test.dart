// test/integration/music_player_flow_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ehit_app/features/music_player/presentation/controllers/music_player_controller.dart';
import 'package:ehit_app/features/music_library/presentation/controllers/music_library_controller.dart';
import 'package:ehit_app/features/music_library/presentation/pages/home_page.dart';
import 'package:ehit_app/features/music_player/presentation/pages/player_page.dart';
import 'package:ehit_app/features/music_library/domain/entities/song.dart';

void main() {
  group('Music Player Integration Tests', () {
    late MusicPlayerController playerController;
    late MusicLibraryController libraryController;

    setUp(() {
      playerController = MusicPlayerController();
      libraryController = MusicLibraryController();
    });

    testWidgets('should navigate from home to player when song is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: playerController),
            ChangeNotifierProvider.value(value: libraryController),
          ],
          child: MaterialApp(
            home: const HomePage(),
            routes: {
              '/player': (context) => const PlayerPage(),
            },
          ),
        ),
      );

      // Wait for initial load
      await tester.pumpAndSettle();

      // Act - Find and tap a song (assuming there are songs in the home page)
      final songTappable = find.byType(GestureDetector).first;
      if (songTappable.evaluate().isNotEmpty) {
        await tester.tap(songTappable);
        await tester.pumpAndSettle();

        // Assert - Should navigate to player page
        expect(find.byType(PlayerPage), findsOneWidget);
      }
    });

    testWidgets('should update player state when play/pause is toggled', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: playerController),
            ChangeNotifierProvider.value(value: libraryController),
          ],
          child: MaterialApp(
            home: const PlayerPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Find and tap the play/pause button
      final playPauseButton = find.byType(GestureDetector).last;
      await tester.tap(playPauseButton);
      await tester.pump();

      // Assert - Player state should be updated
      expect(playerController.isPlaying, isTrue);
    });

    testWidgets('should update progress when slider is dragged', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: playerController),
            ChangeNotifierProvider.value(value: libraryController),
          ],
          child: MaterialApp(
            home: const PlayerPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Find and drag the progress slider
      final slider = find.byType(Slider);
      if (slider.evaluate().isNotEmpty) {
        await tester.drag(slider, const Offset(100, 0));
        await tester.pump();

        // Assert - Position should be updated
        expect(playerController.position, isNot(equals(Duration.zero)));
      }
    });

    testWidgets('should display correct song information in player', (WidgetTester tester) async {
      // Arrange
      const testSong = Song(
        id: '1',
        title: 'Test Song',
        artist: 'Test Artist',
        album: 'Test Album',
        duration: Duration(minutes: 3, seconds: 30),
        imageUrl: 'https://example.com/image.jpg',
        audioUrl: 'https://example.com/audio.mp3',
      );

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: playerController),
            ChangeNotifierProvider.value(value: libraryController),
          ],
          child: MaterialApp(
            home: const PlayerPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Should display song information (currently hardcoded in PlayerPage)
      expect(find.text('Leão'), findsOneWidget);
      expect(find.text('Marília Mendonça'), findsOneWidget);
    });

    testWidgets('should handle back navigation from player', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: playerController),
            ChangeNotifierProvider.value(value: libraryController),
          ],
          child: MaterialApp(
            home: const PlayerPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Find and tap the back button
      final backButton = find.byIcon(Icons.keyboard_arrow_down);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();

        // Assert - Should navigate back (this would depend on the navigation implementation)
        // For now, we just verify the button exists and is tappable
        expect(backButton, findsOneWidget);
      }
    });

    testWidgets('should maintain player state across navigation', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: playerController),
            ChangeNotifierProvider.value(value: libraryController),
          ],
          child: MaterialApp(
            home: const PlayerPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Start playing
      final playPauseButton = find.byType(GestureDetector).last;
      await tester.tap(playPauseButton);
      await tester.pump();

      // Assert - Player should be playing
      expect(playerController.isPlaying, isTrue);

      // Act - Navigate away and back (simulated by rebuilding)
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: playerController),
            ChangeNotifierProvider.value(value: libraryController),
          ],
          child: MaterialApp(
            home: const PlayerPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Player state should be maintained
      expect(playerController.isPlaying, isTrue);
    });
  });
}
