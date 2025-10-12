// core/injection/injection_container.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Data Sources - Music Library
import '../../features/music_library/data/datasources/music_remote_datasource.dart';
import '../../features/music_library/data/datasources/music_local_datasource.dart';

// Data Sources - Music Player
import '../../features/music_player/data/datasources/playlist_remote_datasource.dart';
import '../../features/music_player/data/datasources/playlist_local_datasource.dart';

// Data Sources - Authentication
import '../../features/authentication/data/datasources/auth_remote_datasource.dart';
import '../../features/authentication/data/datasources/auth_local_datasource.dart';

// Repositories - Music Library
import '../../features/music_library/data/repositories/music_repository_impl.dart';
import '../../features/music_library/domain/repositories/music_repository.dart';

// Repositories - Music Player
import '../../features/music_player/data/repositories/playlist_repository_impl.dart';
import '../../features/music_player/domain/repositories/playlist_repository.dart' as playlist_repo;
import '../../features/music_player/data/repositories/audio_player_repository_impl.dart';
import '../../features/music_player/domain/repositories/audio_player_repository.dart';

// Repositories - Authentication
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';

// Use Cases - Music Library
import '../../features/music_library/domain/usecases/get_songs_usecase.dart';
import '../../features/music_library/domain/usecases/get_artists_usecase.dart';

// Use Cases - Music Player
import '../../features/music_player/domain/usecases/playlist_usecases.dart';

// Use Cases - Authentication
import '../../features/authentication/domain/usecases/auth_usecases.dart';

// Controllers
import '../../features/music_library/presentation/controllers/music_library_controller.dart';
import '../../features/music_library/presentation/controllers/artist_detail_controller.dart';
import '../../features/music_player/presentation/controllers/music_player_controller.dart';
import '../../features/music_player/presentation/controllers/playlist_controller.dart';
import '../../features/authentication/presentation/controllers/auth_controller.dart';

// Constants
import '../constants/app_constants.dart';

// Services
import '../audio/offline_audio_service.dart';
import '../social/social_service.dart';

/// Container de injeção de dependências
final GetIt sl = GetIt.instance;

