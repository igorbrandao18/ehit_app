import 'package:equatable/equatable.dart';
import 'user.dart';
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}
enum EmailVerificationStatus {
  notVerified,
  pending,
  verified,
  failed,
}
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
  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isLoadingAuth => status == AuthStatus.loading || isLoading;
  bool get hasError => status == AuthStatus.error || errorMessage != null;
  bool get isEmailVerified => emailVerificationStatus == EmailVerificationStatus.verified;
  bool get canLogin => !isAccountLocked && loginAttempts < 5;
  bool get shouldShowBiometric => isBiometricEnabled && !isAuthenticated;
  bool get shouldRememberUser => isRememberMeEnabled && isAuthenticated;
  Duration? get timeSinceLastLogin {
    if (lastLoginAt == null) return null;
    return DateTime.now().difference(lastLoginAt!);
  }
  bool get hasRecentLogin {
    if (lastLoginAt == null) return false;
    final timeSince = timeSinceLastLogin!;
    return timeSince.inHours < 24;
  }
  AuthState clearError() {
    return copyWith(
      status: AuthStatus.initial,
      errorMessage: null,
    );
  }
  AuthState setLoading(bool loading) {
    return copyWith(
      isLoading: loading,
      status: loading ? AuthStatus.loading : status,
    );
  }
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
  AuthState setUnauthenticated() {
    return copyWith(
      status: AuthStatus.unauthenticated,
      user: null,
      errorMessage: null,
      isLoading: false,
      emailVerificationStatus: EmailVerificationStatus.notVerified,
    );
  }
  AuthState setError(String message) {
    return copyWith(
      status: AuthStatus.error,
      errorMessage: message,
      isLoading: false,
    );
  }
  AuthState incrementLoginAttempts() {
    final newAttempts = loginAttempts + 1;
    return copyWith(
      loginAttempts: newAttempts,
      isAccountLocked: newAttempts >= 5,
    );
  }
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
