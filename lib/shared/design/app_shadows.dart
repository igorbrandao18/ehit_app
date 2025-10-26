import 'package:flutter/material.dart';
import 'design_tokens.dart';
import 'app_colors.dart';
class AppShadows {
  AppShadows._();
  static const List<BoxShadow> shadowNone = [];
  static const List<BoxShadow> shadowSM = [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];
  static const List<BoxShadow> shadowMD = [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  static const List<BoxShadow> shadowLG = [
    BoxShadow(
      color: AppColors.shadowMedium,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  static const List<BoxShadow> shadowXL = [
    BoxShadow(
      color: AppColors.shadowMedium,
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
  static const List<BoxShadow> shadowXXL = [
    BoxShadow(
      color: AppColors.shadowDark,
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];
  static const List<BoxShadow> cardShadow = shadowMD;
  static const List<BoxShadow> buttonShadow = shadowSM;
  static const List<BoxShadow> modalShadow = shadowXL;
  static const List<BoxShadow> playerShadow = shadowLG;
  static const List<BoxShadow> albumArtShadow = shadowLG;
  static const List<BoxShadow> floatingButtonShadow = shadowMD;
  static const List<BoxShadow> musicCardShadow = [
    BoxShadow(
      color: AppColors.shadowMedium,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
  static const List<BoxShadow> artistCardShadow = [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
  static List<BoxShadow> getShadow(double elevation) {
    if (elevation <= 0) return shadowNone;
    if (elevation <= 2) return shadowSM;
    if (elevation <= 4) return shadowMD;
    if (elevation <= 8) return shadowLG;
    if (elevation <= 16) return shadowXL;
    return shadowXXL;
  }
  static List<BoxShadow> getShadowWithColor(Color color, double elevation) {
    if (elevation <= 0) return shadowNone;
    return [
      BoxShadow(
        color: color.withOpacity(0.1),
        blurRadius: elevation,
        offset: Offset(0, elevation / 2),
      ),
    ];
  }
  static List<BoxShadow> getMusicShadow({double elevation = 4}) {
    return [
      BoxShadow(
        color: AppColors.shadowMedium,
        blurRadius: elevation,
        offset: const Offset(0, 2),
      ),
    ];
  }
  static List<BoxShadow> getPlayerShadow({double elevation = 8}) {
    return [
      BoxShadow(
        color: AppColors.shadowDark,
        blurRadius: elevation,
        offset: const Offset(0, 4),
      ),
    ];
  }
}
