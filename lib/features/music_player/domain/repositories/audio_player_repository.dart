// features/music_player/domain/repositories/audio_player_repository.dart

import '../../../../core/utils/result.dart';
import '../../../../features/music_library/domain/entities/song.dart';
import 'dart:async';

/// Repository interface for audio player operations
/// Follows Clean Architecture - Domain Layer
abstract class AudioPlayerRepository {
  /// Play a specific song
  Future<Result<void>> playSong(Song song);
  
  /// Pause current playback
  Future<Result<void>> pause();
  
  /// Resume current playback
  Future<Result<void>> resume();
  
  /// Stop current playback
  Future<Result<void>> stop();
  
  /// Play next song in queue
  Future<Result<void>> next();
  
  /// Play previous song in queue
  Future<Result<void>> previous();
  
  /// Seek to specific position
  Future<Result<void>> seekTo(Duration position);
  
  /// Toggle play/pause
  Future<Result<void>> togglePlayPause();
  
  /// Get current playing song
  Future<Result<Song?>> getCurrentSong();
  
  /// Get current playback position
  Future<Result<Duration>> getCurrentPosition();
  
  /// Get current playback duration
  Future<Result<Duration>> getDuration();
  
  /// Get playback progress (0.0 to 1.0)
  Future<Result<double>> getProgress();
  
  /// Check if currently playing
  Future<Result<bool>> isPlaying();
  
  /// Set playlist
  Future<Result<void>> setPlaylist(List<Song> songs, {int startIndex = 0});
  
  /// Add song to queue
  Future<Result<void>> addToQueue(Song song);
  
  /// Clear queue
  Future<Result<void>> clearQueue();
  
  // Streams for real-time updates
  Stream<Song?> get currentSongStream;
  Stream<bool> get isPlayingStream;
  Stream<Duration> get positionStream;
  Stream<Duration> get durationStream;
  Stream<double> get progressStream;
}