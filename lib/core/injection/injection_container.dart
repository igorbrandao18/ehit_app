// core/injection/injection_container.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Data Sources
import '../../features/music_library/data/datasources/music_remote_datasource.dart';
import '../../features/music_library/data/datasources/music_local_datasource.dart';

// Repositories
import '../../features/music_library/data/repositories/music_repository_impl.dart';
import '../../features/music_library/domain/repositories/music_repository.dart';

// Use Cases
import '../../features/music_library/domain/usecases/get_songs_usecase.dart';
import '../../features/music_library/domain/usecases/get_artists_usecase.dart';

// Controllers
import '../../features/music_library/presentation/controllers/music_library_controller.dart';
import '../../features/music_library/presentation/controllers/artist_detail_controller.dart';
import '../../features/music_player/presentation/controllers/music_player_controller.dart';

// Constants
import '../constants/app_constants.dart';

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
    dio.options.connectTimeout = Duration(milliseconds: AppConstants.connectionTimeout);
    dio.options.receiveTimeout = Duration(milliseconds: AppConstants.receiveTimeout);
    return dio;
  });

  // ============================================================================
  // DATA SOURCES
  // ============================================================================
  
  sl.registerLazySingleton<MusicRemoteDataSource>(
    () => MusicRemoteDataSourceImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<MusicLocalDataSource>(
    () => MusicLocalDataSourceImpl(sl<SharedPreferences>()),
  );

  // ============================================================================
  // REPOSITORIES
  // ============================================================================
  
  sl.registerLazySingleton<MusicRepository>(
    () => MusicRepositoryImpl(
      sl<MusicRemoteDataSource>(),
      sl<MusicLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<ArtistRepository>(
    () => ArtistRepositoryImpl(
      sl<MusicRemoteDataSource>(),
    ),
  );

  // ============================================================================
  // USE CASES
  // ============================================================================
  
  // Song Use Cases
  sl.registerLazySingleton(() => GetSongsUseCase(sl<MusicRepository>()));
  sl.registerLazySingleton(() => GetSongByIdUseCase(sl<MusicRepository>()));
  sl.registerLazySingleton(() => GetSongsByArtistUseCase(sl<MusicRepository>()));
  sl.registerLazySingleton(() => GetPopularSongsUseCase(sl<MusicRepository>()));
  sl.registerLazySingleton(() => GetRecentSongsUseCase(sl<MusicRepository>()));
  sl.registerLazySingleton(() => SearchSongsUseCase(sl<MusicRepository>()));

  // Artist Use Cases
  sl.registerLazySingleton(() => GetArtistsUseCase(sl<ArtistRepository>()));
  sl.registerLazySingleton(() => GetArtistByIdUseCase(sl<ArtistRepository>()));
  sl.registerLazySingleton(() => GetPopularArtistsUseCase(sl<ArtistRepository>()));
  sl.registerLazySingleton(() => GetArtistsByGenreUseCase(sl<ArtistRepository>()));
  sl.registerLazySingleton(() => SearchArtistsUseCase(sl<ArtistRepository>()));

  // ============================================================================
  // CONTROLLERS
  // ============================================================================
  
  sl.registerLazySingleton(() => MusicLibraryController(
    getSongsUseCase: sl<GetSongsUseCase>(),
    getPopularSongsUseCase: sl<GetPopularSongsUseCase>(),
    getArtistsUseCase: sl<GetArtistsUseCase>(),
    getPopularArtistsUseCase: sl<GetPopularArtistsUseCase>(),
  ));

  sl.registerLazySingleton(() => ArtistDetailController());

  sl.registerLazySingleton(() => MusicPlayerController());
}

/// Helper para resetar todas as dependências (útil para testes)
Future<void> reset() async {
  await sl.reset();
}
