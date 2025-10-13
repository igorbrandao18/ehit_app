// features/music_library/presentation/controllers/artist_detail_controller.dart

import 'package:flutter/foundation.dart';
import '../../domain/entities/artist.dart';
import '../../domain/entities/song.dart';

/// Controller responsável por gerenciar o estado da página de detalhes do artista
class ArtistDetailController extends ChangeNotifier {
  bool _isLoading = true;
  String? _error;
  Artist? _artist;
  List<Song> _songs = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  Artist? get artist => _artist;
  List<Song> get songs => _songs;
  bool get hasData => _artist != null && _songs.isNotEmpty;

  /// Carrega os dados do artista
  Future<void> loadArtistData(String artistId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Debug: verificar qual artistId está chegando
      debugPrint('ArtistDetailController: Loading artist with ID: $artistId');

      // Simula delay de carregamento
      await Future.delayed(const Duration(milliseconds: 800));

      // Busca dados mockados
      _artist = _getMockArtist(artistId);
      _songs = _getMockSongs(_artist?.name ?? 'Artista Desconhecido');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar dados do artista: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Busca artista mockado baseado no ID
  Artist? _getMockArtist(String artistId) {
    debugPrint('ArtistDetailController: Looking for artist with ID: $artistId');
    
    // Mock de artistas com IDs numéricos simples
    final mockArtists = {
      '1': Artist(
        id: '1',
        name: 'Marília Mendonça',
        imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
        bio: 'Cantora e compositora brasileira de música sertaneja, conhecida como a "Rainha da Sofrência".',
        totalSongs: 78,
        totalDuration: '4h 32min',
        genres: ['Sertanejo', 'Sertanejo Universitário', 'MPB'],
        followers: 2500000,
      ),
      '2': Artist(
        id: '2',
        name: 'Zé Neto & Cristiano',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        bio: 'Dupla sertaneja brasileira formada por Zé Neto e Cristiano, uma das mais populares do país.',
        totalSongs: 95,
        totalDuration: '5h 15min',
        genres: ['Sertanejo', 'Sertanejo Universitário'],
        followers: 1800000,
      ),
      '3': Artist(
        id: '3',
        name: 'Cristiano Araújo',
        imageUrl: 'https://images.unsplash.com/photo-1471478331149-c72f17e33c73?w=400',
        bio: 'Cantor e compositor brasileiro de música sertaneja, conhecido por suas baladas românticas.',
        totalSongs: 67,
        totalDuration: '3h 45min',
        genres: ['Sertanejo', 'Sertanejo Romântico'],
        followers: 1200000,
      ),
      '4': Artist(
        id: '4',
        name: 'Ana Castela',
        imageUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400',
        bio: 'Cantora brasileira de música sertaneja, conhecida por hits como "Pipoco" e "Boiadeira".',
        totalSongs: 45,
        totalDuration: '2h 30min',
        genres: ['Sertanejo', 'Sertanejo Universitário', 'Piseiro'],
        followers: 800000,
      ),
    };

    // Buscar artista no mock pelo ID
    final artist = mockArtists[artistId];
    if (artist != null) {
      debugPrint('ArtistDetailController: Found artist in mock: ${artist.name}');
      debugPrint('ArtistDetailController: Artist imageUrl: ${artist.imageUrl}');
      return artist;
    }

    debugPrint('ArtistDetailController: Artist not found in mock, using default: $artistId');
    return _getDefaultArtist(artistId);
  }

  /// Retorna artista padrão quando não encontrado
  Artist _getDefaultArtist(String artistId) {
    final name = artistId.replaceAll('_', ' ').split(' ').map((word) {
      return word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : word;
    }).join(' ');

    // Mapear artistId para imagem correta baseado no nome
    String imageUrl = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'; // Default
    
    if (artistId.contains('marilia') || artistId.contains('mendonca')) {
      imageUrl = 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400';
    } else if (artistId.contains('ze_neto') || artistId.contains('cristiano')) {
      imageUrl = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400';
    } else if (artistId.contains('ana_castela')) {
      imageUrl = 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400';
    }

    return Artist(
      id: artistId,
      name: name,
      imageUrl: imageUrl,
      bio: 'Artista brasileiro de música sertaneja.',
      totalSongs: 52,
      totalDuration: '2h 45min',
      genres: ['Sertanejo'],
      followers: 500000,
    );
  }

  /// Busca músicas mockadas do artista
  List<Song> _getMockSongs(String artistName) {
    final songs = <Song>[];
    final now = DateTime.now();
    
    // URLs de áudio reais do SoundHelix
    final audioUrls = [
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
    ];

    for (int i = 1; i <= 8; i++) {
      songs.add(Song(
        id: 'song_${artistName.toLowerCase().replaceAll(' ', '_')}_$i',
        title: 'Música $i',
        artist: artistName,
        album: 'Álbum ${(i % 3) + 1}',
        duration: '${3 + (i % 3)}:${(i * 7) % 60}',
        imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300',
        audioUrl: audioUrls[(i - 1) % audioUrls.length], // Usa URLs reais
        isExplicit: i % 4 == 0,
        releaseDate: now.subtract(Duration(days: i * 30)),
        playCount: 1000000 - (i * 50000),
        genre: 'Pop',
      ));
    }

    return songs;
  }

  /// Reproduz uma música
  void playSong(Song song) {
    // A reprodução será feita pelo AudioPlayerService via Provider
    debugPrint('Reproduzindo: ${song.title} - ${song.artist}');
  }

  /// Reproduz todas as músicas em ordem aleatória
  void shufflePlay() {
    // A reprodução será feita pelo AudioPlayerService via Provider
    debugPrint('Reproduzindo músicas em ordem aleatória');
  }

  /// Reproduz todas as músicas em loop
  void repeatPlay() {
    // A reprodução será feita pelo AudioPlayerService via Provider
    debugPrint('Reproduzindo músicas em loop');
  }

  @override
  void dispose() {
    super.dispose();
  }
}
