import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ehit_app/shared/utils/responsive_utils.dart';
import 'package:ehit_app/shared/design/design_tokens.dart';
import 'dart:ui';

void main() {
  group('ResponsiveUtils', () {
    testWidgets('should return correct device type for mobile', (WidgetTester tester) async {
      // Configurar tamanho de tela mobile (menor que 600)
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final deviceType = ResponsiveUtils.getDeviceType(context);
              expect(deviceType, DeviceType.mobile);
              return const SizedBox();
            },
          ),
        ),
      );
      
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should return mobile spacing for mobile devices', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final spacing = ResponsiveUtils.getResponsiveSpacing(
                context,
                mobile: DesignTokens.spaceMD,
                tablet: DesignTokens.spaceLG,
                desktop: DesignTokens.spaceXL,
              );
              
              // Em mobile, deve retornar o valor mobile
              expect(spacing, DesignTokens.spaceMD);
              return const SizedBox();
            },
          ),
        ),
      );
      
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should return mobile font size for mobile devices', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final fontSize = ResponsiveUtils.getResponsiveFontSize(
                context,
                mobile: DesignTokens.fontSizeMD,
                tablet: DesignTokens.fontSizeLG,
                desktop: DesignTokens.fontSizeXL,
              );
              
              expect(fontSize, DesignTokens.fontSizeMD);
              return const SizedBox();
            },
          ),
        ),
      );
      
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should return mobile icon size for mobile devices', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final iconSize = ResponsiveUtils.getResponsiveIconSize(
                context,
                mobile: DesignTokens.iconMD,
                tablet: DesignTokens.iconLG,
                desktop: DesignTokens.iconXL,
              );
              
              expect(iconSize, DesignTokens.iconMD);
              return const SizedBox();
            },
          ),
        ),
      );
      
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should return mobile image size for mobile devices', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final imageSize = ResponsiveUtils.getResponsiveImageSize(
                context,
                mobile: 100,
                tablet: 150,
                desktop: 200,
              );
              
              expect(imageSize, 100);
              return const SizedBox();
            },
          ),
        ),
      );
      
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should return screen width', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final screenWidth = ResponsiveUtils.getScreenWidth(context);
              expect(screenWidth, isA<double>());
              expect(screenWidth, greaterThan(0));
              return const SizedBox();
            },
          ),
        ),
      );
      
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should return screen height', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final screenHeight = ResponsiveUtils.getScreenHeight(context);
              expect(screenHeight, isA<double>());
              expect(screenHeight, greaterThan(0));
              return const SizedBox();
            },
          ),
        ),
      );
      
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('should return mini player height', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final miniPlayerHeight = ResponsiveUtils.getMiniPlayerHeight(context);
              expect(miniPlayerHeight, isA<double>());
              expect(miniPlayerHeight, greaterThan(0));
              return const SizedBox();
            },
          ),
        ),
      );
      
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });
}
