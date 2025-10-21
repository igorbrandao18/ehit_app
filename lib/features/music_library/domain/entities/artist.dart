// features/music_library/domain/entities/artist.dart

/// Entidade que representa um artista musical
class Artist {
  final int id;
  final String name;
  final String imageUrl;
  final String genre;
  final int albumsCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.genre,
    required this.albumsCount,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria uma cópia do artista com campos modificados
  Artist copyWith({
    int? id,
    String? name,
    String? imageUrl,
    String? genre,
    int? albumsCount,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Artist(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      genre: genre ?? this.genre,
      albumsCount: albumsCount ?? this.albumsCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    return 'Artist(id: $id, name: $name, genre: $genre, albumsCount: $albumsCount)';
  }
}
