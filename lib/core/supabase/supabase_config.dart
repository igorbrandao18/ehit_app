// core/supabase/supabase_config.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_config.dart';

/// Supabase configuration and initialization
class SupabaseConfig {
  static SupabaseClient? _client;
  
  /// Get the Supabase client instance
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call SupabaseConfig.initialize() first.');
    }
    return _client!;
  }
  
  /// Initialize Supabase
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
        debug: AppConfig.isDebugMode,
      );
      
      _client = Supabase.instance.client;
      
      print('✅ Supabase initialized successfully');
    } catch (e) {
      print('❌ Error initializing Supabase: $e');
      rethrow;
    }
  }
  
  /// Get the current user
  static User? get currentUser => _client?.auth.currentUser;
  
  /// Get the current session
  static Session? get currentSession => _client?.auth.currentSession;
  
  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;
  
  /// Get auth stream
  static Stream<AuthState> get authStateChanges => _client!.auth.onAuthStateChange;
  
  /// Sign out
  static Future<void> signOut() async {
    await _client?.auth.signOut();
  }
  
  /// Dispose resources
  static void dispose() {
    _client = null;
  }
}
