import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design/app_colors.dart';
import '../../design/design_tokens.dart';
import '../../../core/routing/app_routes.dart';

class BottomNavigationMenu extends StatelessWidget {
  const BottomNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    
    // Mostrar menu apenas nas páginas principais: home, library, search, radios
    final mainRoutes = [
      AppRoutes.home,
      AppRoutes.library,
      AppRoutes.search,
      AppRoutes.radios,
    ];

    // Debug: verificar rota atual
    debugPrint('📍 BottomNavigationMenu - Rota atual: $currentLocation');
    debugPrint('📍 Main routes: $mainRoutes');
    debugPrint('📍 Menu deve aparecer: ${mainRoutes.contains(currentLocation)}');

    if (!mainRoutes.contains(currentLocation)) {
      return const SizedBox.shrink();
    }

    return Material(
      elevation: 8,
      color: AppColors.solidBackground,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 1,
            color: AppColors.borderLight.withOpacity(0.3),
          ),
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.solidBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(DesignTokens.opacityShadow),
                  blurRadius: DesignTokens.miniPlayerShadowBlur,
                  offset: const Offset(0, -DesignTokens.miniPlayerShadowOffset),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: DesignTokens.spaceXS),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context: context,
                      icon: Icons.home,
                      label: 'Home',
                      route: AppRoutes.home,
                      isActive: currentLocation == AppRoutes.home,
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.library_music,
                      label: 'Minhas Músicas',
                      route: AppRoutes.library,
                      isActive: currentLocation == AppRoutes.library,
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.search,
                      label: 'Buscar',
                      route: AppRoutes.search,
                      isActive: currentLocation == AppRoutes.search,
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.radio,
                      label: 'Rádios',
                      route: AppRoutes.radios,
                      isActive: currentLocation == AppRoutes.radios,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!isActive) {
              context.go(route);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spaceXS,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: isActive ? AppColors.primaryRed : AppColors.textSecondary,
                      size: 20, // Reduzido para 4 itens
                    ),
                    const SizedBox(height: 1), // Espaçamento mínimo
                    Flexible(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isActive ? AppColors.primaryRed : AppColors.textSecondary,
                          fontSize: 10, // Reduzido para 4 itens
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                          height: 1.0, // Altura da linha reduzida
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

