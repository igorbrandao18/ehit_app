import 'package:flutter/material.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../data/datasources/music_local_datasource.dart';

/// Estratégia inteligente para calcular parâmetros de recomendação
/// baseado no consumo do usuário e características do dispositivo
class RecommendationsStrategy {
  final MusicLocalDataSource? _musicLocalDataSource;

  RecommendationsStrategy({
    MusicLocalDataSource? musicLocalDataSource,
  }) : _musicLocalDataSource = musicLocalDataSource;

  /// Calcula automaticamente os parâmetros ideais de recomendação
  Future<RecommendationParams> calculateParams(BuildContext context) async {
    // 1. Calcular limite baseado no tamanho da tela
    final limit = _calculateLimitFromScreen(context);
    
    // 2. Analisar histórico de consumo do usuário para extrair gêneros
    final preferredGenres = await _extractPreferredGenres();
    
    return RecommendationParams(
      limit: limit,
      includeAlbums: true,
      includePlaylists: true,
      includeMusic: false,
      preferredGenres: preferredGenres,
      prioritizePopular: true,
    );
  }

  /// Calcula o limite baseado no tamanho da tela
  int _calculateLimitFromScreen(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = 120.0; // DesignTokens.playhitsCardWidth
    final padding = 32.0; // padding horizontal total
    final spacing = 12.0; // espaçamento entre cards
    
    // Quantos cards cabem na tela
    final availableWidth = screenWidth - padding;
    final cardsPerScreen = (availableWidth / (cardWidth + spacing)).floor();
    
    // Limite mínimo e máximo
    final minLimit = 4;
    final maxLimit = 10;
    
    // Calcular baseado no dispositivo
    final deviceType = ResponsiveUtils.getDeviceType(context);
    int baseLimit;
    
    switch (deviceType) {
      case DeviceType.mobile:
        // Mobile: mostrar o que cabe + 2 extras para scroll
        baseLimit = (cardsPerScreen + 2).clamp(minLimit, 6);
        break;
      case DeviceType.tablet:
        // Tablet: mais espaço, mostrar mais
        baseLimit = (cardsPerScreen + 3).clamp(6, 8);
        break;
      case DeviceType.desktop:
        // Desktop: máximo de recomendações
        baseLimit = (cardsPerScreen + 4).clamp(8, maxLimit);
        break;
    }
    
    return baseLimit;
  }

  /// Extrai gêneros preferidos do histórico local do usuário
  Future<List<String>> _extractPreferredGenres() async {
    final genres = <String>{};
    
    try {
      final dataSource = _musicLocalDataSource;
      if (dataSource != null) {
        // Analisar músicas recentes
        final recentSongs = await dataSource.getRecentSongs();
        for (final song in recentSongs) {
          if (song.genre.isNotEmpty) {
            genres.add(song.genre);
          }
        }
        
        // Analisar favoritos
        final favorites = await dataSource.getFavoriteSongs();
        for (final song in favorites) {
          if (song.genre.isNotEmpty) {
            genres.add(song.genre);
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️ Erro ao extrair gêneros preferidos: $e');
    }
    
    return genres.toList();
  }
}

/// Parâmetros calculados para recomendações
class RecommendationParams {
  final int limit;
  final bool includeAlbums;
  final bool includePlaylists;
  final bool includeMusic;
  final List<String> preferredGenres;
  final bool prioritizePopular;

  RecommendationParams({
    required this.limit,
    required this.includeAlbums,
    required this.includePlaylists,
    required this.includeMusic,
    this.preferredGenres = const [],
    this.prioritizePopular = true,
  });
}

