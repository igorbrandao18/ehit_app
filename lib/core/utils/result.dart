import 'package:equatable/equatable.dart';
sealed class Result<T> extends Equatable {
  const Result();
}
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
  @override
  List<Object?> get props => [data];
}
class Error<T> extends Result<T> {
  final String message;
  final int? code;
  const Error({
    required this.message,
    this.code,
  });
  @override
  List<Object?> get props => [message, code];
}
extension ResultExtensions<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;
  T? get dataOrNull => switch (this) {
    Success<T>(data: final data) => data,
    Error<T>() => null,
  };
  String? get errorMessage => switch (this) {
    Success<T>() => null,
    Error<T>(message: final message) => message,
  };
  Result<U> map<U>(U Function(T data) mapper) {
    return switch (this) {
      Success<T>(data: final data) => Success(mapper(data)),
      Error<T>(message: final message, code: final code) => Error<U>(
          message: message,
          code: code,
        ),
    };
  }
  Result<T> mapError(Result<T> Function(String message, int? code) mapper) {
    return switch (this) {
      Success<T>() => this,
      Error<T>(message: final message, code: final code) => mapper(message, code),
    };
  }
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, int? code) error,
  }) {
    return switch (this) {
      Success<T>(data: final data) => success(data),
      Error<T>(message: final message, code: final code) => error(message, code),
    };
  }
}
