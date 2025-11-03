import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../design/design_tokens.dart';
import '../../../../features/music_library/presentation/controllers/artists_controller.dart';
import '../section_title.dart';
class FeaturedArtistsSection extends StatelessWidget {
  const FeaturedArtistsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistsController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return _buildLoadingState(context);
        }
        if (controller.artists.isEmpty) {
          return _buildEmptyState(context);
        }
        return _buildContent(context, controller);
      },
    );
  }
  Widget _buildLoadingState(BuildContext context) {
    return Container(
      height: DesignTokens.playhitsCardWidth + DesignTokens.spaceXL,
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: DesignTokens.playhitsCardWidth + DesignTokens.spaceXL,
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.noArtistsFound,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
  Widget _buildContent(BuildContext context, ArtistsController controller) {
    final artists = controller.artists.take(10).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: AppLocalizations.of(context)!.featuredArtists),
        const SizedBox(height: DesignTokens.spaceMD),
        SizedBox(
          height: DesignTokens.playhitsCardWidth + DesignTokens.spaceLG,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
            itemCount: artists.length,
            itemBuilder: (context, index) {
              final artist = artists[index];
              return _buildArtistCard(context, artist);
            },
          ),
        ),
      ],
    );
  }
  Widget _buildArtistCard(BuildContext context, dynamic artist) {
    final imageUrl = artist.imageUrl?.isNotEmpty == true ? artist.imageUrl : 'https://via.placeholder.com/300';
    return Container(
      width: DesignTokens.playhitsCardWidth,
      margin: const EdgeInsets.only(right: DesignTokens.spaceMD),
      child: GestureDetector(
        onTap: () => _navigateToArtist(context, artist.id.toString(), artist.name),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: DesignTokens.playhitsCardWidth, 
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DesignTokens.radiusCircular),
                color: Colors.grey[800],
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _navigateToArtist(BuildContext context, String artistId, String artistName) {
    context.pushNamed(
      'artist-detail',
      pathParameters: {'artistId': artistId},
      extra: artistName,
    );
  }
}
