// shared/themes/app_borders.dart
import 'package:flutter/material.dart';

class AppBorders {
  // Border radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusXxl = 32.0;
  
  // Circular borders
  static const double radiusCircular = 50.0;
  
  // Border radius for different components
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius buttonBorderRadius = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius inputBorderRadius = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius modalBorderRadius = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius playerBorderRadius = BorderRadius.all(Radius.circular(radiusXl));
  
  // Circular borders
  static const BorderRadius circularBorderRadius = BorderRadius.all(Radius.circular(radiusCircular));
  
  // Border widths
  static const double borderWidthThin = 0.5;
  static const double borderWidthNormal = 1.0;
  static const double borderWidthThick = 2.0;
}
