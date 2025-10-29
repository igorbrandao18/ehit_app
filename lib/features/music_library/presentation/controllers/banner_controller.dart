import 'package:flutter/foundation.dart';
import '../../domain/entities/banner.dart';
import '../../domain/usecases/get_banners_usecase.dart';
import '../../../../core/utils/result.dart';

class BannerController extends ChangeNotifier {
  final GetBannersUseCase _getBannersUseCase;
  
  List<Banner> _banners = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;
  
  BannerController({
    required GetBannersUseCase getBannersUseCase,
  }) : _getBannersUseCase = getBannersUseCase;

  List<Banner> get banners => _banners;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  Future<void> loadBanners() async {
    if (_isDisposed) return;
    
    _setLoading(true);
    _clearError();
    
    try {
      final banners = await _getBannersUseCase();
      
      if (_isDisposed) return;
      
      _banners = banners;
      debugPrint('🎯 Banners carregados: ${_banners.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erro ao carregar banners: $e');
      if (!_isDisposed) {
        _setError('Erro ao carregar banners: $e');
      }
    } finally {
      if (!_isDisposed) {
        _setLoading(false);
      }
    }
  }
  
  Future<void> initialize() async {
    await loadBanners();
  }
  
  Future<void> refresh() async {
    await loadBanners();
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
  }
  
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

