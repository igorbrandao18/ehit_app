// core/constants/app_constants.dart
class AppConstants {
  // App Info
  static const String appName = 'ÊHIT';
  static const String appVersion = '1.0.0';
  
  // Supabase Configuration
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String offlineMusicKey = 'offline_music';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Audio Configuration
  static const Duration audioBufferDuration = Duration(seconds: 3);
  static const int maxConcurrentDownloads = 3;
}
