// test/unit/core/errors/failures_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:ehit_app/core/errors/failures.dart';

void main() {
  group('Failures', () {
    group('ServerFailure', () {
      test('should create ServerFailure with message', () {
        // Arrange
        const message = 'Server error occurred';

        // Act
        final failure = ServerFailure(message: message);

        // Assert
        expect(failure, isA<ServerFailure>());
        expect(failure.message, equals(message));
        expect(failure.code, isNull);
      });

      test('should create ServerFailure with message and code', () {
        // Arrange
        const message = 'Internal server error';
        const code = 500;

        // Act
        final failure = ServerFailure(message: message, code: code);

        // Assert
        expect(failure, isA<ServerFailure>());
        expect(failure.message, equals(message));
        expect(failure.code, equals(code));
      });

      test('should be equal when message and code are equal', () {
        // Arrange
        const message = 'Server error';
        const code = 404;
        final failure1 = ServerFailure(message: message, code: code);
        final failure2 = ServerFailure(message: message, code: code);

        // Assert
        expect(failure1, equals(failure2));
      });
    });

    group('NetworkFailure', () {
      test('should create NetworkFailure with message', () {
        // Arrange
        const message = 'No internet connection';

        // Act
        final failure = NetworkFailure(message: message);

        // Assert
        expect(failure, isA<NetworkFailure>());
        expect(failure.message, equals(message));
        expect(failure.code, isNull);
      });

      test('should create NetworkFailure with message and code', () {
        // Arrange
        const message = 'Connection timeout';
        const code = 408;

        // Act
        final failure = NetworkFailure(message: message, code: code);

        // Assert
        expect(failure, isA<NetworkFailure>());
        expect(failure.message, equals(message));
        expect(failure.code, equals(code));
      });
    });

    group('CacheFailure', () {
      test('should create CacheFailure with message', () {
        // Arrange
        const message = 'Failed to save to cache';

        // Act
        final failure = CacheFailure(message: message);

        // Assert
        expect(failure, isA<CacheFailure>());
        expect(failure.message, equals(message));
        expect(failure.code, isNull);
      });
    });

    group('ValidationFailure', () {
      test('should create ValidationFailure with message', () {
        // Arrange
        const message = 'Invalid email format';

        // Act
        final failure = ValidationFailure(message: message);

        // Assert
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, equals(message));
        expect(failure.code, isNull);
      });
    });

    group('AuthFailure', () {
      test('should create AuthFailure with message', () {
        // Arrange
        const message = 'Invalid credentials';

        // Act
        final failure = AuthFailure(message: message);

        // Assert
        expect(failure, isA<AuthFailure>());
        expect(failure.message, equals(message));
        expect(failure.code, isNull);
      });

      test('should create AuthFailure with message and code', () {
        // Arrange
        const message = 'Token expired';
        const code = 401;

        // Act
        final failure = AuthFailure(message: message, code: code);

        // Assert
        expect(failure, isA<AuthFailure>());
        expect(failure.message, equals(message));
        expect(failure.code, equals(code));
      });
    });

    group('AudioFailure', () {
      test('should create AudioFailure with message', () {
        // Arrange
        const message = 'Failed to play audio';

        // Act
        final failure = AudioFailure(message: message);

        // Assert
        expect(failure, isA<AudioFailure>());
        expect(failure.message, equals(message));
        expect(failure.code, isNull);
      });

      test('should create AudioFailure with message and code', () {
        // Arrange
        const message = 'Audio format not supported';
        const code = 415;

        // Act
        final failure = AudioFailure(message: message, code: code);

        // Assert
        expect(failure, isA<AudioFailure>());
        expect(failure.message, equals(message));
        expect(failure.code, equals(code));
      });
    });

    group('Failure inheritance', () {
      test('all failures should extend Failure', () {
        // Arrange & Act
        final serverFailure = ServerFailure(message: 'test');
        final networkFailure = NetworkFailure(message: 'test');
        final cacheFailure = CacheFailure(message: 'test');
        final validationFailure = ValidationFailure(message: 'test');
        final authFailure = AuthFailure(message: 'test');
        final audioFailure = AudioFailure(message: 'test');

        // Assert
        expect(serverFailure, isA<Failure>());
        expect(networkFailure, isA<Failure>());
        expect(cacheFailure, isA<Failure>());
        expect(validationFailure, isA<Failure>());
        expect(authFailure, isA<Failure>());
        expect(audioFailure, isA<Failure>());
      });

      test('all failures should have message property', () {
        // Arrange & Act
        final failures = [
          ServerFailure(message: 'server error'),
          NetworkFailure(message: 'network error'),
          CacheFailure(message: 'cache error'),
          ValidationFailure(message: 'validation error'),
          AuthFailure(message: 'auth error'),
          AudioFailure(message: 'audio error'),
        ];

        // Assert
        for (final failure in failures) {
          expect(failure.message, isNotEmpty);
          expect(failure.message, isA<String>());
        }
      });
    });
  });
}
