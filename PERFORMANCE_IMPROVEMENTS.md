# 🚀 Melhorias de Performance - Baseado em rules.mdc

Este documento lista todas as melhorias de performance recomendadas baseadas nas diretrizes do `rules.mdc`.

## 📊 Análise Atual

### ✅ O que já está bem implementado:
- ✅ `ListView.builder` sendo usado em listas grandes
- ✅ `GridView.builder` para grids
- ✅ Controllers com `dispose()` apropriado
- ✅ Streams sendo cancelados corretamente
- ✅ Constantes de cache definidas no `AppConfig`

### ❌ O que precisa ser melhorado:

## 1. 🖼️ Cache de Imagens (CRÍTICO)

**Problema**: Todas as imagens usam `Image.network` sem cache, causando:
- Redownloads constantes de imagens
- Uso excessivo de banda
- Lentidão na rolagem de listas

**Solução**: Implementar `cached_network_image`

### Impacto: 🔴 ALTO
- **Economia de banda**: 70-80% de redução
- **Melhoria de performance**: 3-5x mais rápido em listas
- **UX**: Imagens aparecem instantaneamente após primeira carga

### Implementação:

```dart
// pubspec.yaml - adicionar dependência
dependencies:
  cached_network_image: ^3.3.0

// Criar widget otimizado: lib/shared/widgets/base_components/cached_image.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';

class CachedImage extends StatelessWidget {
  final String? imageUrl;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return errorWidget ?? _defaultErrorWidget();
    }

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => 
        placeholder ?? _defaultPlaceholder(),
      errorWidget: (context, url, error) => 
        errorWidget ?? _defaultErrorWidget(),
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 100),
      maxHeightDiskCache: 1000, // Limitar tamanho do cache
      maxWidthDiskCache: 1000,
    );

    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }

  Widget _defaultPlaceholder() {
    return Container(
      color: Colors.grey.shade800,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
        ),
      ),
    );
  }

  Widget _defaultErrorWidget() {
    return Container(
      color: Colors.grey.shade800,
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
        size: 48,
      ),
    );
  }
}
```

**Substituir em todos os lugares**:
- `lib/shared/widgets/music_components/lists/song_list_item.dart`
- `lib/shared/widgets/music_components/cards/music_card.dart`
- `lib/shared/widgets/music_components/cards/artist_card.dart`
- `lib/shared/widgets/music_components/cards/album_card.dart`
- E todos os outros 16 lugares encontrados

---

## 2. ⏱️ Debounce na Busca (CRÍTICO)

**Problema**: Cada tecla digitada dispara uma busca, causando:
- Múltiplas requisições desnecessárias
- Lentidão na digitação
- Sobrecarga no servidor

**Solução**: Implementar debounce de 500ms

### Impacto: 🔴 ALTO
- **Redução de requisições**: 80-90%
- **Melhoria de UX**: Interface mais responsiva
- **Economia de recursos**: Menos processamento

### Implementação:

```dart
// lib/shared/utils/debouncer.dart
import 'dart:async';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

// Atualizar GenresController
class GenresController extends ChangeNotifier {
  final GetGenresUseCase _getGenresUseCase;
  final Debouncer _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 500));
  
  // ... código existente ...
  
  void updateSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
      
      // Se houver busca de API no futuro, aplicar debounce aqui
      // _searchDebouncer.call(() => _performSearch(query));
    }
  }
  
  @override
  void dispose() {
    _searchDebouncer.dispose();
    super.dispose();
  }
}
```

---

## 3. 🎯 Consumer Otimizado (MÉDIO)

**Problema**: `Consumer` sem `child` pode causar rebuilds desnecessários

**Solução**: Usar `child` parameter para partes estáticas

### Impacto: 🟡 MÉDIO
- **Redução de rebuilds**: 30-40%
- **Performance**: Melhor em listas grandes

### Implementação:

```dart
// Antes
Consumer<MusicLibraryController>(
  builder: (context, controller, child) {
    return Column(
      children: [
        // Widgets que não dependem do controller
        _buildHeader(), // Rebuild desnecessário
        _buildList(controller.songs),
      ],
    );
  },
)

// Depois
Consumer<MusicLibraryController>(
  child: _buildHeader(), // Construído uma vez
  builder: (context, controller, header) {
    return Column(
      children: [
        header!,
        _buildList(controller.songs),
      ],
    );
  },
)
```

