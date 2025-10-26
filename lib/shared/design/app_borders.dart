import 'package:flutter/material.dart';
import 'design_tokens.dart';
import 'app_colors.dart';
class AppBorders {
  AppBorders._();
  static const double borderWidthNone = 0.0;
  static const double borderWidthThin = 1.0;
  static const double borderWidthNormal = 2.0;
  static const double borderWidthThick = 3.0;
  static const BorderRadius borderRadiusNone = BorderRadius.zero;
  static const BorderRadius borderRadiusXS = BorderRadius.all(Radius.circular(DesignTokens.radiusSM));
  static const BorderRadius borderRadiusSM = BorderRadius.all(Radius.circular(DesignTokens.radiusSM));
  static const BorderRadius borderRadiusMD = BorderRadius.all(Radius.circular(DesignTokens.radiusMD));
  static const BorderRadius borderRadiusLG = BorderRadius.all(Radius.circular(DesignTokens.radiusLG));
  static const BorderRadius borderRadiusXL = BorderRadius.all(Radius.circular(DesignTokens.radiusLG));
  static const BorderRadius borderRadiusCircular = BorderRadius.all(Radius.circular(DesignTokens.radiusCircular));
  static const BorderRadius cardBorderRadius = borderRadiusMD;
  static const BorderRadius buttonBorderRadius = borderRadiusSM;
  static const BorderRadius inputBorderRadius = borderRadiusSM;
  static const BorderRadius imageBorderRadius = borderRadiusSM;
  static const BorderRadius modalBorderRadius = borderRadiusMD;
  static const BorderRadius bottomSheetBorderRadius = borderRadiusLG;
  static const BorderRadius searchBarBorderRadius = borderRadiusXL;
  static const Border borderNone = Border();
  static const Border borderLight = Border.fromBorderSide(
    BorderSide(color: AppColors.borderLight, width: borderWidthThin),
  );
  static const Border borderMedium = Border.fromBorderSide(
    BorderSide(color: AppColors.borderMedium, width: borderWidthNormal),
  );
  static const Border borderDark = Border.fromBorderSide(
    BorderSide(color: AppColors.borderDark, width: borderWidthNormal),
  );
  static const Border cardBorder = borderLight;
  static const Border buttonBorder = borderLight;
  static const Border inputBorder = borderLight;
  static const Border modalBorder = borderMedium;
  static Border getBorder({
    Color? color,
    double? width,
  }) {
    return Border.all(
      color: color ?? AppColors.borderLight,
      width: width ?? borderWidthThin,
    );
  }
  static BorderRadius getBorderRadius(double radius) {
    return BorderRadius.all(Radius.circular(radius));
  }
  static BorderRadius getCircularBorderRadius(double radius) {
    return BorderRadius.all(Radius.circular(radius));
  }
  static BorderRadius getTopBorderRadius(double radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    );
  }
  static BorderRadius getBottomBorderRadius(double radius) {
    return BorderRadius.only(
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
  }
}