/// Configura todas as dependências
Future<void> init() async {
  // ============================================================================
  // EXTERNAL DEPENDENCIES
  // ============================================================================
  
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Dio HTTP Client
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.baseUrl = AppConstants.apiBaseUrl;
    dio.options.connectTimeout = const Duration(milliseconds: AppConstants.connectionTimeout);
    dio.options.receiveTimeout = const Duration(milliseconds: AppConstants.receiveTimeout);
    return dio;
  });

  // ============================================================================
  // SERVICES
  // ============================================================================
  
  // Offline Audio Service
  sl.registerLazySingleton<OfflineAudioService>(() => OfflineAudioService());

  // Social Service
  sl.registerLazySingleton<SocialService>(() => SocialService());

  // ============================================================================
  // DATA SOURCES
  // ============================================================================
  
  // Music Library Data Sources
  sl.registerLazySingleton<MusicRemoteDataSource>(
    () => MusicRemoteDataSourceImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<MusicLocalDataSource>(
    () => MusicLocalDataSourceImpl(sl<SharedPreferences>()),
  );

  // Music Player Data Sources
  sl.registerLazySingleton<PlaylistRemoteDataSource>(
    () => PlaylistRemoteDataSourceImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<PlaylistLocalDataSource>(
    () => PlaylistLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Authentication Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // ============================================================================
  // REPOSITORIES
  // ============================================================================
  
  // Music Library Repositories
  sl.registerLazySingleton<MusicRepository>(
    () => MusicRepositoryImpl(
      sl<MusicRemoteDataSource>(),
      sl<MusicLocalDataSource>(),
    ),
  );

  // Music Player Repositories
  sl.registerLazySingleton<playlist_repo.PlaylistRepository>(
    () => PlaylistRepositoryImpl(
      remoteDataSource: sl<PlaylistRemoteDataSource>(),
      localDataSource: sl<PlaylistLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<AudioPlayerRepository>(
    () => AudioPlayerRepositoryImpl(),
  );

  // Authentication Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );

  // ============================================================================
  // USE CASES
  // ============================================================================
  
  // Music Library Use Cases
  sl.registerLazySingleton(() => GetSongsUseCase(sl<MusicRepository>()));
  sl.registerLazySingleton(() => GetSongByIdUseCase(sl<MusicRepository>()));
  sl.registerLazySingleton(() => GetSongsByArtistUseCase(sl<MusicRepository>()));
  sl.registerLazySingleton(() => GetPopularSongsUseCase(sl<MusicRepository>()));
  sl.registerLazySingleton(() => GetRecentSongsUseCase(sl<MusicRepository>()));
  sl.registerLazySingleton(() => SearchSongsUseCase(sl<MusicRepository>()));
  sl.registerLazySingleton(() => GetArtistsUseCase(sl<MusicRepository>()));
  sl.registerLazySingleton(() => GetArtistByIdUseCase(sl<MusicRepository>()));
  sl.registerLazySingleton(() => GetPopularArtistsUseCase(sl<MusicRepository>()));
  sl.registerLazySingleton(() => GetArtistsByGenreUseCase(sl<MusicRepository>()));
  sl.registerLazySingleton(() => SearchArtistsUseCase(sl<MusicRepository>()));

  // Music Player Use Cases - Playlists
  sl.registerLazySingleton(() => GetUserPlaylistsUseCase(sl<playlist_repo.PlaylistRepository>()));
  sl.registerLazySingleton(() => GetPlaylistByIdUseCase(sl<playlist_repo.PlaylistRepository>()));
  sl.registerLazySingleton(() => GetPublicPlaylistsUseCase(sl<playlist_repo.PlaylistRepository>()));
  sl.registerLazySingleton(() => GetPopularPlaylistsUseCase(sl<playlist_repo.PlaylistRepository>()));
  sl.registerLazySingleton(() => SearchPlaylistsUseCase(sl<playlist_repo.PlaylistRepository>()));
  sl.registerLazySingleton(() => CreatePlaylistUseCase(sl<playlist_repo.PlaylistRepository>()));
  sl.registerLazySingleton(() => UpdatePlaylistUseCase(sl<playlist_repo.PlaylistRepository>()));
  sl.registerLazySingleton(() => DeletePlaylistUseCase(sl<playlist_repo.PlaylistRepository>()));
  sl.registerLazySingleton(() => AddSongToPlaylistUseCase(sl<playlist_repo.PlaylistRepository>()));
  sl.registerLazySingleton(() => RemoveSongFromPlaylistUseCase(sl<playlist_repo.PlaylistRepository>()));
  sl.registerLazySingleton(() => FollowPlaylistUseCase(sl<playlist_repo.PlaylistRepository>()));
  sl.registerLazySingleton(() => UnfollowPlaylistUseCase(sl<playlist_repo.PlaylistRepository>()));

  // Authentication Use Cases
  sl.registerLazySingleton(() => LoginWithEmailUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LoginWithBiometricUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SendEmailVerificationUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RequestPasswordResetUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetAuthStateUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => IsAuthenticatedUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => IsBiometricAvailableUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ToggleBiometricAuthUseCase(sl<AuthRepository>()));

  // ============================================================================
  // CONTROLLERS
  // ============================================================================
  
  // Music Library Controllers
  sl.registerLazySingleton(() => MusicLibraryController(
    getSongsUseCase: sl<GetSongsUseCase>(),
    getPopularSongsUseCase: sl<GetPopularSongsUseCase>(),
    getArtistsUseCase: sl<GetArtistsUseCase>(),
    getPopularArtistsUseCase: sl<GetPopularArtistsUseCase>(),
  ));

  sl.registerLazySingleton(() => ArtistDetailController());

  // Music Player Controllers
  sl.registerLazySingleton(() => MusicPlayerController());
  
  sl.registerLazySingleton(() => PlaylistController(
    getUserPlaylistsUseCase: sl<GetUserPlaylistsUseCase>(),
    getPlaylistByIdUseCase: sl<GetPlaylistByIdUseCase>(),
    getPublicPlaylistsUseCase: sl<GetPublicPlaylistsUseCase>(),
    getPopularPlaylistsUseCase: sl<GetPopularPlaylistsUseCase>(),
    searchPlaylistsUseCase: sl<SearchPlaylistsUseCase>(),
    createPlaylistUseCase: sl<CreatePlaylistUseCase>(),
    updatePlaylistUseCase: sl<UpdatePlaylistUseCase>(),
    deletePlaylistUseCase: sl<DeletePlaylistUseCase>(),
    addSongToPlaylistUseCase: sl<AddSongToPlaylistUseCase>(),
    removeSongFromPlaylistUseCase: sl<RemoveSongFromPlaylistUseCase>(),
    followPlaylistUseCase: sl<FollowPlaylistUseCase>(),
    unfollowPlaylistUseCase: sl<UnfollowPlaylistUseCase>(),
  ));

  // Authentication Controllers
  sl.registerLazySingleton(() => AuthController(
    loginWithEmailUseCase: sl<LoginWithEmailUseCase>(),
    loginWithBiometricUseCase: sl<LoginWithBiometricUseCase>(),
    registerUseCase: sl<RegisterUseCase>(),
    logoutUseCase: sl<LogoutUseCase>(),
    sendEmailVerificationUseCase: sl<SendEmailVerificationUseCase>(),
    verifyEmailUseCase: sl<VerifyEmailUseCase>(),
    requestPasswordResetUseCase: sl<RequestPasswordResetUseCase>(),
    resetPasswordUseCase: sl<ResetPasswordUseCase>(),
    updateProfileUseCase: sl<UpdateProfileUseCase>(),
    changePasswordUseCase: sl<ChangePasswordUseCase>(),
    getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
    getAuthStateUseCase: sl<GetAuthStateUseCase>(),
    isAuthenticatedUseCase: sl<IsAuthenticatedUseCase>(),
    isBiometricAvailableUseCase: sl<IsBiometricAvailableUseCase>(),
    toggleBiometricAuthUseCase: sl<ToggleBiometricAuthUseCase>(),
  ));
}

/// Helper para resetar todas as dependências (útil para testes)
Future<void> reset() async {
  await sl.reset();
}
