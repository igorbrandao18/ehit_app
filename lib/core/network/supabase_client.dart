// core/network/supabase_client.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

class SupabaseClient {
  static SupabaseClient? _instance;
  
  static SupabaseClient get instance {
    _instance ??= SupabaseClient._();
    return _instance!;
  }
  
  SupabaseClient._();
  
  SupabaseClient get client => Supabase.instance.client;
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }
}
