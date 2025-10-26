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
      preferredSize: Size.fromHeight(80 + safeAreaTop),
      child: Container(
        padding: EdgeInsets.only(
          top: safeAreaTop + DesignTokens.spaceLG,
          bottom: DesignTokens.spaceMD,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesignTokens.screenPadding),
          child: Row(
            children: [
              if (showLogo)
                GestureDetector(
                  onTap: onLogoTap,
                  child: Container(
                    height: 100,
                    child: Image.asset(
                      'assets/logo-header.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              if (rightWidget != null)
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: rightWidget!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(80);
}
