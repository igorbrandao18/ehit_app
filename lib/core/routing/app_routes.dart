class AppRoutes {
  AppRoutes._();
  static const String home = '/';
  static const String search = '/search';
  static const String library = '/library';
  static const String radios = '/radios';
  static const String more = '/more';
  static const String categoryDetail = '/category';
  static const String artistDetail = '/artist';
  static const String albumDetail = '/album';
  static const String playlistDetail = '/playlist';
  static const String songDetail = '/song';
  static const String player = '/player';
  static const String queue = '/queue';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String settings = '/settings';
  static const String account = '/account';
  static const String privacy = '/privacy';
  static const String about = '/about';
  static String categoryDetailPath(String categoryTitle) => '$categoryDetail/$categoryTitle';
  static String artistDetailPath(String artistId) => '$artistDetail/$artistId';
  static String albumDetailPath(String albumId) => '$albumDetail/$albumId';
  static String playlistDetailPath(String playlistId) => '$playlistDetail/$playlistId';
  static String songDetailPath(String songId) => '$songDetail/$songId';
}
