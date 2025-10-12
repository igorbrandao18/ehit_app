// features/music_library/domain/entities/artist.dart

/// Entidade que representa um artista musical
class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final String bio;
  final int totalSongs;
  final String totalDuration;
  final List<String> genres;
  final int followers;

  const Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.bio,
    required this.totalSongs,
    required this.totalDuration,
    required this.genres,
    required this.followers,
  });

  /// Cria uma cópia do artista com campos modificados
  Artist copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? bio,
    int? totalSongs,
    String? totalDuration,
    List<String>? genres,
    int? followers,
  }) {
    return Artist(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      bio: bio ?? this.bio,
      totalSongs: totalSongs ?? this.totalSongs,
      totalDuration: totalDuration ?? this.totalDuration,
      genres: genres ?? this.genres,
      followers: followers ?? this.followers,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Artist && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Artist(id: $id, name: $name, totalSongs: $totalSongs)';
  }
}
