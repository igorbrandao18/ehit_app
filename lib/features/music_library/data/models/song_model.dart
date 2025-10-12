// features/music_library/data/models/song_model.dart

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/song.dart';

part 'song_model.g.dart';

/// Modelo de dados para Song
@JsonSerializable()
class SongModel extends Song {
  const SongModel({
    required super.id,
    required super.title,
    required super.artist,
    required super.album,
    required super.duration,
    required super.imageUrl,
    required super.audioUrl,
    required super.isExplicit,
    required super.releaseDate,
    required super.playCount,
  });

  /// Cria SongModel a partir de JSON
  factory SongModel.fromJson(Map<String, dynamic> json) => _$SongModelFromJson(json);

  /// Converte SongModel para JSON
  Map<String, dynamic> toJson() => _$SongModelToJson(this);

  /// Cria SongModel a partir de Entity
  factory SongModel.fromEntity(Song song) {
    return SongModel(
      id: song.id,
      title: song.title,
      artist: song.artist,
      album: song.album,
      duration: song.duration,
      imageUrl: song.imageUrl,
      audioUrl: song.audioUrl,
      isExplicit: song.isExplicit,
      releaseDate: song.releaseDate,
      playCount: song.playCount,
    );
  }

  /// Converte SongModel para Entity
  Song toEntity() {
    return Song(
      id: id,
      title: title,
      artist: artist,
      album: album,
      duration: duration,
      imageUrl: imageUrl,
      audioUrl: audioUrl,
      isExplicit: isExplicit,
      releaseDate: releaseDate,
      playCount: playCount,
    );
  }

  /// Cria SongModel a partir de Map (para dados mock)
  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] as String,
      title: map['title'] as String,
      artist: map['artist'] as String,
      album: map['album'] as String,
      duration: map['duration'] as String,
      imageUrl: map['imageUrl'] as String,
      audioUrl: map['audioUrl'] as String,
      isExplicit: map['isExplicit'] as bool? ?? false,
      releaseDate: DateTime.tryParse(map['releaseDate'] as String? ?? '') ?? DateTime.now(),
      playCount: map['playCount'] as int? ?? 0,
    );
  }

  /// Converte SongModel para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'duration': duration,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'isExplicit': isExplicit,
      'releaseDate': releaseDate.toIso8601String(),
      'playCount': playCount,
    };
  }
}
