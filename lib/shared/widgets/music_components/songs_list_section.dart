// shared/widgets/music_components/songs_list_section.dart

import 'package:flutter/material.dart';
import '../../../features/music_library/domain/entities/song.dart';
import '../../design/design_tokens.dart';
import '../../design/app_colors.dart';
import '../../utils/responsive_utils.dart';
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
        _buildSectionHeader(context),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4, // 40% da altura da tela
          child: _buildSongsList(context),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsiveSpacing(context, mobile: 16, tablet: 20, desktop: 24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Lista de sons',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 20, tablet: 22, desktop: 24),
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              _buildActionButton(context, icon: Icons.shuffle, onTap: onShuffleTap),
              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, mobile: 8, tablet: 10, desktop: 12)),
              _buildActionButton(context, icon: Icons.repeat, onTap: onRepeatTap),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, mobile: 8, tablet: 10, desktop: 12)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveSpacing(context, mobile: 8, tablet: 10, desktop: 12)),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: ResponsiveUtils.getResponsiveIconSize(context, mobile: 20, tablet: 24, desktop: 28),
        ),
      ),
    );
  }

  Widget _buildSongsList(BuildContext context) {
    if (songs.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma música encontrada',
          style: TextStyle(
            color: Colors.white70,
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, mobile: 16, tablet: 18, desktop: 20),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        top: ResponsiveUtils.getResponsiveSpacing(context, mobile: 16, tablet: 20, desktop: 24),
        left: ResponsiveUtils.getResponsiveSpacing(context, mobile: 16, tablet: 20, desktop: 24),
        right: ResponsiveUtils.getResponsiveSpacing(context, mobile: 16, tablet: 20, desktop: 24),
      ),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return SongListItem(
          song: song,
          index: index + 1,
          onTap: () => onSongTap(song),
        );
      },
    );
  }
}
