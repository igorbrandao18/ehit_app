// features/music_library/presentation/pages/category_detail_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/layout/gradient_scaffold.dart';
import '../../../../shared/widgets/layout/page_content.dart';
import '../../../../shared/widgets/layout/section_header.dart';
import '../../../../shared/widgets/layout/loading_section.dart';
import '../../../../shared/widgets/music_components/artist_card.dart';
import '../../../../shared/design/design_tokens.dart';
import '../controllers/music_library_controller.dart';

/// Página de detalhes da categoria com lista de artistas
class CategoryDetailPage extends StatelessWidget {
  final String categoryTitle;
  final String categoryArtists;

  const CategoryDetailPage({
    super.key,
    required this.categoryTitle,
    required this.categoryArtists,
  });

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(categoryTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: PageContent(
        children: [
          // Category info section
          _buildCategoryInfo(),
          
          // Artists section
          _buildArtistsSection(),
          
          // Bottom padding
          const SizedBox(height: DesignTokens.miniPlayerHeight + 20),
        ],
      ),
    );
  }

  Widget _buildCategoryInfo() {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryTitle,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: DesignTokens.spaceSM),
          Text(
            categoryArtists,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtistsSection() {
    return Consumer<MusicLibraryController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const LoadingSection(message: 'Carregando artistas...');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Artistas',
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: DesignTokens.spaceMD),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: DesignTokens.cardSpacing,
                mainAxisSpacing: DesignTokens.cardSpacing,
                childAspectRatio: 0.8,
              ),
              itemCount: controller.categoryArtists.length,
              itemBuilder: (context, index) {
                final artist = controller.categoryArtists[index];
                return ArtistCard(
                  name: artist['name']!,
                  imageUrl: artist['imageUrl']!,
                  onTap: () {
                    // TODO: Navigate to artist detail page
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Navegando para: ${artist['name']}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
