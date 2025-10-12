// features/music_player/presentation/controllers/playlist_controller.dart

import 'package:flutter/foundation.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/usecases/playlist_usecases.dart';
import '../../../../core/utils/result.dart';

/// Controller para gerenciar o estado das playlists
class PlaylistController extends ChangeNotifier {
  // Use Cases
  final GetUserPlaylistsUseCase _getUserPlaylistsUseCase;
  final GetPlaylistByIdUseCase _getPlaylistByIdUseCase;
  final GetPublicPlaylistsUseCase _getPublicPlaylistsUseCase;
  final GetPopularPlaylistsUseCase _getPopularPlaylistsUseCase;
  final SearchPlaylistsUseCase _searchPlaylistsUseCase;
  final CreatePlaylistUseCase _createPlaylistUseCase;
  final UpdatePlaylistUseCase _updatePlaylistUseCase;
  final DeletePlaylistUseCase _deletePlaylistUseCase;
  final AddSongToPlaylistUseCase _addSongToPlaylistUseCase;
  final RemoveSongFromPlaylistUseCase _removeSongFromPlaylistUseCase;
  final FollowPlaylistUseCase _followPlaylistUseCase;
  final UnfollowPlaylistUseCase _unfollowPlaylistUseCase;

  // State
  List<Playlist> _userPlaylists = [];
  List<Playlist> _publicPlaylists = [];
  List<Playlist> _popularPlaylists = [];
  List<Playlist> _searchResults = [];
  Playlist? _currentPlaylist;
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  // Getters
  List<Playlist> get userPlaylists => _userPlaylists;
  List<Playlist> get publicPlaylists => _publicPlaylists;
  List<Playlist> get popularPlaylists => _popularPlaylists;
  List<Playlist> get searchResults => _searchResults;
  Playlist? get currentPlaylist => _currentPlaylist;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  PlaylistController({
    required GetUserPlaylistsUseCase getUserPlaylistsUseCase,
    required GetPlaylistByIdUseCase getPlaylistByIdUseCase,
    required GetPublicPlaylistsUseCase getPublicPlaylistsUseCase,
    required GetPopularPlaylistsUseCase getPopularPlaylistsUseCase,
    required SearchPlaylistsUseCase searchPlaylistsUseCase,
    required CreatePlaylistUseCase createPlaylistUseCase,
    required UpdatePlaylistUseCase updatePlaylistUseCase,
    required DeletePlaylistUseCase deletePlaylistUseCase,
    required AddSongToPlaylistUseCase addSongToPlaylistUseCase,
    required RemoveSongFromPlaylistUseCase removeSongFromPlaylistUseCase,
    required FollowPlaylistUseCase followPlaylistUseCase,
    required UnfollowPlaylistUseCase unfollowPlaylistUseCase,
  }) : _getUserPlaylistsUseCase = getUserPlaylistsUseCase,
       _getPlaylistByIdUseCase = getPlaylistByIdUseCase,
       _getPublicPlaylistsUseCase = getPublicPlaylistsUseCase,
       _getPopularPlaylistsUseCase = getPopularPlaylistsUseCase,
       _searchPlaylistsUseCase = searchPlaylistsUseCase,
       _createPlaylistUseCase = createPlaylistUseCase,
       _updatePlaylistUseCase = updatePlaylistUseCase,
       _deletePlaylistUseCase = deletePlaylistUseCase,
       _addSongToPlaylistUseCase = addSongToPlaylistUseCase,
       _removeSongFromPlaylistUseCase = removeSongFromPlaylistUseCase,
       _followPlaylistUseCase = followPlaylistUseCase,
       _unfollowPlaylistUseCase = unfollowPlaylistUseCase;

  /// Inicializa o controller carregando dados iniciais
  Future<void> initialize() async {
    await Future.wait([
      loadUserPlaylists(),
      loadPublicPlaylists(),
      loadPopularPlaylists(),
    ]);
  }

  /// Carrega playlists do usuário
  Future<void> loadUserPlaylists() async {
    _setLoading(true);
    _clearError();

    final result = await _getUserPlaylistsUseCase();
    result.when(
      success: (playlists) {
        _userPlaylists = playlists;
        notifyListeners();
      },
      error: (message, code) {
        _setError('Erro ao carregar suas playlists: $message');
      },
    );

    _setLoading(false);
  }

  /// Carrega playlists públicas
  Future<void> loadPublicPlaylists() async {
    _setLoading(true);
    _clearError();

    final result = await _getPublicPlaylistsUseCase();
    result.when(
      success: (playlists) {
        _publicPlaylists = playlists;
        notifyListeners();
      },
      error: (message, code) {
        _setError('Erro ao carregar playlists públicas: $message');
      },
    );

    _setLoading(false);
  }

  /// Carrega playlists populares
  Future<void> loadPopularPlaylists() async {
    _setLoading(true);
    _clearError();

    final result = await _getPopularPlaylistsUseCase();
    result.when(
      success: (playlists) {
        _popularPlaylists = playlists;
        notifyListeners();
      },
      error: (message, code) {
        _setError('Erro ao carregar playlists populares: $message');
      },
    );

    _setLoading(false);
  }

  /// Carrega uma playlist específica por ID
  Future<void> loadPlaylistById(String playlistId) async {
    _setLoading(true);
    _clearError();

    final result = await _getPlaylistByIdUseCase(playlistId);
    result.when(
      success: (playlist) {
        _currentPlaylist = playlist;
        notifyListeners();
      },
      error: (message, code) {
        _setError('Erro ao carregar playlist: $message');
      },
    );

    _setLoading(false);
  }

