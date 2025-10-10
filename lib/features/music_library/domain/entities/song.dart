// features/music_library/domain/entities/song.dart
class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String albumArtUrl;
  final Duration duration;
  final String audioUrl;
  final bool isExplicit;
  final DateTime releaseDate;
  final List<String> genres;
  
  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.albumArtUrl,
    required this.duration,
    required this.audioUrl,
    this.isExplicit = false,
    required this.releaseDate,
    this.genres = const [],
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Song && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() {
    return 'Song(id: $id, title: $title, artist: $artist)';
  }
}
