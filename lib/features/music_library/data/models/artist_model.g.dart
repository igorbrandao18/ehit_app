// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistModel _$ArtistModelFromJson(Map<String, dynamic> json) => ArtistModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      bio: json['bio'] as String,
      totalSongs: (json['totalSongs'] as num).toInt(),
      totalDuration: json['totalDuration'] as String,
      genres:
          (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
      followers: (json['followers'] as num).toInt(),
    );

Map<String, dynamic> _$ArtistModelToJson(ArtistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'bio': instance.bio,
      'totalSongs': instance.totalSongs,
      'totalDuration': instance.totalDuration,
      'genres': instance.genres,
      'followers': instance.followers,
    };
