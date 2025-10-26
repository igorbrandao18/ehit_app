// shared/widgets/music_components/artists_catalog_section.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/music_library/domain/entities/artist.dart';
import '../../../../features/music_library/presentation/controllers/artists_controller.dart';
import '../../../design/design_tokens.dart';
import '../../../utils/responsive_utils.dart';
import '../../layout/section_header.dart';
import 'artist_card.dart';

/// Seção do catálogo de artistas
class ArtistsCatalogSection extends StatelessWidget {
  const ArtistsCatalogSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistsController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return _buildLoadingState();
        }

        if (controller.errorMessage != null) {
          return _buildErrorState(controller.errorMessage!);
        }

        if (controller.artists.isEmpty) {
          return _buildEmptyState();
        }

        return _buildArtistsList(context, controller.artists);
      },
    );
  }

  Widget _buildLoadingState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = _getResponsiveHeight(context);
        final padding = ResponsiveUtils.getResponsivePadding(context);
        final spacing = ResponsiveUtils.getResponsiveSpacing(context);
        final fontSize = ResponsiveUtils.getResponsiveFontSize(context);
        
        return Container(
          height: height,
          padding: EdgeInsets.only(
            left: padding.left,
            right: padding.right,
            bottom: padding.bottom,
            top: padding.top / 2, // Reduzido o padding superior pela metade
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spacing),
              Container(
                height: fontSize + 4,
                width: ResponsiveUtils.getResponsiveSpacing(context, mobile: 120, tablet: 150, desktop: 180),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
                ),
              ),
              SizedBox(height: spacing),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ResponsiveUtils.getResponsiveColumns(context) + 1,
                  itemBuilder: (context, index) {
                    final cardSize = _getResponsiveCardSize(context);
                    return Container(
                      width: cardSize,
                      margin: EdgeInsets.only(right: spacing),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = _getResponsiveHeight(context);
        final padding = ResponsiveUtils.getResponsivePadding(context);
        final spacing = ResponsiveUtils.getResponsiveSpacing(context);
        final fontSize = ResponsiveUtils.getResponsiveFontSize(context);
        final iconSize = ResponsiveUtils.getResponsiveIconSize(context);
        
        return Container(
          height: height,
          padding: EdgeInsets.only(
            left: padding.left,
            right: padding.right,
            bottom: padding.bottom,
            top: padding.top / 2, // Reduzido o padding superior pela metade
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'Artistas',
                padding: EdgeInsets.only(
                  left: padding.left,
                  right: padding.right,
                  top: padding.top / 2,
                  bottom: padding.bottom, // Mesmo espaçamento do PlayHITS
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: iconSize * 2,
                      ),
                      SizedBox(height: spacing),
                      Text(
                        'Erro ao carregar artistas',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: fontSize,
                        ),
                      ),
                      SizedBox(height: spacing / 2),
                      Text(
                        errorMessage,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: fontSize - 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = _getResponsiveHeight(context);
        final padding = ResponsiveUtils.getResponsivePadding(context);
        final spacing = ResponsiveUtils.getResponsiveSpacing(context);
        final fontSize = ResponsiveUtils.getResponsiveFontSize(context);
        final iconSize = ResponsiveUtils.getResponsiveIconSize(context);
        
        return Container(
          height: height,
          padding: EdgeInsets.only(
            left: padding.left,
            right: padding.right,
            bottom: padding.bottom,
            top: padding.top / 2, // Reduzido o padding superior pela metade
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'Artistas',
                padding: EdgeInsets.only(
                  left: padding.left,
                  right: padding.right,
                  top: padding.top / 2,
                  bottom: padding.bottom, // Mesmo espaçamento do PlayHITS
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.music_note,
                        color: Colors.white60,
                        size: iconSize * 2,
                      ),
                      SizedBox(height: spacing),
                      Text(
                        'Nenhum artista encontrado',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArtistsList(BuildContext context, List<Artist> artists) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = _getResponsiveHeight(context);
        final padding = ResponsiveUtils.getResponsivePadding(context);
        final spacing = ResponsiveUtils.getResponsiveSpacing(context);
        
        return Container(
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'Artistas',
                padding: EdgeInsets.only(
                  left: padding.left,
                  right: padding.right,
                  top: padding.top / 2,
                  bottom: padding.bottom, // Mesmo espaçamento do PlayHITS
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: padding.left,
                    right: padding.right,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: artists.length,
                    itemBuilder: (context, index) {
                      final artist = artists[index];
                      return Padding(
                        padding: EdgeInsets.only(right: spacing),
                        child: ArtistCard(
                          artist: artist,
                          onTap: () => _onArtistTap(context, artist),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onArtistTap(BuildContext context, Artist artist) {
    debugPrint('🎤 Artista selecionado: ${artist.name}');
    
    // Navegar para a página de detalhes do artista
    context.pushNamed(
      'artist-detail',
      pathParameters: {'artistId': artist.id.toString()},
      extra: artist.name,
    );
  }

  /// Retorna a altura responsiva baseada no tipo de dispositivo
  double _getResponsiveHeight(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return 180.0; // Increased height for mobile to prevent overflow
      case DeviceType.tablet:
        return 200.0; // Increased height for tablet
      case DeviceType.desktop:
        return 220.0; // Increased height for desktop
    }
  }

  /// Retorna o tamanho responsivo do card baseado no tipo de dispositivo
  double _getResponsiveCardSize(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return 100.0; // Smaller cards for mobile
      case DeviceType.tablet:
        return 120.0; // Medium cards for tablet
      case DeviceType.desktop:
        return 140.0; // Larger cards for desktop
    }
  }
}
