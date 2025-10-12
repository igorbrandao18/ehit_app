// core/utils/result.dart

import 'package:equatable/equatable.dart';

/// Resultado de operações que podem falhar
sealed class Result<T> extends Equatable {
  const Result();
}

/// Operação bem-sucedida
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  List<Object?> get props => [data];
}

/// Operação falhou
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

/// Extensões para facilitar o uso do Result
extension ResultExtensions<T> on Result<T> {
  /// Verifica se é sucesso
  bool get isSuccess => this is Success<T>;

  /// Verifica se é erro
  bool get isError => this is Error<T>;

  /// Obtém os dados se for sucesso, null caso contrário
  T? get dataOrNull => switch (this) {
    Success<T>(data: final data) => data,
    Error<T>() => null,
  };

  /// Obtém a mensagem de erro se for erro, null caso contrário
  String? get errorMessage => switch (this) {
    Success<T>() => null,
    Error<T>(message: final message) => message,
  };

  /// Executa uma função se for sucesso
  Result<U> map<U>(U Function(T data) mapper) {
    return switch (this) {
      Success<T>(data: final data) => Success(mapper(data)),
      Error<T>(message: final message, code: final code) => Error<U>(
          message: message,
          code: code,
        ),
    };
  }

  /// Executa uma função se for erro
  Result<T> mapError(Result<T> Function(String message, int? code) mapper) {
    return switch (this) {
      Success<T>() => this,
      Error<T>(message: final message, code: final code) => mapper(message, code),
    };
  }

  /// Executa uma função baseada no tipo do resultado
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
