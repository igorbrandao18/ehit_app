import 'dart:async';

/// Helper para calcular e atualizar a posição da música manualmente
/// quando o positionStream do just_audio não funciona no iOS
class AudioPositionHelper {
  DateTime? _startTime;
  Duration _startPosition = Duration.zero;
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;
  Timer? _updateTimer;
  
  /// Callback chamado quando a posição é atualizada
  void Function(Duration position)? onPositionUpdate;

  AudioPositionHelper({this.onPositionUpdate});

  /// Inicia o tracking da posição
  void start({Duration initialPosition = Duration.zero}) {
    _startTime = DateTime.now();
    _startPosition = initialPosition;
    _currentPosition = initialPosition;
    _isPlaying = true;
    
    // Atualizar a posição a cada 100ms
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isPlaying) return;
      
      final now = DateTime.now();
      if (_startTime != null) {
        final elapsed = now.difference(_startTime!);
        _currentPosition = _startPosition + elapsed;
        onPositionUpdate?.call(_currentPosition);
      }
    });
  }

  /// Pausa o tracking da posição
  void pause() {
    if (!_isPlaying) return; // Já está pausado
    
    _isPlaying = false;
    if (_startTime != null) {
      // Salvar a posição atual como nova posição inicial
      final now = DateTime.now();
      final elapsed = now.difference(_startTime!);
      _startPosition = _startPosition + elapsed;
      _currentPosition = _startPosition;
      
      // Chamar callback uma última vez com a posição atual ao pausar
      // Isso garante que a UI seja atualizada com a posição correta
      onPositionUpdate?.call(_currentPosition);
    }
  }

  /// Retoma o tracking da posição
  void resume() {
    if (!_isPlaying) {
      _startTime = DateTime.now();
      _isPlaying = true;
    }
  }

  /// Atualiza a posição manualmente (útil após seek)
  void seek(Duration newPosition) {
    _startPosition = newPosition;
    _currentPosition = newPosition;
    _startTime = DateTime.now();
    onPositionUpdate?.call(_currentPosition);
  }

  /// Retorna a posição atual
  Duration get position => _currentPosition;

  /// Para completamente o tracking
  void stop() {
    _isPlaying = false;
    _updateTimer?.cancel();
    _updateTimer = null;
    _startTime = null;
    _startPosition = Duration.zero;
    _currentPosition = Duration.zero;
  }

  /// Libera os recursos
  void dispose() {
    stop();
    onPositionUpdate = null;
  }
}

