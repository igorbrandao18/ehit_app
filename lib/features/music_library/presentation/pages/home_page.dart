import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/layout/app_layout.dart';
import '../../../../shared/widgets/layout/app_header.dart';
import '../../../../shared/design/app_colors.dart';
import '../../../../shared/widgets/music_components/sections/banner_section.dart';
import '../../../../shared/widgets/music_components/sections/playhits_personalized_section.dart';
import '../../../../shared/widgets/music_components/sections/featured_artists_section.dart';
import '../../../../shared/widgets/music_components/sections/releases_section.dart';
import '../../../../shared/widgets/music_components/sections/ehit_recommends_section.dart';
import '../../../../shared/widgets/music_components/sections/events_section.dart';
import '../../../../shared/design/layout_tokens.dart';
import '../../../../shared/design/design_tokens.dart';
import '../controllers/music_library_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      extendBodyBehindAppBar: true,
      appBar: AppHeader(
        title: AppLocalizations.of(context)!.appTitle,
        subtitle: AppLocalizations.of(context)!.music,
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.solidBackground,
        ),
        child: Consumer<MusicLibraryController>(
        builder: (context, controller, child) {
            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: BannerSection(),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: DesignTokens.bannerBottomSpacing),
                    const PlayHitsPersonalizedSection(),
                    const SizedBox(height: DesignTokens.spaceSM),
                    const FeaturedArtistsSection(),
                    const SizedBox(height: DesignTokens.spaceSM),
                    const ReleasesSection(),
                    const SizedBox(height: DesignTokens.spaceSM),
                    const EhitRecommendsSection(),
                    const SizedBox(height: DesignTokens.spaceSM),
                    const EventsSection(),
                    SizedBox(height: DesignTokens.spaceMD), 
                  ]),
                ),
              ],
          );
        },
        ),
      ),
    );
  }
}
