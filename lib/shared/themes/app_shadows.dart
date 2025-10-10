// shared/themes/app_shadows.dart
import 'package:flutter/material.dart';

class AppShadows {
  // Shadow elevations
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;
  
  // Box shadows
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 4.0,
    offset: Offset(0, 2),
  );
  
  static const BoxShadow playerShadow = BoxShadow(
    color: Color(0x33000000),
    blurRadius: 8.0,
    offset: Offset(0, 4),
  );
  
  static const BoxShadow modalShadow = BoxShadow(
    color: Color(0x4D000000),
    blurRadius: 16.0,
    offset: Offset(0, 8),
  );
  
  static const BoxShadow buttonShadow = BoxShadow(
    color: Color(0x26000000),
    blurRadius: 6.0,
    offset: Offset(0, 3),
  );
  
  // List of shadows for different elevations
  static List<BoxShadow> getShadow(double elevation) {
    switch (elevation) {
      case elevationXs:
        return [cardShadow];
      case elevationSm:
        return [cardShadow];
      case elevationMd:
        return [playerShadow];
      case elevationLg:
        return [modalShadow];
      case elevationXl:
        return [modalShadow];
      default:
        return [cardShadow];
    }
  }
}
