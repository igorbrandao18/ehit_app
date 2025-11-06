import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design/app_colors.dart';
import '../../design/design_tokens.dart';
import '../../../core/routing/app_routes.dart';

class BottomNavigationMenu extends StatefulWidget {
  const BottomNavigationMenu({super.key});

  @override
  State<BottomNavigationMenu> createState() => _BottomNavigationMenuState();
}

class _BottomNavigationMenuState extends State<BottomNavigationMenu> {
  String _currentLocation = AppRoutes.home;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateLocation();
  }

  void _updateLocation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      try {
        final routerState = GoRouterState.of(context);
        final newLocation = routerState.uri.path;
        if (_currentLocation != newLocation) {
          setState(() {
            _currentLocation = newLocation;
          });
        }
      } catch (e) {
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _updateLocation();
    
    final mainRoutes = [
      AppRoutes.home,
      AppRoutes.library,
      AppRoutes.search,
      AppRoutes.radios,
      AppRoutes.more,
    ];

    if (!mainRoutes.contains(_currentLocation)) {
      return const SizedBox.shrink();
    }

    return RepaintBoundary(
      child: Material(
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildNavItem(
                        key: const ValueKey('nav-home'),
                        icon: Icons.home,
                        label: 'Home',
                        route: AppRoutes.home,
                        isActive: _currentLocation == AppRoutes.home,
                      ),
                      _buildNavItem(
                        key: const ValueKey('nav-library'),
                        icon: Icons.library_music,
                        label: 'Minhas Músicas',
                        route: AppRoutes.library,
                        isActive: _currentLocation == AppRoutes.library,
                      ),
                      _buildNavItem(
                        key: const ValueKey('nav-search'),
                        icon: Icons.search,
                        label: 'Buscar',
                        route: AppRoutes.search,
                        isActive: _currentLocation == AppRoutes.search,
                      ),
                      _buildNavItem(
                        key: const ValueKey('nav-radios'),
                        icon: Icons.radio,
                        label: 'Rádios',
                        route: AppRoutes.radios,
                        isActive: _currentLocation == AppRoutes.radios,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    Key? key,
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    return Expanded(
      key: key,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!isActive) {
              context.go(route);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02, 
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isActive ? AppColors.primaryRed : AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isActive ? AppColors.primaryRed : AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      height: 1.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
