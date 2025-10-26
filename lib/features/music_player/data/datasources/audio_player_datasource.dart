import '../../../../core/utils/result.dart';
import '../../../music_library/domain/entities/song.dart';
abstract class AudioPlayerDataSource {
  Future<Result<void>> initialize();
  Future<Result<void>> dispose();
  Future<Result<void>> playSong(Song song);
  Future<Result<void>> pause();
  Future<Result<void>> resume();
  Future<Result<void>> stop();
  Future<Result<void>> seekTo(Duration position);
  Future<Result<void>> setVolume(double volume);
  Future<Result<void>> setMuted(bool muted);
  Future<Result<Duration>> getCurrentPosition();
  Future<Result<Duration>> getCurrentDuration();
  Future<Result<bool>> isPlaying();
  Future<Result<bool>> isPaused();
  Future<Result<double>> getVolume();
  Future<Result<bool>> isMuted();
  Stream<bool> get playingStateStream;
  Stream<Duration> get positionStream;
  Stream<Duration?> get durationStream;
}
