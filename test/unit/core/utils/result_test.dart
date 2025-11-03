import 'package:flutter_test/flutter_test.dart';
import 'package:ehit_app/core/utils/result.dart';

void main() {
  group('Result', () {
    test('Success should contain data', () {
      const result = Success<String>('test data');
      
      result.when(
        success: (data) {
          expect(data, 'test data');
        },
        error: (message, code) {
          fail('Should not be an error');
        },
      );
    });

    test('Error should contain message and code', () {
      const result = Error<String>(message: 'Test error', code: 404);
      
      result.when(
        success: (data) {
          fail('Should not be a success');
        },
        error: (message, code) {
          expect(message, 'Test error');
          expect(code, 404);
        },
      );
    });

    test('Success can be compared for equality', () {
      const result1 = Success<String>('test');
      const result2 = Success<String>('test');
      const result3 = Success<String>('different');
      
      expect(result1, result2);
      expect(result1, isNot(result3));
    });

    test('Error can be compared for equality', () {
      const result1 = Error<String>(message: 'error', code: 500);
      const result2 = Error<String>(message: 'error', code: 500);
      const result3 = Error<String>(message: 'error', code: 404);
      
      expect(result1, result2);
      expect(result1, isNot(result3));
    });

    test('map extension should transform Success data', () {
      const result = Success<int>(5);
      final mapped = result.map((value) => value * 2);
      
      mapped.when(
        success: (data) {
          expect(data, 10);
        },
        error: (_, __) {
          fail('Should not be an error');
        },
      );
    });

    test('map extension should preserve Error', () {
      const result = Error<int>(message: 'error', code: 500);
      final mapped = result.map((value) => value * 2);
      
      mapped.when(
        success: (_) {
          fail('Should not be a success');
        },
        error: (message, code) {
          expect(message, 'error');
          expect(code, 500);
        },
      );
    });

    test('isSuccess should return true for Success', () {
      const result = Success<String>('test');
      expect(result.isSuccess, true);
      expect(result.isError, false);
    });

    test('isError should return true for Error', () {
      const result = Error<String>(message: 'error', code: 500);
      expect(result.isError, true);
      expect(result.isSuccess, false);
    });

    test('dataOrNull should return data for Success', () {
      const result = Success<String>('test data');
      expect(result.dataOrNull, 'test data');
    });

    test('dataOrNull should return null for Error', () {
      const result = Error<String>(message: 'error', code: 500);
      expect(result.dataOrNull, null);
    });

    test('errorMessage should return null for Success', () {
      const result = Success<String>('test');
      expect(result.errorMessage, null);
    });

    test('errorMessage should return message for Error', () {
      const result = Error<String>(message: 'test error', code: 404);
      expect(result.errorMessage, 'test error');
    });
  });
}
