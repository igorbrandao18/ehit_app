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
    required super.bio,
    required super.totalSongs,
    required super.totalDuration,
    required super.genres,
    required super.followers,
  });

  /// Cria ArtistModel a partir de JSON
  factory ArtistModel.fromJson(Map<String, dynamic> json) => _$ArtistModelFromJson(json);

  /// Converte ArtistModel para JSON
  Map<String, dynamic> toJson() => _$ArtistModelToJson(this);

  /// Cria ArtistModel a partir de Entity
  factory ArtistModel.fromEntity(Artist artist) {
    return ArtistModel(
      id: artist.id,
      name: artist.name,
      imageUrl: artist.imageUrl,
      bio: artist.bio,
      totalSongs: artist.totalSongs,
      totalDuration: artist.totalDuration,
      genres: artist.genres,
      followers: artist.followers,
    );
  }

  /// Converte ArtistModel para Entity
  Artist toEntity() {
    return Artist(
      id: id,
      name: name,
      imageUrl: imageUrl,
      bio: bio,
      totalSongs: totalSongs,
      totalDuration: totalDuration,
      genres: genres,
      followers: followers,
    );
  }

  /// Cria ArtistModel a partir de Map (para dados mock)
  factory ArtistModel.fromMap(Map<String, dynamic> map) {
    return ArtistModel(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      bio: map['bio'] as String? ?? '',
      totalSongs: map['totalSongs'] as int? ?? 0,
      totalDuration: map['totalDuration'] as String? ?? '0:00',
      genres: (map['genres'] as List<dynamic>?)?.cast<String>() ?? [],
      followers: map['followers'] as int? ?? 0,
    );
  }

  /// Converte ArtistModel para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'bio': bio,
      'totalSongs': totalSongs,
      'totalDuration': totalDuration,
      'genres': genres,
      'followers': followers,
    };
  }
}
