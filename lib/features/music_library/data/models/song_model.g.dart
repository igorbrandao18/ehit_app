// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongModel _$SongModelFromJson(Map<String, dynamic> json) => SongModel(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      album: json['album'] as String,
      duration: json['duration'] as String,
      imageUrl: json['imageUrl'] as String,
      audioUrl: json['audioUrl'] as String,
      isExplicit: json['isExplicit'] as bool,
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      playCount: (json['playCount'] as num).toInt(),
      genre: json['genre'] as String,
    );

Map<String, dynamic> _$SongModelToJson(SongModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artist': instance.artist,
      'album': instance.album,
      'duration': instance.duration,
      'imageUrl': instance.imageUrl,
      'audioUrl': instance.audioUrl,
      'isExplicit': instance.isExplicit,
      'releaseDate': instance.releaseDate.toIso8601String(),
      'playCount': instance.playCount,
      'genre': instance.genre,
    };
