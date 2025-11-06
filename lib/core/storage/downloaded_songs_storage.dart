import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/music_library/domain/entities/song.dart';
import '../../features/music_library/data/models/song_model.dart';

class DownloadedSongsStorage {
  static const String _boxName = 'downloaded_songs_box';
  Box? _box; 

  DownloadedSongsStorage();

  Future<void> init() async {
    try {
      if (Hive.isBoxOpen(_boxName)) {
        _box = Hive.box(_boxName);
        return;
      }
      
      _box = await Hive.openBox(_boxName);
    } catch (e) {
      debugPrint('❌ Erro ao inicializar box do Hive: $e');
      try {
        try {
          await Hive.initFlutter();
        } catch (_) {
        }
        _box = await Hive.openBox(_boxName);
      } catch (e2) {
        debugPrint('❌ Erro ao reinicializar Hive: $e2');
        rethrow;
      }
    }
  }

  Future<void> _ensureInitialized() async {
    if (_box == null || !_box!.isOpen) {
      await init();
    }
  }

  Future<void> addDownloadedSong(Song song) async {
    try {
      await _ensureInitialized();
      
      if (song.duration.isEmpty || song.duration == '0:00') {
        debugPrint('⚠️ ATENÇÃO: Duração vazia/inválida ao salvar: ${song.title} - valor: "${song.duration}"');
      }
      
      final songModel = SongModel.fromEntity(song);
      final songMap = songModel.toMap();
      
      if (!songMap.containsKey('duration') || songMap['duration'] == null || songMap['duration'].toString().isEmpty) {
        debugPrint('⚠️ ATENÇÃO: Duração ausente no map ao salvar: ${song.title}');
      }
      
      await _box!.put(song.id, songMap);
      
      debugPrint('✅ Música ${song.id} (${song.title}) salva no Hive - Duração: ${song.duration}');
    } catch (e) {
      debugPrint('❌ Erro ao salvar música baixada: $e');
    }
  }

  Future<void> removeDownloadedSong(String songId) async {
    try {
      await _ensureInitialized();
      await _box!.delete(songId);
      debugPrint('🗑️ Música $songId removida do Hive');
    } catch (e) {
      debugPrint('❌ Erro ao remover música baixada: $e');
    }
  }

  Future<List<Song>> getDownloadedSongs() async {
    try {
      await _ensureInitialized();
      
      final songs = _box!.values
          .map((songMap) {
            try {
              final map = Map<String, dynamic>.from(songMap);
              if (!map.containsKey('duration') || map['duration'] == null || map['duration'].toString().isEmpty) {
                debugPrint('⚠️ Duração ausente no Hive para música: ${map['title']} (ID: ${map['id']})');
              }
              return SongModel.fromMap(map).toEntity();
            } catch (e) {
              debugPrint('❌ Erro ao deserializar música do Hive: $e');
              debugPrint('   Dados: $songMap');
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

  Future<List<String>> getDownloadedSongIds() async {
    try {
      await _ensureInitialized();
      return _box!.keys.cast<String>().toList();
    } catch (e) {
      debugPrint('❌ Erro ao obter IDs das músicas baixadas: $e');
      return [];
    }
  }

  Future<bool> isDownloaded(String songId) async {
    try {
      await _ensureInitialized();
      return _box!.containsKey(songId);
    } catch (e) {
      return false;
    }
  }

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

