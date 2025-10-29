// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistModel _$PlaylistModelFromJson(Map<String, dynamic> json) =>
    PlaylistModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      cover: json['cover'] as String,
      musicsCount: (json['musics_count'] as num).toInt(),
      musicsData: (json['musics_data'] as List<dynamic>)
          .map((e) => SongModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$PlaylistModelToJson(PlaylistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cover': instance.cover,
      'musics_count': instance.musicsCount,
      'musics_data': instance.musicsData.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'is_active': instance.isActive,
    };
