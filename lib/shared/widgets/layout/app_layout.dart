import 'package:flutter/material.dart';

/// Layout simples para páginas dentro do shell
/// O menu e mini player são gerenciados pelo AppShell
class AppLayout extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final bool extendBodyBehindAppBar;

  const AppLayout({
    super.key,
    required this.child,
    this.appBar,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar,
      body: SafeArea(
        top: true, // Sempre respeitar a status bar
        bottom: false, // O footer já gerencia o safe area inferior
        child: child,
      ),
    );
  }
}

