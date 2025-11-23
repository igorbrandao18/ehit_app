import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/album.dart';
import '../../../../core/constants/app_config.dart';

part 'album_model.g.dart';

@JsonSerializable()
class AlbumModel extends Album {
  const AlbumModel({
    required super.id,
    required super.title,
    required super.artistName,
    required super.imageUrl,
    required super.songsCount,
    required super.releaseDate,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    // Converter cover de forma segura
    final coverValue = json['cover'] ?? json['image'];
    String? coverUrl = '';
    if (coverValue != null) {
      if (coverValue is String) {
        coverUrl = coverValue;
      } else if (coverValue is int) {
        coverUrl = coverValue.toString();
      }
    }
    if (coverUrl.isNotEmpty && !coverUrl.startsWith('http')) {
      coverUrl = '${AppConfig.resourcesBaseUrl}$coverUrl';
    }
    
    // Converter id de forma segura
    final idValue = json['id'];
    final id = idValue is int 
        ? idValue 
        : (idValue is String ? int.tryParse(idValue) ?? 0 : 0);
    
    // Converter title de forma segura
    final nameValue = json['name'] ?? json['title'];
    final title = nameValue is String 
        ? nameValue 
        : (nameValue is int ? nameValue.toString() : 'Unknown Album');
    
    // Converter artistName de forma segura
    final artistNameValue = json['artist_name'] ?? json['artist_data']?['stage_name'];
    final artistName = artistNameValue is String
        ? artistNameValue
        : (artistNameValue is int ? artistNameValue.toString() : 'Unknown Artist');
    
    // Converter songsCount de forma segura
    final musicsCountValue = json['musics_count'] ?? json['songs_count'];
    final songsCount = musicsCountValue is int
        ? musicsCountValue
        : (musicsCountValue is String ? int.tryParse(musicsCountValue) ?? 0 : 0);
    
    // Converter datas de forma segura
    DateTime parseDate(dynamic dateValue) {
      if (dateValue == null) return DateTime.now();
      if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          return DateTime.now();
        }
      }
      if (dateValue is int) {
        // Pode ser timestamp
        try {
          return DateTime.fromMillisecondsSinceEpoch(dateValue * 1000);
        } catch (e) {
          return DateTime.fromMillisecondsSinceEpoch(dateValue);
        }
      }
      return DateTime.now();
    }
    
    return AlbumModel(
      id: id,
      title: title,
      artistName: artistName,
      imageUrl: coverUrl,
      songsCount: songsCount,
      releaseDate: parseDate(json['release_date'] ?? json['created_at']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => _$AlbumModelToJson(this);

  factory AlbumModel.fromEntity(Album album) {
    return AlbumModel(
      id: album.id,
      title: album.title,
      artistName: album.artistName,
      imageUrl: album.imageUrl,
      songsCount: album.songsCount,
      releaseDate: album.releaseDate,
      createdAt: album.createdAt,
      updatedAt: album.updatedAt,
    );
  }

  Album toEntity() {
    return Album(
      id: id,
      title: title,
      artistName: artistName,
      imageUrl: imageUrl,
      songsCount: songsCount,
      releaseDate: releaseDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

