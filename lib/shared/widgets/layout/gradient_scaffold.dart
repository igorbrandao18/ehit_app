// shared/widgets/layout/gradient_scaffold.dart
import 'package:flutter/material.dart';
import '../../design/app_colors.dart';
import 'app_layout_with_mini_player.dart';

/// Scaffold com gradiente de fundo reutilizável
class GradientScaffold extends StatelessWidget {
  final Widget body;
  final bool extendBodyBehindAppBar;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final LinearGradient? gradient;
  final bool showMiniPlayer;

  const GradientScaffold({
    super.key,
    required this.body,
    this.extendBodyBehindAppBar = false,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.gradient,
    this.showMiniPlayer = true,
  });

  @override
  Widget build(BuildContext context) {
    final scaffoldBody = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: gradient != null ? null : AppColors.solidBackground,
        gradient: gradient,
      ),
      child: body,
    );

    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      backgroundColor: backgroundColor ?? Colors.transparent,
      body: showMiniPlayer 
          ? AppLayoutWithMiniPlayer(child: scaffoldBody)
          : scaffoldBody,
    );
  }
}