  /// Busca playlists
  Future<void> searchPlaylists(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _searchQuery = '';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearError();
    _searchQuery = query;

    final result = await _searchPlaylistsUseCase(query);
    result.when(
      success: (playlists) {
        _searchResults = playlists;
        notifyListeners();
      },
      error: (message, code) {
        _setError('Erro ao buscar playlists: $message');
      },
    );

    _setLoading(false);
  }

  /// Cria uma nova playlist
  Future<bool> createPlaylist({
    required String name,
    required String description,
    required bool isPublic,
    required bool isCollaborative,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _createPlaylistUseCase(
      name: name,
      description: description,
      isPublic: isPublic,
      isCollaborative: isCollaborative,
    );

    bool success = false;
    result.when(
      success: (playlist) {
        _userPlaylists.insert(0, playlist); // Adiciona no início da lista
        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _setError('Erro ao criar playlist: $message');
      },
    );

    _setLoading(false);
    return success;
  }

  /// Atualiza uma playlist
  Future<bool> updatePlaylist({
    required String playlistId,
    String? name,
    String? description,
    bool? isPublic,
    bool? isCollaborative,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _updatePlaylistUseCase(
      playlistId: playlistId,
      name: name,
      description: description,
      isPublic: isPublic,
      isCollaborative: isCollaborative,
    );

    bool success = false;
    result.when(
      success: (updatedPlaylist) {
        // Atualiza na lista de playlists do usuário
        final index = _userPlaylists.indexWhere((p) => p.id == playlistId);
        if (index != -1) {
          _userPlaylists[index] = updatedPlaylist;
        }

        // Atualiza playlist atual se for a mesma
        if (_currentPlaylist?.id == playlistId) {
          _currentPlaylist = updatedPlaylist;
        }

        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _setError('Erro ao atualizar playlist: $message');
      },
    );

    _setLoading(false);
    return success;
  }

  /// Remove uma playlist
  Future<bool> deletePlaylist(String playlistId) async {
    _setLoading(true);
    _clearError();

    final result = await _deletePlaylistUseCase(playlistId);

    bool success = false;
    result.when(
      success: (_) {
        // Remove da lista de playlists do usuário
        _userPlaylists.removeWhere((p) => p.id == playlistId);

        // Limpa playlist atual se for a mesma
        if (_currentPlaylist?.id == playlistId) {
          _currentPlaylist = null;
        }

        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _setError('Erro ao remover playlist: $message');
      },
    );

    _setLoading(false);
    return success;
  }

  /// Adiciona música à playlist
  Future<bool> addSongToPlaylist(String playlistId, String songId) async {
    _setLoading(true);
    _clearError();

    final result = await _addSongToPlaylistUseCase(
      playlistId: playlistId,
      songId: songId,
    );

    bool success = false;
    result.when(
      success: (updatedPlaylist) {
        // Atualiza na lista de playlists do usuário
        final index = _userPlaylists.indexWhere((p) => p.id == playlistId);
        if (index != -1) {
          _userPlaylists[index] = updatedPlaylist;
        }

        // Atualiza playlist atual se for a mesma
        if (_currentPlaylist?.id == playlistId) {
          _currentPlaylist = updatedPlaylist;
        }

        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _setError('Erro ao adicionar música à playlist: $message');
      },
    );

    _setLoading(false);
    return success;
  }

  /// Remove música da playlist
  Future<bool> removeSongFromPlaylist(String playlistId, String songId) async {
    _setLoading(true);
    _clearError();

    final result = await _removeSongFromPlaylistUseCase(
      playlistId: playlistId,
      songId: songId,
    );

    bool success = false;
    result.when(
      success: (updatedPlaylist) {
        // Atualiza na lista de playlists do usuário
        final index = _userPlaylists.indexWhere((p) => p.id == playlistId);
        if (index != -1) {
          _userPlaylists[index] = updatedPlaylist;
        }

        // Atualiza playlist atual se for a mesma
        if (_currentPlaylist?.id == playlistId) {
          _currentPlaylist = updatedPlaylist;
        }

        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _setError('Erro ao remover música da playlist: $message');
      },
    );

    _setLoading(false);
    return success;
  }

  /// Segue uma playlist
  Future<bool> followPlaylist(String playlistId) async {
    _setLoading(true);
    _clearError();

    final result = await _followPlaylistUseCase(playlistId);

    bool success = false;
    result.when(
      success: (_) {
        // Atualiza playlist atual se for a mesma
        if (_currentPlaylist?.id == playlistId) {
          _currentPlaylist = _currentPlaylist!.copyWith(isFollowing: true);
        }

        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _setError('Erro ao seguir playlist: $message');
      },
    );

    _setLoading(false);
    return success;
  }

  /// Para de seguir uma playlist
  Future<bool> unfollowPlaylist(String playlistId) async {
    _setLoading(true);
    _clearError();

    final result = await _unfollowPlaylistUseCase(playlistId);

    bool success = false;
    result.when(
      success: (_) {
        // Atualiza playlist atual se for a mesma
        if (_currentPlaylist?.id == playlistId) {
          _currentPlaylist = _currentPlaylist!.copyWith(isFollowing: false);
        }

        success = true;
        notifyListeners();
      },
      error: (message, code) {
        _setError('Erro ao parar de seguir playlist: $message');
      },
    );

    _setLoading(false);
    return success;
  }

  /// Limpa os resultados de busca
  void clearSearchResults() {
    _searchResults = [];
    _searchQuery = '';
    notifyListeners();
  }

  /// Limpa a playlist atual
  void clearCurrentPlaylist() {
    _currentPlaylist = null;
    notifyListeners();
  }

  /// Limpa todos os dados
  void clearAll() {
    _userPlaylists = [];
    _publicPlaylists = [];
    _popularPlaylists = [];
    _searchResults = [];
    _currentPlaylist = null;
    _searchQuery = '';
    _clearError();
    notifyListeners();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
