// features/music_player/data/datasources/audio_player_datasource.dart

import '../../../../core/utils/result.dart';
import '../../../music_library/domain/entities/song.dart';

/// Interface para data source de reprodução de áudio
abstract class AudioPlayerDataSource {
  /// Inicializa o player de áudio
  Future<Result<void>> initialize();
  
  /// Libera recursos do player
  Future<Result<void>> dispose();
  
  /// Toca uma música específica
  Future<Result<void>> playSong(Song song);
  
  /// Pausa a reprodução
  Future<Result<void>> pause();
  
  /// Resume a reprodução
  Future<Result<void>> resume();
  
  /// Para a reprodução
  Future<Result<void>> stop();
  
  /// Define a posição da música
  Future<Result<void>> seekTo(Duration position);
  
  /// Define o volume (0.0 a 1.0)
  Future<Result<void>> setVolume(double volume);
  
  /// Liga/desliga o mute
  Future<Result<void>> setMuted(bool muted);
  
  /// Obtém a posição atual
  Future<Result<Duration>> getCurrentPosition();
  
  /// Obtém a duração da música atual
  Future<Result<Duration>> getCurrentDuration();
  
  /// Verifica se está tocando
  Future<Result<bool>> isPlaying();
  
  /// Verifica se está pausado
  Future<Result<bool>> isPaused();
  
  /// Obtém o volume atual
  Future<Result<double>> getVolume();
  
  /// Verifica se está mutado
  Future<Result<bool>> isMuted();
  
  /// Stream do estado de reprodução
  Stream<bool> get playingStateStream;
  
  /// Stream da posição atual
  Stream<Duration> get positionStream;
  
  /// Stream da duração atual
  Stream<Duration?> get durationStream;
}
