// shared/widgets/layout/gradient_scaffold.dart
import 'package:flutter/material.dart';
import '../../design/app_colors.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      backgroundColor: backgroundColor ?? Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: gradient ?? AppColors.subtleGradient,
        ),
        child: body,
      ),
    );
  }
}
