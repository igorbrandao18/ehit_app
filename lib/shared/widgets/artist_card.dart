// shared/widgets/artist_card.dart
import 'package:flutter/material.dart';
import 'music_components/music_card.dart';

class ArtistCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback? onTap;

  const ArtistCard({
    super.key,
    required this.name,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MusicCard(
      title: name,
      artist: '',
      imageUrl: imageUrl,
      onTap: onTap,
      width: 120,
      height: 160,
      isCircular: true,
      showPlayButton: false,
    );
  }
}