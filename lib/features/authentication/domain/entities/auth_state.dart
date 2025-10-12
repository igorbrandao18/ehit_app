// features/authentication/domain/entities/auth_state.dart

import 'package:equatable/equatable.dart';
import 'user.dart';

/// Estados possíveis da autenticação
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Estados de verificação de email
enum EmailVerificationStatus {
  notVerified,
  pending,
  verified,
  failed,
}

/// Entidade que representa o estado atual da autenticação
class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final bool isLoading;
  final EmailVerificationStatus emailVerificationStatus;
  final bool isBiometricEnabled;
  final bool isRememberMeEnabled;
  final DateTime? lastLoginAt;
  final int loginAttempts;
  final bool isPasswordResetRequested;
  final bool isAccountLocked;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
    required this.isLoading,
    required this.emailVerificationStatus,
    required this.isBiometricEnabled,
    required this.isRememberMeEnabled,
    this.lastLoginAt,
    required this.loginAttempts,
    required this.isPasswordResetRequested,
    required this.isAccountLocked,
  });

  /// Estado inicial da autenticação
  static const AuthState initial = AuthState(
    status: AuthStatus.initial,
    isLoading: false,
    emailVerificationStatus: EmailVerificationStatus.notVerified,
    isBiometricEnabled: false,
    isRememberMeEnabled: false,
    loginAttempts: 0,
    isPasswordResetRequested: false,
    isAccountLocked: false,
  );

  /// Cria uma cópia do estado com campos modificados
  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool? isLoading,
    EmailVerificationStatus? emailVerificationStatus,
    bool? isBiometricEnabled,
    bool? isRememberMeEnabled,
    DateTime? lastLoginAt,
    int? loginAttempts,
    bool? isPasswordResetRequested,
    bool? isAccountLocked,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      emailVerificationStatus: emailVerificationStatus ?? this.emailVerificationStatus,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isRememberMeEnabled: isRememberMeEnabled ?? this.isRememberMeEnabled,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      loginAttempts: loginAttempts ?? this.loginAttempts,
      isPasswordResetRequested: isPasswordResetRequested ?? this.isPasswordResetRequested,
      isAccountLocked: isAccountLocked ?? this.isAccountLocked,
    );
  }

  /// Verifica se está autenticado
  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;

  /// Verifica se não está autenticado
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  /// Verifica se está carregando
  bool get isLoadingAuth => status == AuthStatus.loading || isLoading;

  /// Verifica se há erro
  bool get hasError => status == AuthStatus.error || errorMessage != null;

  /// Verifica se o email está verificado
  bool get isEmailVerified => emailVerificationStatus == EmailVerificationStatus.verified;

  /// Verifica se pode fazer login (não está bloqueado)
  bool get canLogin => !isAccountLocked && loginAttempts < 5;

  /// Verifica se deve mostrar opção de biometria
  bool get shouldShowBiometric => isBiometricEnabled && !isAuthenticated;

  /// Verifica se deve lembrar do usuário
  bool get shouldRememberUser => isRememberMeEnabled && isAuthenticated;

  /// Obtém o tempo desde o último login
  Duration? get timeSinceLastLogin {
    if (lastLoginAt == null) return null;
    return DateTime.now().difference(lastLoginAt!);
  }

  /// Verifica se o último login foi recente (menos de 24h)
  bool get hasRecentLogin {
    if (lastLoginAt == null) return false;
    final timeSince = timeSinceLastLogin!;
    return timeSince.inHours < 24;
  }

  /// Limpa o erro
  AuthState clearError() {
    return copyWith(
      status: AuthStatus.initial,
      errorMessage: null,
    );
  }

  /// Define estado de carregamento
  AuthState setLoading(bool loading) {
    return copyWith(
      isLoading: loading,
      status: loading ? AuthStatus.loading : status,
    );
  }

  /// Define usuário autenticado
  AuthState setAuthenticated(User user) {
    return copyWith(
      status: AuthStatus.authenticated,
      user: user,
      errorMessage: null,
      isLoading: false,
      lastLoginAt: DateTime.now(),
      loginAttempts: 0,
      isAccountLocked: false,
    );
  }

  /// Define estado não autenticado
  AuthState setUnauthenticated() {
    return copyWith(
      status: AuthStatus.unauthenticated,
      user: null,
      errorMessage: null,
      isLoading: false,
      emailVerificationStatus: EmailVerificationStatus.notVerified,
    );
  }

  /// Define erro
  AuthState setError(String message) {
    return copyWith(
      status: AuthStatus.error,
      errorMessage: message,
      isLoading: false,
    );
  }

  /// Incrementa tentativas de login
  AuthState incrementLoginAttempts() {
    final newAttempts = loginAttempts + 1;
    return copyWith(
      loginAttempts: newAttempts,
      isAccountLocked: newAttempts >= 5,
    );
  }

  /// Reseta tentativas de login
  AuthState resetLoginAttempts() {
    return copyWith(
      loginAttempts: 0,
      isAccountLocked: false,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        errorMessage,
        isLoading,
        emailVerificationStatus,
        isBiometricEnabled,
        isRememberMeEnabled,
        lastLoginAt,
        loginAttempts,
        isPasswordResetRequested,
        isAccountLocked,
      ];

  @override
  String toString() {
    return 'AuthState(status: $status, user: ${user?.username}, isLoading: $isLoading, hasError: $hasError)';
  }
}
