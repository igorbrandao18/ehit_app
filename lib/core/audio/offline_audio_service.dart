import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../utils/result.dart';
import '../errors/failures.dart';
import '../../features/music_library/domain/entities/song.dart';
class OfflineAudioService {
  static final OfflineAudioService _instance = OfflineAudioService._internal();
  factory OfflineAudioService() => _instance;
  OfflineAudioService._internal();
  final Dio _dio = Dio();
  final Map<String, StreamController<double>> _downloadProgress = {};
  final Map<String, CancelToken> _downloadCancelTokens = {};
  Directory? _offlineDirectory;
  Future<Result<void>> initialize() async {
    try {
      _offlineDirectory = await getApplicationDocumentsDirectory();
      _offlineDirectory = Directory('${_offlineDirectory!.path}/offline_music');
      if (!await _offlineDirectory!.exists()) {
        await _offlineDirectory!.create(recursive: true);
      }
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao inicializar serviço offline: $e',
      );
    }
  }
  Future<Result<void>> downloadSong(Song song) async {
    try {
      if (_offlineDirectory == null) {
        await initialize();
      }
      final fileName = '${song.id}.mp3';
      final filePath = '${_offlineDirectory!.path}/$fileName';
      final file = File(filePath);
      if (await file.exists()) {
        return const Success(null);
      }
      final progressController = StreamController<double>();
      _downloadProgress[song.id] = progressController;
      final cancelToken = CancelToken();
      _downloadCancelTokens[song.id] = cancelToken;
      try {
        await _dio.download(
          song.audioUrl,
          filePath,
          cancelToken: cancelToken,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              final progress = received / total;
              progressController.add(progress);
            }
          },
        );
        progressController.add(1.0);
        progressController.close();
        _downloadProgress.remove(song.id);
        _downloadCancelTokens.remove(song.id);
        return const Success(null);
      } catch (e) {
        progressController.close();
        _downloadProgress.remove(song.id);
        _downloadCancelTokens.remove(song.id);
        if (e is DioException && e.type == DioExceptionType.cancel) {
          return Error<void>(
            message: 'Download cancelado',
          );
        }
        throw e;
      }
    } catch (e) {
      return Error<void>(
        message: 'Erro ao baixar música: $e',
      );
    }
  }
  Future<Result<void>> cancelDownload(String songId) async {
    try {
      final cancelToken = _downloadCancelTokens[songId];
      if (cancelToken != null && !cancelToken.isCancelled) {
        cancelToken.cancel();
      }
      final progressController = _downloadProgress[songId];
      if (progressController != null) {
        progressController.close();
      }
      _downloadProgress.remove(songId);
      _downloadCancelTokens.remove(songId);
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao cancelar download: $e',
      );
    }
  }
  Future<Result<bool>> isSongAvailableOffline(Song song) async {
    try {
      if (_offlineDirectory == null) {
        await initialize();
      }
      final fileName = '${song.id}.mp3';
      final filePath = '${_offlineDirectory!.path}/$fileName';
      final file = File(filePath);
      return Success(await file.exists());
    } catch (e) {
      return Error<bool>(
        message: 'Erro ao verificar disponibilidade offline: $e',
      );
    }
  }
  Future<Result<String?>> getOfflineSongPath(Song song) async {
    try {
      if (_offlineDirectory == null) {
        await initialize();
      }
      final fileName = '${song.id}.mp3';
      final filePath = '${_offlineDirectory!.path}/$fileName';
      final file = File(filePath);
      if (await file.exists()) {
        return Success(filePath);
      } else {
        return const Success(null);
      }
    } catch (e) {
      return Error<String?>(
        message: 'Erro ao obter caminho offline: $e',
      );
    }
  }
  Future<Result<void>> removeOfflineSong(Song song) async {
    try {
      if (_offlineDirectory == null) {
        await initialize();
      }
      final fileName = '${song.id}.mp3';
      final filePath = '${_offlineDirectory!.path}/$fileName';
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao remover música offline: $e',
      );
    }
  }
  Stream<double>? getDownloadProgress(String songId) {
    return _downloadProgress[songId]?.stream;
  }
  bool isDownloading(String songId) {
    return _downloadProgress.containsKey(songId);
  }
  Future<Result<List<String>>> getOfflineSongIds() async {
    try {
      if (_offlineDirectory == null) {
        await initialize();
      }
      final files = await _offlineDirectory!.list().toList();
      final songIds = files
          .where((file) => file.path.endsWith('.mp3'))
          .map((file) => file.path.split('/').last.replaceAll('.mp3', ''))
          .toList();
      return Success(songIds);
    } catch (e) {
      return Error<List<String>>(
        message: 'Erro ao obter músicas offline: $e',
      );
    }
  }
  Future<Result<int>> getOfflineStorageSize() async {
    try {
      if (_offlineDirectory == null) {
        await initialize();
      }
      int totalSize = 0;
      final files = await _offlineDirectory!.list().toList();
      for (final file in files) {
        if (file is File && file.path.endsWith('.mp3')) {
          totalSize += await file.length();
        }
      }
      return Success(totalSize);
    } catch (e) {
      return Error<int>(
        message: 'Erro ao obter tamanho do armazenamento offline: $e',
      );
    }
  }
  Future<Result<void>> clearOfflineStorage() async {
    try {
      if (_offlineDirectory == null) {
        await initialize();
      }
      final files = await _offlineDirectory!.list().toList();
      for (final file in files) {
        if (file is File && file.path.endsWith('.mp3')) {
          await file.delete();
        }
      }
      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Erro ao limpar armazenamento offline: $e',
      );
    }
  }
  void dispose() {
    for (final controller in _downloadProgress.values) {
      controller.close();
    }
    _downloadProgress.clear();
    _downloadCancelTokens.clear();
  }
}
