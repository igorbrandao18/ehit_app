class AppConfig {
  AppConfig._();
  static const bool isDebugMode = true; 
  static const bool enableLogging = true;
  static const bool enableAnalytics = false; 
  static const String defaultAlbumArt = 'https://via.placeholder.com/300x300/333333/FFFFFF?text=Album';
  static const String defaultArtistImage = 'https://via.placeholder.com/300x300/333333/FFFFFF?text=Artist';
  static const String defaultPlaylistImage = 'https://via.placeholder.com/300x300/333333/FFFFFF?text=Playlist';
  static const String defaultPlaylistImageUrl = 'https://via.placeholder.com/300x300/333333/FFFFFF?text=Playlist';
  static const String apiBaseUrl = 'https://api.ehit.app';
  static const String apiVersion = 'v1';
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);
  static const String audioBaseUrl = 'https://audio.ehit.app';
  static const List<String> supportedAudioFormats = [
    'mp3', 'wav', 'flac', 'aac', 'm4a', 'ogg', 'wma'
  ];
  static const int audioQuality = 320; 
  static const Duration audioBufferDuration = Duration(seconds: 10);
  static const int maxCacheSizeMB = 100;
  static const Duration cacheExpiration = Duration(hours: 24);
  static const Duration imageCacheExpiration = Duration(days: 7);
  static const Duration audioCacheExpiration = Duration(days: 30);
  static const double minTouchTarget = 48.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const bool enableOfflineMode = true;
  static const bool enableSocialFeatures = true; 
  static const bool enablePushNotifications = false; 
  static const bool enableBiometricAuth = false; 
  static const int maxPlaylistSongs = 1000;
  static const int maxRecentSongs = 50;
  static const int maxOfflineSongs = 100;
  static const int maxSearchResults = 50;
  static const int maxHistoryItems = 100;
  static const int maxRecentSearches = 10;
  static const int minSearchLength = 2;
  static const int maxSearchLength = 100;
  static const int minPlaylistNameLength = 1;
  static const int maxPlaylistNameLength = 50;
  static const int maxPlaylistDescriptionLength = 500;
  static const int maxCommentLength = 500;
  static const int maxBioLength = 160;
  static const int maxUsernameLength = 30;
  static const int minPasswordLength = 8;
  static String getApiUrl(String endpoint) {
    return '$apiBaseUrl/api/$apiVersion$endpoint';
  }
  static String getAudioUrl(String songId, {int quality = 320}) {
    return '$audioBaseUrl/songs/$songId?quality=${quality}kbps';
  }
  static String getImageUrl(String baseUrl, {int? width, int? height}) {
    if (width != null && height != null) {
      return '$baseUrl?w=$width&h=$height&fit=crop';
    } else if (width != null) {
      return '$baseUrl?w=$width';
    }
    return baseUrl;
  }
  static bool isAudioFormatSupported(String format) {
    return supportedAudioFormats.contains(format.toLowerCase());
  }
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
