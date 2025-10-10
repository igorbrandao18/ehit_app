// shared/themes/app_dimensions.dart
import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class AppDimensions {
  // Card dimensions
  static double getAlbumCardWidth(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 140.0,
      tablet: 160.0,
      desktop: 180.0,
    );
  }

  static double getAlbumCardHeight(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 180.0,
      tablet: 200.0,
      desktop: 220.0,
    );
  }

  static double getArtistCardSize(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 80.0,
      tablet: 100.0,
      desktop: 120.0,
    );
  }

  static double getSongCardHeight(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 60.0,
      tablet: 70.0,
      desktop: 80.0,
    );
  }

  // Spacing
  static double getSectionSpacing(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 4.0,
      tablet: 6.0,
      desktop: 8.0,
    );
  }

  static double getCardSpacing(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 12.0,
      tablet: 16.0,
      desktop: 20.0,
    );
  }

  static double getListSpacing(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 8.0,
      tablet: 12.0,
      desktop: 16.0,
    );
  }

  // Text sizes
  static double getTitleSize(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 20.0,
      tablet: 24.0,
      desktop: 28.0,
    );
  }

  static double getSubtitleSize(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );
  }

  static double getBodySize(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 14.0,
      tablet: 16.0,
      desktop: 18.0,
    );
  }

  // Icon sizes
  static double getIconSize(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 20.0,
      tablet: 24.0,
      desktop: 28.0,
    );
  }

  static double getSmallIconSize(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );
  }
}
