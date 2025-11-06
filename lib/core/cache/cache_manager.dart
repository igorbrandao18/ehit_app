import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_config.dart';

class ApiCacheManager {
  static final ApiCacheManager _instance = ApiCacheManager._internal();
  factory ApiCacheManager() => _instance;
  ApiCacheManager._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> cacheData<T>({
    required String key,
    required T data,
    required String Function(T) toJson,
    Duration? expiration,
  }) async {
    await init();
    
    final expirationTime = DateTime.now().add(
      expiration ?? AppConfig.cacheExpiration,
    ).millisecondsSinceEpoch;
    
    final cacheData = {
      'data': toJson(data),
      'expiration': expirationTime,
    };
    
    await _prefs?.setString(key, jsonEncode(cacheData));
    debugPrint('💾 Cache salvo: $key (expira em ${expiration ?? AppConfig.cacheExpiration})');
  }

  Future<T?> getCachedData<T>({
    required String key,
    required T Function(String) fromJson,
  }) async {
    await init();
    final cached = _prefs?.getString(key);
    if (cached == null) {
      debugPrint('💾 Cache não encontrado: $key');
      return null;
    }
    
    try {
      final cacheData = jsonDecode(cached) as Map<String, dynamic>;
      final expiration = cacheData['expiration'] as int;
      
      if (DateTime.now().millisecondsSinceEpoch > expiration) {
        await _prefs?.remove(key);
        debugPrint('💾 Cache expirado: $key');
        return null;
      }
      
      final data = cacheData['data'] as String;
      debugPrint('💾 Cache recuperado: $key');
      return fromJson(data);
    } catch (e) {
      debugPrint('❌ Erro ao recuperar cache: $key - $e');
      await _prefs?.remove(key);
      return null;
    }
  }

  Future<bool> hasValidCache(String key) async {
    await init();
    final cached = _prefs?.getString(key);
    if (cached == null) return false;
    
    try {
      final cacheData = jsonDecode(cached) as Map<String, dynamic>;
      final expiration = cacheData['expiration'] as int;
      return DateTime.now().millisecondsSinceEpoch <= expiration;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearCache(String key) async {
    await init();
    await _prefs?.remove(key);
    debugPrint('🗑️ Cache removido: $key');
  }

  Future<void> clearAllCache() async {
    await init();
    final keys = _prefs?.getKeys() ?? {};
    int removed = 0;
    
    for (final key in keys) {
      if (key.startsWith('cache_')) {
        await _prefs?.remove(key);
        removed++;
      }
    }
    
    debugPrint('🗑️ $removed caches removidos');
  }

  Future<void> clearExpiredCache() async {
    await init();
    final keys = _prefs?.getKeys() ?? {};
    int removed = 0;
    
    for (final key in keys) {
      if (key.startsWith('cache_')) {
        final cached = _prefs?.getString(key);
        if (cached != null) {
          try {
            final cacheData = jsonDecode(cached) as Map<String, dynamic>;
            final expiration = cacheData['expiration'] as int;
            
            if (DateTime.now().millisecondsSinceEpoch > expiration) {
              await _prefs?.remove(key);
              removed++;
            }
          } catch (e) {
            await _prefs?.remove(key);
            removed++;
          }
        }
      }
    }
    
    if (removed > 0) {
      debugPrint('🗑️ $removed caches expirados removidos');
    }
  }

  Future<Map<String, dynamic>> getCacheInfo() async {
    await init();
    final keys = _prefs?.getKeys() ?? {};
    int total = 0;
    int valid = 0;
    int expired = 0;
    
    for (final key in keys) {
      if (key.startsWith('cache_')) {
        total++;
        if (await hasValidCache(key)) {
          valid++;
        } else {
          expired++;
        }
      }
    }
    
    return {
      'total': total,
      'valid': valid,
      'expired': expired,
    };
  }
}
