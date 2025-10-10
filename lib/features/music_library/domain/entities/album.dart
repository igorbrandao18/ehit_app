// features/music_library/domain/entities/album.dart
class Album {
  final String id;
  final String title;
  final String artist;
  final String albumArtUrl;
  final DateTime releaseDate;
  final List<String> genres;
  final int trackCount;
  final Duration totalDuration;
  final bool isExplicit;
  
  const Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumArtUrl,
    required this.releaseDate,
    this.genres = const [],
    required this.trackCount,
    required this.totalDuration,
    this.isExplicit = false,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Album && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() {
    return 'Album(id: $id, title: $title, artist: $artist)';
  }
}
