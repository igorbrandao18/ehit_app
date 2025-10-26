import '../../../../core/utils/result.dart';
import '../entities/user.dart';
import '../entities/auth_state.dart';
abstract class AuthRepository {
  Future<Result<AuthState>> getCurrentAuthState();
  Future<Result<User>> loginWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  });
  Future<Result<User>> loginWithBiometric();
  Future<Result<User>> register({
    required String email,
    required String password,
    required String username,
    String? displayName,
  });
  Future<Result<void>> logout();
  Future<Result<void>> sendEmailVerification();
  Future<Result<void>> verifyEmail(String verificationCode);
  Future<Result<void>> requestPasswordReset(String email);
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  });
  Future<Result<User>> updateProfile({
    String? displayName,
    String? bio,
    String? profileImageUrl,
  });
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<Result<void>> deleteAccount(String password);
  Future<Result<void>> toggleBiometricAuth(bool enabled);
  Future<Result<bool>> isBiometricAvailable();
  Future<Result<bool>> isBiometricEnabled();
  Future<Result<User>> getCurrentUser();
  Future<Result<User>> updateUser(User user);
  Future<Result<bool>> isTokenValid();
  Future<Result<String>> refreshToken();
  Future<Result<void>> saveCredentials({
    required String email,
    required String password,
  });
  Future<Result<void>> clearSavedCredentials();
  Future<Result<Map<String, String>>> getSavedCredentials();
  Future<Result<bool>> hasSavedCredentials();
  Future<Result<void>> setUserPreferences(Map<String, dynamic> preferences);
  Future<Result<Map<String, dynamic>>> getUserPreferences();
  Future<Result<bool>> isUserOnline();
  Future<Result<void>> updateOnlineStatus(bool isOnline);
  Future<Result<List<Map<String, dynamic>>>> getLoginHistory();
  Future<Result<void>> clearLoginHistory();
  Future<Result<bool>> isAccountLocked();
  Future<Result<void>> unlockAccount();
  Future<Result<Map<String, dynamic>>> getSecurityStats();
}
