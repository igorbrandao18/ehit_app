// features/authentication/domain/usecases/auth_usecases.dart

import '../../../../core/utils/result.dart';
import '../entities/user.dart';
import '../entities/auth_state.dart';
import '../repositories/auth_repository.dart';

/// Use case para fazer login com email e senha
class LoginWithEmailUseCase {
  final AuthRepository repository;
  
  const LoginWithEmailUseCase(this.repository);
  
  Future<Result<User>> call({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    if (email.trim().isEmpty) {
      return const Error(message: 'Email não pode estar vazio');
    }
    
    if (password.trim().isEmpty) {
      return const Error(message: 'Senha não pode estar vazia');
    }
    
    if (!_isValidEmail(email)) {
      return const Error(message: 'Email inválido');
    }
    
    if (password.length < 8) {
      return const Error(message: 'Senha deve ter pelo menos 8 caracteres');
    }
    
    return await repository.loginWithEmail(
      email: email.trim().toLowerCase(),
      password: password,
      rememberMe: rememberMe,
    );
  }
  
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

/// Use case para fazer login com biometria
class LoginWithBiometricUseCase {
  final AuthRepository repository;
  
  const LoginWithBiometricUseCase(this.repository);
  
  Future<Result<User>> call() async {
    return await repository.loginWithBiometric();
  }
}

/// Use case para registrar usuário
class RegisterUseCase {
  final AuthRepository repository;
  
  const RegisterUseCase(this.repository);
  
  Future<Result<User>> call({
    required String email,
    required String password,
    required String username,
    String? displayName,
  }) async {
    if (email.trim().isEmpty) {
      return const Error(message: 'Email não pode estar vazio');
    }
    
    if (password.trim().isEmpty) {
      return const Error(message: 'Senha não pode estar vazia');
    }
    
    if (username.trim().isEmpty) {
      return const Error(message: 'Nome de usuário não pode estar vazio');
    }
    
    if (!_isValidEmail(email)) {
      return const Error(message: 'Email inválido');
    }
    
    if (password.length < 8) {
      return const Error(message: 'Senha deve ter pelo menos 8 caracteres');
    }
    
    if (username.length < 3) {
      return const Error(message: 'Nome de usuário deve ter pelo menos 3 caracteres');
    }
    
    if (!_isValidUsername(username)) {
      return const Error(message: 'Nome de usuário deve conter apenas letras, números e underscore');
    }
    
    return await repository.register(
      email: email.trim().toLowerCase(),
      password: password,
      username: username.trim(),
      displayName: displayName?.trim(),
    );
  }
  
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  bool _isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username);
  }
}

/// Use case para fazer logout
class LogoutUseCase {
  final AuthRepository repository;
  
  const LogoutUseCase(this.repository);
  
  Future<Result<void>> call() async {
    return await repository.logout();
  }
}

/// Use case para enviar verificação de email
class SendEmailVerificationUseCase {
  final AuthRepository repository;
  
  const SendEmailVerificationUseCase(this.repository);
  
  Future<Result<void>> call() async {
    return await repository.sendEmailVerification();
  }
}

/// Use case para verificar email
class VerifyEmailUseCase {
  final AuthRepository repository;
  
  const VerifyEmailUseCase(this.repository);
  
  Future<Result<void>> call(String verificationCode) async {
    if (verificationCode.trim().isEmpty) {
      return const Error(message: 'Código de verificação não pode estar vazio');
    }
    
    return await repository.verifyEmail(verificationCode.trim());
  }
}

/// Use case para solicitar reset de senha
class RequestPasswordResetUseCase {
  final AuthRepository repository;
  
  const RequestPasswordResetUseCase(this.repository);
  
  Future<Result<void>> call(String email) async {
    if (email.trim().isEmpty) {
      return const Error(message: 'Email não pode estar vazio');
    }
    
    if (!_isValidEmail(email)) {
      return const Error(message: 'Email inválido');
    }
    
    return await repository.requestPasswordReset(email.trim().toLowerCase());
  }
  
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

/// Use case para resetar senha
class ResetPasswordUseCase {
  final AuthRepository repository;
  
  const ResetPasswordUseCase(this.repository);
  
  Future<Result<void>> call({
    required String token,
    required String newPassword,
  }) async {
    if (token.trim().isEmpty) {
      return const Error(message: 'Token não pode estar vazio');
    }
    
    if (newPassword.trim().isEmpty) {
      return const Error(message: 'Nova senha não pode estar vazia');
    }
    
    if (newPassword.length < 8) {
      return const Error(message: 'Nova senha deve ter pelo menos 8 caracteres');
    }
    
    return await repository.resetPassword(
      token: token.trim(),
      newPassword: newPassword,
    );
  }
}

/// Use case para atualizar perfil
class UpdateProfileUseCase {
  final AuthRepository repository;
  
  const UpdateProfileUseCase(this.repository);
  
  Future<Result<User>> call({
    String? displayName,
    String? bio,
    String? profileImageUrl,
  }) async {
    if (displayName != null && displayName.trim().isEmpty) {
      return const Error(message: 'Nome de exibição não pode estar vazio');
    }
    
    if (bio != null && bio.length > 160) {
      return const Error(message: 'Bio deve ter no máximo 160 caracteres');
    }
    
    return await repository.updateProfile(
      displayName: displayName?.trim(),
      bio: bio?.trim(),
      profileImageUrl: profileImageUrl?.trim(),
    );
  }
}

/// Use case para alterar senha
class ChangePasswordUseCase {
  final AuthRepository repository;
  
  const ChangePasswordUseCase(this.repository);
  
  Future<Result<void>> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (currentPassword.trim().isEmpty) {
      return const Error(message: 'Senha atual não pode estar vazia');
    }
    
    if (newPassword.trim().isEmpty) {
      return const Error(message: 'Nova senha não pode estar vazia');
    }
    
    if (newPassword.length < 8) {
      return const Error(message: 'Nova senha deve ter pelo menos 8 caracteres');
    }
    
    if (currentPassword == newPassword) {
      return const Error(message: 'Nova senha deve ser diferente da senha atual');
    }
    
    return await repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}

/// Use case para obter usuário atual
class GetCurrentUserUseCase {
  final AuthRepository repository;
  
  const GetCurrentUserUseCase(this.repository);
  
  Future<Result<User>> call() async {
    return await repository.getCurrentUser();
  }
}

/// Use case para obter estado de autenticação
class GetAuthStateUseCase {
  final AuthRepository repository;
  
  const GetAuthStateUseCase(this.repository);
  
  Future<Result<AuthState>> call() async {
    return await repository.getCurrentAuthState();
  }
}

/// Use case para verificar se está autenticado
class IsAuthenticatedUseCase {
  final AuthRepository repository;
  
  const IsAuthenticatedUseCase(this.repository);
  
  Future<Result<bool>> call() async {
    final authStateResult = await repository.getCurrentAuthState();
    return authStateResult.when(
      success: (authState) => Success(authState.isAuthenticated),
      error: (message, code) => Error(message: message, code: code),
    );
  }
}

/// Use case para verificar se biometria está disponível
class IsBiometricAvailableUseCase {
  final AuthRepository repository;
  
  const IsBiometricAvailableUseCase(this.repository);
  
  Future<Result<bool>> call() async {
    return await repository.isBiometricAvailable();
  }
}

/// Use case para alternar autenticação biométrica
class ToggleBiometricAuthUseCase {
  final AuthRepository repository;
  
  const ToggleBiometricAuthUseCase(this.repository);
  
  Future<Result<void>> call(bool enabled) async {
    return await repository.toggleBiometricAuth(enabled);
  }
}
