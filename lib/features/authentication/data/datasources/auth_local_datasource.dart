import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../../../core/errors/failures.dart';
abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCachedUser();
  Future<void> saveCredentials(String email, String password);
  Future<Map<String, String>?> getSavedCredentials();
  Future<void> clearSavedCredentials();
  Future<bool> hasSavedCredentials();
  Future<void> setBiometricEnabled(bool enabled);
  Future<bool> isBiometricEnabled();
  Future<void> setRememberMe(bool enabled);
  Future<bool> isRememberMeEnabled();
  Future<void> setUserPreferences(Map<String, dynamic> preferences);
  Future<Map<String, dynamic>> getUserPreferences();
  Future<void> saveLoginHistory(List<Map<String, dynamic>> history);
  Future<List<Map<String, dynamic>>> getLoginHistory();
  Future<void> clearLoginHistory();
  Future<void> setLastLoginAt(DateTime dateTime);
  Future<DateTime?> getLastLoginAt();
  Future<void> setLoginAttempts(int attempts);
  Future<int> getLoginAttempts();
  Future<void> setAccountLocked(bool locked);
  Future<bool> isAccountLocked();
  Future<void> setPasswordResetRequested(bool requested);
  Future<bool> isPasswordResetRequested();
  Future<void> clearAllAuthData();
}
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  AuthLocalDataSourceImpl({required this.sharedPreferences});
  static const String _cachedUserKey = 'cached_user';
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _rememberMeKey = 'remember_me';
  static const String _userPreferencesKey = 'user_preferences';
  static const String _loginHistoryKey = 'login_history';
  static const String _lastLoginAtKey = 'last_login_at';
  static const String _loginAttemptsKey = 'login_attempts';
  static const String _accountLockedKey = 'account_locked';
  static const String _passwordResetRequestedKey = 'password_reset_requested';
  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(_cachedUserKey);
      if (jsonString != null) {
        return UserModel.fromJson(json.decode(jsonString));
      }
      return null;
    } catch (e) {
      throw CacheFailure(message: 'Erro ao recuperar usuário do cache: $e');
    }
  }
  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final jsonString = json.encode(user.toJson());
      await sharedPreferences.setString(_cachedUserKey, jsonString);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao salvar usuário no cache: $e');
    }
  }
  @override
  Future<void> clearCachedUser() async {
    try {
      await sharedPreferences.remove(_cachedUserKey);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao limpar usuário do cache: $e');
    }
  }
  @override
  Future<void> saveCredentials(String email, String password) async {
    try {
      await sharedPreferences.setString(_savedEmailKey, email);
      await sharedPreferences.setString(_savedPasswordKey, password);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao salvar credenciais: $e');
    }
  }
  @override
  Future<Map<String, String>?> getSavedCredentials() async {
    try {
      final email = sharedPreferences.getString(_savedEmailKey);
      final password = sharedPreferences.getString(_savedPasswordKey);
      if (email != null && password != null) {
        return {'email': email, 'password': password};
      }
      return null;
    } catch (e) {
      throw CacheFailure(message: 'Erro ao recuperar credenciais: $e');
    }
  }
  @override
  Future<void> clearSavedCredentials() async {
    try {
      await sharedPreferences.remove(_savedEmailKey);
      await sharedPreferences.remove(_savedPasswordKey);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao limpar credenciais: $e');
    }
  }
  @override
  Future<bool> hasSavedCredentials() async {
    try {
      final email = sharedPreferences.getString(_savedEmailKey);
      final password = sharedPreferences.getString(_savedPasswordKey);
      return email != null && password != null;
    } catch (e) {
      return false;
    }
  }
  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    try {
      await sharedPreferences.setBool(_biometricEnabledKey, enabled);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao salvar configuração biométrica: $e');
    }
  }
  @override
  Future<bool> isBiometricEnabled() async {
    try {
      return sharedPreferences.getBool(_biometricEnabledKey) ?? false;
    } catch (e) {
      return false;
    }
  }
  @override
  Future<void> setRememberMe(bool enabled) async {
    try {
      await sharedPreferences.setBool(_rememberMeKey, enabled);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao salvar configuração de lembrar: $e');
    }
  }
  @override
  Future<bool> isRememberMeEnabled() async {
    try {
      return sharedPreferences.getBool(_rememberMeKey) ?? false;
    } catch (e) {
      return false;
    }
  }
  @override
  Future<void> setUserPreferences(Map<String, dynamic> preferences) async {
    try {
      final jsonString = json.encode(preferences);
      await sharedPreferences.setString(_userPreferencesKey, jsonString);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao salvar preferências: $e');
    }
  }
  @override
  Future<Map<String, dynamic>> getUserPreferences() async {
    try {
      final jsonString = sharedPreferences.getString(_userPreferencesKey);
      if (jsonString != null) {
        return json.decode(jsonString);
      }
      return {};
    } catch (e) {
      return {};
    }
  }
  @override
  Future<void> saveLoginHistory(List<Map<String, dynamic>> history) async {
    try {
      final jsonString = json.encode(history);
      await sharedPreferences.setString(_loginHistoryKey, jsonString);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao salvar histórico de logins: $e');
    }
  }
  @override
  Future<List<Map<String, dynamic>>> getLoginHistory() async {
    try {
      final jsonString = sharedPreferences.getString(_loginHistoryKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((item) => item as Map<String, dynamic>).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
  @override
  Future<void> clearLoginHistory() async {
    try {
      await sharedPreferences.remove(_loginHistoryKey);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao limpar histórico de logins: $e');
    }
  }
  @override
  Future<void> setLastLoginAt(DateTime dateTime) async {
    try {
      await sharedPreferences.setString(_lastLoginAtKey, dateTime.toIso8601String());
    } catch (e) {
      throw CacheFailure(message: 'Erro ao salvar último login: $e');
    }
  }
  @override
  Future<DateTime?> getLastLoginAt() async {
    try {
      final dateString = sharedPreferences.getString(_lastLoginAtKey);
      if (dateString != null) {
        return DateTime.parse(dateString);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  @override
  Future<void> setLoginAttempts(int attempts) async {
    try {
      await sharedPreferences.setInt(_loginAttemptsKey, attempts);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao salvar tentativas de login: $e');
    }
  }
  @override
  Future<int> getLoginAttempts() async {
    try {
      return sharedPreferences.getInt(_loginAttemptsKey) ?? 0;
    } catch (e) {
      return 0;
    }
  }
  @override
  Future<void> setAccountLocked(bool locked) async {
    try {
      await sharedPreferences.setBool(_accountLockedKey, locked);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao salvar status de bloqueio: $e');
    }
  }
  @override
  Future<bool> isAccountLocked() async {
    try {
      return sharedPreferences.getBool(_accountLockedKey) ?? false;
    } catch (e) {
      return false;
    }
  }
  @override
  Future<void> setPasswordResetRequested(bool requested) async {
    try {
      await sharedPreferences.setBool(_passwordResetRequestedKey, requested);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao salvar status de reset de senha: $e');
    }
  }
  @override
  Future<bool> isPasswordResetRequested() async {
    try {
      return sharedPreferences.getBool(_passwordResetRequestedKey) ?? false;
    } catch (e) {
      return false;
    }
  }
  @override
  Future<void> clearAllAuthData() async {
    try {
      await sharedPreferences.remove(_cachedUserKey);
      await sharedPreferences.remove(_savedEmailKey);
      await sharedPreferences.remove(_savedPasswordKey);
      await sharedPreferences.remove(_biometricEnabledKey);
      await sharedPreferences.remove(_rememberMeKey);
      await sharedPreferences.remove(_userPreferencesKey);
      await sharedPreferences.remove(_loginHistoryKey);
      await sharedPreferences.remove(_lastLoginAtKey);
      await sharedPreferences.remove(_loginAttemptsKey);
      await sharedPreferences.remove(_accountLockedKey);
      await sharedPreferences.remove(_passwordResetRequestedKey);
    } catch (e) {
      throw CacheFailure(message: 'Erro ao limpar todos os dados de autenticação: $e');
    }
  }
}
