// core/supabase/supabase_storage_service.dart

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/result.dart';
import '../errors/failures.dart';
import '../constants/app_config.dart';
import 'supabase_config.dart';

/// Supabase-based storage service for files
class SupabaseStorageService {
  static final SupabaseStorageService _instance = SupabaseStorageService._internal();
  factory SupabaseStorageService() => _instance;
  SupabaseStorageService._internal();

  /// Upload audio file
  Future<Result<String>> uploadAudioFile({
    required File file,
    required String fileName,
    String? folder,
  }) async {
    try {
      final path = folder != null ? '$folder/$fileName' : fileName;
      
      await SupabaseConfig.client.storage
          .from(AppConfig.audioStorageBucket)
          .upload(path, file);

      final publicUrl = SupabaseConfig.client.storage
          .from(AppConfig.audioStorageBucket)
          .getPublicUrl(path);

      return Success(publicUrl);
    } catch (e) {
      return Error<String>(
        message: 'Error uploading audio file: $e',
      );
    }
  }

  /// Upload image file
  Future<Result<String>> uploadImageFile({
    required File file,
    required String fileName,
    String? folder,
  }) async {
    try {
      final path = folder != null ? '$folder/$fileName' : fileName;
      
      await SupabaseConfig.client.storage
          .from(AppConfig.imageStorageBucket)
          .upload(path, file);

      final publicUrl = SupabaseConfig.client.storage
          .from(AppConfig.imageStorageBucket)
          .getPublicUrl(path);

      return Success(publicUrl);
    } catch (e) {
      return Error<String>(
        message: 'Error uploading image file: $e',
      );
    }
  }

  /// Upload profile image
  Future<Result<String>> uploadProfileImage({
    required File file,
    required String userId,
  }) async {
    try {
      final fileName = 'profile_$userId.jpg';
      final path = 'profiles/$fileName';
      
      await SupabaseConfig.client.storage
          .from(AppConfig.profileImageBucket)
          .upload(path, file);

      final publicUrl = SupabaseConfig.client.storage
          .from(AppConfig.profileImageBucket)
          .getPublicUrl(path);

      return Success(publicUrl);
    } catch (e) {
      return Error<String>(
        message: 'Error uploading profile image: $e',
      );
    }
  }

  /// Upload album cover
  Future<Result<String>> uploadAlbumCover({
    required File file,
    required String albumId,
  }) async {
    try {
      final fileName = 'album_$albumId.jpg';
      final path = 'albums/$fileName';
      
      await SupabaseConfig.client.storage
          .from(AppConfig.imageStorageBucket)
          .upload(path, file);

      final publicUrl = SupabaseConfig.client.storage
          .from(AppConfig.imageStorageBucket)
          .getPublicUrl(path);

      return Success(publicUrl);
    } catch (e) {
      return Error<String>(
        message: 'Error uploading album cover: $e',
      );
    }
  }

  /// Upload artist image
  Future<Result<String>> uploadArtistImage({
    required File file,
    required String artistId,
  }) async {
    try {
      final fileName = 'artist_$artistId.jpg';
      final path = 'artists/$fileName';
      
      await SupabaseConfig.client.storage
          .from(AppConfig.imageStorageBucket)
          .upload(path, file);

      final publicUrl = SupabaseConfig.client.storage
          .from(AppConfig.imageStorageBucket)
          .getPublicUrl(path);

      return Success(publicUrl);
    } catch (e) {
      return Error<String>(
        message: 'Error uploading artist image: $e',
      );
    }
  }

  /// Upload playlist cover
  Future<Result<String>> uploadPlaylistCover({
    required File file,
    required String playlistId,
  }) async {
    try {
      final fileName = 'playlist_$playlistId.jpg';
      final path = 'playlists/$fileName';
      
      await SupabaseConfig.client.storage
          .from(AppConfig.imageStorageBucket)
          .upload(path, file);

      final publicUrl = SupabaseConfig.client.storage
          .from(AppConfig.imageStorageBucket)
          .getPublicUrl(path);

      return Success(publicUrl);
    } catch (e) {
      return Error<String>(
        message: 'Error uploading playlist cover: $e',
      );
    }
  }

