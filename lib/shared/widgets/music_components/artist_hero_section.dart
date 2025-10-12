// shared/widgets/music_components/artist_hero_section.dart

import 'package:flutter/material.dart';
import '../../../features/music_library/domain/entities/artist.dart';
import '../../design/design_tokens.dart';
import '../../design/app_colors.dart';

/// Componente hero section para página de detalhes do artista
class ArtistHeroSection extends StatelessWidget {
  final Artist artist;

  const ArtistHeroSection({
    super.key,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.screenPadding,
        vertical: DesignTokens.spaceMD,
      ),
      child: Column(
        children: [
          SizedBox(height: DesignTokens.spaceXL), // Space for status bar
          _buildAlbumArt(),
          SizedBox(height: DesignTokens.spaceLG),
          _buildAlbumTitle(),
          SizedBox(height: DesignTokens.spaceSM),
          _buildAlbumInfo(),
        ],
      ),
    );
  }

  Widget _buildAlbumArt() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final imageSize = screenWidth * 0.6; // 60% da largura da tela
        
        return Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              artist.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: imageSize * 0.3,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlbumTitle() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final fontSize = screenWidth * 0.08; // 8% da largura da tela
        
        return Text(
          artist.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize.clamp(20, 32), // Entre 20 e 32px
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }

  Widget _buildAlbumInfo() {
    return Text(
      '${artist.totalSongs} Músicas • ${artist.totalDuration}',
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }
}
