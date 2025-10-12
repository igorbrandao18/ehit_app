// features/authentication/data/repositories/auth_repository_impl.dart

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementação do repositório de autenticação
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<AuthState>> getCurrentAuthState() async {
    try {
      // Tenta obter usuário do cache local primeiro
      final cachedUser = await localDataSource.getCachedUser();
      
      if (cachedUser != null) {
        // Verifica se o token ainda é válido
        final isTokenValid = await remoteDataSource.isTokenValid();
        
        if (isTokenValid) {
          final user = cachedUser.toEntity();
          final authState = AuthState.initial.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            isBiometricEnabled: await localDataSource.isBiometricEnabled(),
            isRememberMeEnabled: await localDataSource.isRememberMeEnabled(),
            lastLoginAt: await localDataSource.getLastLoginAt(),
            loginAttempts: await localDataSource.getLoginAttempts(),
            isAccountLocked: await localDataSource.isAccountLocked(),
            isPasswordResetRequested: await localDataSource.isPasswordResetRequested(),
          );
          return Success(authState);
        } else {
          // Token inválido, tenta renovar
          try {
            await remoteDataSource.refreshToken();
            final authState = AuthState.initial.copyWith(
              status: AuthStatus.authenticated,
              user: cachedUser.toEntity(),
              isBiometricEnabled: await localDataSource.isBiometricEnabled(),
              isRememberMeEnabled: await localDataSource.isRememberMeEnabled(),
              lastLoginAt: await localDataSource.getLastLoginAt(),
              loginAttempts: await localDataSource.getLoginAttempts(),
              isAccountLocked: await localDataSource.isAccountLocked(),
              isPasswordResetRequested: await localDataSource.isPasswordResetRequested(),
            );
            return Success(authState);
          } catch (e) {
            // Falha ao renovar token, limpa cache e retorna não autenticado
            await localDataSource.clearCachedUser();
            return Success(AuthState.initial);
          }
        }
      }
      
      return Success(AuthState.initial);
    } catch (e) {
      return Error(message: 'Erro ao obter estado de autenticação: $e');
    }
  }

  @override
  Future<Result<User>> loginWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final userModel = await remoteDataSource.loginWithEmail(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
      
      // Salva usuário no cache local
      await localDataSource.cacheUser(userModel);
      
      // Salva credenciais se solicitado
      if (rememberMe) {
        await localDataSource.saveCredentials(email, password);
        await localDataSource.setRememberMe(true);
      }
      
      // Atualiza último login
      await localDataSource.setLastLoginAt(DateTime.now());
      
      // Reseta tentativas de login
      await localDataSource.setLoginAttempts(0);
      await localDataSource.setAccountLocked(false);
      
      return Success(userModel.toEntity());
    } on ServerFailure catch (e) {
      // Incrementa tentativas de login em caso de erro
      final attempts = await localDataSource.getLoginAttempts();
      await localDataSource.setLoginAttempts(attempts + 1);
      
      if (attempts + 1 >= 5) {
        await localDataSource.setAccountLocked(true);
      }
      
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<User>> loginWithBiometric() async {
    try {
      final userModel = await remoteDataSource.loginWithBiometric();
      
      // Salva usuário no cache local
      await localDataSource.cacheUser(userModel);
      
      // Atualiza último login
      await localDataSource.setLastLoginAt(DateTime.now());
      
      // Reseta tentativas de login
      await localDataSource.setLoginAttempts(0);
      await localDataSource.setAccountLocked(false);
      
      return Success(userModel.toEntity());
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<User>> register({
    required String email,
    required String password,
    required String username,
    String? displayName,
  }) async {
    try {
      final userModel = await remoteDataSource.register(
        email: email,
        password: password,
        username: username,
        displayName: displayName,
      );
      
      // Salva usuário no cache local
      await localDataSource.cacheUser(userModel);
      
      // Atualiza último login
      await localDataSource.setLastLoginAt(DateTime.now());
      
      return Success(userModel.toEntity());
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await remoteDataSource.logout();
      
      // Limpa dados locais
      await localDataSource.clearCachedUser();
      
      // Limpa credenciais se não está marcado para lembrar
      final rememberMe = await localDataSource.isRememberMeEnabled();
      if (!rememberMe) {
        await localDataSource.clearSavedCredentials();
      }
      
      return const Success(null);
    } on ServerFailure catch (e) {
      // Mesmo com erro no servidor, limpa dados locais
      await localDataSource.clearCachedUser();
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<void>> sendEmailVerification() async {
    try {
      await remoteDataSource.sendEmailVerification();
      return const Success(null);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<void>> verifyEmail(String verificationCode) async {
    try {
      await remoteDataSource.verifyEmail(verificationCode);
      
      // Atualiza usuário local para marcar email como verificado
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        final updatedUser = cachedUser.copyWith(isEmailVerified: true);
        await localDataSource.cacheUser(updatedUser);
      }
      
      return const Success(null);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<void>> requestPasswordReset(String email) async {
    try {
      await remoteDataSource.requestPasswordReset(email);
      await localDataSource.setPasswordResetRequested(true);
      return const Success(null);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      await localDataSource.setPasswordResetRequested(false);
      return const Success(null);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<User>> updateProfile({
    String? displayName,
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      final userModel = await remoteDataSource.updateProfile(
        displayName: displayName,
        bio: bio,
        profileImageUrl: profileImageUrl,
      );
      
      // Atualiza usuário no cache local
      await localDataSource.cacheUser(userModel);
      
      return Success(userModel.toEntity());
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Success(null);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<void>> deleteAccount(String password) async {
    try {
      await remoteDataSource.deleteAccount(password);
      
      // Limpa todos os dados locais
      await localDataSource.clearAllAuthData();
      
      return const Success(null);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<bool>> isBiometricAvailable() async {
    try {
      final isAvailable = await remoteDataSource.isBiometricAvailable();
      return Success(isAvailable);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<bool>> isBiometricEnabled() async {
    try {
      final isEnabled = await localDataSource.isBiometricEnabled();
      return Success(isEnabled);
    } catch (e) {
      return Error(message: 'Erro ao verificar biometria: $e');
    }
  }

  @override
  Future<Result<void>> toggleBiometricAuth(bool enabled) async {
    try {
      await localDataSource.setBiometricEnabled(enabled);
      return const Success(null);
    } catch (e) {
      return Error(message: 'Erro ao alterar configuração biométrica: $e');
    }
  }

  @override
  Future<Result<User>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Success(cachedUser.toEntity());
      }
      
      // Se não há usuário em cache, tenta obter do servidor
      final userModel = await remoteDataSource.getCurrentUser();
      await localDataSource.cacheUser(userModel);
      return Success(userModel.toEntity());
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<User>> updateUser(User user) async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      await localDataSource.cacheUser(userModel);
      return Success(userModel.toEntity());
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<bool>> isTokenValid() async {
    try {
      final isValid = await remoteDataSource.isTokenValid();
      return Success(isValid);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<String>> refreshToken() async {
    try {
      final token = await remoteDataSource.refreshToken();
      return Success(token);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<void>> saveCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await localDataSource.saveCredentials(email, password);
      return const Success(null);
    } catch (e) {
      return Error(message: 'Erro ao salvar credenciais: $e');
    }
  }

  @override
  Future<Result<void>> clearSavedCredentials() async {
    try {
      await localDataSource.clearSavedCredentials();
      return const Success(null);
    } catch (e) {
      return Error(message: 'Erro ao limpar credenciais: $e');
    }
  }

  @override
  Future<Result<Map<String, String>>> getSavedCredentials() async {
    try {
      final credentials = await localDataSource.getSavedCredentials();
      if (credentials != null) {
        return Success(credentials);
      }
      return const Success({});
    } catch (e) {
      return Error(message: 'Erro ao obter credenciais: $e');
    }
  }

  @override
  Future<Result<bool>> hasSavedCredentials() async {
    try {
      final hasCredentials = await localDataSource.hasSavedCredentials();
      return Success(hasCredentials);
    } catch (e) {
      return Error(message: 'Erro ao verificar credenciais: $e');
    }
  }

  @override
  Future<Result<void>> setUserPreferences(Map<String, dynamic> preferences) async {
    try {
      await localDataSource.setUserPreferences(preferences);
      await remoteDataSource.setUserPreferences(preferences);
      return const Success(null);
    } on ServerFailure catch (e) {
      // Salva localmente mesmo se falhar no servidor
      await localDataSource.setUserPreferences(preferences);
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getUserPreferences() async {
    try {
      final preferences = await localDataSource.getUserPreferences();
      return Success(preferences);
    } catch (e) {
      return Error(message: 'Erro ao obter preferências: $e');
    }
  }

  @override
  Future<Result<bool>> isUserOnline() async {
    try {
      final isOnline = await remoteDataSource.isUserOnline();
      return Success(isOnline);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<void>> updateOnlineStatus(bool isOnline) async {
    try {
      await remoteDataSource.updateOnlineStatus(isOnline);
      return const Success(null);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<List<Map<String, dynamic>>>> getLoginHistory() async {
    try {
      final history = await localDataSource.getLoginHistory();
      return Success(history);
    } catch (e) {
      return Error(message: 'Erro ao obter histórico de logins: $e');
    }
  }

  @override
  Future<Result<void>> clearLoginHistory() async {
    try {
      await localDataSource.clearLoginHistory();
      await remoteDataSource.clearLoginHistory();
      return const Success(null);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<bool>> isAccountLocked() async {
    try {
      final isLocked = await localDataSource.isAccountLocked();
      return Success(isLocked);
    } catch (e) {
      return Error(message: 'Erro ao verificar bloqueio da conta: $e');
    }
  }

  @override
  Future<Result<void>> unlockAccount() async {
    try {
      await remoteDataSource.unlockAccount();
      await localDataSource.setAccountLocked(false);
      await localDataSource.setLoginAttempts(0);
      return const Success(null);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getSecurityStats() async {
    try {
      final stats = await remoteDataSource.getSecurityStats();
      return Success(stats);
    } on ServerFailure catch (e) {
      return Error(message: e.message, code: e.code);
    }
  }
}
