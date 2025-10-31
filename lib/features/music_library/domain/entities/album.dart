class Album {
  final int id;
  final String title;
  final String artistName;
  final String imageUrl;
  final int songsCount;
  final DateTime releaseDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Album({
    required this.id,
    required this.title,
    required this.artistName,
    required this.imageUrl,
    required this.songsCount,
    required this.releaseDate,
    required this.createdAt,
    required this.updatedAt,
  });

  Album copyWith({
    int? id,
    String? title,
    String? artistName,
    String? imageUrl,
    int? songsCount,
    DateTime? releaseDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Album(
      id: id ?? this.id,
      title: title ?? this.title,
      artistName: artistName ?? this.artistName,
      imageUrl: imageUrl ?? this.imageUrl,
      songsCount: songsCount ?? this.songsCount,
      releaseDate: releaseDate ?? this.releaseDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Album && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Album(id: $id, title: $title, artistName: $artistName, songsCount: $songsCount)';
  }
}

