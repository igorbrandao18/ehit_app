// core/constants/app_config.dart

/// Configurações da aplicação
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  // ============================================================================
  // ENVIRONMENT CONFIGURATION
  // ============================================================================
  
  static const bool isDebugMode = true; // TODO: Make this environment-based
  static const bool enableLogging = true;
  static const bool enableAnalytics = false; // TODO: Enable in production

  // ============================================================================
  // ASSET URLS
  // ============================================================================
  
  // Default/Placeholder Images
  static const String defaultAlbumArt = 'https://via.placeholder.com/300x300/333333/FFFFFF?text=Album';
  static const String defaultArtistImage = 'https://via.placeholder.com/300x300/333333/FFFFFF?text=Artist';
  static const String defaultPlaylistImage = 'https://via.placeholder.com/300x300/333333/FFFFFF?text=Playlist';
  
  // Sample Images for Development
  static const String sampleArtistImage1 = 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400';
  static const String sampleArtistImage2 = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400';
  static const String sampleArtistImage3 = 'https://images.unsplash.com/photo-1471478331149-c72f17e33c73?w=400';
  static const String sampleArtistImage4 = 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400';
  
  // Sample Album Covers
  static const String sampleAlbumCover1 = 'https://www.cartacapital.com.br/wp-content/uploads/2021/11/pluralmusica.jpg';
  static const String sampleAlbumCover2 = 'https://cdn-images.dzcdn.net/images/artist/ea589fefdebdefd0624edda903d07672/1900x1900-000000-81-0-0.jpg';
  
  // Sample Music Cards
  static const String sampleMusicCard1 = 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop';
  static const String sampleMusicCard2 = 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400&h=300&fit=crop';

  // ============================================================================
  // API CONFIGURATION
  // ============================================================================
  
  static const String apiBaseUrl = 'https://api.ehit.app';
  static const String apiVersion = 'v1';
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  // ============================================================================
  // AUDIO CONFIGURATION
  // ============================================================================
  
  static const String audioBaseUrl = 'https://audio.ehit.app';
  static const List<String> supportedAudioFormats = [
    'mp3', 'wav', 'flac', 'aac', 'm4a', 'ogg', 'wma'
  ];
  static const int audioQuality = 320; // kbps
  static const Duration audioBufferDuration = Duration(seconds: 10);

  // ============================================================================
  // CACHE CONFIGURATION
  // ============================================================================
  
  static const int maxCacheSizeMB = 100;
  static const Duration cacheExpiration = Duration(hours: 24);
  static const Duration imageCacheExpiration = Duration(days: 7);
  static const Duration audioCacheExpiration = Duration(days: 30);

  // ============================================================================
  // UI CONFIGURATION
  // ============================================================================
  
  static const double minTouchTarget = 48.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // ============================================================================
  // FEATURE FLAGS
  // ============================================================================
  
  static const bool enableOfflineMode = true;
  static const bool enableSocialFeatures = false; // TODO: Enable when implemented
  static const bool enablePushNotifications = false; // TODO: Enable when implemented
  static const bool enableBiometricAuth = false; // TODO: Enable when implemented

  // ============================================================================
  // LIMITS
  // ============================================================================
  
  static const int maxPlaylistSongs = 1000;
  static const int maxRecentSongs = 50;
  static const int maxOfflineSongs = 100;
  static const int maxSearchResults = 50;
  static const int maxHistoryItems = 100;
  static const int maxRecentSearches = 10;

  // ============================================================================
  // VALIDATION LIMITS
  // ============================================================================
  
  static const int minSearchLength = 2;
  static const int maxSearchLength = 100;
  static const int minPlaylistNameLength = 1;
  static const int maxPlaylistNameLength = 50;
  static const int maxPlaylistDescriptionLength = 500;
  static const int maxCommentLength = 500;
  static const int maxBioLength = 160;
  static const int maxUsernameLength = 30;
  static const int minPasswordLength = 8;

  // ============================================================================
  // HELPER METHODS
  // ============================================================================
  
  /// Get full API URL for an endpoint
  static String getApiUrl(String endpoint) {
    return '$apiBaseUrl/api/$apiVersion$endpoint';
  }
  
  /// Get audio URL for a song
  static String getAudioUrl(String songId, {int quality = 320}) {
    return '$audioBaseUrl/songs/$songId?quality=${quality}kbps';
  }
  
  /// Get image URL with size parameters
  static String getImageUrl(String baseUrl, {int? width, int? height}) {
    if (width != null && height != null) {
      return '$baseUrl?w=$width&h=$height&fit=crop';
    } else if (width != null) {
      return '$baseUrl?w=$width';
    }
    return baseUrl;
  }
  
  /// Check if audio format is supported
  static bool isAudioFormatSupported(String format) {
    return supportedAudioFormats.contains(format.toLowerCase());
  }
  
  /// Get default image based on type
  static String getDefaultImage(String type) {
    switch (type.toLowerCase()) {
      case 'artist':
        return defaultArtistImage;
      case 'album':
        return defaultAlbumArt;
      case 'playlist':
        return defaultPlaylistImage;
      default:
        return defaultAlbumArt;
    }
  }
}
