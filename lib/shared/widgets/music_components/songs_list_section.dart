// shared/widgets/music_components/songs_list_section.dart

import 'package:flutter/material.dart';
import '../../../features/music_library/domain/entities/song.dart';
import '../../design/design_tokens.dart';
import '../../design/app_colors.dart';
import 'song_list_item.dart';

/// Componente para exibir lista de músicas do artista
class SongsListSection extends StatelessWidget {
  final List<Song> songs;
  final String artistName;
  final Function(Song) onSongTap;
  final VoidCallback onShuffleTap;
  final VoidCallback onRepeatTap;

  const SongsListSection({
    super.key,
    required this.songs,
    required this.artistName,
    required this.onSongTap,
    required this.onShuffleTap,
    required this.onRepeatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          const SizedBox(height: DesignTokens.listHeaderSpacing),
          _buildSongsList(),
        ],
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spaceMD),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Lista de sons',
            style: TextStyle(
              color: Colors.white,
              fontSize: DesignTokens.fontSizeLG,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              _buildActionButton(
                icon: Icons.shuffle,
                onTap: onShuffleTap,
              ),
              const SizedBox(width: DesignTokens.spaceSM),
              _buildActionButton(
                icon: Icons.repeat,
                onTap: onRepeatTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.spaceSM),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: DesignTokens.iconMD,
        ),
      ),
    );
  }

  Widget _buildSongsList() {
    if (songs.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma música encontrada',
          style: TextStyle(
            color: Colors.white70,
            fontSize: DesignTokens.fontSizeMD,
          ),
        ),
      );
    }

    return Column(
      children: songs.map((song) {
        final index = songs.indexOf(song) + 1;
        return SongListItem(
          song: song,
          index: index,
          onTap: () => onSongTap(song),
        );
      }).toList(),
    );
  }
}
