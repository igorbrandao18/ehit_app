// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared/design/app_theme.dart';
import 'core/injection/injection_container.dart' as di;
import 'core/routing/app_router.dart';
import 'core/audio/audio_player_service.dart';
import 'features/music_player/presentation/controllers/audio_player_controller.dart';
import 'features/music_player/presentation/controllers/music_player_controller.dart';
import 'features/music_player/presentation/controllers/playlist_controller.dart';
import 'features/music_library/presentation/controllers/music_library_controller.dart';
import 'features/music_library/presentation/controllers/artists_controller.dart';
import 'features/authentication/presentation/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await di.init();
  
  runApp(const EhitApp());
}

class EhitApp extends StatelessWidget {
  const EhitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AudioPlayerService>()),
        ChangeNotifierProvider(create: (_) => di.sl<AudioPlayerController>()),
        ChangeNotifierProvider(create: (_) => di.sl<AuthController>()),
        ChangeNotifierProvider(create: (_) => di.sl<MusicPlayerController>()),
        ChangeNotifierProvider(create: (_) => di.sl<PlaylistController>()..initialize()),
        ChangeNotifierProvider(create: (_) => di.sl<MusicLibraryController>()..initialize()),
        ChangeNotifierProvider(create: (_) => di.sl<ArtistsController>()..initialize()),
      ],
      child: MaterialApp.router(
        title: 'ÊHIT',
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
