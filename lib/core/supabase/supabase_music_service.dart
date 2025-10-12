// core/supabase/supabase_music_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/result.dart';
import '../errors/failures.dart';
import '../../features/music_library/domain/entities/song.dart';
import '../../features/music_library/domain/entities/artist.dart';
import 'supabase_config.dart';

/// Supabase-based music service
class SupabaseMusicService {
  static final SupabaseMusicService _instance = SupabaseMusicService._internal();
  factory SupabaseMusicService() => _instance;
  SupabaseMusicService._internal();

  /// Get all songs
  Future<Result<List<Song>>> getSongs() async {
    try {
      final response = await SupabaseConfig.client
          .from('songs')
          .select('''
            *,
            artists!inner(*),
            albums(*)
          ''')
          .order('created_at', ascending: false);

      final songs = (response as List).map((data) => _mapSongFromData(data)).toList();
      return Success(songs);
    } catch (e) {
      return Error<List<Song>>(
        message: 'Error fetching songs: $e',
      );
    }
  }

  /// Get song by ID
  Future<Result<Song>> getSongById(String id) async {
    try {
      final response = await SupabaseConfig.client
          .from('songs')
          .select('''
            *,
            artists!inner(*),
            albums(*)
          ''')
          .eq('id', id)
          .single();

      final song = _mapSongFromData(response);
      return Success(song);
    } catch (e) {
      return Error<Song>(
        message: 'Error fetching song: $e',
      );
    }
  }

  /// Get songs by artist
  Future<Result<List<Song>>> getSongsByArtist(String artistId) async {
    try {
      final response = await SupabaseConfig.client
          .from('songs')
          .select('''
            *,
            artists!inner(*),
            albums(*)
          ''')
          .eq('artist_id', artistId)
          .order('created_at', ascending: false);

      final songs = (response as List).map((data) => _mapSongFromData(data)).toList();
      return Success(songs);
    } catch (e) {
      return Error<List<Song>>(
        message: 'Error fetching songs by artist: $e',
      );
    }
  }

  /// Get popular songs
  Future<Result<List<Song>>> getPopularSongs() async {
    try {
      final response = await SupabaseConfig.client
          .from('songs')
          .select('''
            *,
            artists!inner(*),
            albums(*)
          ''')
          .order('play_count', ascending: false)
          .limit(20);

      final songs = (response as List).map((data) => _mapSongFromData(data)).toList();
      return Success(songs);
    } catch (e) {
      return Error<List<Song>>(
        message: 'Error fetching popular songs: $e',
      );
    }
  }

  /// Get recent songs
  Future<Result<List<Song>>> getRecentSongs() async {
    try {
      final response = await SupabaseConfig.client
          .from('songs')
          .select('''
            *,
            artists!inner(*),
            albums(*)
          ''')
          .order('created_at', ascending: false)
          .limit(20);

      final songs = (response as List).map((data) => _mapSongFromData(data)).toList();
      return Success(songs);
    } catch (e) {
      return Error<List<Song>>(
        message: 'Error fetching recent songs: $e',
      );
    }
  }

  /// Search songs
  Future<Result<List<Song>>> searchSongs(String query) async {
    try {
      final response = await SupabaseConfig.client
          .from('songs')
          .select('''
            *,
            artists!inner(*),
            albums(*)
          ''')
          .or('title.ilike.%$query%,artist_id.in.(select id from artists where name.ilike.%$query%)')
          .order('play_count', ascending: false)
          .limit(50);

      final songs = (response as List).map((data) => _mapSongFromData(data)).toList();
      return Success(songs);
    } catch (e) {
      return Error<List<Song>>(
        message: 'Error searching songs: $e',
      );
    }
  }

  /// Get all artists
  Future<Result<List<Artist>>> getArtists() async {
    try {
      final response = await SupabaseConfig.client
          .from('artists')
          .select('*')
          .order('followers_count', ascending: false);

      final artists = (response as List).map((data) => _mapArtistFromData(data)).toList();
      return Success(artists);
    } catch (e) {
      return Error<List<Artist>>(
        message: 'Error fetching artists: $e',
      );
    }
  }

  /// Get artist by ID
  Future<Result<Artist>> getArtistById(String id) async {
    try {
      final response = await SupabaseConfig.client
          .from('artists')
          .select('*')
          .eq('id', id)
          .single();

      final artist = _mapArtistFromData(response);
      return Success(artist);
    } catch (e) {
      return Error<Artist>(
        message: 'Error fetching artist: $e',
      );
    }
  }

  /// Get popular artists
  Future<Result<List<Artist>>> getPopularArtists() async {
    try {
      final response = await SupabaseConfig.client
          .from('artists')
          .select('*')
          .order('followers_count', ascending: false)
          .limit(20);

      final artists = (response as List).map((data) => _mapArtistFromData(data)).toList();
      return Success(artists);
    } catch (e) {
      return Error<List<Artist>>(
        message: 'Error fetching popular artists: $e',
      );
    }
  }

  /// Get artists by genre
  Future<Result<List<Artist>>> getArtistsByGenre(String genre) async {
    try {
      final response = await SupabaseConfig.client
          .from('artists')
          .select('*')
          .eq('genre', genre)
          .order('followers_count', ascending: false);

      final artists = (response as List).map((data) => _mapArtistFromData(data)).toList();
      return Success(artists);
    } catch (e) {
      return Error<List<Artist>>(
        message: 'Error fetching artists by genre: $e',
      );
    }
  }

