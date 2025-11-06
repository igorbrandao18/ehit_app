import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'shared/design/app_theme.dart';
import 'core/injection/injection_container.dart' as di;
import 'core/routing/app_router.dart';
import 'core/audio/audio_player_service.dart';
import 'features/music_player/presentation/controllers/audio_player_controller.dart';
import 'features/music_player/presentation/controllers/music_player_controller.dart';
import 'features/music_player/presentation/controllers/playlist_controller.dart';
import 'features/music_library/presentation/controllers/music_library_controller.dart';
import 'features/music_library/presentation/controllers/artists_controller.dart';
import 'features/music_library/presentation/controllers/banner_controller.dart';
import 'features/authentication/presentation/controllers/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  await di.init();
  runApp(const EhitApp());
}
class EhitApp extends StatelessWidget {
  const EhitApp({super.key});
  @override
  Widget build(BuildContext context) {
    final musicLibraryController = di.sl<MusicLibraryController>();
    final artistsController = di.sl<ArtistsController>();
    final bannerController = di.sl<BannerController>();
    
    Future.microtask(() async {
      await musicLibraryController.initialize();
      await artistsController.initialize();
      await bannerController.initialize();
    });
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AudioPlayerService>()),
        ChangeNotifierProvider(create: (_) => di.sl<AudioPlayerController>()),
        ChangeNotifierProvider(create: (_) => di.sl<AuthController>()),
        ChangeNotifierProvider(create: (_) => di.sl<MusicPlayerController>()),
        ChangeNotifierProvider(create: (_) => di.sl<PlaylistController>()..initialize()),
        ChangeNotifierProvider.value(value: musicLibraryController),
        ChangeNotifierProvider.value(value: artistsController),
        ChangeNotifierProvider.value(value: bannerController),
      ],
      child: MaterialApp.router(
        title: 'ÊHIT',
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('pt', 'BR'),
        ],
        locale: const Locale('pt', 'BR'),
      ),
    );
  }
}
