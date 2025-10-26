import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/playlist.dart';
import 'song_model.dart';
part 'playlist_model.g.dart';
@JsonSerializable(explicitToJson: true)
class PlaylistModel {
  final int id;
  final String name;
  final String cover;
  @JsonKey(name: 'musics_count')
  final int musicsCount;
  @JsonKey(name: 'musics_data')
  final List<SongModel> musicsData;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'is_active')
  final bool isActive;
  const PlaylistModel({
    required this.id,
    required this.name,
    required this.cover,
    required this.musicsCount,
    required this.musicsData,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });
  factory PlaylistModel.fromJson(Map<String, dynamic> json) => _$PlaylistModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistModelToJson(this);
  Playlist toEntity() {
    return Playlist(
      id: id,
      name: name,
      cover: cover,
      musicsCount: musicsCount,
      musicsData: musicsData.map((song) => song.toEntity()).toList(),
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      isActive: isActive,
    );
  }
  factory PlaylistModel.fromEntity(Playlist entity) {
    return PlaylistModel(
      id: entity.id,
      name: entity.name,
      cover: entity.cover,
      musicsCount: entity.musicsCount,
      musicsData: entity.musicsData.map((song) => SongModel.fromEntity(song)).toList(),
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      isActive: entity.isActive,
    );
  }
}
