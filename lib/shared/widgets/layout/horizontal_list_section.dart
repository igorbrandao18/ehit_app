import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';
class HorizontalListSection extends StatelessWidget {
  final Widget child;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? itemSpacing;
  const HorizontalListSection({
    super.key,
    required this.child,
    this.height,
    this.padding,
    this.itemSpacing,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? DesignTokens.musicCardHeightLarge + 40,
      child: Padding(
        padding: itemSpacing ?? const EdgeInsets.only(right: DesignTokens.cardSpacing),
        child: child,
      ),
    );
  }
}
