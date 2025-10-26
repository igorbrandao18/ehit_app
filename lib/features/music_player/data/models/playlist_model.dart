import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/playlist.dart';
import '../../../music_library/domain/entities/song.dart';
import '../../../music_library/data/models/song_model.dart';
part 'playlist_model.g.dart';
@JsonSerializable()
class PlaylistModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String ownerId;
  final String ownerName;
  final bool isPublic;
  final bool isCollaborative;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime updatedAt;
  @JsonKey(fromJson: _songsFromJson, toJson: _songsToJson)
  final List<Song> songs;
  final int totalSongs;
  final String totalDuration;
  final int followersCount;
  final bool isFollowing;
  const PlaylistModel({
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
  static DateTime _dateTimeFromJson(String dateString) => DateTime.parse(dateString);
  static String _dateTimeToJson(DateTime dateTime) => dateTime.toIso8601String();
  static List<Song> _songsFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => SongModel.fromJson(json as Map<String, dynamic>)).toList();
  }
  static List<Map<String, dynamic>> _songsToJson(List<Song> songs) {
    return songs.map((song) => (song as SongModel).toJson()).toList();
  }
  factory PlaylistModel.fromJson(Map<String, dynamic> json) => 
      _$PlaylistModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistModelToJson(this);
  factory PlaylistModel.fromEntity(Playlist playlist) {
    return PlaylistModel(
      id: playlist.id,
      name: playlist.name,
      description: playlist.description,
      imageUrl: playlist.imageUrl,
      ownerId: playlist.ownerId,
      ownerName: playlist.ownerName,
      isPublic: playlist.isPublic,
      isCollaborative: playlist.isCollaborative,
      createdAt: playlist.createdAt,
      updatedAt: playlist.updatedAt,
      songs: playlist.songs,
      totalSongs: playlist.totalSongs,
      totalDuration: playlist.totalDuration,
      followersCount: playlist.followersCount,
      isFollowing: playlist.isFollowing,
    );
  }
  Playlist toEntity() {
    return Playlist(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      ownerId: ownerId,
      ownerName: ownerName,
      isPublic: isPublic,
      isCollaborative: isCollaborative,
      createdAt: createdAt,
      updatedAt: updatedAt,
      songs: songs,
      totalSongs: totalSongs,
      totalDuration: totalDuration,
      followersCount: followersCount,
      isFollowing: isFollowing,
    );
  }
  factory PlaylistModel.fromMap(Map<String, dynamic> map) {
    return PlaylistModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      ownerId: map['ownerId'] as String,
      ownerName: map['ownerName'] as String,
      isPublic: map['isPublic'] as bool,
      isCollaborative: map['isCollaborative'] as bool,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      songs: (map['songs'] as List<dynamic>?)
          ?.map((songJson) => SongModel.fromJson(songJson as Map<String, dynamic>))
          .toList() ?? [],
      totalSongs: map['totalSongs'] as int,
      totalDuration: map['totalDuration'] as String,
      followersCount: map['followersCount'] as int,
      isFollowing: map['isFollowing'] as bool,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'isPublic': isPublic,
      'isCollaborative': isCollaborative,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'songs': songs.map((song) => (song as SongModel).toJson()).toList(),
      'totalSongs': totalSongs,
      'totalDuration': totalDuration,
      'followersCount': followersCount,
      'isFollowing': isFollowing,
    };
  }
  PlaylistModel copyWith({
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
    return PlaylistModel(
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
  @override
  String toString() {
    return 'PlaylistModel(id: $id, name: $name, totalSongs: $totalSongs, isPublic: $isPublic)';
  }
}