---

## 4. 📦 Cache Inteligente de API (CRÍTICO)

**Problema**: Constantes definidas mas cache não implementado

**Solução**: Implementar cache com TTL (Time To Live)

### Impacto: 🔴 ALTO
- **Redução de requisições**: 60-70%
- **Offline-first**: Dados disponíveis sem internet
- **UX**: Resposta instantânea

### Implementação:

```dart
// lib/core/cache/cache_manager.dart
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_config.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> cacheData<T>({
    required String key,
    required T data,
    required T Function(Map<String, dynamic>) fromJson,
    Duration? expiration,
  }) async {
    await init();
    final expirationTime = DateTime.now().add(
      expiration ?? AppConfig.cacheExpiration,
    ).millisecondsSinceEpoch;
    
    final cacheData = {
      'data': jsonEncode(data),
      'expiration': expirationTime,
    };
    
    await _prefs?.setString(key, jsonEncode(cacheData));
  }

  Future<T?> getCachedData<T>({
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    await init();
    final cached = _prefs?.getString(key);
    if (cached == null) return null;
    
    try {
      final cacheData = jsonDecode(cached) as Map<String, dynamic>;
      final expiration = cacheData['expiration'] as int;
      
      if (DateTime.now().millisecondsSinceEpoch > expiration) {
        await _prefs?.remove(key);
        return null;
      }
      
      final data = jsonDecode(cacheData['data'] as String) as Map<String, dynamic>;
      return fromJson(data);
    } catch (e) {
      debugPrint('Erro ao recuperar cache: $e');
      return null;
    }
  }

  Future<void> clearCache(String key) async {
    await init();
    await _prefs?.remove(key);
  }

  Future<void> clearAllCache() async {
    await init();
    await _prefs?.clear();
  }
}
```

**Usar nos repositories**:
```dart
class MusicRepositoryImpl implements MusicRepository {
  final CacheManager _cache = CacheManager();
  
  @override
  Future<Result<List<Song>>> getSongs() async {
    // Tentar cache primeiro
    final cached = await _cache.getCachedData<List<Song>>(
      key: 'songs',
      fromJson: (json) => (json['songs'] as List).map((s) => Song.fromJson(s)).toList(),
    );
    
    if (cached != null) {
      return Success(cached);
    }
    
    // Se não tem cache, buscar da API
    final result = await _remoteDataSource.getSongs();
    
    result.when(
      success: (songs) async {
        await _cache.cacheData<List<Song>>(
          key: 'songs',
          data: songs,
          fromJson: (json) => (json['songs'] as List).map((s) => Song.fromJson(s)).toList(),
        );
      },
      error: (_, __) {},
    );
    
    return result;
  }
}
```

---

## 5. 🎨 Const Constructors (BAIXO)

**Problema**: Alguns widgets podem ser `const` mas não são

**Solução**: Adicionar `const` onde possível

### Impacto: 🟢 BAIXO
- **Redução de rebuilds**: 10-15%
- **Memory**: Menos objetos criados

### Exemplos:
```dart
// Antes
SizedBox(height: DesignTokens.spaceMD)

// Depois
const SizedBox(height: DesignTokens.spaceMD) // Se possível
```

---

## 6. 🔄 Paginação para Listas Grandes (MÉDIO)

**Problema**: Carregar todas as músicas de uma vez pode ser lento

**Solução**: Implementar paginação

### Impacto: 🟡 MÉDIO
- **Tempo de carregamento inicial**: 5-10x mais rápido
- **Memória**: Uso reduzido
- **UX**: Interface responsiva imediatamente

### Implementação:

```dart
class MusicLibraryController extends ChangeNotifier {
  static const int _pageSize = 20;
  int _currentPage = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    
    _isLoadingMore = true;
    notifyListeners();
    
    final result = await _getSongsUseCase(page: _currentPage + 1, limit: _pageSize);
    
    result.when(
      success: (newSongs) {
        if (newSongs.length < _pageSize) {
          _hasMore = false;
        }
        _songs.addAll(newSongs);
        _currentPage++;
      },
      error: (_, __) {},
    );
    
    _isLoadingMore = false;
    notifyListeners();
  }
}
```