  /// Search artists
  Future<Result<List<Artist>>> searchArtists(String query) async {
    try {
      final response = await SupabaseConfig.client
          .from('artists')
          .select('*')
          .ilike('name', '%$query%')
          .order('followers_count', ascending: false)
          .limit(50);

      final artists = (response as List).map((data) => _mapArtistFromData(data)).toList();
      return Success(artists);
    } catch (e) {
      return Error<List<Artist>>(
        message: 'Error searching artists: $e',
      );
    }
  }

  /// Follow an artist
  Future<Result<void>> followArtist(String artistId) async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return Error<void>(
          message: 'User not authenticated',
        );
      }

      await SupabaseConfig.client.from('artist_follows').insert({
        'user_id': currentUser.id,
        'artist_id': artistId,
      });

      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error following artist: $e',
      );
    }
  }

  /// Unfollow an artist
  Future<Result<void>> unfollowArtist(String artistId) async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return Error<void>(
          message: 'User not authenticated',
        );
      }

      await SupabaseConfig.client
          .from('artist_follows')
          .delete()
          .eq('user_id', currentUser.id)
          .eq('artist_id', artistId);

      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error unfollowing artist: $e',
      );
    }
  }

  /// Check if user is following an artist
  Future<Result<bool>> isFollowingArtist(String artistId) async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return const Success(false);
      }

      final response = await SupabaseConfig.client
          .from('artist_follows')
          .select('id')
          .eq('user_id', currentUser.id)
          .eq('artist_id', artistId)
          .maybeSingle();

      return Success(response != null);
    } catch (e) {
      return Error<bool>(
        message: 'Error checking follow status: $e',
      );
    }
  }

  /// Get followed artists
  Future<Result<List<Artist>>> getFollowedArtists() async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return const Success([]);
      }

      final response = await SupabaseConfig.client
          .from('artist_follows')
          .select('''
            artists!inner(*)
          ''')
          .eq('user_id', currentUser.id);

      final artists = (response as List)
          .map((data) => _mapArtistFromData(data['artists']))
          .toList();

      return Success(artists);
    } catch (e) {
      return Error<List<Artist>>(
        message: 'Error fetching followed artists: $e',
      );
    }
  }

  /// Add song to favorites
  Future<Result<void>> addToFavorites(String songId) async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return Error<void>(
          message: 'User not authenticated',
        );
      }

      await SupabaseConfig.client.from('user_favorites').insert({
        'user_id': currentUser.id,
        'song_id': songId,
      });

      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error adding to favorites: $e',
      );
    }
  }

  /// Remove song from favorites
  Future<Result<void>> removeFromFavorites(String songId) async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return Error<void>(
          message: 'User not authenticated',
        );
      }

      await SupabaseConfig.client
          .from('user_favorites')
          .delete()
          .eq('user_id', currentUser.id)
          .eq('song_id', songId);

      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error removing from favorites: $e',
      );
    }
  }

  /// Get favorite songs
  Future<Result<List<Song>>> getFavoriteSongs() async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return const Success([]);
      }

      final response = await SupabaseConfig.client
          .from('user_favorites')
          .select('''
            songs!inner(
              *,
              artists!inner(*),
              albums(*)
            )
          ''')
          .eq('user_id', currentUser.id);

      final songs = (response as List)
          .map((data) => _mapSongFromData(data['songs']))
          .toList();

      return Success(songs);
    } catch (e) {
      return Error<List<Song>>(
        message: 'Error fetching favorite songs: $e',
      );
    }
  }

  /// Record song playback
  Future<Result<void>> recordPlayback(String songId, int durationPlayed) async {
    try {
      final currentUser = SupabaseConfig.client.auth.currentUser;
      if (currentUser == null) {
        return const Success(null); // Don't fail if user not authenticated
      }

      // Add to playback history
      await SupabaseConfig.client.from('playback_history').insert({
        'user_id': currentUser.id,
        'song_id': songId,
        'duration_played': durationPlayed,
      });

      // Update song play count
      await SupabaseConfig.client.rpc('increment_play_count', params: {
        'song_id': songId,
      });

      return const Success(null);
    } catch (e) {
      return Error<void>(
        message: 'Error recording playback: $e',
      );
    }
  }

  /// Map database data to Song entity
  Song _mapSongFromData(Map<String, dynamic> data) {
    final artist = data['artists'] as Map<String, dynamic>;
    final album = data['albums'] as Map<String, dynamic>?;

    return Song(
      id: data['id'],
      title: data['title'],
      artist: artist['name'],
      album: album?['title'] ?? 'Unknown Album',
      duration: Duration(seconds: data['duration']),
      imageUrl: data['image_url'] ?? '',
      audioUrl: data['audio_url'],
      genre: data['genre'] ?? '',
      year: data['year'],
      isFavorite: false, // Will be determined separately
    );
  }

  /// Map database data to Artist entity
  Artist _mapArtistFromData(Map<String, dynamic> data) {
    return Artist(
      id: data['id'],
      name: data['name'],
      bio: data['bio'] ?? '',
      imageUrl: data['image_url'] ?? '',
      followersCount: data['followers_count'] ?? 0,
      isVerified: data['is_verified'] ?? false,
    );
  }
}
