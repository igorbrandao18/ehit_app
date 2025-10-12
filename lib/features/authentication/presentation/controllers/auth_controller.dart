// features/authentication/presentation/controllers/auth_controller.dart

import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../../../core/utils/result.dart';

/// Controller para gerenciar o estado da autenticação
class AuthController extends ChangeNotifier {
  // Use Cases
  final LoginWithEmailUseCase _loginWithEmailUseCase;
  final LoginWithBiometricUseCase _loginWithBiometricUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final SendEmailVerificationUseCase _sendEmailVerificationUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final RequestPasswordResetUseCase _requestPasswordResetUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetAuthStateUseCase _getAuthStateUseCase;
  final IsAuthenticatedUseCase _isAuthenticatedUseCase;
  final IsBiometricAvailableUseCase _isBiometricAvailableUseCase;
  final ToggleBiometricAuthUseCase _toggleBiometricAuthUseCase;

  // State
  AuthState _authState = AuthState.initial;
  bool _isInitialized = false;

  // Getters
  AuthState get authState => _authState;
  User? get currentUser => _authState.user;
  bool get isAuthenticated => _authState.isAuthenticated;
  bool get isLoading => _authState.isLoadingAuth;
  String? get errorMessage => _authState.errorMessage;
  bool get isInitialized => _isInitialized;

  AuthController({
    required LoginWithEmailUseCase loginWithEmailUseCase,
    required LoginWithBiometricUseCase loginWithBiometricUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required SendEmailVerificationUseCase sendEmailVerificationUseCase,
    required VerifyEmailUseCase verifyEmailUseCase,
    required RequestPasswordResetUseCase requestPasswordResetUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetAuthStateUseCase getAuthStateUseCase,
    required IsAuthenticatedUseCase isAuthenticatedUseCase,
    required IsBiometricAvailableUseCase isBiometricAvailableUseCase,
    required ToggleBiometricAuthUseCase toggleBiometricAuthUseCase,
  }) : _loginWithEmailUseCase = loginWithEmailUseCase,
       _loginWithBiometricUseCase = loginWithBiometricUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _sendEmailVerificationUseCase = sendEmailVerificationUseCase,
       _verifyEmailUseCase = verifyEmailUseCase,
       _requestPasswordResetUseCase = requestPasswordResetUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _updateProfileUseCase = updateProfileUseCase,
       _changePasswordUseCase = changePasswordUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _getAuthStateUseCase = getAuthStateUseCase,
       _isAuthenticatedUseCase = isAuthenticatedUseCase,
       _isBiometricAvailableUseCase = isBiometricAvailableUseCase,
       _toggleBiometricAuthUseCase = toggleBiometricAuthUseCase;

  /// Inicializa o controller verificando o estado de autenticação
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _setLoading(true);
    _clearError();

    final result = await _getAuthStateUseCase();
    result.when(
      success: (authState) {
        _authState = authState;
        _isInitialized = true;
        notifyListeners();
      },
      error: (message, code) {
        _setError('Erro ao inicializar autenticação: $message');
        _isInitialized = true;
      },
    );

