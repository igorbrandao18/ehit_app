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
                const SliverToBoxAdapter(
                  child: BannerSection(),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: DesignTokens.bannerBottomSpacing),
                ),
                const SliverToBoxAdapter(
                  child: PlayHitsPersonalizedSection(),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: DesignTokens.spaceSM),
                ),
                const SliverToBoxAdapter(
                  child: FeaturedArtistsSection(),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: DesignTokens.spaceMD), // Espaçamento mínimo no final
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
