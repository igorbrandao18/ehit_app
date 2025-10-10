// features/music_library/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_dimensions.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../../shared/widgets/song_card.dart';
import '../../../../shared/widgets/album_card.dart';
import '../../../../shared/widgets/artist_card.dart';
import '../controllers/music_library_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context),
              
              // PlayHITS da semana section
              _buildPlayHitsSection(context),
              
              // Artists section
              _buildArtistsSection(context),
              
              // Recently played
              _buildRecentlyPlayedSection(context),
              
              // Bottom padding for player
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final padding = ResponsiveUtils.getResponsivePadding(context);
    final iconSize = AppDimensions.getIconSize(context);
    
    return Container(
      padding: EdgeInsets.fromLTRB(
        padding.left,
        padding.top + 8, // Extra top padding
        padding.right,
        padding.bottom,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Boa tarde',
                  style: AppTextStyles.h2.copyWith(
                    fontSize: AppDimensions.getTitleSize(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Que tal ouvir algo novo?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: AppDimensions.getBodySize(context) * 0.9,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.headphones,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayHitsSection(BuildContext context) {
    final padding = ResponsiveUtils.getResponsivePadding(context);
    final cardSpacing = AppDimensions.getCardSpacing(context);
    final cardHeight = AppDimensions.getAlbumCardHeight(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            padding.left,
            24.0, // Fixed spacing from header
            padding.right,
            16.0, // Fixed spacing to content
          ),
          child: Text(
            'PlayHITS da semana',
            style: AppTextStyles.h3.copyWith(
              fontSize: AppDimensions.getTitleSize(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: cardHeight + 20, // Reduced extra space for text
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
              left: padding.left,
              right: padding.right,
            ),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: cardSpacing),
                child: AlbumCard(
                  title: index == 0 ? 'Sertanejo Esquenta' : 'Pote',
                  artist: index == 0 ? 'Vários artistas' : 'Artista',
                  imageUrl: 'https://via.placeholder.com/200x200',
                  onTap: () {
                    // Navigate to album detail
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildArtistsSection(BuildContext context) {
    final padding = ResponsiveUtils.getResponsivePadding(context);
    final spacing = AppDimensions.getSectionSpacing(context);
    final cardSpacing = AppDimensions.getCardSpacing(context);
    final cardSize = AppDimensions.getArtistCardSize(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            padding.left,
            32.0, // Fixed spacing from previous section
            padding.right,
            16.0, // Fixed spacing to content
          ),
          child: Text(
            'Artistas',
            style: AppTextStyles.h3.copyWith(
              fontSize: AppDimensions.getTitleSize(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: cardSize + 40, // Reduced extra space for text
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
              left: padding.left,
              right: padding.right,
            ),
            itemCount: 3,
            itemBuilder: (context, index) {
              final artists = ['Matheus & Kouen', 'Murilo Huff', 'Gusttavo Lima'];
              return Padding(
                padding: EdgeInsets.only(right: cardSpacing),
                child: ArtistCard(
                  name: artists[index],
                  imageUrl: 'https://via.placeholder.com/120x120',
                  onTap: () {
                    // Navigate to artist page
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentlyPlayedSection(BuildContext context) {
    final padding = ResponsiveUtils.getResponsivePadding(context);
    final spacing = AppDimensions.getSectionSpacing(context);
    final listSpacing = AppDimensions.getListSpacing(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            padding.left,
            32.0, // Fixed spacing from previous section
            padding.right,
            16.0, // Fixed spacing to content
          ),
          child: Text(
            'Tocados recentemente',
            style: AppTextStyles.h3.copyWith(
              fontSize: AppDimensions.getTitleSize(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                padding.left,
                index == 0 ? 8 : listSpacing,
                padding.right,
                listSpacing,
              ),
              child: SongCard(
                title: 'Leão',
                artist: 'Marilia Mendonça',
                album: 'Decretos Reais',
                imageUrl: 'https://via.placeholder.com/60x60',
                duration: const Duration(minutes: 3, seconds: 45),
                onTap: () {
                  // Play song
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
