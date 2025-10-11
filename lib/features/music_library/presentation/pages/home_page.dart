// features/music_library/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../shared/design/app_text_styles.dart';
import '../../../../shared/widgets/playhits_card.dart';
import '../../../../shared/design/app_constants.dart';
import '../../../../shared/design/design_tokens.dart';
import '../controllers/music_library_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.subtleGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PlayHITS da semana section
                _buildPlayHitsSection(),
                
              // Bottom padding for player
              const SizedBox(height: DesignTokens.miniPlayerHeight + 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayHitsSection() {
    return Consumer<MusicLibraryController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            DesignTokens.screenPadding, 
            DesignTokens.spaceLG, 
            DesignTokens.screenPadding, 
            DesignTokens.screenPadding
          ),
          child: Text(
            AppConstants.playHitsTitle,
            style: AppTextStyles.h3,
          ),
        ),
            SizedBox(
              height: DesignTokens.musicCardHeightLarge + 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
                itemCount: controller.playHits.length,
                itemBuilder: (context, index) {
                  final playHit = controller.playHits[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: DesignTokens.cardSpacing),
                    child: PlayHitsCard(
                      title: playHit['title']!,
                      artist: playHit['artist']!,
                      imageUrl: playHit['imageUrl']!,
                      isLarge: index == 0, // First card is large
                      onTap: () {
                        // Navigate to playlist
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

}