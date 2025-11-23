import 'package:flutter/foundation.dart';
import '../../data/datasources/events_remote_datasource.dart';
import '../../data/models/event_model.dart';

class EventsController extends ChangeNotifier {
  final EventsRemoteDataSource _dataSource;
  
  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  EventsController(this._dataSource);

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  Future<void> initialize() async {
    await loadEvents();
  }

  Future<void> loadEvents({int limit = 10, bool featured = true}) async {
    if (_isDisposed) return;
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _dataSource.getEvents(limit: limit, featured: featured);
      
      if (_isDisposed) return;
      
      final eventsList = response['events'] as List<dynamic>? ?? [];
      
      _events = eventsList.map((eventData) {
        final eventJson = eventData as Map<String, dynamic>;
        if (kDebugMode) {
          debugPrint('📅 Evento: ${eventJson['name']} - Photo: ${eventJson['photo']}');
        }
        return EventModel.fromJson(eventJson);
      }).toList();
      
      if (kDebugMode) {
        debugPrint('✅ ${_events.length} eventos carregados');
        for (var event in _events) {
          debugPrint('   - ${event.name}: photo=${event.photo ?? "null"}');
        }
      }
      
      notifyListeners();
    } catch (e) {
      if (!_isDisposed) {
        if (kDebugMode) {
          debugPrint('❌ Erro ao carregar eventos: $e');
        }
        _setError('Não foi possível carregar eventos');
      }
    } finally {
      if (!_isDisposed) {
        _setLoading(false);
      }
    }
  }

  Future<void> refresh() async {
    await loadEvents();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
