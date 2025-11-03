import 'package:dio/dio.dart';
import '../models/playlist_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/constants/app_config.dart';

abstract class PlaylistRemoteDataSource {
  Future<List<PlaylistModel>> getPlaylists();
}

class PlaylistRemoteDataSourceImpl implements PlaylistRemoteDataSource {
  final Dio _dio;

  PlaylistRemoteDataSourceImpl(this._dio);

  @override
  Future<List<PlaylistModel>> getPlaylists() async {
    try {
      final response = await _dio.get(AppConfig.getApiEndpoint('playlists/'));
      if (response.statusCode == 200) {
        final data = response.data;
        final results = data['results'] as List;
        return results.map((playlistData) {
          // Map API response to PlaylistModel
          return PlaylistModel(
            id: playlistData['id'].toString(),
            name: playlistData['name'] ?? 'Unknown Playlist',
            description: playlistData['description'] ?? '',
            imageUrl: playlistData['cover'] ?? AppConfig.defaultPlaylistImageUrl,
            ownerId: playlistData['owner_id']?.toString() ?? '0',
            ownerName: playlistData['owner_name'] ?? 'Unknown',
            isPublic: playlistData['is_public'] ?? true,
            isCollaborative: playlistData['is_collaborative'] ?? false,
            createdAt: playlistData['created_at'] != null 
                ? DateTime.parse(playlistData['created_at']) 
                : DateTime.now(),
            updatedAt: playlistData['updated_at'] != null 
                ? DateTime.parse(playlistData['updated_at']) 
                : DateTime.now(),
            songs: [], // Songs would need to be parsed separately if available
            totalSongs: playlistData['musics_count'] ?? 0,
            totalDuration: '0:00', // Would need to calculate from songs
            followersCount: playlistData['followers_count'] ?? 0,
            isFollowing: playlistData['is_following'] ?? false,
          );
        }).toList();
      } else {
        throw Exception('Failed to load playlists: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching playlists: $e');
    }
  }
}
