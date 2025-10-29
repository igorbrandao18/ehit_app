import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../design/design_tokens.dart';
import '../../../../features/music_library/domain/entities/banner.dart' as banner_entity;
import '../../../../features/music_library/presentation/controllers/banner_controller.dart';

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
  bool _autoSlideStarted = false;

  @override
  void initState() {
    super.initState();
    
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
  }

  void _startAutoSlide(int bannersLength) {
    if (!mounted || bannersLength <= 1) return;
    
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      
      _animationController.forward().then((_) {
        if (!mounted) return;
        
        setState(() {
          _currentIndex = _nextIndex;
          _nextIndex = (_nextIndex + 1) % bannersLength;
        });
        
        _animationController.reset();
        _startAutoSlide(bannersLength);
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BannerController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return SizedBox(
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (controller.errorMessage != null || controller.banners.isEmpty) {
          return const SizedBox.shrink();
        }
        
        // Garante que os índices estão corretos
        if (_currentIndex >= controller.banners.length) {
          _currentIndex = 0;
        }
        if (_nextIndex >= controller.banners.length) {
          _nextIndex = controller.banners.length > 1 ? 1 : 0;
        }
        
        // Inicia o auto-slide quando os banners estiverem disponíveis (apenas uma vez)
        if (controller.banners.length > 1 && !_autoSlideStarted) {
          _autoSlideStarted = true;
          _startAutoSlide(controller.banners.length);
        }
        
        return Container(
          height: 200,
          child: Stack(
            children: [
              // Banner atual (sempre visível)
              _buildBannerCard(context, controller.banners[_currentIndex]),
              
              // Próximo banner (aparece por cima)
              if (controller.banners.length > 1)
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: _buildBannerCard(context, controller.banners[_nextIndex]),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBannerCard(BuildContext context, banner_entity.Banner banner) {
    return GestureDetector(
      onTap: () => _handleBannerTap(context, banner),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(banner.image),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(),
      ),
    );
  }

  void _handleBannerTap(BuildContext context, banner_entity.Banner banner) {
    debugPrint('🎯 Banner clicado: ${banner.name}');
    debugPrint('🎯 Link: ${banner.link}');
    
    // TODO: Implementar abertura de link quando necessário
    // Pode usar banner.targetId e banner.targetType para navegar
  }
}
