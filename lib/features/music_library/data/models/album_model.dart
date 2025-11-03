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
    // Helper para concatenar URL completa
    String? coverUrl = json['cover'] as String? ?? json['image'] as String? ?? '';
    if (coverUrl.isNotEmpty && !coverUrl.startsWith('http')) {
      coverUrl = '${AppConfig.resourcesBaseUrl}$coverUrl';
    }
    
    return AlbumModel(
      id: json['id'] as int,
      // API retorna 'name' ao invés de 'title'
      title: json['name'] as String? ?? json['title'] as String? ?? 'Unknown Album',
      artistName: json['artist_name'] as String? ?? json['artist_data']?['stage_name'] as String? ?? 'Unknown Artist',
      imageUrl: coverUrl,
      songsCount: json['musics_count'] as int? ?? json['songs_count'] as int? ?? 0,
      releaseDate: json['release_date'] != null 
          ? DateTime.parse(json['release_date'] as String)
          : (json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now()),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
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

