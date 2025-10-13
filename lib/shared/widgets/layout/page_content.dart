// shared/widgets/layout/page_content.dart
import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';

/// Container de conteúdo de página reutilizável
class PageContent extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final bool isScrollable;
  final ScrollPhysics? physics;
  final Future<void> Function()? onRefresh;

  const PageContent({
    super.key,
    required this.children,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.isScrollable = true,
    this.physics,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: children,
    );

    if (!isScrollable) {
      return SafeArea(
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: content,
        ),
      );
    }

    final scrollView = SingleChildScrollView(
      physics: physics,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: content,
      ),
    );

    // Se tem função de refresh, envolve com RefreshIndicator
    if (onRefresh != null) {
      return SafeArea(
        child: RefreshIndicator(
          onRefresh: onRefresh!,
          child: scrollView,
        ),
      );
    }

    return SafeArea(child: scrollView);
  }
}
