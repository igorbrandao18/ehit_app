// shared/design/app_constants.dart

/// Constantes centralizadas do app ÊHIT
/// Consolida app_constants.dart e outras constantes espalhadas
class AppConstants {
  // ============================================================================
  // APP INFO
  // ============================================================================
  
  static const String appName = 'ÊHIT';
  static const String appVersion = '1.0.0';
  
  // ============================================================================
  // UI TEXT CONSTANTS
  // ============================================================================
  
  // Section titles
  static const String playHitsTitle = 'PlayHITS da semana';
  static const String artistsTitle = 'Artistas';
  static const String recentlyPlayedTitle = 'Tocados recentemente';
  static const String featuredAlbumsTitle = 'Álbuns em destaque';
  static const String popularPlaylistsTitle = 'Playlists populares';
  static const String genresTitle = 'Gêneros';
  
  // Navigation labels
  static const String homeLabel = 'Início';
  static const String searchLabel = 'Buscar';
  static const String libraryLabel = 'Biblioteca';
  static const String profileLabel = 'Perfil';
  
  // Player controls
  static const String playButton = 'Tocar';
  static const String pauseButton = 'Pausar';
  static const String nextButton = 'Próxima';
  static const String previousButton = 'Anterior';
  static const String shuffleButton = 'Embaralhar';
  static const String repeatButton = 'Repetir';
  
  // ============================================================================
  // MUSIC CATEGORIES
  // ============================================================================
  
  static const String sertanejoCategory = 'Sertanejo';
  static const String popCategory = 'Pop';
  static const String rockCategory = 'Rock';
  static const String funkCategory = 'Funk';
  static const String mpbCategory = 'MPB';
  static const String forroCategory = 'Forró';
  static const String pagodeCategory = 'Pagode';
  static const String sambaCategory = 'Samba';
  static const String rapCategory = 'Rap';
  static const String reggaeCategory = 'Reggae';
  static const String jazzCategory = 'Jazz';
  static const String classicalCategory = 'Clássica';
  static const String electronicCategory = 'Eletrônica';
  
  // ============================================================================
  // DEFAULT VALUES
  // ============================================================================
  
  static const String defaultArtist = 'Artista desconhecido';
  static const String defaultAlbum = 'Álbum desconhecido';
  static const String defaultPlaylist = 'Playlist sem nome';
  static const String defaultSong = 'Música sem título';
  static const String defaultGenre = 'Gênero desconhecido';
  
  // ============================================================================
  // ERROR MESSAGES
  // ============================================================================
  
  static const String networkError = 'Erro de conexão';
  static const String loadingError = 'Erro ao carregar';
  static const String playbackError = 'Erro na reprodução';
  static const String searchError = 'Erro na busca';
  static const String authError = 'Erro de autenticação';
  static const String permissionError = 'Permissão negada';
  static const String storageError = 'Erro de armazenamento';
  static const String unknownError = 'Erro desconhecido';
  
  // ============================================================================
  // SUCCESS MESSAGES
  // ============================================================================
  
  static const String addedToPlaylist = 'Adicionado à playlist';
  static const String removedFromPlaylist = 'Removido da playlist';
  static const String liked = 'Curtido';
  static const String unliked = 'Descurtido';
  static const String downloaded = 'Baixado';
  static const String uploaded = 'Enviado';
  static const String saved = 'Salvo';
  static const String deleted = 'Excluído';
  
  // ============================================================================
  // PLACEHOLDER TEXT
  // ============================================================================
  
  static const String searchPlaceholder = 'Buscar músicas, artistas, álbuns...';
  static const String playlistNamePlaceholder = 'Nome da playlist';
  static const String commentPlaceholder = 'Adicionar comentário...';
  static const String bioPlaceholder = 'Conte sobre você...';
  static const String emailPlaceholder = 'seu@email.com';
  static const String passwordPlaceholder = 'Sua senha';
  
  // ============================================================================
  // TIME FORMATS
  // ============================================================================
  
  static const String timeFormat = 'mm:ss';
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeAgoFormat = 'h:mm a';
  static const String fullDateFormat = 'dd/MM/yyyy HH:mm';
  
