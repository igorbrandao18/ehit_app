// test/unit/presentation/controllers/music_player_controller_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:ehit_app/features/music_player/presentation/controllers/music_player_controller.dart';

void main() {
  group('MusicPlayerController', () {
    late MusicPlayerController controller;

    setUp(() {
      controller = MusicPlayerController();
    });

    group('initial state', () {
      test('should have correct initial state', () {
        // Assert
        expect(controller.state, equals(PlayerState.stopped));
        expect(controller.position, equals(Duration.zero));
        expect(controller.duration, equals(const Duration(minutes: 4, seconds: 19)));
        expect(controller.isPlaying, isFalse);
        expect(controller.isPaused, isFalse);
        expect(controller.isLoading, isFalse);
        expect(controller.isShuffled, isFalse);
        expect(controller.isRepeating, isFalse);
      });
    });

    group('play', () {
      test('should change state to playing', () {
        // Act
        controller.play();

        // Assert
        expect(controller.state, equals(PlayerState.playing));
        expect(controller.isPlaying, isTrue);
        expect(controller.isPaused, isFalse);
        expect(controller.isLoading, isFalse);
      });

      test('should notify listeners when playing', () {
        // Arrange
        var notified = false;
        controller.addListener(() {
          notified = true;
        });

        // Act
        controller.play();

        // Assert
        expect(notified, isTrue);
      });
    });

    group('pause', () {
      test('should change state to paused when playing', () {
        // Arrange
        controller.play();

        // Act
        controller.pause();

        // Assert
        expect(controller.state, equals(PlayerState.paused));
        expect(controller.isPlaying, isFalse);
        expect(controller.isPaused, isTrue);
        expect(controller.isLoading, isFalse);
      });

      test('should notify listeners when pausing', () {
        // Arrange
        controller.play();
        var notified = false;
        controller.addListener(() {
          notified = true;
        });

        // Act
        controller.pause();

        // Assert
        expect(notified, isTrue);
      });
    });

    group('resume', () {
      test('should change state to playing when paused', () {
        // Arrange
        controller.play();
        controller.pause();

        // Act
        controller.resume();

        // Assert
        expect(controller.state, equals(PlayerState.playing));
        expect(controller.isPlaying, isTrue);
        expect(controller.isPaused, isFalse);
        expect(controller.isLoading, isFalse);
      });

      test('should notify listeners when resuming', () {
        // Arrange
        controller.play();
        controller.pause();
        var notified = false;
        controller.addListener(() {
          notified = true;
        });

        // Act
        controller.resume();

        // Assert
        expect(notified, isTrue);
      });
    });

    group('stop', () {
      test('should change state to stopped and reset position', () {
        // Arrange
        controller.play();
        controller.seekTo(const Duration(seconds: 30));

        // Act
        controller.stop();

        // Assert
        expect(controller.state, equals(PlayerState.stopped));
        expect(controller.position, equals(Duration.zero));
        expect(controller.isPlaying, isFalse);
        expect(controller.isPaused, isFalse);
        expect(controller.isLoading, isFalse);
      });

      test('should notify listeners when stopping', () {
        // Arrange
        controller.play();
        var notified = false;
        controller.addListener(() {
          notified = true;
        });

        // Act
        controller.stop();

        // Assert
        expect(notified, isTrue);
      });
    });

    group('togglePlayPause', () {
      test('should play when stopped', () {
        // Act
        controller.togglePlayPause();

        // Assert
        expect(controller.state, equals(PlayerState.playing));
        expect(controller.isPlaying, isTrue);
      });

      test('should pause when playing', () {
        // Arrange
        controller.play();

        // Act
        controller.togglePlayPause();

        // Assert
        expect(controller.state, equals(PlayerState.paused));
        expect(controller.isPaused, isTrue);
      });

      test('should resume when paused', () {
        // Arrange
        controller.play();
        controller.pause();

        // Act
        controller.togglePlayPause();

        // Assert
        expect(controller.state, equals(PlayerState.playing));
        expect(controller.isPlaying, isTrue);
      });
    });

    group('seekTo', () {
      test('should update position', () {
        // Arrange
        const newPosition = Duration(minutes: 2, seconds: 30);

        // Act
        controller.seekTo(newPosition);

        // Assert
        expect(controller.position, equals(newPosition));
      });

      test('should notify listeners when seeking', () {
        // Arrange
        var notified = false;
        controller.addListener(() {
          notified = true;
        });

        // Act
        controller.seekTo(const Duration(seconds: 30));

        // Assert
        expect(notified, isTrue);
      });
    });

    group('toggleShuffle', () {
      test('should toggle shuffle state', () {
        // Assert initial state
        expect(controller.isShuffled, isFalse);

        // Act
        controller.toggleShuffle();

        // Assert
        expect(controller.isShuffled, isTrue);

        // Act
        controller.toggleShuffle();

        // Assert
        expect(controller.isShuffled, isFalse);
      });

      test('should notify listeners when toggling shuffle', () {
        // Arrange
        var notified = false;
        controller.addListener(() {
          notified = true;
        });

        // Act
        controller.toggleShuffle();

        // Assert
        expect(notified, isTrue);
      });
    });

    group('toggleRepeat', () {
      test('should toggle repeat state', () {
        // Assert initial state
        expect(controller.isRepeating, isFalse);

        // Act
        controller.toggleRepeat();

        // Assert
        expect(controller.isRepeating, isTrue);

        // Act
        controller.toggleRepeat();

        // Assert
        expect(controller.isRepeating, isFalse);
      });

      test('should notify listeners when toggling repeat', () {
        // Arrange
        var notified = false;
        controller.addListener(() {
          notified = true;
        });

        // Act
        controller.toggleRepeat();

        // Assert
        expect(notified, isTrue);
      });
    });

    group('state transitions', () {
      test('should handle multiple state transitions correctly', () {
        // Act & Assert
        controller.play();
        expect(controller.isPlaying, isTrue);

        controller.pause();
        expect(controller.isPaused, isTrue);

        controller.resume();
        expect(controller.isPlaying, isTrue);

        controller.stop();
        expect(controller.state, equals(PlayerState.stopped));
      });
    });
  });
}
