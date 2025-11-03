import 'package:flutter_test/flutter_test.dart';
import 'package:ehit_app/core/utils/audio_position_helper.dart';
import 'dart:async';

void main() {
  group('AudioPositionHelper', () {
    late AudioPositionHelper helper;
    Duration? lastPositionUpdate;

    setUp(() {
      helper = AudioPositionHelper(
        onPositionUpdate: (position) {
          lastPositionUpdate = position;
        },
      );
    });

    tearDown(() {
      helper.dispose();
    });

    test('should start with zero position', () {
      expect(helper.position, Duration.zero);
    });

    test('should start tracking position', () async {
      helper.start(initialPosition: Duration.zero);
      
      // Aguardar um pouco para que o timer atualize
      await Future.delayed(const Duration(milliseconds: 150));
      
      // A posição deve ter aumentado após o tempo decorrido
      expect(helper.position.inMilliseconds, greaterThan(0));
    });

    test('should preserve position when paused', () async {
      helper.start(initialPosition: const Duration(seconds: 5));
      
      // Aguardar um pouco
      await Future.delayed(const Duration(milliseconds: 200));
      
      final positionBeforePause = helper.position;
      expect(positionBeforePause.inSeconds, greaterThanOrEqualTo(5));
      
      // Pausar
      helper.pause();
      final positionAfterPause = helper.position;
      
      // Aguardar mais tempo
      await Future.delayed(const Duration(milliseconds: 200));
      
      // A posição deve permanecer a mesma após pausar
      expect(helper.position, positionAfterPause);
      expect(helper.position.inSeconds, greaterThanOrEqualTo(5));
    });

    test('should resume from saved position', () async {
      helper.start(initialPosition: const Duration(seconds: 10));
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      final positionBeforePause = helper.position;
      helper.pause();
      
      await Future.delayed(const Duration(milliseconds: 100));
      final pausedPosition = helper.position;
      
      // Retomar
      helper.resume();
      await Future.delayed(const Duration(milliseconds: 100));
      
      // A posição deve continuar de onde parou
      expect(helper.position.inMilliseconds, greaterThan(pausedPosition.inMilliseconds));
    });

    test('should update position on seek', () {
      helper.start(initialPosition: const Duration(seconds: 5));
      
      // Buscar para uma nova posição
      helper.seek(const Duration(seconds: 30));
      
      expect(helper.position, const Duration(seconds: 30));
      expect(lastPositionUpdate, const Duration(seconds: 30));
    });

    test('should call onPositionUpdate callback when playing', () async {
      bool callbackCalled = false;
      Duration? receivedPosition;
      
      final testHelper = AudioPositionHelper(
        onPositionUpdate: (position) {
          callbackCalled = true;
          receivedPosition = position;
        },
      );
      
      testHelper.start(initialPosition: const Duration(seconds: 0));
      
      await Future.delayed(const Duration(milliseconds: 150));
      
      expect(callbackCalled, true);
      expect(receivedPosition, isNotNull);
      expect(receivedPosition!.inMilliseconds, greaterThan(0));
      
      testHelper.dispose();
    });

    test('should call onPositionUpdate when pausing', () {
      Duration? pausePosition;
      
      final testHelper = AudioPositionHelper(
        onPositionUpdate: (position) {
          pausePosition = position;
        },
      );
      
      testHelper.start(initialPosition: const Duration(seconds: 25));
      testHelper.pause();
      
      expect(pausePosition, isNotNull);
      expect(pausePosition!.inSeconds, greaterThanOrEqualTo(25));
      
      testHelper.dispose();
    });

    test('should stop completely when stop() is called', () async {
      helper.start(initialPosition: const Duration(seconds: 10));
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      final positionBeforeStop = helper.position;
      expect(positionBeforeStop.inSeconds, greaterThanOrEqualTo(10));
      
      helper.stop();
      
      // A posição deve voltar para zero após stop
      expect(helper.position.inMilliseconds, lessThan(100)); // Permitir pequena variação
    });

    test('should handle multiple pause/resume cycles', () async {
      helper.start(initialPosition: Duration.zero);
      
      for (int i = 0; i < 3; i++) {
        await Future.delayed(const Duration(milliseconds: 50));
        final positionBeforePause = helper.position;
        
        helper.pause();
        // Aguardar um pouco para garantir que o pause foi processado
        await Future.delayed(const Duration(milliseconds: 10));
        final positionAfterPause = helper.position;
        
        // Aguardar mais tempo enquanto pausado
        await Future.delayed(const Duration(milliseconds: 100));
        final positionWhilePaused = helper.position;
        
        // Quando pausado, a posição não deve mudar significativamente
        expect(positionWhilePaused.inMilliseconds, closeTo(positionAfterPause.inMilliseconds, 20));
        
        helper.resume();
        await Future.delayed(const Duration(milliseconds: 100));
        
        // A posição deve continuar aumentando após retomar
        expect(helper.position.inMilliseconds, greaterThanOrEqualTo(positionWhilePaused.inMilliseconds));
      }
    });

    test('should not update position when paused', () async {
      helper.start(initialPosition: const Duration(seconds: 10));
      await Future.delayed(const Duration(milliseconds: 100));
      
      helper.pause();
      // Aguardar um pouco para garantir que o pause foi processado
      await Future.delayed(const Duration(milliseconds: 50));
      final positionAfterPause = helper.position;
      
      // Aguardar um tempo considerável enquanto pausado
      await Future.delayed(const Duration(milliseconds: 500));
      
      // A posição deve permanecer a mesma após um longo período pausado
      // (com tolerância para pequenas variações de timer)
      expect(helper.position.inMilliseconds, closeTo(positionAfterPause.inMilliseconds, 100));
    });
  });
}