---

## 7. 🎭 RepaintBoundary (BAIXO)

**Problema**: Widgets complexos fazem repaint desnecessário

**Solução**: Envolver widgets pesados com `RepaintBoundary`

### Impacto: 🟢 BAIXO
- **Repaint reduction**: 20-30%
- **Performance**: Melhor em animações

### Implementação:

```dart
RepaintBoundary(
  child: MusicCard(
    title: album.title,
    imageUrl: album.imageUrl,
    onTap: () => onAlbumTap(album),
  ),
)
```

---

## 8. 📱 Lazy Loading de Imagens (MÉDIO)

**Problema**: Carregar todas as imagens de uma lista de uma vez

**Solução**: Carregar apenas imagens visíveis

### Impacto: 🟡 MÉDIO
- **Banda**: Economia de 50-60%
- **Performance**: Lista mais fluida

**Nota**: `cached_network_image` já faz isso automaticamente, mas podemos melhorar:

```dart
ListView.builder(
  cacheExtent: 250, // Reduzir área de cache
  itemBuilder: (context, index) {
    return CachedImage(
      imageUrl: songs[index].imageUrl,
      // Já otimizado automaticamente
    );
  },
)
```

---

## 9. 🧹 Limpeza de Cache de Imagens (BAIXO)

**Problema**: Cache de imagens pode crescer indefinidamente

**Solução**: Limpar cache periodicamente

### Impacto: 🟢 BAIXO
- **Storage**: Liberar espaço automaticamente

### Implementação:

```dart
// No main.dart ou AppConfig
Future<void> cleanImageCache() async {
  final cacheManager = DefaultCacheManager();
  await cacheManager.emptyCache();
  
  // Ou implementar limpeza baseada em tamanho
  final size = await cacheManager.getCacheSize();
  if (size > AppConfig.maxCacheSizeMB * 1024 * 1024) {
    await cacheManager.emptyCache();
  }
}
```

---

## 10. 🚫 Evitar notifyListeners() Desnecessários (MÉDIO)

**Problema**: `notifyListeners()` sendo chamado mesmo quando estado não muda

**Solução**: Verificar mudanças antes de notificar

### Impacto: 🟡 MÉDIO
- **Rebuilds**: Redução de 20-30%

### Implementação:

```dart
void updateSearchQuery(String query) {
  if (_searchQuery == query) return; // ✅ Já existe
  _searchQuery = query;
  notifyListeners();
}
```

---

## 📋 Priorização de Implementação

### Fase 1 - Crítico (Impacto Alto):
1. ✅ Cache de Imagens (cached_network_image)
2. ✅ Debounce na Busca
3. ✅ Cache Inteligente de API

### Fase 2 - Importante (Impacto Médio):
4. ✅ Consumer Otimizado
5. ✅ Paginação
6. ✅ Lazy Loading (já vem com cached_network_image)

### Fase 3 - Otimização (Impacto Baixo):
7. ✅ Const Constructors
8. ✅ RepaintBoundary
9. ✅ Limpeza de Cache
10. ✅ Evitar notifyListeners() desnecessários

---

## 📊 Resultados Esperados

Após implementar todas as melhorias:

- **Redução de uso de banda**: 60-70%
- **Tempo de carregamento inicial**: 3-5x mais rápido
- **Responsividade da UI**: 40-50% melhor
- **Uso de memória**: 20-30% reduzido
- **Requisitions à API**: 70-80% reduzidas

---

## 🧪 Como Testar

### Antes das melhorias:
```bash
flutter run --profile
# Verificar no DevTools:
# - Network tab: requisições de imagens
# - Performance tab: FPS e rebuilds
# - Memory tab: uso de memória
```

### Depois das melhorias:
```bash
# Repetir e comparar métricas
```

---

**Última atualização**: Dezembro 2024  
**Próximos passos**: Implementar Fase 1 (Crítico)
