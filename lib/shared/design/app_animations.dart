import 'package:flutter/material.dart';
import 'design_tokens.dart';
class AppAnimations {
  AppAnimations._();
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationVerySlow = Duration(milliseconds: 800);
  static const Curve curveEaseInOut = Curves.easeInOut;
  static const Curve curveEaseIn = Curves.easeIn;
  static const Curve curveEaseOut = Curves.easeOut;
  static const Curve curveFastOutSlowIn = Curves.fastOutSlowIn;
  static const Curve curveBounceIn = Curves.bounceIn;
  static const Curve curveBounceOut = Curves.bounceOut;
  static const Curve curveElasticIn = Curves.elasticIn;
  static const Curve curveElasticOut = Curves.elasticOut;
  static const double scalePressed = 0.95;
  static const double scaleNormal = 1.0;
  static const double scaleHover = 1.05;
  static const double opacityVisible = 1.0;
  static const double opacityHidden = 0.0;
  static const double opacityDisabled = 0.5;
  static const Duration pageTransitionDuration = durationNormal;
  static const Duration modalTransitionDuration = durationNormal;
  static const Duration bottomSheetTransitionDuration = durationNormal;
  static const Duration snackbarTransitionDuration = durationFast;
  static Animation<double> createScaleAnimation(AnimationController controller) {
    return Tween<double>(
      begin: scaleNormal,
      end: scalePressed,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curveEaseInOut,
    ));
  }
  static Animation<double> createFadeAnimation(AnimationController controller) {
    return Tween<double>(
      begin: opacityHidden,
      end: opacityVisible,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curveEaseInOut,
    ));
  }
  static Animation<Offset> createSlideUpAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curveEaseOut,
    ));
  }
  static Animation<Offset> createSlideLeftAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curveEaseOut,
    ));
  }
  static Widget fadeTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
  static Widget scaleTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }
  static Widget slideTransition({
    required Animation<Offset> animation,
    required Widget child,
  }) {
    return SlideTransition(
      position: animation,
      child: child,
    );
  }
  static Widget rotationTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return RotationTransition(
      turns: animation,
      child: child,
    );
  }
  static PageRouteBuilder<T> createPageRoute<T>({
    required Widget page,
    Duration? duration,
    Curve? curve,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? pageTransitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve ?? curveEaseOut)),
          ),
          child: child,
        );
      },
    );
  }
  static PageRouteBuilder<T> createModalRoute<T>({
    required Widget page,
    Duration? duration,
    Curve? curve,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? modalTransitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(
            CurveTween(curve: curve ?? curveEaseInOut),
          ),
          child: child,
        );
      },
    );
  }
}
