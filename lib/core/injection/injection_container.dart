// core/injection/injection_container.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core Services
import '../audio/audio_player_service.dart';

// Data Sources - Music Library
import '../../features/music_library/data/datasources/music_remote_datasource.dart';
import '../../features/music_library/data/datasources/music_local_datasource.dart';

// Data Sources - Music Player
import '../../features/music_player/data/datasources/playlist_remote_datasource.dart';
import '../../features/music_player/data/datasources/playlist_local_datasource.dart';
import '../../features/music_player/data/datasources/just_audio_datasource.dart';
import '../../features/music_player/data/datasources/audio_player_datasource.dart';

// Data Sources - Authentication
import '../../features/authentication/data/datasources/auth_remote_datasource.dart';
import '../../features/authentication/data/datasources/auth_local_datasource.dart';

// Repositories - Music Library
import '../../features/music_library/data/repositories/music_repository_impl.dart' as music_lib_impl;
import '../../features/music_library/domain/repositories/playlist_repository.dart' as music_lib;

// Repositories - Music Player
import '../../features/music_player/data/repositories/playlist_repository_impl.dart';
import '../../features/music_player/domain/repositories/playlist_repository.dart' as playlist_repo;
import '../../features/music_player/data/repositories/audio_player_repository_impl.dart';
import '../../features/music_player/domain/repositories/audio_player_repository.dart';

// Repositories - Authentication
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';

// Use Cases - Music Library
import '../../features/music_library/domain/usecases/get_playlists_usecase.dart';

// Use Cases - Music Player
import '../../features/music_player/domain/usecases/playlist_usecases.dart';
import '../../features/music_player/domain/usecases/play_song_usecase.dart';
import '../../features/music_player/domain/usecases/play_queue_usecase.dart';
import '../../features/music_player/domain/usecases/audio_player_usecases.dart';

// Use Cases - Authentication
import '../../features/authentication/domain/usecases/auth_usecases.dart';

// Controllers
import '../../features/music_library/presentation/controllers/music_library_controller.dart';
import '../../features/music_library/presentation/controllers/artist_detail_controller.dart';
import '../../features/music_player/presentation/controllers/music_player_controller.dart';
import '../../features/music_player/presentation/controllers/playlist_controller.dart';
import '../../features/music_player/presentation/controllers/audio_player_controller.dart';
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
  
  // Audio Player Service
  sl.registerLazySingleton<AudioPlayerService>(() => AudioPlayerService());
  
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

  // Audio Player Data Sources
  sl.registerLazySingleton<AudioPlayerDataSource>(
    () => JustAudioDataSource(),
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
  sl.registerLazySingleton<music_lib.PlaylistRepository>(
    () => music_lib_impl.PlaylistRepositoryImpl(sl<MusicRemoteDataSource>()),
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
  sl.registerLazySingleton(() => GetPlaylistsUseCase(sl<music_lib.PlaylistRepository>()));

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

  // Music Player Use Cases - Audio Player
  sl.registerLazySingleton(() => PlaySongUseCase(sl<AudioPlayerRepository>()));
  sl.registerLazySingleton(() => PlayQueueUseCase(sl<AudioPlayerRepository>()));
  sl.registerLazySingleton(() => TogglePlayPauseUseCase(sl<AudioPlayerRepository>()));
  sl.registerLazySingleton(() => NextSongUseCase(sl<AudioPlayerRepository>()));
  sl.registerLazySingleton(() => GetCurrentSongUseCase(sl<AudioPlayerRepository>()));
  sl.registerLazySingleton(() => IsPlayingUseCase(sl<AudioPlayerRepository>()));
  sl.registerLazySingleton(() => GetProgressUseCase(sl<AudioPlayerRepository>()));
  sl.registerLazySingleton(() => GetCurrentPositionUseCase(sl<AudioPlayerRepository>()));
  sl.registerLazySingleton(() => GetDurationUseCase(sl<AudioPlayerRepository>()));

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
    getPlaylistsUseCase: sl<GetPlaylistsUseCase>(),
  ));

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

  sl.registerLazySingleton(() => AudioPlayerController(
    playSongUseCase: sl<PlaySongUseCase>(),
    togglePlayPauseUseCase: sl<TogglePlayPauseUseCase>(),
    nextSongUseCase: sl<NextSongUseCase>(),
    getCurrentSongUseCase: sl<GetCurrentSongUseCase>(),
    isPlayingUseCase: sl<IsPlayingUseCase>(),
    getProgressUseCase: sl<GetProgressUseCase>(),
    getCurrentPositionUseCase: sl<GetCurrentPositionUseCase>(),
    getDurationUseCase: sl<GetDurationUseCase>(),
    repository: sl<AudioPlayerRepository>(),
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
