import 'package:flutter/material.dart';
import '../design/design_tokens.dart';
class ResponsiveUtils {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return const EdgeInsets.all(16.0);
      case DeviceType.tablet:
        return const EdgeInsets.all(24.0);
      case DeviceType.desktop:
        return const EdgeInsets.all(32.0);
    }
  }
  static double getResponsiveSpacing(BuildContext context, {
    double mobile = 8.0,
    double tablet = 12.0,
    double desktop = 16.0,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.desktop:
        return desktop;
    }
  }
  static double getResponsiveFontSize(BuildContext context, {
    double mobile = 14.0,
    double tablet = 16.0,
    double desktop = 18.0,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.desktop:
        return desktop;
    }
  }
  static double getResponsiveIconSize(BuildContext context, {
    double mobile = 20.0,
    double tablet = 24.0,
    double desktop = 28.0,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.desktop:
        return desktop;
    }
  }
  static double getResponsiveImageSize(BuildContext context, {
    double mobile = 50.0,
    double tablet = 60.0,
    double desktop = 70.0,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.desktop:
        return desktop;
    }
  }
  static int getResponsiveColumns(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return 1;
      case DeviceType.tablet:
        return 2;
      case DeviceType.desktop:
        return 3;
    }
  }
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }
  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }
  
  // Album card dimensions
  static double getAlbumCardWidth(BuildContext context) {
    final padding = getResponsivePadding(context);
    final spacing = getResponsiveSpacing(context);
    final screenWidth = getScreenWidth(context);
    // Calcula o tamanho do card para grid 2x2
    // (largura da tela - padding horizontal - espaçamento entre cards) / 2
    return (screenWidth - (padding.horizontal * 2) - spacing) / 2;
  }
  
  static double getAlbumCardHeight(BuildContext context) {
    final cardWidth = getAlbumCardWidth(context);
    // Altura = largura (quadrado) - apenas a capa, sem texto
    return cardWidth;
  }
  
  // Mini Player dimensions
  static double getMiniPlayerHeight(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return 70.0;
      case DeviceType.tablet:
        return 80.0;
      case DeviceType.desktop:
        return 90.0;
    }
  }
  
  static double getMiniPlayerAlbumSize(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return 50.0;
      case DeviceType.tablet:
        return 55.0;
      case DeviceType.desktop:
        return 60.0;
    }
  }
  
  static double getMiniPlayerButtonSize(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return 32.0;
      case DeviceType.tablet:
        return 36.0;
      case DeviceType.desktop:
        return 40.0;
    }
  }
  
  static double getMiniPlayerIconSize(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return 16.0;
      case DeviceType.tablet:
        return 18.0;
      case DeviceType.desktop:
        return 20.0;
    }
  }
  
  static double getMiniPlayerSmallIconSize(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return 14.0;
      case DeviceType.tablet:
        return 16.0;
      case DeviceType.desktop:
        return 18.0;
    }
  }
}
enum DeviceType {
  mobile,
  tablet,
  desktop,
}
