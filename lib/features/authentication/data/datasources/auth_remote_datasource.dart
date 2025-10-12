// features/authentication/data/datasources/auth_remote_datasource.dart

import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/supabase/supabase_auth_service.dart';
import '../../../../core/utils/result.dart';

/// Interface para fonte de dados remota de autenticação
abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  });
  
  Future<UserModel> loginWithBiometric();
  
  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
    String? displayName,
  });
  
  Future<void> logout();
  
  Future<void> sendEmailVerification();
  
  Future<void> verifyEmail(String verificationCode);
  
  Future<void> requestPasswordReset(String email);
  
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });
  
  Future<UserModel> updateProfile({
    String? displayName,
    String? bio,
    String? profileImageUrl,
  });
  
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  
  Future<void> deleteAccount(String password);
  
  Future<bool> isBiometricAvailable();
  
  Future<bool> isBiometricEnabled();
  
  Future<UserModel> getCurrentUser();
  
  Future<bool> isTokenValid();
  
  Future<String> refreshToken();
  
  Future<void> setUserPreferences(Map<String, dynamic> preferences);
  
  Future<Map<String, dynamic>> getUserPreferences();
  
  Future<bool> isUserOnline();
  
  Future<void> updateOnlineStatus(bool isOnline);
  
  Future<List<Map<String, dynamic>>> getLoginHistory();
  
  Future<void> clearLoginHistory();
  
  Future<bool> isAccountLocked();
  
  Future<void> unlockAccount();
  
  Future<Map<String, dynamic>> getSecurityStats();
}

/// Implementação da fonte de dados remota de autenticação usando Supabase
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  final SupabaseAuthService _authService;

  AuthRemoteDataSourceImpl(this._dio) : _authService = SupabaseAuthService();

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final result = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      return result.when(
        success: (user) => UserModel.fromEntity(user),
        error: (message, code) => throw ServerFailure(
          message: message,
          code: code,
        ),
      );
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure(
        message: 'Erro inesperado ao fazer login: $e',
      );
    }
  }

  @override
  Future<UserModel> loginWithBiometric() async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
      return _getMockUser();
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao fazer login biométrico: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao fazer login biométrico: $e');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
    String? displayName,
  }) async {
    try {
      final result = await _authService.signUpWithEmail(
        email: email,
        password: password,
        username: username,
        displayName: displayName,
      );

      return result.when(
        success: (user) => UserModel.fromEntity(user),
        error: (message, code) => throw ServerFailure(
          message: message,
          code: code,
        ),
      );
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure(
        message: 'Erro inesperado ao registrar: $e',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      final result = await _authService.signOut();
      if (result is Error) {
        throw ServerFailure(
          message: result.message,
          code: result.code,
        );
      }
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw ServerFailure(
        message: 'Erro inesperado ao fazer logout: $e',
      );
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao enviar verificação de email: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao enviar verificação de email: $e');
    }
  }

  @override
  Future<void> verifyEmail(String verificationCode) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao verificar email: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao verificar email: $e');
    }
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao solicitar reset de senha: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao solicitar reset de senha: $e');
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao resetar senha: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao resetar senha: $e');
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? displayName,
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
      return _getMockUser();
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao atualizar perfil: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao atualizar perfil: $e');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao alterar senha: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao alterar senha: $e');
    }
  }

  @override
  Future<void> deleteAccount(String password) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao deletar conta: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao deletar conta: $e');
    }
  }

  @override
  Future<bool> isBiometricAvailable() async {
    try {
      // TODO: Implementar verificação real de biometria
      await Future.delayed(const Duration(milliseconds: 500));
      return true; // Mock response
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isBiometricEnabled() async {
    try {
      // TODO: Implementar verificação real de biometria
      await Future.delayed(const Duration(milliseconds: 500));
      return false; // Mock response
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(milliseconds: 500));
      return _getMockUser();
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao obter usuário atual: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao obter usuário atual: $e');
    }
  }

  @override
  Future<bool> isTokenValid() async {
    try {
      // TODO: Implementar verificação real de token
      await Future.delayed(const Duration(milliseconds: 500));
      return true; // Mock response
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> refreshToken() async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
      return 'mock_refresh_token'; // Mock response
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao renovar token: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao renovar token: $e');
    }
  }

  @override
  Future<void> setUserPreferences(Map<String, dynamic> preferences) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao salvar preferências: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao salvar preferências: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserPreferences() async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(milliseconds: 500));
      return {}; // Mock response
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao obter preferências: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao obter preferências: $e');
    }
  }

  @override
  Future<bool> isUserOnline() async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(milliseconds: 500));
      return true; // Mock response
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateOnlineStatus(bool isOnline) async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      // Ignore errors for online status updates
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getLoginHistory() async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(milliseconds: 500));
      return []; // Mock response
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao obter histórico de logins: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao obter histórico de logins: $e');
    }
  }

  @override
  Future<void> clearLoginHistory() async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao limpar histórico de logins: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao limpar histórico de logins: $e');
    }
  }

  @override
  Future<bool> isAccountLocked() async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(milliseconds: 500));
      return false; // Mock response
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> unlockAccount() async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(seconds: 1));
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao desbloquear conta: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao desbloquear conta: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getSecurityStats() async {
    try {
      // TODO: Implementar chamada real para API
      await Future.delayed(const Duration(milliseconds: 500));
      return {}; // Mock response
    } on DioException catch (e) {
      throw ServerFailure(
        message: 'Erro ao obter estatísticas de segurança: ${e.message}',
        code: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerFailure(message: 'Erro desconhecido ao obter estatísticas de segurança: $e');
    }
  }

  // Mock data methods
  UserModel _getMockUser() {
    return UserModel(
      id: 'user_123',
      email: 'user@example.com',
      username: 'testuser',
      displayName: 'Test User',
      profileImageUrl: AppConfig.defaultArtistImage,
      bio: 'Usuário de teste do ÊHIT',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
      isEmailVerified: true,
      isActive: true,
      phoneNumber: '+5511999999999',
      lastLoginAt: DateTime.now().subtract(const Duration(minutes: 5)),
      preferences: ['dark_mode', 'notifications_enabled'],
      metadata: {
        'theme': 'dark',
        'language': 'pt_BR',
        'timezone': 'America/Sao_Paulo',
      },
    );
  }
}
