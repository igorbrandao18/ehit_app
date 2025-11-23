import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../data/datasources/music_local_datasource.dart';

/// Estratégia inteligente para calcular parâmetros de recomendação
/// baseado no consumo do usuário e características do dispositivo
class RecommendationsStrategy {
  final MusicLocalDataSource? _musicLocalDataSource;
  final SharedPreferences? _prefs;

  RecommendationsStrategy({
    MusicLocalDataSource? musicLocalDataSource,
    SharedPreferences? prefs,
  })  : _musicLocalDataSource = musicLocalDataSource,
        _prefs = prefs;

  /// Calcula automaticamente os parâmetros ideais de recomendação
  Future<RecommendationParams> calculateParams(BuildContext context) async {
    // 1. Calcular limite baseado no tamanho da tela
    final limit = _calculateLimitFromScreen(context);
    
    // 2. Analisar histórico de consumo do usuário
    final consumptionAnalysis = await _analyzeUserConsumption();
    
    // 3. Determinar quais tipos incluir automaticamente
    final includeParams = _determineIncludeParams(consumptionAnalysis);
    
    return RecommendationParams(
      limit: limit,
      includeAlbums: includeParams['albums'] ?? true,
      includePlaylists: includeParams['playlists'] ?? true,
      includeMusic: includeParams['music'] ?? false,
      preferredGenres: consumptionAnalysis.favoriteGenres,
      prioritizePopular: true, // Sempre priorizar popularidade
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

  /// Analisa o histórico de consumo do usuário
  Future<ConsumptionAnalysis> _analyzeUserConsumption() async {
    int albumsCount = 0;
    int playlistsCount = 0;
    int musicCount = 0;
    List<String> favoriteGenres = [];
    
    try {
      // Analisar músicas recentes
      if (_musicLocalDataSource != null) {
        final recentSongs = await _musicLocalDataSource!.getRecentSongs();
        musicCount = recentSongs.length;
        
        // Extrair gêneros das músicas recentes
        for (final song in recentSongs) {
          if (song.genre.isNotEmpty && !favoriteGenres.contains(song.genre)) {
            favoriteGenres.add(song.genre);
          }
        }
      }
      
      // Analisar favoritos
      if (_musicLocalDataSource != null) {
        final favorites = await _musicLocalDataSource!.getFavoriteSongs();
        musicCount += favorites.length;
      }
      
      // Verificar preferências salvas
      if (_prefs != null) {
        final prefs = await _getUserPreferences();
        final preferredContentType = prefs['preferred_content_type'] as String?;
        
        if (preferredContentType == 'albums') {
          albumsCount += 10; // Boost para álbuns
        } else if (preferredContentType == 'playlists') {
          playlistsCount += 10; // Boost para playlists
        } else if (preferredContentType == 'music') {
          musicCount += 10; // Boost para músicas individuais
        }
      }
    } catch (e) {
      debugPrint('⚠️ Erro ao analisar consumo: $e');
    }
    
    return ConsumptionAnalysis(
      albumsCount: albumsCount,
      playlistsCount: playlistsCount,
      musicCount: musicCount,
      favoriteGenres: favoriteGenres,
    );
  }

  /// Determina quais tipos de conteúdo incluir baseado na análise
  Map<String, bool> _determineIncludeParams(ConsumptionAnalysis analysis) {
    final params = <String, bool>{};
    
    // Se o usuário ouve mais músicas individuais, incluir músicas
    if (analysis.musicCount > analysis.albumsCount && 
        analysis.musicCount > analysis.playlistsCount) {
      params['music'] = true;
      params['albums'] = analysis.albumsCount > 0;
      params['playlists'] = analysis.playlistsCount > 0;
    } 
    // Se o usuário prefere álbuns
    else if (analysis.albumsCount > analysis.playlistsCount) {
      params['albums'] = true;
      params['playlists'] = true;
      params['music'] = false;
    }
    // Se o usuário prefere playlists
    else if (analysis.playlistsCount > analysis.albumsCount) {
      params['playlists'] = true;
      params['albums'] = true;
      params['music'] = false;
    }
    // Padrão: álbuns e playlists
    else {
      params['albums'] = true;
      params['playlists'] = true;
      params['music'] = false;
    }
    
    return params;
  }

  Future<Map<String, dynamic>> _getUserPreferences() async {
    if (_prefs == null) return {};
    try {
      final jsonString = _prefs!.getString(AppConstants.userPreferencesKey);
      if (jsonString != null) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('⚠️ Erro ao ler preferências: $e');
    }
    return {};
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

/// Análise do consumo do usuário
class ConsumptionAnalysis {
  final int albumsCount;
  final int playlistsCount;
  final int musicCount;
  final List<String> favoriteGenres;

  ConsumptionAnalysis({
    required this.albumsCount,
    required this.playlistsCount,
    required this.musicCount,
    required this.favoriteGenres,
  });
}

