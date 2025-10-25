// features/music_library/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/layout/gradient_scaffold.dart';
import '../../../../shared/widgets/layout/app_header.dart';
import '../../../../shared/widgets/music_components/playhits_personalized_section.dart';
import '../../../../shared/widgets/music_components/playhits_featured_section.dart';
import '../../../../shared/design/design_tokens.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../shared/design/layout_tokens.dart';
import '../controllers/music_library_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      extendBodyBehindAppBar: true,
      appBar: const AppHeader(
        title: 'ÊHIT',
        subtitle: 'Music',
      ),
      body: Consumer<MusicLibraryController>(
        builder: (context, controller, child) {
          return SafeArea(
            child: CustomScrollView(
              slivers: [
                // Seção "PlayHITS para você"
                const SliverToBoxAdapter(
                  child: PlayHitsPersonalizedSection(),
                ),
                
                // Espaçamento
                const SliverToBoxAdapter(
                  child: SizedBox(height: LayoutTokens.sectionSpacing),
                ),
                
                // Seção "PlayHITS em destaque"
                const SliverToBoxAdapter(
                  child: PlayHitsFeaturedSection(),
                ),
                
                // Bottom padding for navigation
                SliverToBoxAdapter(
                  child: SizedBox(height: LayoutTokens.getSafeAreaPadding(context).bottom + 20),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}