import 'package:equatable/equatable.dart';
import 'song.dart';
class Playlist extends Equatable {
  final int id;
  final String name;
  final String cover;
  final int musicsCount;
  final List<Song> musicsData;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  const Playlist({
    required this.id,
    required this.name,
    required this.cover,
    required this.musicsCount,
    required this.musicsData,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });
  @override
  List<Object?> get props => [
        id,
        name,
        cover,
        musicsCount,
        musicsData,
        createdAt,
        updatedAt,
        isActive,
      ];
}
