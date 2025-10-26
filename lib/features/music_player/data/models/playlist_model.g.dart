part of 'playlist_model.dart';
PlaylistModel _$PlaylistModelFromJson(Map<String, dynamic> json) =>
    PlaylistModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      isPublic: json['isPublic'] as bool,
      isCollaborative: json['isCollaborative'] as bool,
      createdAt: PlaylistModel._dateTimeFromJson(json['createdAt'] as String),
      updatedAt: PlaylistModel._dateTimeFromJson(json['updatedAt'] as String),
      songs: PlaylistModel._songsFromJson(json['songs'] as List),
      totalSongs: (json['totalSongs'] as num).toInt(),
      totalDuration: json['totalDuration'] as String,
      followersCount: (json['followersCount'] as num).toInt(),
      isFollowing: json['isFollowing'] as bool,
    );
Map<String, dynamic> _$PlaylistModelToJson(PlaylistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'ownerId': instance.ownerId,
      'ownerName': instance.ownerName,
      'isPublic': instance.isPublic,
      'isCollaborative': instance.isCollaborative,
      'createdAt': PlaylistModel._dateTimeToJson(instance.createdAt),
      'updatedAt': PlaylistModel._dateTimeToJson(instance.updatedAt),
      'songs': PlaylistModel._songsToJson(instance.songs),
      'totalSongs': instance.totalSongs,
      'totalDuration': instance.totalDuration,
      'followersCount': instance.followersCount,
      'isFollowing': instance.isFollowing,
    };
