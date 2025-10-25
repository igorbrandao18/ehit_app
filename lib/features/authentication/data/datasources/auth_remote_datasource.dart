// features/authentication/data/datasources/auth_remote_datasource.dart

import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/constants/app_config.dart';

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

/// Implementação da fonte de dados remota de autenticação usando mock data
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    // Simular delay de rede
    await Future.delayed(const Duration(seconds: 1));
    return _getMockUser();
  }

  @override
  Future<UserModel> loginWithBiometric() async {
    await Future.delayed(const Duration(seconds: 1));
    return _getMockUser();
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
    String? displayName,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return _getMockUser();
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock logout - não faz nada
  }

  @override
  Future<void> sendEmailVerification() async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock verification - não faz nada
  }

  @override
  Future<void> verifyEmail(String verificationCode) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock verification - não faz nada
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock reset - não faz nada
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock reset - não faz nada
  }

  @override
  Future<UserModel> updateProfile({
    String? displayName,
    String? bio,
    String? profileImageUrl,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return _getMockUser();
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock change - não faz nada
  }

  @override
  Future<void> deleteAccount(String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock delete - não faz nada
  }

  @override
  Future<bool> isBiometricAvailable() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Mock response
  }

  @override
  Future<bool> isBiometricEnabled() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return false; // Mock response
  }

  @override
  Future<UserModel> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockUser();
  }

  @override
  Future<bool> isTokenValid() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Mock response
  }

  @override
  Future<String> refreshToken() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'mock_refresh_token'; // Mock response
  }

  @override
  Future<void> setUserPreferences(Map<String, dynamic> preferences) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock save - não faz nada
  }

  @override
  Future<Map<String, dynamic>> getUserPreferences() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {}; // Mock response
  }

  @override
  Future<bool> isUserOnline() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Mock response
  }

  @override
  Future<void> updateOnlineStatus(bool isOnline) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock update - não faz nada
  }

  @override
  Future<List<Map<String, dynamic>>> getLoginHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return []; // Mock response
  }

  @override
  Future<void> clearLoginHistory() async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock clear - não faz nada
  }

  @override
  Future<bool> isAccountLocked() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return false; // Mock response
  }

  @override
  Future<void> unlockAccount() async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock unlock - não faz nada
  }

  @override
  Future<Map<String, dynamic>> getSecurityStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {}; // Mock response
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