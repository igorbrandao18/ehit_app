import 'package:flutter/material.dart';
import '../../../../features/music_library/domain/entities/album.dart';
import '../../../design/design_tokens.dart';
import '../../../utils/responsive_utils.dart';
import '../cards/album_card.dart';

class AlbumsListSection extends StatelessWidget {
  final List<Album> albums;
  final Function(Album) onAlbumTap;

  const AlbumsListSection({
    super.key,
    required this.albums,
    required this.onAlbumTap,
  });

  @override
  Widget build(BuildContext context) {
    if (albums.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(DesignTokens.spaceLG),
          child: Text(
            'Nenhum álbum encontrado',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    // Usar MediaQuery para cálculos responsivos precisos
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = ResponsiveUtils.getResponsivePadding(context);
    final spacing = ResponsiveUtils.getResponsiveSpacing(context);
    
    // Calcular largura do card baseado na largura disponível
    final availableWidth = screenWidth - (padding.horizontal * 2) - spacing;
    final cardWidth = availableWidth / 2;
    final cardHeight = cardWidth; // Quadrado
    
    // Calcular aspect ratio correto
    final aspectRatio = cardWidth / cardHeight;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding.horizontal,
        vertical: DesignTokens.spaceMD,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 colunas
              crossAxisSpacing: spacing, // Espaçamento horizontal entre cards
              mainAxisSpacing: spacing, // Espaçamento vertical entre cards
              childAspectRatio: aspectRatio,
            ),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              return AlbumCard(
                title: album.title,
                artist: album.artistName,
                imageUrl: album.imageUrl,
                onTap: () => onAlbumTap(album),
              );
            },
          );
        },
      ),
    );
  }
}

