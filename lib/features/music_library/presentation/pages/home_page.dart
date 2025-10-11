// features/music_library/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import '../../../../shared/widgets/layout/gradient_scaffold.dart';
import '../../../../shared/widgets/layout/page_content.dart';
import '../../../../shared/widgets/music_components/playhits_section.dart';
import '../../../../shared/design/design_tokens.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      extendBodyBehindAppBar: true,
      body: PageContent(
        children: [
          // PlayHITS da semana section
          const PlayHitsSection(
            onCardTap: _onPlayHitsCardTap,
            onViewAllTap: _onViewAllPlayHits,
          ),
          
          // Bottom padding for player
          const SizedBox(height: DesignTokens.miniPlayerHeight + 20),
        ],
      ),
    );
  }

  // Navigation handlers
  static void _onPlayHitsCardTap() {
    // TODO: Implement navigation to specific playlist
  }

  static void _onViewAllPlayHits() {
    // TODO: Implement navigation to all PlayHITS
  }

}