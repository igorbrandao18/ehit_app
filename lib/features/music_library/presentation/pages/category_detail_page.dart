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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFDA3637),
            Color(0xFF8B0000),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: Text(
            categoryTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              _buildHeaderSection(),
              
              // Artists section
              _buildArtistsSection(),
              
              // Bottom padding
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category description
          Consumer<MusicLibraryController>(
            builder: (context, controller, child) {
              return Text(
                '${controller.categoryArtists.length} artistas nesta categoria',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildArtistsSection() {
    return Consumer<MusicLibraryController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return Container(
            height: 200,
            padding: const EdgeInsets.all(24),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDA3637)),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header
              const Text(
                'Artistas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              
              // Artists list
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.categoryArtists.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final artist = controller.categoryArtists[index];
                  return _buildArtistListItem(context, artist, index + 1);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArtistListItem(BuildContext context, Map<String, String> artist, int rank) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to artist detail page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navegando para: ${artist['name']}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Rank number
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFDA3637).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    color: Color(0xFFDA3637),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Artist image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                artist['imageUrl']!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.grey,
                      size: 28,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            
            // Artist info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Artista',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

