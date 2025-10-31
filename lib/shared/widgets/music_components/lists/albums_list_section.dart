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
        child: Text(
          'Nenhum álbum encontrado',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final spacing = ResponsiveUtils.getResponsiveSpacing(context);
    final padding = ResponsiveUtils.getResponsivePadding(context);
    final cardWidth = ResponsiveUtils.getAlbumCardWidth(context);
    final cardHeight = ResponsiveUtils.getAlbumCardHeight(context);

    return Transform.translate(
      offset: Offset(0, DesignTokens.albumsListOffset), // Offset para subir a listagem
      child: Padding(
        padding: EdgeInsets.only(
          left: padding.horizontal,
          right: padding.horizontal,
        ),
        child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 colunas
          crossAxisSpacing: spacing, // Espaçamento horizontal entre cards
          mainAxisSpacing: spacing, // Espaçamento vertical entre cards
          childAspectRatio: cardWidth / cardHeight,
        ),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: AlbumCard(
              title: album.title,
              artist: album.artistName,
              imageUrl: album.imageUrl,
              onTap: () => onAlbumTap(album),
            ),
          );
        },
        ),
      ),
    );
  }
}

