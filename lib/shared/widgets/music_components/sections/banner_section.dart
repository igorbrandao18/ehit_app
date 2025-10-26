// shared/widgets/music_components/banner_section.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../design/design_tokens.dart';

class BannerSection extends StatefulWidget {
  const BannerSection({super.key});

  @override
  State<BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentIndex = 0;
  int _nextIndex = 1;
  late List<BannerData> _banners;

  @override
  void initState() {
    super.initState();
    _banners = _getBanners();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _animationController.forward().then((_) {
          if (mounted) {
            setState(() {
              _currentIndex = _nextIndex;
              _nextIndex = (_nextIndex + 1) % _banners.length;
            });
            _animationController.reset();
            _startAutoSlide();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(
        top: DesignTokens.spaceMD,
        bottom: DesignTokens.spaceMD,
      ),
      child: Stack(
        children: [
          // Banner atual (sempre visível)
          _buildBannerCard(context, _banners[_currentIndex]),
          
          // Próximo banner (aparece por cima)
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: _buildBannerCard(context, _banners[_nextIndex]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard(BuildContext context, BannerData banner) {
    return GestureDetector(
      onTap: () => _handleBannerTap(context, banner),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(banner.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(),
      ),
    );
  }

  void _handleBannerTap(BuildContext context, BannerData banner) {
    switch (banner.type) {
      case BannerType.playlist:
        context.pushNamed(
          'playlist-detail',
          pathParameters: {'playlistId': banner.actionId},
          extra: banner.title,
        );
        break;
      case BannerType.artist:
        context.pushNamed(
          'artist-detail',
          pathParameters: {'artistId': banner.actionId},
          extra: banner.title,
        );
        break;
      case BannerType.promotion:
        // Abrir promoção ou link externo
        break;
    }
  }

  List<BannerData> _getBanners() {
    return [
      BannerData(
        id: '1',
        title: 'PlayHITS da Semana',
        subtitle: 'As músicas mais tocadas esta semana',
        imageUrl: 'https://img.cdndsgni.com/preview/13090966.jpg',
        type: BannerType.playlist,
        actionId: 'featured_1',
      ),
      BannerData(
        id: '2',
        title: 'Novos Lançamentos',
        subtitle: 'Descubra as últimas músicas dos seus artistas favoritos',
        imageUrl: 'https://img.cdndsgni.com/preview/13344164.jpg',
        type: BannerType.promotion,
        actionId: 'new_releases',
      ),
    ];
  }
}

class BannerData {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final BannerType type;
  final String actionId;

  BannerData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.type,
    required this.actionId,
  });
}

enum BannerType {
  playlist,
  artist,
  promotion,
}
