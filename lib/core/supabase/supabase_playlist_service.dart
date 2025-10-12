// core/supabase/supabase_playlist_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/result.dart';
import '../errors/failures.dart';
import '../../features/music_player/domain/entities/playlist.dart';
import '../../features/music_library/domain/entities/song.dart';
import 'supabase_config.dart';

/// Supabase-based playlist service
class SupabasePlaylistService {
  static final SupabasePlaylistService _instance = SupabasePlaylistService._internal();
  factory SupabasePlaylistService() => _instance;
  SupabasePlaylistService._internal();

  /// Get user playlists
  Future<Result<List<Playlist>>> getUserPlaylists() async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return const Success([]);
      }

      final response = await SupabaseConfig.client
          .from('playlists')
          .select('''
            *,
            playlist_songs(
              position,
              songs!inner(
                *,
                artists!inner(*),
                albums(*)
              )
            )
          ''')
          .eq('user_id', currentUser.id)
          .order('created_at', ascending: false);

      final playlists = (response as List).map((data) => _mapPlaylistFromData(data)).toList();
      return Success(playlists);
    } catch (e) {
      return Error<List<Playlist>>(
        message: 'Error fetching user playlists: $e',
      );
    }
  }

  /// Get playlist by ID
  Future<Result<Playlist>> getPlaylistById(String playlistId) async {
    try {
      final response = await SupabaseConfig.client
          .from('playlists')
          .select('''
            *,
            playlist_songs(
              position,
              songs!inner(
                *,
                artists!inner(*),
                albums(*)
              )
            )
          ''')
          .eq('id', playlistId)
          .single();

      final playlist = _mapPlaylistFromData(response);
      return Success(playlist);
    } catch (e) {
      return Error<Playlist>(
        message: 'Error fetching playlist: $e',
      );
    }
  }

  /// Get public playlists
  Future<Result<List<Playlist>>> getPublicPlaylists() async {
    try {
      final response = await SupabaseConfig.client
          .from('playlists')
          .select('''
            *,
            profiles!inner(username, display_name, profile_image_url),
            playlist_songs(
              position,
              songs!inner(
                *,
                artists!inner(*),
                albums(*)
              )
            )
          ''')
          .eq('is_public', true)
          .order('followers_count', ascending: false)
          .limit(20);

      final playlists = (response as List).map((data) => _mapPlaylistFromData(data)).toList();
      return Success(playlists);
    } catch (e) {
      return Error<List<Playlist>>(
        message: 'Error fetching public playlists: $e',
      );
    }
  }

  /// Get popular playlists
  Future<Result<List<Playlist>>> getPopularPlaylists() async {
    try {
      final response = await SupabaseConfig.client
          .from('playlists')
          .select('''
            *,
            profiles!inner(username, display_name, profile_image_url),
            playlist_songs(
              position,
              songs!inner(
                *,
                artists!inner(*),
                albums(*)
              )
            )
          ''')
          .eq('is_public', true)
          .order('followers_count', ascending: false)
          .limit(20);

      final playlists = (response as List).map((data) => _mapPlaylistFromData(data)).toList();
      return Success(playlists);
    } catch (e) {
      return Error<List<Playlist>>(
        message: 'Error fetching popular playlists: $e',
      );
    }
  }

  /// Get playlists by genre
  Future<Result<List<Playlist>>> getPlaylistsByGenre(String genre) async {
    try {
      final response = await SupabaseConfig.client
          .from('playlists')
          .select('''
            *,
            profiles!inner(username, display_name, profile_image_url),
            playlist_songs(
              position,
              songs!inner(
                *,
                artists!inner(*),
                albums(*)
              )
            )
          ''')
          .eq('is_public', true)
          .contains('tags', [genre])
          .order('followers_count', ascending: false)
          .limit(20);

      final playlists = (response as List).map((data) => _mapPlaylistFromData(data)).toList();
      return Success(playlists);
    } catch (e) {
      return Error<List<Playlist>>(
        message: 'Error fetching playlists by genre: $e',
      );
    }
  }

  /// Search playlists
  Future<Result<List<Playlist>>> searchPlaylists(String query) async {
    try {
      final response = await SupabaseConfig.client
          .from('playlists')
          .select('''
            *,
            profiles!inner(username, display_name, profile_image_url),
            playlist_songs(
              position,
              songs!inner(
                *,
                artists!inner(*),
                albums(*)
              )
            )
          ''')
          .eq('is_public', true)
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .order('followers_count', ascending: false)
          .limit(50);

      final playlists = (response as List).map((data) => _mapPlaylistFromData(data)).toList();
      return Success(playlists);
    } catch (e) {
      return Error<List<Playlist>>(
        message: 'Error searching playlists: $e',
      );
    }
  }

  /// Create playlist
  Future<Result<Playlist>> createPlaylist({
    required String name,
    required String description,
    required bool isPublic,
    required bool isCollaborative,
  }) async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return Error<Playlist>(
          message: 'User not authenticated',
        );
      }

      final response = await SupabaseConfig.client
          .from('playlists')
          .insert({
            'name': name,
            'description': description,
            'user_id': currentUser.id,
            'is_public': isPublic,
            'is_collaborative': isCollaborative,
            'songs_count': 0,
            'followers_count': 0,
          })
          .select()
          .single();

      final playlist = _mapPlaylistFromData(response);
      return Success(playlist);
    } catch (e) {
      return Error<Playlist>(
        message: 'Error creating playlist: $e',
      );
    }
  }

  /// Update playlist
  Future<Result<Playlist>> updatePlaylist({
    required String playlistId,
    String? name,
    String? description,
    bool? isPublic,
    bool? isCollaborative,
  }) async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return Error<Playlist>(
          message: 'User not authenticated',
        );
      }

      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (description != null) updateData['description'] = description;
      if (isPublic != null) updateData['is_public'] = isPublic;
      if (isCollaborative != null) updateData['is_collaborative'] = isCollaborative;

      final response = await SupabaseConfig.client
          .from('playlists')
          .update(updateData)
          .eq('id', playlistId)
          .eq('user_id', currentUser.id)
          .select()
          .single();

      final playlist = _mapPlaylistFromData(response);
      return Success(playlist);
    } catch (e) {
      return Error<Playlist>(
        message: 'Error updating playlist: $e',
      );
    }
  }

  /// Delete playlist
  Future<Result<void>> deletePlaylist(String playlistId) async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return Error<void>(
          message: 'User not authenticated',
        );
      }

      await SupabaseConfig.client
          .from('playlists')
          .delete()
          .eq('id', playlistId)
          .eq('user_id', currentUser.id);

      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error deleting playlist: $e',
      );
    }
  }

  /// Add song to playlist
  Future<Result<Playlist>> addSongToPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return Error<Playlist>(
          message: 'User not authenticated',
        );
      }

      // Get current max position
      final positionResponse = await SupabaseConfig.client
          .from('playlist_songs')
          .select('position')
          .eq('playlist_id', playlistId)
          .order('position', ascending: false)
          .limit(1);

      final nextPosition = positionResponse.isEmpty ? 0 : (positionResponse.first['position'] as int) + 1;

      // Add song to playlist
      await SupabaseConfig.client.from('playlist_songs').insert({
        'playlist_id': playlistId,
        'song_id': songId,
        'position': nextPosition,
        'added_by': currentUser.id,
      });

      // Get updated playlist
      final playlistResult = await getPlaylistById(playlistId);
      if (playlistResult is Error) {
        return playlistResult;
      }

      return Success((playlistResult as Success).data);
    } catch (e) {
      return Error<Playlist>(
        message: 'Error adding song to playlist: $e',
      );
    }
  }

  /// Remove song from playlist
  Future<Result<Playlist>> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return Error<Playlist>(
          message: 'User not authenticated',
        );
      }

      // Remove song from playlist
      await SupabaseConfig.client
          .from('playlist_songs')
          .delete()
          .eq('playlist_id', playlistId)
          .eq('song_id', songId);

      // Get updated playlist
      final playlistResult = await getPlaylistById(playlistId);
      if (playlistResult is Error) {
        return playlistResult;
      }

      return Success((playlistResult as Success).data);
    } catch (e) {
      return Error<Playlist>(
        message: 'Error removing song from playlist: $e',
      );
    }
  }

  /// Reorder playlist songs
  Future<Result<Playlist>> reorderPlaylistSongs({
    required String playlistId,
    required int oldIndex,
    required int newIndex,
  }) async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return Error<Playlist>(
          message: 'User not authenticated',
        );
      }

      // Get all songs in playlist
      final songsResponse = await SupabaseConfig.client
          .from('playlist_songs')
          .select('song_id, position')
          .eq('playlist_id', playlistId)
          .order('position');

      final songs = songsResponse as List<Map<String, dynamic>>;
      
      if (oldIndex < 0 || oldIndex >= songs.length || newIndex < 0 || newIndex >= songs.length) {
        return Error<Playlist>(
          message: 'Invalid song positions',
        );
      }

      // Reorder songs
      final songToMove = songs.removeAt(oldIndex);
      songs.insert(newIndex, songToMove);

      // Update positions
      for (int i = 0; i < songs.length; i++) {
        await SupabaseConfig.client
            .from('playlist_songs')
            .update({'position': i})
            .eq('playlist_id', playlistId)
            .eq('song_id', songs[i]['song_id']);
      }

      // Get updated playlist
      final playlistResult = await getPlaylistById(playlistId);
      if (playlistResult is Error) {
        return playlistResult;
      }

      return Success((playlistResult as Success).data);
    } catch (e) {
      return Error<Playlist>(
        message: 'Error reordering playlist songs: $e',
      );
    }
  }

  /// Follow playlist
  Future<Result<void>> followPlaylist(String playlistId) async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return Error<void>(
          message: 'User not authenticated',
        );
      }

      await SupabaseConfig.client.from('playlist_follows').insert({
        'user_id': currentUser.id,
        'playlist_id': playlistId,
      });

      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error following playlist: $e',
      );
    }
  }

  /// Unfollow playlist
  Future<Result<void>> unfollowPlaylist(String playlistId) async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return Error<void>(
          message: 'User not authenticated',
        );
      }

      await SupabaseConfig.client
          .from('playlist_follows')
          .delete()
          .eq('user_id', currentUser.id)
          .eq('playlist_id', playlistId);

      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error unfollowing playlist: $e',
      );
    }
  }

  /// Check if user is following playlist
  Future<Result<bool>> isFollowingPlaylist(String playlistId) async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return const Success(false);
      }

      final response = await SupabaseConfig.client
          .from('playlist_follows')
          .select('id')
          .eq('user_id', currentUser.id)
          .eq('playlist_id', playlistId)
          .maybeSingle();

      return Success(response != null);
    } catch (e) {
      return Error<bool>(
        message: 'Error checking follow status: $e',
      );
    }
  }

  /// Get followed playlists
  Future<Result<List<Playlist>>> getFollowedPlaylists() async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return const Success([]);
      }

      final response = await SupabaseConfig.client
          .from('playlist_follows')
          .select('''
            playlists!inner(
              *,
              profiles!inner(username, display_name, profile_image_url),
              playlist_songs(
                position,
                songs!inner(
                  *,
                  artists!inner(*),
                  albums(*)
                )
              )
            )
          ''')
          .eq('user_id', currentUser.id);

      final playlists = (response as List)
          .map((data) => _mapPlaylistFromData(data['playlists']))
          .toList();

      return Success(playlists);
    } catch (e) {
      return Error<List<Playlist>>(
        message: 'Error fetching followed playlists: $e',
      );
    }
  }

  /// Map database data to Playlist entity
  Playlist _mapPlaylistFromData(Map<String, dynamic> data) {
    final songs = <Song>[];
    
    if (data['playlist_songs'] != null) {
      final playlistSongs = data['playlist_songs'] as List;
      playlistSongs.sort((a, b) => (a['position'] as int).compareTo(b['position'] as int));
      
      songs.addAll(playlistSongs.map((playlistSong) {
        final songData = playlistSong['songs'];
        final artist = songData['artists'];
        final album = songData['albums'];
        
        return Song(
          id: songData['id'],
          title: songData['title'],
          artist: artist['name'],
          album: album?['title'] ?? 'Unknown Album',
          duration: Duration(seconds: songData['duration']),
          imageUrl: songData['image_url'] ?? '',
          audioUrl: songData['audio_url'],
          genre: songData['genre'] ?? '',
          year: songData['year'],
          isFavorite: false,
        );
      }));
    }

    final profile = data['profiles'];
    final ownerName = profile != null ? profile['display_name'] ?? profile['username'] : 'Unknown';

    return Playlist(
      id: data['id'],
      name: data['name'],
      description: data['description'] ?? '',
      ownerId: data['user_id'],
      ownerName: ownerName,
      imageUrl: data['image_url'] ?? '',
      isPublic: data['is_public'] ?? true,
      isCollaborative: data['is_collaborative'] ?? false,
      followersCount: data['followers_count'] ?? 0,
      songsCount: data['songs_count'] ?? 0,
      songs: songs,
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }
}
