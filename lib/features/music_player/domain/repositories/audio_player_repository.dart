import '../../../../core/utils/result.dart';
import '../../../../features/music_library/domain/entities/song.dart';
import 'dart:async';
abstract class AudioPlayerRepository {
  Future<Result<void>> playSong(Song song);
  Future<Result<void>> pause();
  Future<Result<void>> resume();
  Future<Result<void>> stop();
  Future<Result<void>> next();
  Future<Result<void>> previous();
  Future<Result<void>> seekTo(Duration position);
  Future<Result<void>> togglePlayPause();
  Future<Result<Song?>> getCurrentSong();
  Future<Result<Duration>> getCurrentPosition();
  Future<Result<Duration>> getDuration();
  Future<Result<double>> getProgress();
  Future<Result<bool>> isPlaying();
  Future<Result<void>> setPlaylist(List<Song> songs, {int startIndex = 0});
  Future<Result<void>> addToQueue(Song song);
  Future<Result<void>> clearQueue();
  Stream<Song?> get currentSongStream;
  Stream<bool> get isPlayingStream;
  Stream<Duration> get positionStream;
  Stream<Duration> get durationStream;
  Stream<double> get progressStream;
}