  /// Delete file
  Future<Result<void>> deleteFile({
    required String bucket,
    required String path,
  }) async {
    try {
      await SupabaseConfig.client.storage
          .from(bucket)
          .remove([path]);

      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error deleting file: $e',
      );
    }
  }

  /// Delete audio file
  Future<Result<void>> deleteAudioFile(String path) async {
    try {
      await SupabaseConfig.client.storage
          .from(AppConfig.audioStorageBucket)
          .remove([path]);

      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error deleting audio file: $e',
      );
    }
  }

  /// Delete image file
  Future<Result<void>> deleteImageFile(String path) async {
    try {
      await SupabaseConfig.client.storage
          .from(AppConfig.imageStorageBucket)
          .remove([path]);

      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error deleting image file: $e',
      );
    }
  }

  /// Delete profile image
  Future<Result<void>> deleteProfileImage(String userId) async {
    try {
      final fileName = 'profile_$userId.jpg';
      final path = 'profiles/$fileName';
      
      await SupabaseConfig.client.storage
          .from(AppConfig.profileImageBucket)
          .remove([path]);

      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error deleting profile image: $e',
      );
    }
  }

  /// Get file URL
  Future<Result<String>> getFileUrl({
    required String bucket,
    required String path,
  }) async {
    try {
      final publicUrl = SupabaseConfig.client.storage
          .from(bucket)
          .getPublicUrl(path);

      return Success(publicUrl);
    } catch (e) {
      return Error<String>(
        message: 'Error getting file URL: $e',
      );
    }
  }

  /// Get signed URL for private file
  Future<Result<String>> getSignedUrl({
    required String bucket,
    required String path,
    int expiresIn = 3600, // 1 hour
  }) async {
    try {
      final signedUrl = await SupabaseConfig.client.storage
          .from(bucket)
          .createSignedUrl(path, expiresIn);

      return Success(signedUrl);
    } catch (e) {
      return Error<String>(
        message: 'Error getting signed URL: $e',
      );
    }
  }

  /// List files in bucket
  Future<Result<List<String>>> listFiles({
    required String bucket,
    String? folder,
  }) async {
    try {
      final files = await SupabaseConfig.client.storage
          .from(bucket)
          .list(path: folder);

      final fileNames = files.map((file) => file['name'] as String).toList();
      return Success(fileNames);
    } catch (e) {
      return Error<List<String>>(
        message: 'Error listing files: $e',
      );
    }
  }

  /// Get file info
  Future<Result<Map<String, dynamic>>> getFileInfo({
    required String bucket,
    required String path,
  }) async {
    try {
      final files = await SupabaseConfig.client.storage
          .from(bucket)
          .list();

      final file = files.firstWhere(
        (file) => file['name'] == path,
        orElse: () => throw Exception('File not found'),
      );

      return Success(file);
    } catch (e) {
      return Error<Map<String, dynamic>>(
        message: 'Error getting file info: $e',
      );
    }
  }

  /// Download file
  Future<Result<List<int>>> downloadFile({
    required String bucket,
    required String path,
  }) async {
    try {
      final bytes = await SupabaseConfig.client.storage
          .from(bucket)
          .download(path);

      return Success(bytes);
    } catch (e) {
      return Error<List<int>>(
        message: 'Error downloading file: $e',
      );
    }
  }

  /// Download audio file
  Future<Result<List<int>>> downloadAudioFile(String path) async {
    try {
      final bytes = await SupabaseConfig.client.storage
          .from(AppConfig.audioStorageBucket)
          .download(path);

      return Success(bytes);
    } catch (e) {
      return Error<List<int>>(
        message: 'Error downloading audio file: $e',
      );
    }
  }

  /// Download image file
  Future<Result<List<int>>> downloadImageFile(String path) async {
    try {
      final bytes = await SupabaseConfig.client.storage
          .from(AppConfig.imageStorageBucket)
          .download(path);

      return Success(bytes);
    } catch (e) {
      return Error<List<int>>(
        message: 'Error downloading image file: $e',
      );
    }
  }

  /// Check if file exists
  Future<Result<bool>> fileExists({
    required String bucket,
    required String path,
  }) async {
    try {
      final files = await SupabaseConfig.client.storage
          .from(bucket)
          .list();

      final exists = files.any((file) => file['name'] == path);
      return Success(exists);
    } catch (e) {
      return Error<bool>(
        message: 'Error checking file existence: $e',
      );
    }
  }

  /// Get file size
  Future<Result<int>> getFileSize({
    required String bucket,
    required String path,
  }) async {
    try {
      final files = await SupabaseConfig.client.storage
          .from(bucket)
          .list();

      final file = files.firstWhere(
        (file) => file['name'] == path,
        orElse: () => throw Exception('File not found'),
      );

      final size = file['metadata']?['size'] as int? ?? 0;
      return Success(size);
    } catch (e) {
      return Error<int>(
        message: 'Error getting file size: $e',
      );
    }
  }

  /// Get file metadata
  Future<Result<Map<String, dynamic>>> getFileMetadata({
    required String bucket,
    required String path,
  }) async {
    try {
      final files = await SupabaseConfig.client.storage
          .from(bucket)
          .list();

      final file = files.firstWhere(
        (file) => file['name'] == path,
        orElse: () => throw Exception('File not found'),
      );

      final metadata = file['metadata'] as Map<String, dynamic>? ?? {};
      return Success(metadata);
    } catch (e) {
      return Error<Map<String, dynamic>>(
        message: 'Error getting file metadata: $e',
      );
    }
  }

  /// Copy file
  Future<Result<String>> copyFile({
    required String bucket,
    required String sourcePath,
    required String destinationPath,
  }) async {
    try {
      await SupabaseConfig.client.storage
          .from(bucket)
          .copy(sourcePath, destinationPath);

      final publicUrl = SupabaseConfig.client.storage
          .from(bucket)
          .getPublicUrl(destinationPath);

      return Success(publicUrl);
    } catch (e) {
      return Error<String>(
        message: 'Error copying file: $e',
      );
    }
  }

  /// Move file
  Future<Result<String>> moveFile({
    required String bucket,
    required String sourcePath,
    required String destinationPath,
  }) async {
    try {
      await SupabaseConfig.client.storage
          .from(bucket)
          .move(sourcePath, destinationPath);

      final publicUrl = SupabaseConfig.client.storage
          .from(bucket)
          .getPublicUrl(destinationPath);

      return Success(publicUrl);
    } catch (e) {
      return Error<String>(
        message: 'Error moving file: $e',
      );
    }
  }

  /// Create folder
  Future<Result<void>> createFolder({
    required String bucket,
    required String folderPath,
  }) async {
    try {
      // Create a placeholder file to create the folder
      final placeholderPath = '$folderPath/.keep';
      await SupabaseConfig.client.storage
          .from(bucket)
          .upload(placeholderPath, <int>[]);

      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error creating folder: $e',
      );
    }
  }

  /// Delete folder
  Future<Result<void>> deleteFolder({
    required String bucket,
    required String folderPath,
  }) async {
    try {
      final files = await SupabaseConfig.client.storage
          .from(bucket)
          .list(path: folderPath);

      final filePaths = files.map((file) => '$folderPath/${file['name']}').toList();
      
      if (filePaths.isNotEmpty) {
        await SupabaseConfig.client.storage
            .from(bucket)
            .remove(filePaths);
      }

      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error deleting folder: $e',
      );
    }
  }
}
