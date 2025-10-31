import 'package:flutter/foundation.dart';
import '../../domain/entities/artist.dart';
import '../../domain/entities/album.dart';
import '../../domain/usecases/get_artists_usecase.dart';
import '../../domain/usecases/get_albums_by_artist_usecase.dart';
import '../../../../core/utils/result.dart';
class ArtistDetailController extends ChangeNotifier {
  final GetArtistsUseCase _getArtistsUseCase;
  final GetAlbumsByArtistUseCase _getAlbumsByArtistUseCase;
  bool _isLoading = true;
  String? _error;
  Artist? _artist;
  List<Album> _albums = [];
  ArtistDetailController({
    required GetArtistsUseCase getArtistsUseCase,
    required GetAlbumsByArtistUseCase getAlbumsByArtistUseCase,
  }) : _getArtistsUseCase = getArtistsUseCase,
       _getAlbumsByArtistUseCase = getAlbumsByArtistUseCase;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Artist? get artist => _artist;
  List<Album> get albums => _albums;
  bool get hasData => _artist != null && _albums.isNotEmpty;
  Future<void> loadArtistData(String artistId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      debugPrint('ArtistDetailController: Loading artist with ID: $artistId');
      final artistsResult = await _getArtistsUseCase();
      artistsResult.when(
        success: (artists) {
          _artist = artists.where((a) => a.id.toString() == artistId).firstOrNull;
          if (_artist != null) {
            debugPrint('ArtistDetailController: Artist loaded: ${_artist!.name}');
          } else {
            _error = 'Artista não encontrado';
          }
        },
        error: (message, code) {
          _error = 'Erro ao carregar artista: $message';
          debugPrint('ArtistDetailController: Error loading artist: $message');
        },
      );
      if (_artist != null) {
        final albumsResult = await _getAlbumsByArtistUseCase(_artist!.id);
        albumsResult.when(
          success: (albums) {
            _albums = albums;
            debugPrint('ArtistDetailController: Albums loaded: ${_albums.length} albums');
          },
          error: (message, code) {
            _error = 'Erro ao carregar álbuns: $message';
            debugPrint('ArtistDetailController: Error loading albums: $message');
          },
        );
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar dados do artista: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
  @override
  void dispose() {
    super.dispose();
  }
}
