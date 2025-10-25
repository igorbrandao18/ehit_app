// shared/widgets/layout/app_header.dart
import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? rightWidget;
  final bool showLogo;
  final VoidCallback? onLogoTap;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.rightWidget,
    this.showLogo = true,
    this.onLogoTap,
  });

  @override
  Widget build(BuildContext context) {
    final safeAreaTop = DesignTokens.getSafeAreaPadding(context).top;
    
    return PreferredSize(
      preferredSize: Size.fromHeight(60 + safeAreaTop),
      child: Container(
        padding: EdgeInsets.only(top: safeAreaTop),
        child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
          child: Row(
            children: [
              // Título alinhado à esquerda
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (subtitle != null) ...[
                        Text(
                          ' $subtitle',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // Widget do lado direito (logo ou outro widget)
              if (rightWidget != null)
                rightWidget!
              else if (showLogo)
                GestureDetector(
                  onTap: onLogoTap,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage('icon.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
