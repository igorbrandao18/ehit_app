import 'package:flutter/material.dart';
import '../../../../features/music_library/domain/entities/genre.dart';
import '../../../design/app_colors.dart';
import '../../../design/design_tokens.dart';
import '../../../utils/responsive_utils.dart';
import '../cards/genre_card.dart';

class GenresListSection extends StatelessWidget {
  final List<Genre> genres;
  final String searchQuery;
  final Function(Genre) onGenreTap;
  final EdgeInsetsGeometry? padding;

  const GenresListSection({
    super.key,
    required this.genres,
    required this.searchQuery,
    required this.onGenreTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Mensagem quando não há resultados de busca
    if (genres.isEmpty && searchQuery.isNotEmpty) {
      return Padding(
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: DesignTokens.screenPadding,
            ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.spaceXL),
            child: Column(
              children: [
                Icon(
                  Icons.search_off,
                  color: AppColors.textTertiary,
                  size: 64,
                ),
                const SizedBox(height: DesignTokens.spaceMD),
                Text(
                  'Nenhum gênero encontrado',
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DesignTokens.spaceSM),
                Text(
                  'Tente buscar com outros termos',
                  style: TextStyle(
                    color: AppColors.textTertiary.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Lista de gêneros
    final spacing = ResponsiveUtils.getResponsiveSpacing(context);
    final sectionPadding = padding ??
        EdgeInsets.symmetric(
          horizontal: DesignTokens.screenPadding,
        );

    return Padding(
      padding: sectionPadding,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: genres.length,
        separatorBuilder: (context, index) => SizedBox(height: spacing),
        itemBuilder: (context, index) {
          final genre = genres[index];
          return GenreCard(
            name: genre.name,
            imageUrl: genre.imageUrl,
            onTap: () => onGenreTap(genre),
          );
        },
      ),
    );
  }
}

