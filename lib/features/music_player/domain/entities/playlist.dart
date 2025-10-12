// features/music_player/domain/entities/playlist.dart

import 'package:equatable/equatable.dart';
import '../../../music_library/domain/entities/song.dart';

/// Entidade que representa uma playlist
class Playlist extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String ownerId;
  final String ownerName;
  final bool isPublic;
  final bool isCollaborative;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Song> songs;
  final int totalSongs;
  final String totalDuration;
  final int followersCount;
  final bool isFollowing;

  const Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.ownerId,
    required this.ownerName,
    required this.isPublic,
    required this.isCollaborative,
    required this.createdAt,
    required this.updatedAt,
    required this.songs,
    required this.totalSongs,
    required this.totalDuration,
    required this.followersCount,
    required this.isFollowing,
  });

  /// Cria uma cópia da playlist com campos modificados
  Playlist copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? ownerId,
    String? ownerName,
    bool? isPublic,
    bool? isCollaborative,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Song>? songs,
    int? totalSongs,
    String? totalDuration,
    int? followersCount,
    bool? isFollowing,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      isPublic: isPublic ?? this.isPublic,
      isCollaborative: isCollaborative ?? this.isCollaborative,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      songs: songs ?? this.songs,
      totalSongs: totalSongs ?? this.totalSongs,
      totalDuration: totalDuration ?? this.totalDuration,
      followersCount: followersCount ?? this.followersCount,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  /// Adiciona uma música à playlist
  Playlist addSong(Song song) {
    final updatedSongs = List<Song>.from(songs)..add(song);
    return copyWith(
      songs: updatedSongs,
      totalSongs: updatedSongs.length,
      updatedAt: DateTime.now(),
    );
  }

  /// Remove uma música da playlist
  Playlist removeSong(String songId) {
    final updatedSongs = songs.where((song) => song.id != songId).toList();
    return copyWith(
      songs: updatedSongs,
      totalSongs: updatedSongs.length,
      updatedAt: DateTime.now(),
    );
  }

  /// Reordena as músicas da playlist
  Playlist reorderSongs(int oldIndex, int newIndex) {
    final updatedSongs = List<Song>.from(songs);
    final song = updatedSongs.removeAt(oldIndex);
    updatedSongs.insert(newIndex, song);
    
    return copyWith(
      songs: updatedSongs,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        ownerId,
        ownerName,
        isPublic,
        isCollaborative,
        createdAt,
        updatedAt,
        songs,
        totalSongs,
        totalDuration,
        followersCount,
        isFollowing,
      ];

  @override
  String toString() {
    return 'Playlist(id: $id, name: $name, totalSongs: $totalSongs, isPublic: $isPublic)';
  }
}
