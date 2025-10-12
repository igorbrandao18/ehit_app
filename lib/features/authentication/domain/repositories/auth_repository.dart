// features/authentication/domain/repositories/auth_repository.dart

import '../../../../core/utils/result.dart';
import '../entities/user.dart';
import '../entities/auth_state.dart';

/// Interface para operações de autenticação
abstract class AuthRepository {
  /// Obtém o estado atual da autenticação
  Future<Result<AuthState>> getCurrentAuthState();
  
  /// Faz login com email e senha
  Future<Result<User>> loginWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  });
  
  /// Faz login com biometria
  Future<Result<User>> loginWithBiometric();
  
  /// Registra um novo usuário
  Future<Result<User>> register({
    required String email,
    required String password,
    required String username,
    String? displayName,
  });
  
  /// Faz logout
  Future<Result<void>> logout();
  
  /// Envia email de verificação
  Future<Result<void>> sendEmailVerification();
  
  /// Verifica email com código
  Future<Result<void>> verifyEmail(String verificationCode);
  
  /// Solicita reset de senha
  Future<Result<void>> requestPasswordReset(String email);
  
  /// Reseta senha com token
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  });
  
  /// Atualiza perfil do usuário
  Future<Result<User>> updateProfile({
    String? displayName,
    String? bio,
    String? profileImageUrl,
  });
  
  /// Altera senha
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  
  /// Deleta conta
  Future<Result<void>> deleteAccount(String password);
  
  /// Ativa/desativa autenticação biométrica
  Future<Result<void>> toggleBiometricAuth(bool enabled);
  
  /// Verifica se biometria está disponível
  Future<Result<bool>> isBiometricAvailable();
  
  /// Verifica se biometria está habilitada
  Future<Result<bool>> isBiometricEnabled();
  
  /// Obtém informações do usuário atual
  Future<Result<User>> getCurrentUser();
  
  /// Atualiza informações do usuário
  Future<Result<User>> updateUser(User user);
  
  /// Verifica se o token de acesso é válido
  Future<Result<bool>> isTokenValid();
  
  /// Renova token de acesso
  Future<Result<String>> refreshToken();
  
  /// Salva credenciais para login automático
  Future<Result<void>> saveCredentials({
    required String email,
    required String password,
  });
  
  /// Remove credenciais salvas
  Future<Result<void>> clearSavedCredentials();
  
  /// Obtém credenciais salvas
  Future<Result<Map<String, String>>> getSavedCredentials();
  
  /// Verifica se há credenciais salvas
  Future<Result<bool>> hasSavedCredentials();
  
  /// Define preferências do usuário
  Future<Result<void>> setUserPreferences(Map<String, dynamic> preferences);
  
  /// Obtém preferências do usuário
  Future<Result<Map<String, dynamic>>> getUserPreferences();
  
  /// Verifica se o usuário está online
  Future<Result<bool>> isUserOnline();
  
  /// Atualiza status online do usuário
  Future<Result<void>> updateOnlineStatus(bool isOnline);
  
  /// Obtém histórico de logins
  Future<Result<List<Map<String, dynamic>>>> getLoginHistory();
  
  /// Limpa histórico de logins
  Future<Result<void>> clearLoginHistory();
  
  /// Verifica se a conta está bloqueada
  Future<Result<bool>> isAccountLocked();
  
  /// Desbloqueia conta
  Future<Result<void>> unlockAccount();
  
  /// Obtém estatísticas de segurança
  Future<Result<Map<String, dynamic>>> getSecurityStats();
}
