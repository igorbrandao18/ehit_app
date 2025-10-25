// shared/widgets/music_components/category_filter_buttons.dart
import 'package:flutter/material.dart';
import '../../design/layout_tokens.dart';
import '../../design/app_colors.dart';

class CategoryFilterButtons extends StatelessWidget {
  const CategoryFilterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Top Playlists',
      'Podcasts',
      'Máquina do Tempo',
      'Países',
      'Lançamentos',
      'Mais Tocadas',
    ];

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: LayoutTokens.paddingMD),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: LayoutTokens.paddingMD),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: LayoutTokens.paddingSM),
            child: FilterChip(
              label: Text(
                categories[index],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.white.withOpacity(0.1),
              selectedColor: Colors.white.withOpacity(0.3),
              side: BorderSide(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
              selected: index == 0, // Primeiro item selecionado por padrão
              onSelected: (selected) {
                // Implementar lógica de seleção
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(LayoutTokens.radiusCircular),
              ),
            ),
          );
        },
      ),
    );
  }
}
