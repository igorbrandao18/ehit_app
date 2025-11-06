import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/song.dart';
part 'song_model.g.dart';
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
    required super.genre,
  });
  factory SongModel.fromJson(Map<String, dynamic> json) => _$SongModelFromJson(json);
  Map<String, dynamic> toJson() => _$SongModelToJson(this);
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
      genre: song.genre,
    );
  }
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
      genre: genre,
    );
  }
  factory SongModel.fromMap(Map<String, dynamic> map) {
    String duration = '0:00';
    final durationValue = map['duration'];
    if (durationValue != null && durationValue.toString().isNotEmpty) {
      duration = durationValue.toString();
    }
    
    return SongModel(
      id: map['id'] as String,
      title: map['title'] as String,
      artist: map['artist'] as String,
      album: map['album'] as String,
      duration: duration,
      imageUrl: map['imageUrl'] as String,
      audioUrl: map['audioUrl'] as String,
      isExplicit: map['isExplicit'] as bool? ?? false,
      releaseDate: DateTime.tryParse(map['releaseDate'] as String? ?? '') ?? DateTime.now(),
      playCount: map['playCount'] as int? ?? 0,
      genre: map['genre'] as String? ?? 'Pop',
    );
  }
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
      'genre': genre,
    };
  }
}
