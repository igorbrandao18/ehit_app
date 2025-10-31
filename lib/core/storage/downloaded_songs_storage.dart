import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/music_library/domain/entities/song.dart';
import '../../features/music_library/data/models/song_model.dart';

/// Serviço para gerenciar persistência das músicas baixadas usando Hive
class DownloadedSongsStorage {
  static const String _boxName = 'downloaded_songs_box';
  Box? _box; // Box sem tipo genérico para armazenar Maps

  DownloadedSongsStorage();

  /// Inicializa o box do Hive
  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox(_boxName);
    }
  }

  /// Garante que o box está inicializado
  Future<void> _ensureInitialized() async {
    if (_box == null || !_box!.isOpen) {
      await init();
    }
  }

  /// Adiciona uma música à lista de músicas baixadas (salva o objeto completo)
  Future<void> addDownloadedSong(Song song) async {
    try {
      await _ensureInitialized();
      
      final songModel = SongModel.fromEntity(song);
      final songMap = songModel.toMap();
      
      // Usar o ID da música como chave no Hive
      await _box!.put(song.id, songMap);
      
      debugPrint('✅ Música ${song.id} (${song.title}) salva no Hive');
    } catch (e) {
      debugPrint('❌ Erro ao salvar música baixada: $e');
    }
  }

  /// Remove uma música da lista de músicas baixadas
  Future<void> removeDownloadedSong(String songId) async {
    try {
      await _ensureInitialized();
      await _box!.delete(songId);
      debugPrint('🗑️ Música $songId removida do Hive');
    } catch (e) {
      debugPrint('❌ Erro ao remover música baixada: $e');
    }
  }

  /// Retorna a lista de músicas baixadas (objetos completos)
  Future<List<Song>> getDownloadedSongs() async {
    try {
      await _ensureInitialized();
      
      final songs = _box!.values
          .map((songMap) {
            try {
              return SongModel.fromMap(Map<String, dynamic>.from(songMap)).toEntity();
            } catch (e) {
              debugPrint('❌ Erro ao deserializar música do Hive: $e');
              return null;
            }
          })
          .whereType<Song>()
          .toList();
      
      debugPrint('📦 DownloadedSongsStorage: ${songs.length} músicas carregadas do Hive');
      return songs;
    } catch (e) {
      debugPrint('❌ Erro ao carregar músicas baixadas: $e');
      return [];
    }
  }

  /// Retorna a lista de IDs das músicas baixadas
  Future<List<String>> getDownloadedSongIds() async {
    try {
      await _ensureInitialized();
      return _box!.keys.cast<String>().toList();
    } catch (e) {
      debugPrint('❌ Erro ao obter IDs das músicas baixadas: $e');
      return [];
    }
  }

  /// Verifica se uma música está baixada
  Future<bool> isDownloaded(String songId) async {
    try {
      await _ensureInitialized();
      return _box!.containsKey(songId);
    } catch (e) {
      return false;
    }
  }

  /// Limpa todas as músicas baixadas
  Future<void> clearAll() async {
    try {
      await _ensureInitialized();
      await _box!.clear();
      debugPrint('🗑️ Todas as músicas baixadas foram removidas');
    } catch (e) {
      debugPrint('❌ Erro ao limpar músicas baixadas: $e');
    }
  }
}