    _setLoading(false);
  }

  /// Faz login com email e senha
  Future<bool> loginWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _loginWithEmailUseCase(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );

    bool success = false;
    result.when(
      success: (user) {
        _authState = _authState.setAuthenticated(user);
        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _authState = _authState.setError(message);
        notifyListeners();
      },
    );

    _setLoading(false);
    return success;
  }

  /// Faz login com biometria
  Future<bool> loginWithBiometric() async {
    _setLoading(true);
    _clearError();

    final result = await _loginWithBiometricUseCase();

    bool success = false;
    result.when(
      success: (user) {
        _authState = _authState.setAuthenticated(user);
        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _authState = _authState.setError(message);
        notifyListeners();
      },
    );

    _setLoading(false);
    return success;
  }

  /// Registra um novo usuário
  Future<bool> register({
    required String email,
    required String password,
    required String username,
    String? displayName,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _registerUseCase(
      email: email,
      password: password,
      username: username,
      displayName: displayName,
    );

    bool success = false;
    result.when(
      success: (user) {
        _authState = _authState.setAuthenticated(user);
        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _authState = _authState.setError(message);
        notifyListeners();
      },
    );

    _setLoading(false);
    return success;
  }

  /// Faz logout
  Future<bool> logout() async {
    _setLoading(true);
    _clearError();

    final result = await _logoutUseCase();

    bool success = false;
    result.when(
      success: (_) {
        _authState = _authState.setUnauthenticated();
        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _authState = _authState.setError(message);
        notifyListeners();
      },
    );

    _setLoading(false);
    return success;
  }

  /// Envia verificação de email
  Future<bool> sendEmailVerification() async {
    _setLoading(true);
    _clearError();

    final result = await _sendEmailVerificationUseCase();

    bool success = false;
    result.when(
      success: (_) {
        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _authState = _authState.setError(message);
        notifyListeners();
      },
    );

    _setLoading(false);
    return success;
  }

  /// Verifica email com código
  Future<bool> verifyEmail(String verificationCode) async {
    _setLoading(true);
    _clearError();

    final result = await _verifyEmailUseCase(verificationCode);

    bool success = false;
    result.when(
      success: (_) {
        // Atualiza estado do usuário para email verificado
        if (_authState.user != null) {
          final updatedUser = _authState.user!.copyWith(isEmailVerified: true);
          _authState = _authState.copyWith(user: updatedUser);
        }
        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _authState = _authState.setError(message);
        notifyListeners();
      },
    );

    _setLoading(false);
    return success;
  }

  /// Solicita reset de senha
  Future<bool> requestPasswordReset(String email) async {
    _setLoading(true);
    _clearError();

    final result = await _requestPasswordResetUseCase(email);

    bool success = false;
    result.when(
      success: (_) {
        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _authState = _authState.setError(message);
        notifyListeners();
      },
    );

    _setLoading(false);
    return success;
  }

  /// Reseta senha
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _resetPasswordUseCase(
      token: token,
      newPassword: newPassword,
    );

    bool success = false;
    result.when(
      success: (_) {
        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _authState = _authState.setError(message);
        notifyListeners();
      },
    );

    _setLoading(false);
    return success;
  }

  /// Atualiza perfil do usuário
  Future<bool> updateProfile({
    String? displayName,
    String? bio,
    String? profileImageUrl,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _updateProfileUseCase(
      displayName: displayName,
      bio: bio,
      profileImageUrl: profileImageUrl,
    );

    bool success = false;
    result.when(
      success: (updatedUser) {
        _authState = _authState.copyWith(user: updatedUser);
        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _authState = _authState.setError(message);
        notifyListeners();
      },
    );

    _setLoading(false);
    return success;
  }

  /// Altera senha
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _changePasswordUseCase(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    bool success = false;
    result.when(
      success: (_) {
        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _authState = _authState.setError(message);
        notifyListeners();
      },
    );

    _setLoading(false);
    return success;
  }

  /// Verifica se está autenticado
  Future<bool> checkAuthentication() async {
    final result = await _isAuthenticatedUseCase();
    return result.when(
      success: (isAuthenticated) => isAuthenticated,
      error: (message, code) => false,
    );
  }

  /// Verifica se biometria está disponível
  Future<bool> checkBiometricAvailability() async {
    final result = await _isBiometricAvailableUseCase();
    return result.when(
      success: (isAvailable) => isAvailable,
      error: (message, code) => false,
    );
  }

  /// Ativa/desativa autenticação biométrica
  Future<bool> toggleBiometricAuth(bool enabled) async {
    _setLoading(true);
    _clearError();

    final result = await _toggleBiometricAuthUseCase(enabled);

    bool success = false;
    result.when(
      success: (_) {
        _authState = _authState.copyWith(isBiometricEnabled: enabled);
        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _authState = _authState.setError(message);
        notifyListeners();
      },
    );

    _setLoading(false);
    return success;
  }

  /// Atualiza usuário atual
  Future<void> refreshUser() async {
    final result = await _getCurrentUserUseCase();
    result.when(
      success: (user) {
        _authState = _authState.copyWith(user: user);
        notifyListeners();
      },
      error: (message, code) {
        _authState = _authState.setError(message);
        notifyListeners();
      },
    );
  }

  /// Limpa erro
  void clearError() {
    _authState = _authState.clearError();
    notifyListeners();
  }

  /// Reseta estado
  void reset() {
    _authState = AuthState.initial;
    _isInitialized = false;
    notifyListeners();
  }

  // Private methods
  void _setLoading(bool loading) {
    _authState = _authState.setLoading(loading);
    notifyListeners();
  }

  void _setError(String error) {
    _authState = _authState.setError(error);
    notifyListeners();
  }

  void _clearError() {
    _authState = _authState.clearError();
  }
}
