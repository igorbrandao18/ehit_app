// features/music_library/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/layout/gradient_scaffold.dart';
import '../../../../shared/widgets/music_components/personalized_playlists_section.dart';
import '../../../../shared/widgets/music_components/category_filter_buttons.dart';
import '../../../../shared/widgets/music_components/featured_playlists_section.dart';
import '../../../../shared/design/layout_tokens.dart';
import '../../../../shared/design/app_colors.dart';
import '../controllers/music_library_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Consumer<MusicLibraryController>(
        builder: (context, controller, child) {
          return SafeArea(
            child: CustomScrollView(
              slivers: [
                // Seção "PlayHITS para você"
                const SliverToBoxAdapter(
                  child: PersonalizedPlaylistsSection(),
                ),
                
                // Espaçamento
                const SliverToBoxAdapter(
                  child: SizedBox(height: LayoutTokens.sectionSpacing),
                ),
                
                // Botões de categoria
                const SliverToBoxAdapter(
                  child: CategoryFilterButtons(),
                ),
                
                // Seção "PlayHITS em destaque"
                const SliverToBoxAdapter(
                  child: FeaturedPlaylistsSection(),
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final safeAreaTop = LayoutTokens.getSafeAreaPadding(context).top;
    
    return PreferredSize(
      preferredSize: Size.fromHeight(60 + safeAreaTop),
      child: Container(
        padding: EdgeInsets.only(top: safeAreaTop),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: LayoutTokens.paddingMD),
          child: Row(
            children: [
              // Logo centralizado
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ÊHIT',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      ' Music',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}