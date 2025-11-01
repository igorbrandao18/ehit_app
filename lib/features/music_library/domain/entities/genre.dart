class Genre {
  final int id;
  final String name;
  final String? imageUrl;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Genre({
    required this.id,
    required this.name,
    this.imageUrl,
    this.description,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  Genre copyWith({
    int? id,
    String? name,
    String? imageUrl,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Genre(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Genre && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Genre(id: $id, name: $name, imageUrl: $imageUrl)';
  }
}

