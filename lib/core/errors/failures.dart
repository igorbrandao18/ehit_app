// core/errors/failures.dart

import 'package:equatable/equatable.dart';

/// Classe base para falhas da aplicação
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Falha de servidor/API
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}

/// Falha de rede/conectividade
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });
}

/// Falha de cache/local storage
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });
}

/// Falha de validação
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

/// Falha de autenticação
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
  });
}

/// Falha de áudio/reprodução
class AudioFailure extends Failure {
  const AudioFailure({
    required super.message,
    super.code,
  });
}
