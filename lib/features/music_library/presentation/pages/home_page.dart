// features/music_library/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/layout/gradient_scaffold.dart';
import '../../../../shared/widgets/layout/app_header.dart';
import '../../../../shared/widgets/music_components/sections/banner_section.dart';
import '../../../../shared/widgets/music_components/sections/playhits_personalized_section.dart';
import '../../../../shared/widgets/music_components/sections/featured_artists_section.dart';
import '../../../../shared/design/layout_tokens.dart';
import '../../../../shared/design/design_tokens.dart';
import '../controllers/music_library_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      extendBodyBehindAppBar: true,
      appBar: AppHeader(
        title: AppLocalizations.of(context)!.appTitle,
        subtitle: AppLocalizations.of(context)!.music,
      ),
      body: Consumer<MusicLibraryController>(
        builder: (context, controller, child) {
          return SafeArea(
            child: CustomScrollView(
              slivers: [
                // Banner Section
                const SliverToBoxAdapter(
                  child: BannerSection(),
                ),
                
                // Seção "PlayHI"
                const SliverToBoxAdapter(
                  child: PlayHitsPersonalizedSection(),
                ),
                
                // Espaçamento
                const SliverToBoxAdapter(
                  child: SizedBox(height: DesignTokens.spaceSM),
                ),
                
                // Seção "Artistas em Destaque"
                const SliverToBoxAdapter(
                  child: FeaturedArtistsSection(),
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