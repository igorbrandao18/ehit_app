// features/playlists/domain/entities/playlist.dart
class Playlist {
  final String id;
  final String name;
  final String description;
  final String coverImageUrl;
  final String ownerId;
  final String ownerName;
  final bool isPublic;
  final bool isCollaborative;
  final int trackCount;
  final Duration totalDuration;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> trackIds;
  
  const Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.coverImageUrl,
    required this.ownerId,
    required this.ownerName,
    this.isPublic = true,
    this.isCollaborative = false,
    required this.trackCount,
    required this.totalDuration,
    required this.createdAt,
    required this.updatedAt,
    this.trackIds = const [],
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Playlist && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() {
    return 'Playlist(id: $id, name: $name, owner: $ownerName)';
  }
}
