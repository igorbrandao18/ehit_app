// shared/widgets/playhits_card.dart
import 'package:flutter/material.dart';
import 'music_components/music_card.dart';
import '../design/design_tokens.dart';

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
    final cardWidth = DesignTokens.musicCardWidth;
    final cardHeight = isLarge ? DesignTokens.musicCardHeightLarge : DesignTokens.musicCardHeight;
    
    return MusicCard(
      title: title, // Show title
      artist: artist, // Show artist
      imageUrl: imageUrl,
      onTap: onTap,
      width: cardWidth,
      height: cardHeight,
      isCircular: false,
      showPlayButton: false, // No play button
      onPlay: onTap,
      showText: true, // Show text
      centerText: true, // Center text in the middle
    );
  }
}
