// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared/design/app_theme.dart';
import 'features/music_player/presentation/controllers/music_player_controller.dart';
import 'features/music_library/presentation/controllers/music_library_controller.dart';
import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const EhitApp());
}

class EhitApp extends StatelessWidget {
  const EhitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MusicPlayerController()),
        ChangeNotifierProvider(create: (_) => MusicLibraryController()..initialize()),
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
