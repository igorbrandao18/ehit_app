// shared/widgets/music_components/song_list_item.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/music_library/domain/entities/song.dart';
import '../../../features/music_player/presentation/controllers/music_player_controller.dart';
import '../../design/design_tokens.dart';

/// Componente para item individual da lista de músicas
class SongListItem extends StatelessWidget {
  final Song song;
  final int index;
  final VoidCallback onTap;

  const SongListItem({
    super.key,
    required this.song,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 0, // Removido padding horizontal
          vertical: DesignTokens.spaceSM,
        ),
        child: Row(
          children: [
            _buildAlbumArt(),
            const SizedBox(width: DesignTokens.spaceMD),
            Expanded(
              child: _buildSongInfo(),
            ),
            _buildDownloadButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumArt() {
    return Container(
      width: DesignTokens.songThumbnailSize,
      height: DesignTokens.songThumbnailSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(DesignTokens.cardOverlayOpacity),
            blurRadius: DesignTokens.cardShadowBlur,
            offset: const Offset(0, DesignTokens.cardShadowOffset),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          song.imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('❌ SongListItem: Error loading image: ${song.imageUrl}');
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.music_note,
                color: Colors.grey,
                size: DesignTokens.songThumbnailSize * DesignTokens.cardIconSizeRatio,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSongInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          song.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: DesignTokens.fontSizeMD,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: DesignTokens.songItemSpacing),
        Text(
          song.artist,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: DesignTokens.fontSizeSM,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDownloadButton() {
    return Consumer<MusicPlayerController>(
      builder: (context, playerController, child) {
        return FutureBuilder<bool>(
          future: _isSongAvailableOffline(),
          builder: (context, snapshot) {
            final isAvailableOffline = snapshot.data ?? false;
            
            return GestureDetector(
              onTap: () => _handleDownloadTap(context),
              child: Container(
                padding: const EdgeInsets.all(DesignTokens.spaceSM),
                child: Icon(
                  isAvailableOffline ? Icons.check_circle : Icons.download,
                  color: isAvailableOffline ? Colors.green : Colors.white70,
                  size: DesignTokens.iconSM,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _isSongAvailableOffline() async {
    // TODO: Implementar verificação real usando AudioPlayerRepository
    return false;
  }

  void _handleDownloadTap(BuildContext context) async {
    // TODO: Implementar download usando OfflineAudioService
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Download de "${song.title}" iniciado'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
