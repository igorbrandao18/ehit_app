// features/music_player/domain/repositories/audio_player_repository.dart

import '../../../../core/utils/result.dart';
import '../entities/audio_state.dart';
import '../../../music_library/domain/entities/song.dart';

/// Interface para operações do player de áudio
abstract class AudioPlayerRepository {
  /// Inicializa o player
  Future<Result<void>> initialize();
  
  /// Libera recursos do player
  Future<Result<void>> dispose();
  
  /// Toca uma música específica
  Future<Result<void>> playSong(Song song);
  
  /// Toca uma lista de músicas
  Future<Result<void>> playQueue(List<Song> songs, {int startIndex = 0});
  
  /// Pausa a reprodução
  Future<Result<void>> pause();
  
  /// Resume a reprodução
  Future<Result<void>> resume();
  
  /// Para a reprodução
  Future<Result<void>> stop();
  
  /// Vai para a próxima música
  Future<Result<void>> next();
  
  /// Vai para a música anterior
  Future<Result<void>> previous();
  
  /// Define a posição da música
  Future<Result<void>> seekTo(Duration position);
  
  /// Define o volume (0.0 a 1.0)
  Future<Result<void>> setVolume(double volume);
  
  /// Liga/desliga o mute
  Future<Result<void>> setMuted(bool muted);
  
  /// Ativa/desativa o modo shuffle
  Future<Result<void>> setShuffled(bool shuffled);
  
  /// Define o modo de repetição
  Future<Result<void>> setRepeatMode(RepeatMode repeatMode);
  
  /// Obtém o estado atual do player
  Future<Result<AudioState>> getCurrentState();
  
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
  
  /// Verifica se está em modo shuffle
  Future<Result<bool>> isShuffled();
  
  /// Obtém o modo de repetição atual
  Future<Result<RepeatMode>> getRepeatMode();
  
  /// Adiciona música à fila
  Future<Result<void>> addToQueue(Song song);
  
  /// Remove música da fila
  Future<Result<void>> removeFromQueue(int index);
  
  /// Limpa a fila
  Future<Result<void>> clearQueue();
  
  /// Obtém a fila atual
  Future<Result<List<Song>>> getQueue();
  
  /// Obtém o índice atual na fila
  Future<Result<int>> getCurrentIndex();
  
  /// Define o índice atual na fila
  Future<Result<void>> setCurrentIndex(int index);
  
  /// Obtém a música atual
  Future<Result<Song?>> getCurrentSong();
  
  /// Obtém a próxima música
  Future<Result<Song?>> getNextSong();
  
  /// Obtém a música anterior
  Future<Result<Song?>> getPreviousSong();
  
  /// Verifica se pode ir para a próxima música
  Future<Result<bool>> canGoNext();
  
  /// Verifica se pode ir para a música anterior
  Future<Result<bool>> canGoPrevious();
  
  /// Obtém o progresso da música (0.0 a 1.0)
  Future<Result<double>> getProgress();
  
  /// Verifica se há erro
  Future<Result<bool>> hasError();
  
  /// Obtém a mensagem de erro
  Future<Result<String?>> getErrorMessage();
  
  /// Limpa o erro
  Future<Result<void>> clearError();
  
  /// Verifica se está em modo offline
  Future<Result<bool>> isOfflineMode();
  
  /// Define o modo offline
  Future<Result<void>> setOfflineMode(bool offline);
  
  /// Obtém informações de metadados da música atual
  Future<Result<Map<String, dynamic>>> getCurrentSongMetadata();
  
  /// Obtém informações de metadados de uma música específica
  Future<Result<Map<String, dynamic>>> getSongMetadata(Song song);
  
  /// Verifica se uma música está disponível offline
  Future<Result<bool>> isSongAvailableOffline(Song song);
  
  /// Obtém o caminho local de uma música offline
  Future<Result<String?>> getOfflineSongPath(Song song);
  
  /// Obtém estatísticas de reprodução
  Future<Result<Map<String, dynamic>>> getPlaybackStats();
  
  /// Salva estatísticas de reprodução
  Future<Result<void>> savePlaybackStats(Map<String, dynamic> stats);
}
