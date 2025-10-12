// features/music_library/domain/entities/song.dart

/// Entidade que representa uma música
class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String duration;
  final String imageUrl;
  final String audioUrl;
  final bool isExplicit;
  final DateTime releaseDate;
  final int playCount;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.imageUrl,
    required this.audioUrl,
    required this.isExplicit,
    required this.releaseDate,
    required this.playCount,
  });

  /// Cria uma cópia da música com campos modificados
  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? duration,
    String? imageUrl,
    String? audioUrl,
    bool? isExplicit,
    DateTime? releaseDate,
    int? playCount,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      isExplicit: isExplicit ?? this.isExplicit,
      releaseDate: releaseDate ?? this.releaseDate,
      playCount: playCount ?? this.playCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Song && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Song(id: $id, title: $title, artist: $artist, duration: $duration)';
  }
}
