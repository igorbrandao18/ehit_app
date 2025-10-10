// shared/themes/app_animations.dart
import 'package:flutter/material.dart';

class AppAnimations {
  // Duration constants
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationVerySlow = Duration(milliseconds: 800);
  
  // Curve constants
  static const Curve curveEaseIn = Curves.easeIn;
  static const Curve curveEaseOut = Curves.easeOut;
  static const Curve curveEaseInOut = Curves.easeInOut;
  static const Curve curveBounce = Curves.bounceOut;
  static const Curve curveElastic = Curves.elasticOut;
  
  // Music-specific animations
  static const Duration musicTransitionDuration = Duration(milliseconds: 400);
  static const Curve musicTransitionCurve = Curves.easeInOutCubic;
  
  static const Duration playerControlDuration = Duration(milliseconds: 200);
  static const Curve playerControlCurve = Curves.easeOut;
  
  static const Duration cardHoverDuration = Duration(milliseconds: 150);
  static const Curve cardHoverCurve = Curves.easeOut;
  
  // Animation builders
  static Widget fadeTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
  
  static Widget slideTransition({
    required Widget child,
    required Animation<Offset> animation,
  }) {
    return SlideTransition(
      position: animation,
      child: child,
    );
  }
  
  static Widget scaleTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }
  
  // Music player animations
  static AnimationController createPlayerController(TickerProvider vsync) {
    return AnimationController(
      duration: musicTransitionDuration,
      vsync: vsync,
    );
  }
  
  static Animation<double> createPlayerAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: musicTransitionCurve,
    ));
  }
}
