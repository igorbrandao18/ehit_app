// test/unit/core/utils/result_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:ehit_app/core/utils/result.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('should create Success with data', () {
        // Arrange
        const data = 'test data';

        // Act
        final result = Success(data);

        // Assert
        expect(result, isA<Success<String>>());
        expect(result.data, equals(data));
      });

      test('should be equal when data is equal', () {
        // Arrange
        const data = 'test data';
        final result1 = Success(data);
        final result2 = Success(data);

        // Assert
        expect(result1, equals(result2));
      });
    });

    group('Error', () {
      test('should create Error with message', () {
        // Arrange
        const message = 'Something went wrong';

        // Act
        final result = Error<String>(message: message);

        // Assert
        expect(result, isA<Error<String>>());
        expect(result.message, equals(message));
        expect(result.code, isNull);
      });

      test('should create Error with message and code', () {
        // Arrange
        const message = 'Server error';
        const code = 500;

        // Act
        final result = Error<String>(message: message, code: code);

        // Assert
        expect(result, isA<Error<String>>());
        expect(result.message, equals(message));
        expect(result.code, equals(code));
      });

      test('should be equal when message and code are equal', () {
        // Arrange
        const message = 'Error message';
        const code = 404;
        final result1 = Error<String>(message: message, code: code);
        final result2 = Error<String>(message: message, code: code);

        // Assert
        expect(result1, equals(result2));
      });
    });

    group('ResultExtensions', () {
      group('isSuccess', () {
        test('should return true for Success', () {
          // Arrange
          final result = const Success('data');

          // Assert
          expect(result.isSuccess, isTrue);
        });

        test('should return false for Error', () {
          // Arrange
          final result = const Error<String>(message: 'error');

          // Assert
          expect(result.isSuccess, isFalse);
        });
      });

      group('isError', () {
        test('should return true for Error', () {
          // Arrange
          final result = const Error<String>(message: 'error');

          // Assert
          expect(result.isError, isTrue);
        });

        test('should return false for Success', () {
          // Arrange
          final result = const Success('data');

          // Assert
          expect(result.isError, isFalse);
        });
      });

      group('dataOrNull', () {
        test('should return data for Success', () {
          // Arrange
          const data = 'test data';
          final result = Success(data);

          // Assert
          expect(result.dataOrNull, equals(data));
        });

        test('should return null for Error', () {
          // Arrange
          final result = const Error<String>(message: 'error');

          // Assert
          expect(result.dataOrNull, isNull);
        });
      });

      group('errorMessage', () {
        test('should return message for Error', () {
          // Arrange
          const message = 'error message';
          final result = Error<String>(message: message);

          // Assert
          expect(result.errorMessage, equals(message));
        });

        test('should return null for Success', () {
          // Arrange
          final result = const Success('data');

          // Assert
          expect(result.errorMessage, isNull);
        });
      });

      group('map', () {
        test('should transform Success data', () {
          // Arrange
          const data = 42;
          final result = Success(data);

          // Act
          final mappedResult = result.map((value) => value.toString());

          // Assert
          expect(mappedResult, isA<Success<String>>());
          expect(mappedResult.dataOrNull, equals('42'));
        });

        test('should preserve Error', () {
          // Arrange
          const message = 'error message';
          final result = Error<int>(message: message);

          // Act
          final mappedResult = result.map((value) => value.toString());

          // Assert
          expect(mappedResult, isA<Error<String>>());
          expect(mappedResult.errorMessage, equals(message));
        });
      });

      group('mapError', () {
        test('should preserve Success', () {
          // Arrange
          const data = 'data';
          final result = Success(data);

          // Act
          final mappedResult = result.mapError((message, code) => 
            Error<String>(message: 'new error', code: code));

          // Assert
          expect(mappedResult, isA<Success<String>>());
          expect(mappedResult.dataOrNull, equals(data));
        });

        test('should transform Error', () {
          // Arrange
          const message = 'original error';
          const code = 500;
          final result = Error<String>(message: message, code: code);

          // Act
          final mappedResult = result.mapError((msg, cd) => 
            Error<String>(message: 'transformed: $msg', code: cd));

          // Assert
          expect(mappedResult, isA<Error<String>>());
          expect(mappedResult.errorMessage, equals('transformed: $message'));
          // Note: We can't access code directly from Result, only from Error
          if (mappedResult is Error<String>) {
            expect(mappedResult.code, equals(code));
          }
        });
      });
    });
  });
}
