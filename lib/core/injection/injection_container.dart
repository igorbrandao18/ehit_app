import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../audio/audio_player_service.dart';
import '../../features/music_library/data/datasources/music_remote_datasource.dart';
import '../../features/music_library/data/datasources/music_local_datasource.dart';
import '../../features/music_library/data/datasources/artist_remote_datasource.dart';
import '../../features/music_library/data/datasources/banner_remote_datasource.dart';
import '../../features/music_player/data/datasources/playlist_remote_datasource.dart';
import '../../features/music_player/data/datasources/playlist_local_datasource.dart';
import '../../features/music_player/data/datasources/just_audio_datasource.dart';
import '../../features/music_player/data/datasources/audio_player_datasource.dart';
import '../../features/authentication/data/datasources/auth_remote_datasource.dart';
import '../../features/authentication/data/datasources/auth_local_datasource.dart';
import '../../features/music_library/data/repositories/music_repository_impl.dart' as music_lib_impl;
import '../../features/music_library/data/repositories/artist_repository_impl.dart';
import '../../features/music_library/data/repositories/banner_repository_impl.dart';
import '../../features/music_library/domain/repositories/playlist_repository.dart' as music_lib;
import '../../features/music_library/domain/repositories/music_repository.dart';
import '../../features/music_library/domain/repositories/artist_repository.dart' as artist_repo;
import '../../features/music_library/domain/repositories/banner_repository.dart';
import '../../features/music_player/data/repositories/playlist_repository_impl.dart';
import '../../features/music_player/domain/repositories/playlist_repository.dart' as playlist_repo;
import '../../features/music_player/data/repositories/audio_player_repository_impl.dart';
import '../../features/music_player/domain/repositories/audio_player_repository.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/music_library/domain/usecases/get_playlists_usecase.dart';
import '../../features/music_library/domain/usecases/get_artists_usecase.dart';
import '../../features/music_library/domain/usecases/get_songs_usecase.dart';
import '../../features/music_library/domain/usecases/get_banners_usecase.dart';
import '../../features/music_player/domain/usecases/playlist_usecases.dart';
import '../../features/music_player/domain/usecases/play_song_usecase.dart';
import '../../features/music_player/domain/usecases/play_queue_usecase.dart';
import '../../features/music_player/domain/usecases/audio_player_usecases.dart';
import '../../features/authentication/domain/usecases/auth_usecases.dart';
import '../../features/music_library/presentation/controllers/music_library_controller.dart';
import '../../features/music_library/presentation/controllers/artist_detail_controller.dart';
import '../../features/music_library/presentation/controllers/artists_controller.dart';
import '../../features/music_library/presentation/controllers/banner_controller.dart';
import '../../features/music_player/presentation/controllers/music_player_controller.dart';
import '../../features/music_player/presentation/controllers/playlist_controller.dart';
import '../../features/music_player/presentation/controllers/audio_player_controller.dart';
import '../../features/authentication/presentation/controllers/auth_controller.dart';
import '../constants/app_constants.dart';
import '../audio/offline_audio_service.dart';

final GetIt sl = GetIt.instance;
Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.baseUrl = AppConstants.apiBaseUrl;
    dio.options.connectTimeout = const Duration(milliseconds: AppConstants.connectionTimeout);
    dio.options.receiveTimeout = const Duration(milliseconds: AppConstants.receiveTimeout);
    return dio;
  });
  sl.registerLazySingleton<AudioPlayerService>(() => AudioPlayerService());
  sl.registerLazySingleton<OfflineAudioService>(() => OfflineAudioService());
  sl.registerLazySingleton<MusicRemoteDataSource>(
    () => MusicRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<MusicLocalDataSource>(
    () => MusicLocalDataSourceImpl(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<ArtistRemoteDataSource>(
    () => ArtistRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<BannerRemoteDataSource>(
    () => BannerRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<PlaylistRemoteDataSource>(
    () => PlaylistRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<PlaylistLocalDataSource>(
    () => PlaylistLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<AudioPlayerDataSource>(
    () => JustAudioDataSource(),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<music_lib.PlaylistRepository>(
    () => music_lib_impl.PlaylistRepositoryImpl(sl<MusicRemoteDataSource>()),
  );
  sl.registerLazySingleton<MusicRepository>(
    () => music_lib_impl.MusicRepositoryImpl(sl<MusicRemoteDataSource>()),
  );
  sl.registerLazySingleton<artist_repo.ArtistRepository>(
    () => ArtistRepositoryImpl(sl<ArtistRemoteDataSource>()),
  );
  sl.registerLazySingleton<BannerRepository>(
    () => BannerRepositoryImpl(sl<BannerRemoteDataSource>()),
  );
  sl.registerLazySingleton<playlist_repo.PlaylistRepository>(
    () => PlaylistRepositoryImpl(
      remoteDataSource: sl<PlaylistRemoteDataSource>(),
      localDataSource: sl<PlaylistLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<AudioPlayerRepository>(
    () => AudioPlayerRepositoryImpl(),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton(() => GetPlaylistsUseCase(sl<music_lib.PlaylistRepository>()));
  sl.registerLazySingleton(() => GetArtistsUseCase(sl<artist_repo.ArtistRepository>()));
  sl.registerLazySingleton(() => GetSongsUseCase(sl<MusicRepository>()));
  sl.registerLazySingleton(() => GetBannersUseCase(sl<BannerRepository>()));
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
  sl.registerLazySingleton(() => PlaySongUseCase(sl<AudioPlayerRepository>()));
  sl.registerLazySingleton(() => PlayQueueUseCase(sl<AudioPlayerRepository>()));
  sl.registerLazySingleton(() => TogglePlayPauseUseCase(sl<AudioPlayerRepository>()));
  sl.registerLazySingleton(() => NextSongUseCase(sl<AudioPlayerRepository>()));
  sl.registerLazySingleton(() => GetCurrentSongUseCase(sl<AudioPlayerRepository>()));
  sl.registerLazySingleton(() => IsPlayingUseCase(sl<AudioPlayerRepository>()));
  sl.registerLazySingleton(() => GetProgressUseCase(sl<AudioPlayerRepository>()));
  sl.registerLazySingleton(() => GetCurrentPositionUseCase(sl<AudioPlayerRepository>()));
  sl.registerLazySingleton(() => GetDurationUseCase(sl<AudioPlayerRepository>()));
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
  sl.registerLazySingleton(() => MusicLibraryController(
    getPlaylistsUseCase: sl<GetPlaylistsUseCase>(),
  ));
  sl.registerLazySingleton(() => ArtistsController(sl<GetArtistsUseCase>()));
  sl.registerLazySingleton(() => ArtistDetailController(
    getArtistsUseCase: sl<GetArtistsUseCase>(),
    getSongsUseCase: sl<GetSongsUseCase>(),
  ));
  sl.registerLazySingleton(() => BannerController(
    getBannersUseCase: sl<GetBannersUseCase>(),
  ));
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
Future<void> reset() async {
  await sl.reset();
}
