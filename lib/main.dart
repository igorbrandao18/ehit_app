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
import 'features/music_library/presentation/controllers/featured_albums_controller.dart';
import 'features/music_library/presentation/controllers/banner_controller.dart';
import 'features/music_library/presentation/controllers/recommendations_controller.dart';
import 'features/music_library/presentation/controllers/moments_controller.dart';
import 'features/authentication/presentation/controllers/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  await di.init();
  runApp(const EhitApp());
}
class EhitApp extends StatefulWidget {
  const EhitApp({super.key});

  @override
  State<EhitApp> createState() => _EhitAppState();
}

class _EhitAppState extends State<EhitApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('📱 App lifecycle mudou para: $state');
    final audioService = di.sl<AudioPlayerService>();
    
    // Quando o app vai para background (incluindo tela bloqueada)
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      debugPrint('🔒 App foi para background/tela bloqueada');
      // Sempre mostrar a notificação quando o app vai para background/tela bloqueada
      if (audioService.isPlaying && audioService.currentSong != null) {
        debugPrint('🎵 Música está tocando: ${audioService.currentSong?.title}');
        // Usar showMediaNotification para garantir que a notificação seja exibida
        // Isso força a notificação a aparecer mesmo que já exista
        Future.microtask(() async {
          debugPrint('📤 Disparando notificação...');
          try {
            await audioService.showMediaNotification();
            debugPrint('✅ Notificação disparada com sucesso');
          } catch (e) {
            debugPrint('❌ Erro ao disparar notificação: $e');
          }
        });
      } else {
        debugPrint('⚠️ Música não está tocando ou não há música atual');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final musicLibraryController = di.sl<MusicLibraryController>();
    final artistsController = di.sl<ArtistsController>();
    final featuredAlbumsController = di.sl<FeaturedAlbumsController>();
    final bannerController = di.sl<BannerController>();
    final recommendationsController = di.sl<RecommendationsController>();
    final momentsController = di.sl<MomentsController>();
    
    Future.microtask(() async {
      await musicLibraryController.initialize();
      await artistsController.initialize();
      await featuredAlbumsController.initialize();
      await bannerController.initialize();
      // RecommendationsController será inicializado no widget com contexto
      // para usar estratégia automática baseada no dispositivo
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
        ChangeNotifierProvider.value(value: featuredAlbumsController),
        ChangeNotifierProvider.value(value: bannerController),
        ChangeNotifierProvider.value(value: recommendationsController),
        ChangeNotifierProvider.value(value: momentsController),
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
