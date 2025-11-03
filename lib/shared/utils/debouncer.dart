import 'dart:async';

/// Utility class para implementar debounce em operações
/// Útil para evitar múltiplas chamadas desnecessárias (ex: busca)
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  /// Executa a ação após o delay, cancelando qualquer execução pendente
  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancela qualquer execução pendente
  void cancel() {
    _timer?.cancel();
  }

  /// Verifica se há uma execução pendente
  bool get isPending => _timer?.isActive ?? false;

  /// Libera os recursos
  void dispose() {
    _timer?.cancel();
  }
}
