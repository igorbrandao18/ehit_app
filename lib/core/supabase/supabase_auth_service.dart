// core/supabase/supabase_auth_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/result.dart';
import '../errors/failures.dart';
import '../../features/authentication/domain/entities/user.dart' as app_user;
import '../../features/authentication/domain/entities/auth_state.dart' as app_auth;
import 'supabase_config.dart';

/// Supabase-based authentication service
class SupabaseAuthService {
  static final SupabaseAuthService _instance = SupabaseAuthService._internal();
  factory SupabaseAuthService() => _instance;
  SupabaseAuthService._internal();

  /// Sign up with email and password
  Future<Result<app_user.User>> signUpWithEmail({
    required String email,
    required String password,
    required String username,
    String? displayName,
  }) async {
    try {
      final response = await SupabaseConfig.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'display_name': displayName ?? username,
        },
      );

      if (response.user == null) {
        return Error<app_user.User>(
          message: 'Failed to create user account',
        );
      }

      // Create user profile
      final profileResult = await _createUserProfile(
        response.user!,
        username,
        displayName,
      );

      if (profileResult is Error) {
        return Error<app_user.User>(
          message: profileResult.errorMessage ?? 'Failed to create user profile',
        );
      }

      final user = _mapSupabaseUserToEntity(response.user!);
      return Success(user);
    } on AuthException catch (e) {
      return Error<app_user.User>(
        message: e.message,
            code: int.tryParse(e.statusCode ?? '500'),
      );
    } catch (e) {
      return Error<app_user.User>(
        message: 'Unexpected error during sign up: $e',
      );
    }
  }

  /// Sign in with email and password
  Future<Result<app_user.User>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return Error<app_user.User>(
          message: 'Invalid email or password',
        );
      }

      final user = _mapSupabaseUserToEntity(response.user!);
      return Success(user);
    } on AuthException catch (e) {
      return Error<app_user.User>(
        message: e.message,
            code: int.tryParse(e.statusCode ?? '500'),
      );
    } catch (e) {
      return Error<app_user.User>(
        message: 'Unexpected error during sign in: $e',
      );
    }
  }

  /// Sign out
  Future<Result<void>> signOut() async {
    try {
      await SupabaseConfig.client.auth.signOut();
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error signing out: $e',
      );
    }
  }

  /// Get current user
  Future<Result<app_user.User?>> getCurrentUser() async {
    try {
      final supabaseUser = SupabaseConfig.client.auth.currentUser;
      if (supabaseUser == null) {
        return const Success(null);
      }

      final user = _mapSupabaseUserToEntity(supabaseUser);
      return Success(user);
    } catch (e) {
      return Error<app_user.User?>(
        message: 'Error getting current user: $e',
      );
    }
  }

  /// Get current auth state
  Future<Result<app_auth.AuthState>> getCurrentAuthState() async {
    try {
      final supabaseUser = SupabaseConfig.client.auth.currentUser;
      final session = SupabaseConfig.client.auth.currentSession;

      if (supabaseUser == null || session == null) {
            return Success(app_auth.AuthState(
              status: app_auth.AuthStatus.unauthenticated,
              isLoading: false,
              emailVerificationStatus: app_auth.EmailVerificationStatus.notVerified,
              isBiometricEnabled: false,
              isRememberMeEnabled: false,
              loginAttempts: 0,
              isPasswordResetRequested: false,
              isAccountLocked: false,
            ));
      }

      final user = _mapSupabaseUserToEntity(supabaseUser);
      return Success(app_auth.AuthState(
        status: app_auth.AuthStatus.authenticated,
        user: user,
        isLoading: false,
        emailVerificationStatus: app_auth.EmailVerificationStatus.verified,
        isBiometricEnabled: false,
        isRememberMeEnabled: false,
        loginAttempts: 0,
        isPasswordResetRequested: false,
        isAccountLocked: false,
      ));
    } catch (e) {
      return Error<app_auth.AuthState>(
        message: 'Error getting auth state: $e',
      );
    }
  }

  /// Check if user is authenticated
  Future<Result<bool>> isAuthenticated() async {
    try {
      final isAuth = SupabaseConfig.client.auth.currentUser != null;
      return Success(isAuth);
    } catch (e) {
      return Error<bool>(
        message: 'Error checking authentication status: $e',
      );
    }
  }

  /// Send password reset email
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      await SupabaseConfig.client.auth.resetPasswordForEmail(email);
      return const Success(null);
    } on AuthException catch (e) {
      return Error<void>(
        message: e.message,
            code: int.tryParse(e.statusCode ?? '500'),
      );
    } catch (e) {
      return Error<void>(
        message: 'Error sending password reset email: $e',
      );
    }
  }

  /// Update user password
  Future<Result<void>> updatePassword(String newPassword) async {
    try {
      await SupabaseConfig.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return const Success(null);
    } on AuthException catch (e) {
      return Error<void>(
        message: e.message,
            code: int.tryParse(e.statusCode ?? '500'),
      );
    } catch (e) {
      return Error<void>(
        message: 'Error updating password: $e',
      );
    }
  }

  /// Update user profile
  Future<Result<app_user.User>> updateProfile({
    String? username,
    String? displayName,
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return Error<app_user.User>(
          message: 'No authenticated user',
        );
      }

      // Update auth user metadata
      final userAttributes = UserAttributes(
        data: {
          if (username != null) 'username': username,
          if (displayName != null) 'display_name': displayName,
          if (bio != null) 'bio': bio,
          if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
        },
      );

      await SupabaseConfig.client.auth.updateUser(userAttributes);

      // Update profile in database
      final updateData = <String, dynamic>{};
      if (username != null) updateData['username'] = username;
      if (displayName != null) updateData['display_name'] = displayName;
      if (bio != null) updateData['bio'] = bio;
      if (profileImageUrl != null) updateData['profile_image_url'] = profileImageUrl;

      if (updateData.isNotEmpty) {
        await SupabaseConfig.client
            .from('profiles')
            .update(updateData)
            .eq('id', currentUser.id);
      }

      final updatedUser = _mapSupabaseUserToEntity(currentUser);
      return Success(updatedUser);
    } on AuthException catch (e) {
      return Error<app_user.User>(
        message: e.message,
            code: int.tryParse(e.statusCode ?? '500'),
      );
    } catch (e) {
      return Error<app_user.User>(
        message: 'Error updating profile: $e',
      );
    }
  }

  /// Get auth state changes stream
  Stream<app_auth.AuthState> get authStateChanges {
    return SupabaseConfig.client.auth.onAuthStateChange.map((data) {
      if (data.session?.user == null) {
        return app_auth.AuthState(
          status: app_auth.AuthStatus.unauthenticated,
          isLoading: false,
          emailVerificationStatus: app_auth.EmailVerificationStatus.notVerified,
          isBiometricEnabled: false,
          isRememberMeEnabled: false,
          loginAttempts: 0,
          isPasswordResetRequested: false,
          isAccountLocked: false,
        );
      } else {
        final user = _mapSupabaseUserToEntity(data.session!.user!);
        return app_auth.AuthState(
          status: app_auth.AuthStatus.authenticated,
          user: user,
          isLoading: false,
          emailVerificationStatus: app_auth.EmailVerificationStatus.verified,
          isBiometricEnabled: false,
          isRememberMeEnabled: false,
          loginAttempts: 0,
          isPasswordResetRequested: false,
          isAccountLocked: false,
        );
      }
    });
  }

  /// Create user profile in database
  Future<Result<void>> _createUserProfile(
    User supabaseUser,
    String username,
    String? displayName,
  ) async {
    try {
      await SupabaseConfig.client.from('profiles').insert({
        'id': supabaseUser.id,
        'username': username,
        'display_name': displayName ?? username,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error creating user profile: $e',
      );
    }
  }

  /// Map Supabase User to our User entity
  app_user.User _mapSupabaseUserToEntity(User supabaseUser) {
    final metadata = supabaseUser.userMetadata ?? {};
    
    return app_user.User(
      id: supabaseUser.id,
      username: metadata['username'] ?? supabaseUser.email?.split('@').first ?? '',
      email: supabaseUser.email ?? '',
      displayName: metadata['display_name'] ?? metadata['username'] ?? '',
      profileImageUrl: metadata['profile_image_url'],
      createdAt: DateTime.parse(supabaseUser.createdAt),
      updatedAt: DateTime.parse(supabaseUser.updatedAt ?? supabaseUser.createdAt),
      isEmailVerified: supabaseUser.emailConfirmedAt != null,
      isActive: true,
      preferences: [],
      metadata: metadata,
    );
  }

  /// Get user profile from database
  Future<Result<app_user.User>> getUserProfile(String userId) async {
    try {
      final response = await SupabaseConfig.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      final user = app_user.User(
        id: response['id'],
        username: response['username'],
        email: '', // Not stored in profiles table
        displayName: response['display_name'],
        profileImageUrl: response['profile_image_url'],
        createdAt: DateTime.parse(response['created_at']),
        updatedAt: DateTime.parse(response['updated_at']),
        isEmailVerified: response['is_verified'] ?? false,
        isActive: true,
        preferences: [],
        metadata: response,
      );

      return Success(user);
    } catch (e) {
      return Error<app_user.User>(
        message: 'Error fetching user profile: $e',
      );
    }
  }

  /// Delete user account
  Future<Result<void>> deleteAccount() async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return Error<void>(
          message: 'No authenticated user',
        );
      }

      // Delete user profile from database
      await SupabaseConfig.client
          .from('profiles')
          .delete()
          .eq('id', currentUser.id);

      // Delete auth user
      await SupabaseConfig.client.auth.admin.deleteUser(currentUser.id);

      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error deleting account: $e',
      );
    }
  }
}
