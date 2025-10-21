// features/music_library/data/models/artist_model.dart

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/artist.dart';

part 'artist_model.g.dart';

/// Modelo de dados para Artist
@JsonSerializable()
class ArtistModel extends Artist {
  const ArtistModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.genre,
    required super.albumsCount,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Cria ArtistModel a partir de JSON da API
  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['id'] as int,
      name: json['stage_name'] as String,
      imageUrl: json['photo'] as String? ?? '',
      genre: json['genre_data']?['name'] as String? ?? 'Unknown',
      albumsCount: json['albums_count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converte ArtistModel para JSON
  Map<String, dynamic> toJson() => _$ArtistModelToJson(this);

  /// Cria ArtistModel a partir de Entity
  factory ArtistModel.fromEntity(Artist artist) {
    return ArtistModel(
      id: artist.id,
      name: artist.name,
      imageUrl: artist.imageUrl,
      genre: artist.genre,
      albumsCount: artist.albumsCount,
      isActive: artist.isActive,
      createdAt: artist.createdAt,
      updatedAt: artist.updatedAt,
    );
  }

  /// Converte ArtistModel para Entity
  Artist toEntity() {
    return Artist(
      id: id,
      name: name,
      imageUrl: imageUrl,
      genre: genre,
      albumsCount: albumsCount,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}