  // ============================================================================
  // FILE EXTENSIONS
  // ============================================================================
  
  static const List<String> supportedAudioFormats = [
    'mp3', 'wav', 'flac', 'aac', 'm4a', 'ogg', 'wma'
  ];
  
  static const List<String> supportedImageFormats = [
    'jpg', 'jpeg', 'png', 'gif', 'webp'
  ];
  
  // ============================================================================
  // CACHE SETTINGS
  // ============================================================================
  
  static const int maxCacheSize = 100; // MB
  static const int maxOfflineSongs = 50;
  static const int maxRecentSearches = 10;
  static const int maxPlaylistSongs = 1000;
  static const int maxHistoryItems = 100;
  
  // ============================================================================
  // ANIMATION DURATIONS
  // ============================================================================
  
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;
  static const int extraLongAnimationDuration = 800;
  
  // ============================================================================
  // DEBOUNCE TIMES
  // ============================================================================
  
  static const int searchDebounceTime = 500; // ms
  static const int scrollDebounceTime = 100; // ms
  static const int inputDebounceTime = 300; // ms
  
  // ============================================================================
  // PAGINATION
  // ============================================================================
  
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int minPageSize = 10;
  
  // ============================================================================
  // IMAGE SIZES
  // ============================================================================
  
  static const int thumbnailSize = 150;
  static const int mediumImageSize = 300;
  static const int largeImageSize = 500;
  static const int extraLargeImageSize = 1000;
  
  // ============================================================================
  // AUDIO SETTINGS
  // ============================================================================
  
  static const double defaultVolume = 0.8;
  static const double minVolume = 0.0;
  static const double maxVolume = 1.0;
  static const int seekStep = 10; // seconds
  static const int maxSongDuration = 3600; // 1 hour in seconds
  
  // ============================================================================
  // SOCIAL FEATURES
  // ============================================================================
  
  static const int maxCommentLength = 500;
  static const int maxPlaylistNameLength = 50;
  static const int maxBioLength = 160;
  static const int maxUsernameLength = 30;
  static const int minPasswordLength = 8;
  
  // ============================================================================
  // API ENDPOINTS (when using real API)
  // ============================================================================
  
  static const String baseUrl = 'https://api.ehit.com';
  static const String songsEndpoint = '/songs';
  static const String artistsEndpoint = '/artists';
  static const String albumsEndpoint = '/albums';
  static const String playlistsEndpoint = '/playlists';
  static const String searchEndpoint = '/search';
  static const String userEndpoint = '/user';
  static const String authEndpoint = '/auth';
  static const String uploadEndpoint = '/upload';
  
  // ============================================================================
  // STORAGE KEYS
  // ============================================================================
  
  static const String userTokenKey = 'user_token';
  static const String userPreferencesKey = 'user_preferences';
  static const String recentSearchesKey = 'recent_searches';
  static const String offlineSongsKey = 'offline_songs';
  static const String lastPlayedSongKey = 'last_played_song';
  static const String volumeKey = 'volume';
  static const String shuffleKey = 'shuffle';
  static const String repeatKey = 'repeat';
  static const String themeKey = 'theme';
  static const String languageKey = 'language';
  
  // ============================================================================
  // VALIDATION RULES
  // ============================================================================
  
  static const int minSearchLength = 2;
  static const int maxSearchLength = 100;
  static const int minPlaylistNameLength = 1;
  static const int maxPlaylistDescriptionLength = 500;
  
  // ============================================================================
  // FEATURE FLAGS
  // ============================================================================
  
  static const bool enableOfflineMode = true;
  static const bool enableSocialFeatures = true;
  static const bool enableLyrics = true;
  static const bool enableEqualizer = true;
  static const bool enableDarkMode = true;
  
  // ============================================================================
  // URLS
  // ============================================================================
  
  static const String privacyPolicyUrl = 'https://ehit.com/privacy';
  static const String termsOfServiceUrl = 'https://ehit.com/terms';
  static const String supportUrl = 'https://ehit.com/support';
  static const String websiteUrl = 'https://ehit.com';
}
