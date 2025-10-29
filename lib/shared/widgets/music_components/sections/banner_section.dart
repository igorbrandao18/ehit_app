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
    
    // Inicia o auto-slide após os banners carregarem
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<BannerController>(context, listen: false);
      if (controller.banners.length > 1) {
        _startAutoSlide();
      }
    });
  }

  void _startAutoSlide() {
    final controller = Provider.of<BannerController>(context, listen: false);
    
    if (!mounted || controller.banners.length <= 1) return;
    
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      
      _animationController.forward().then((_) {
        if (!mounted) return;
        
        setState(() {
          _currentIndex = _nextIndex;
          _nextIndex = (_nextIndex + 1) % controller.banners.length;
        });
        
        _animationController.reset();
        _startAutoSlide();
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
        
        // Atualizar índices se necessário
        if (_nextIndex >= controller.banners.length) {
          _nextIndex = controller.banners.length > 1 ? 1 : 0;
        }
        
        return Container(
          height: 200,
          child: Stack(
            children: [
              _buildBannerCard(context, controller.banners[_currentIndex]),
              if (controller.banners.length > 1 && _nextIndex < controller.banners.length)
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
