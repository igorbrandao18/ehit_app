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
  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    // Converter id de forma segura
    final idValue = json['id'];
    final id = idValue is int 
        ? idValue 
        : (idValue is String ? int.tryParse(idValue) ?? 0 : 0);
    
    // Converter name de forma segura
    final nameValue = json['name'];
    final name = nameValue is String 
        ? nameValue 
        : (nameValue is int ? nameValue.toString() : 'Unknown Playlist');
    
    // Converter cover de forma segura
    final coverValue = json['cover'];
    final cover = coverValue is String
        ? coverValue
        : (coverValue is int ? coverValue.toString() : (coverValue ?? ''));
    
    // Converter musicsCount de forma segura
    final musicsCountValue = json['musics_count'];
    final musicsCount = musicsCountValue is int
        ? musicsCountValue
        : (musicsCountValue is String ? int.tryParse(musicsCountValue) ?? 0 : 0);
    
    // Converter musicsData de forma segura
    final musicsDataValue = json['musics_data'];
    final musicsData = musicsDataValue is List
        ? musicsDataValue
            .map((e) {
              try {
                return SongModel.fromJson(e as Map<String, dynamic>);
              } catch (e) {
                return null;
              }
            })
            .whereType<SongModel>()
            .toList()
        : <SongModel>[];
    
    // Converter datas de forma segura
    String convertDate(dynamic dateValue) {
      if (dateValue == null) return DateTime.now().toIso8601String();
      if (dateValue is String) {
        try {
          DateTime.parse(dateValue); // Validar formato
          return dateValue;
        } catch (e) {
          return DateTime.now().toIso8601String();
        }
      }
      if (dateValue is int) {
        // Pode ser timestamp
        try {
          return DateTime.fromMillisecondsSinceEpoch(dateValue * 1000).toIso8601String();
        } catch (e) {
          try {
            return DateTime.fromMillisecondsSinceEpoch(dateValue).toIso8601String();
          } catch (e2) {
            return DateTime.now().toIso8601String();
          }
        }
      }
      return DateTime.now().toIso8601String();
    }
    
    final createdAt = convertDate(json['created_at']);
    final updatedAt = convertDate(json['updated_at']);
    
    // Converter isActive de forma segura
    final isActiveValue = json['is_active'];
    final isActive = isActiveValue is bool
        ? isActiveValue
        : (isActiveValue is int ? isActiveValue != 0 : (isActiveValue is String ? isActiveValue.toLowerCase() == 'true' : true));
    
    return PlaylistModel(
      id: id,
      name: name,
      cover: cover,
      musicsCount: musicsCount,
      musicsData: musicsData,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
    );
  }
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
