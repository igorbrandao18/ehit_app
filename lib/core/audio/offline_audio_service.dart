// core/audio/offline_audio_service.dart

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../utils/result.dart';
import '../errors/failures.dart';
import '../supabase/supabase_storage_service.dart';
import '../../features/music_library/domain/entities/song.dart';

/// Serviço para gerenciar downloads de áudio offline
class OfflineAudioService {
  static final OfflineAudioService _instance = OfflineAudioService._internal();
  factory OfflineAudioService() => _instance;
  OfflineAudioService._internal();

  final Dio _dio = Dio();
  final SupabaseStorageService _storageService = SupabaseStorageService();
  final Map<String, StreamController<double>> _downloadProgress = {};
  final Map<String, CancelToken> _downloadCancelTokens = {};

  /// Diretório onde os arquivos offline são armazenados
  Directory? _offlineDirectory;

  /// Inicializa o serviço
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

  /// Baixa uma música para modo offline
  Future<Result<void>> downloadSong(Song song) async {
    try {
      if (_offlineDirectory == null) {
        await initialize();
      }

      final fileName = '${song.id}.mp3';
      final filePath = '${_offlineDirectory!.path}/$fileName';
      final file = File(filePath);

      // Verifica se já existe
      if (await file.exists()) {
        return const Success(null);
      }

      // Cria stream de progresso
      final progressController = StreamController<double>();
      _downloadProgress[song.id] = progressController;

      // Cria token de cancelamento
      final cancelToken = CancelToken();
      _downloadCancelTokens[song.id] = cancelToken;

      try {
        // Tenta baixar do Supabase Storage primeiro
        final storageResult = await _storageService.downloadAudioFile(song.audioUrl);
        
        if (storageResult is Success) {
          // Salva o arquivo localmente
          await file.writeAsBytes(storageResult.data);
          progressController.add(1.0);
          progressController.close();
          _downloadProgress.remove(song.id);
          _downloadCancelTokens.remove(song.id);
          
          return const Success(null);
        } else {
          // Fallback para download direto da URL
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
        }

        // Download concluído
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

  /// Cancela o download de uma música
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

  /// Verifica se uma música está disponível offline
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

  /// Obtém o caminho local de uma música offline
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

  /// Remove uma música do armazenamento offline
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

  /// Obtém o progresso de download de uma música
  Stream<double>? getDownloadProgress(String songId) {
    return _downloadProgress[songId]?.stream;
  }

  /// Verifica se uma música está sendo baixada
  bool isDownloading(String songId) {
    return _downloadProgress.containsKey(songId);
  }

  /// Obtém todas as músicas disponíveis offline
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

  /// Obtém o tamanho total do armazenamento offline
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

  /// Limpa todo o armazenamento offline
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

  /// Libera recursos
  void dispose() {
    for (final controller in _downloadProgress.values) {
      controller.close();
    }
    _downloadProgress.clear();
    _downloadCancelTokens.clear();
  }
}
