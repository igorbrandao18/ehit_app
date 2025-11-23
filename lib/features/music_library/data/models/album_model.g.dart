// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumModel _$AlbumModelFromJson(Map<String, dynamic> json) => AlbumModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      artistName: json['artistName'] as String,
      imageUrl: json['imageUrl'] as String,
      songsCount: (json['songsCount'] as num).toInt(),
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AlbumModelToJson(AlbumModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artistName': instance.artistName,
      'imageUrl': instance.imageUrl,
      'songsCount': instance.songsCount,
      'releaseDate': instance.releaseDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
