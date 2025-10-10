// shared/widgets/playhits_card.dart
import 'package:flutter/material.dart';
import 'music_components/music_card.dart';

class PlayHitsCard extends StatelessWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final bool isLarge;
  final VoidCallback? onTap;

  const PlayHitsCard({
    super.key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    this.isLarge = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = 180.0; // Same width for all cards
    final cardHeight = isLarge ? 300.0 : 260.0;
    
    return MusicCard(
      title: '', // No title
      artist: '', // No artist
      imageUrl: imageUrl,
      onTap: onTap,
      width: cardWidth,
      height: cardHeight,
      isCircular: false,
      showPlayButton: true,
      onPlay: onTap,
      showText: false, // Hide text
    );
  }
}
