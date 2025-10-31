import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/audio/audio_player_service.dart';
import '../../../../core/injection/injection_container.dart' as di;
import '../../domain/entities/song.dart';
import '../controllers/downloaded_songs_controller.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../shared/design/design_tokens.dart';
import '../../../../shared/widgets/layout/app_layout.dart';
import '../../../../shared/widgets/layout/app_header.dart';
import '../../../../shared/widgets/music_components/sections/offline_songs_header.dart';
import '../../../../shared/widgets/music_components/lists/offline_songs_list.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  void initState() {
    super.initState();
    // Carregar músicas baixadas quando a página for aberta
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final controller = context.read<DownloadedSongsController>();
        controller.loadDownloadedSongs();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recarregar sempre que a página for visitada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final controller = context.read<DownloadedSongsController>();
        // Só recarregar se não estiver carregando
        if (!controller.isLoading) {
          controller.loadDownloadedSongs();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: AppHeader(
        title: 'Minhas Músicas',
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.solidBackground,
        ),
        child: Consumer<DownloadedSongsController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                ),
              );
            }

            if (controller.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white70,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.error!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => controller.loadDownloadedSongs(),
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              );
            }

            if (!controller.hasSongs) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.download_outlined,
                        color: AppColors.primaryRed.withOpacity(0.6),
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spaceLG),
                    const Text(
                      'Nenhuma música offline',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spaceSM),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spaceXL,
                      ),
                      child: Text(
                        'Baixe suas músicas favoritas para ouvir mesmo sem internet',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.spaceXL),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spaceLG,
                        vertical: DesignTokens.spaceSM,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryRed,
                            AppColors.primaryRed.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(DesignTokens.radiusLG),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: DesignTokens.spaceXS),
                          const Text(
                            'Toque no ícone de download para baixar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.loadDownloadedSongs(),
              color: AppColors.primaryRed,
              child: CustomScrollView(
                slivers: [
                  // Header impressionante
                  SliverToBoxAdapter(
                    child: OfflineSongsHeader(
                      totalSongs: controller.songsCount,
                      onShufflePlay: () {
                        final audioPlayer = Provider.of<AudioPlayerService>(
                          context,
                          listen: false,
                        );
                        final shuffled = List<Song>.from(controller.downloadedSongs)..shuffle();
                        if (shuffled.isNotEmpty) {
                          audioPlayer.playPlaylist(shuffled, startIndex: 0);
                          context.pushNamed('player');
                        }
                      },
                      onPlayAll: () {
                        final audioPlayer = Provider.of<AudioPlayerService>(
                          context,
                          listen: false,
                        );
                        if (controller.downloadedSongs.isNotEmpty) {
                          audioPlayer.playPlaylist(
                            controller.downloadedSongs,
                            startIndex: 0,
                          );
                          context.pushNamed('player');
                        }
                      },
                    ),
                  ),
                  
                  // Lista de músicas
                  SliverPadding(
                    padding: EdgeInsets.only(
                      top: DesignTokens.spaceMD,
                      bottom: DesignTokens.spaceXL,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: OfflineSongsList(
                        songs: controller.downloadedSongs,
                        onSongTap: (song, index) {
                          final audioPlayer = Provider.of<AudioPlayerService>(
                            context,
                            listen: false,
                          );
                          audioPlayer.playPlaylist(
                            controller.downloadedSongs,
                            startIndex: index,
                          );
                          context.pushNamed('player');
                        },
                        onMoreOptions: (song) {
                          // TODO: Implementar menu de opções
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

