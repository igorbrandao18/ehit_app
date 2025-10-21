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
        final imageSize = screenWidth * DesignTokens.artistHeroImageSizeRatio;
        
        return Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(DesignTokens.opacityShadow),
                blurRadius: DesignTokens.artistHeroShadowBlur,
                offset: const Offset(0, DesignTokens.artistHeroShadowOffset),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              artist.imageUrl,
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
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                debugPrint('ArtistHeroSection: Error loading image: ${artist.imageUrl}');
                debugPrint('ArtistHeroSection: Error: $error');
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: imageSize * DesignTokens.artistHeroIconSizeRatio,
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
        final fontSize = screenWidth * DesignTokens.artistHeroFontSizeRatio;
        
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
      '${artist.albumsCount} Álbuns • ${artist.genre}',
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }
}
