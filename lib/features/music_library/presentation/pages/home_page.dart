// features/music_library/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/widgets/playhits_card.dart';
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
              // PlayHITS da semana section
              _buildPlayHitsSection(),
              
              // Artists section
              _buildArtistsSection(),
              
              // Bottom padding for player
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayHitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Text(
            'PlayHITS da semana',
            style: AppTextStyles.h3,
          ),
        ),
        SizedBox(
          height: 340,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              if (index == 0) {
                // First card - larger format
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: PlayHitsCard(
                    title: 'Sertanejo Esquenta',
                    artist: 'Vários artistas',
                    imageUrl: 'https://via.placeholder.com/280x180',
                    isLarge: true,
                    onTap: () {
                      // Navigate to playlist
                    },
                  ),
                );
              } else {
                // Regular cards
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: PlayHitsCard(
                    title: 'Potên',
                    artist: 'Artista',
                    imageUrl: 'https://via.placeholder.com/200x160',
                    isLarge: false,
                    onTap: () {
                      // Navigate to playlist
                    },
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildArtistsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
          child: Text(
            'Artistas',
            style: AppTextStyles.h3,
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              final artists = [
                {'name': 'Matheus e Kauan', 'image': 'https://via.placeholder.com/120x120'},
                {'name': 'Murilo Huff', 'image': 'https://via.placeholder.com/120x120'},
                {'name': 'Gusttavo Lima', 'image': 'https://via.placeholder.com/120x120'},
              ];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: ArtistCard(
                  name: artists[index]['name']!,
                  imageUrl: artists[index]['image']!,
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
}