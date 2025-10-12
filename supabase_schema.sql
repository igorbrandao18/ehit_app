-- Supabase Database Schema for Ehit Music App
-- This file contains all the necessary tables and relationships

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- USERS TABLE (extends Supabase auth.users)
-- ============================================================================

CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  display_name TEXT,
  bio TEXT,
  profile_image_url TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  followers_count INTEGER DEFAULT 0,
  following_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Create policies for profiles
CREATE POLICY "Users can view all profiles" ON public.profiles
  FOR SELECT USING (true);

CREATE POLICY "Users can update own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- ============================================================================
-- ARTISTS TABLE
-- ============================================================================

CREATE TABLE public.artists (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  bio TEXT,
  image_url TEXT,
  followers_count INTEGER DEFAULT 0,
  is_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.artists ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view artists" ON public.artists
  FOR SELECT USING (true);

CREATE POLICY "Only authenticated users can insert artists" ON public.artists
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- ============================================================================
-- ALBUMS TABLE
-- ============================================================================

CREATE TABLE public.albums (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  title TEXT NOT NULL,
  artist_id UUID REFERENCES public.artists(id) ON DELETE CASCADE,
  release_date DATE,
  image_url TEXT,
  genre TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.albums ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view albums" ON public.albums
  FOR SELECT USING (true);

CREATE POLICY "Only authenticated users can insert albums" ON public.albums
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- ============================================================================
-- SONGS TABLE
-- ============================================================================

CREATE TABLE public.songs (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  title TEXT NOT NULL,
  artist_id UUID REFERENCES public.artists(id) ON DELETE CASCADE,
  album_id UUID REFERENCES public.albums(id) ON DELETE SET NULL,
  duration INTEGER NOT NULL, -- Duration in seconds
  audio_url TEXT NOT NULL,
  image_url TEXT,
  genre TEXT,
  year INTEGER,
  track_number INTEGER,
  is_explicit BOOLEAN DEFAULT FALSE,
  play_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.songs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view songs" ON public.songs
  FOR SELECT USING (true);

CREATE POLICY "Only authenticated users can insert songs" ON public.songs
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- ============================================================================
-- PLAYLISTS TABLE
-- ============================================================================

CREATE TABLE public.playlists (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  image_url TEXT,
  is_public BOOLEAN DEFAULT TRUE,
  is_collaborative BOOLEAN DEFAULT FALSE,
  followers_count INTEGER DEFAULT 0,
  songs_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.playlists ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view public playlists" ON public.playlists
  FOR SELECT USING (is_public = true OR user_id = auth.uid());

CREATE POLICY "Users can create playlists" ON public.playlists
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own playlists" ON public.playlists
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own playlists" ON public.playlists
  FOR DELETE USING (auth.uid() = user_id);

-- ============================================================================
-- PLAYLIST_SONGS TABLE (Many-to-Many relationship)
-- ============================================================================

CREATE TABLE public.playlist_songs (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  playlist_id UUID REFERENCES public.playlists(id) ON DELETE CASCADE,
  song_id UUID REFERENCES public.songs(id) ON DELETE CASCADE,
  position INTEGER NOT NULL,
  added_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  added_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  UNIQUE(playlist_id, song_id)
);

ALTER TABLE public.playlist_songs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view playlist songs" ON public.playlist_songs
  FOR SELECT USING (true);

CREATE POLICY "Users can add songs to playlists" ON public.playlist_songs
  FOR INSERT WITH CHECK (
    auth.uid() IN (
      SELECT user_id FROM public.playlists WHERE id = playlist_id
    )
  );

CREATE POLICY "Users can remove songs from own playlists" ON public.playlist_songs
  FOR DELETE USING (
    auth.uid() IN (
      SELECT user_id FROM public.playlists WHERE id = playlist_id
    )
  );

-- ============================================================================
-- USER_FOLLOWS TABLE (Social features)
-- ============================================================================

CREATE TABLE public.user_follows (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  follower_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  following_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(follower_id, following_id)
);

ALTER TABLE public.user_follows ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view follows" ON public.user_follows
  FOR SELECT USING (true);

CREATE POLICY "Users can follow others" ON public.user_follows
  FOR INSERT WITH CHECK (auth.uid() = follower_id);

CREATE POLICY "Users can unfollow others" ON public.user_follows
  FOR DELETE USING (auth.uid() = follower_id);

-- ============================================================================
-- ARTIST_FOLLOWS TABLE
-- ============================================================================

CREATE TABLE public.artist_follows (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  artist_id UUID REFERENCES public.artists(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, artist_id)
);

ALTER TABLE public.artist_follows ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view artist follows" ON public.artist_follows
  FOR SELECT USING (true);

CREATE POLICY "Users can follow artists" ON public.artist_follows
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can unfollow artists" ON public.artist_follows
  FOR DELETE USING (auth.uid() = user_id);

-- ============================================================================
-- PLAYLIST_FOLLOWS TABLE
-- ============================================================================

CREATE TABLE public.playlist_follows (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  playlist_id UUID REFERENCES public.playlists(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, playlist_id)
);

ALTER TABLE public.playlist_follows ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view playlist follows" ON public.playlist_follows
  FOR SELECT USING (true);

CREATE POLICY "Users can follow playlists" ON public.playlist_follows
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can unfollow playlists" ON public.playlist_follows
  FOR DELETE USING (auth.uid() = user_id);

-- ============================================================================
-- SONG_COMMENTS TABLE
-- ============================================================================

CREATE TABLE public.song_comments (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  song_id UUID REFERENCES public.songs(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  comment TEXT NOT NULL,
  likes_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.song_comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view comments" ON public.song_comments
  FOR SELECT USING (true);

CREATE POLICY "Users can create comments" ON public.song_comments
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own comments" ON public.song_comments
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own comments" ON public.song_comments
  FOR DELETE USING (auth.uid() = user_id);

-- ============================================================================
-- COMMENT_LIKES TABLE
-- ============================================================================

CREATE TABLE public.comment_likes (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  comment_id UUID REFERENCES public.song_comments(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(comment_id, user_id)
);

ALTER TABLE public.comment_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view comment likes" ON public.comment_likes
  FOR SELECT USING (true);

CREATE POLICY "Users can like comments" ON public.comment_likes
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can unlike comments" ON public.comment_likes
  FOR DELETE USING (auth.uid() = user_id);

-- ============================================================================
-- USER_FAVORITES TABLE
-- ============================================================================

CREATE TABLE public.user_favorites (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  song_id UUID REFERENCES public.songs(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, song_id)
);

ALTER TABLE public.user_favorites ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own favorites" ON public.user_favorites
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can add favorites" ON public.user_favorites
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can remove favorites" ON public.user_favorites
  FOR DELETE USING (auth.uid() = user_id);

-- ============================================================================
-- PLAYBACK_HISTORY TABLE
-- ============================================================================

CREATE TABLE public.playback_history (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  song_id UUID REFERENCES public.songs(id) ON DELETE CASCADE,
  played_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  duration_played INTEGER DEFAULT 0 -- Duration played in seconds
);

ALTER TABLE public.playback_history ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own history" ON public.playback_history
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can add to history" ON public.playback_history
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- FUNCTIONS AND TRIGGERS
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Add triggers for updated_at
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_artists_updated_at BEFORE UPDATE ON public.artists
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_albums_updated_at BEFORE UPDATE ON public.albums
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_songs_updated_at BEFORE UPDATE ON public.songs
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_playlists_updated_at BEFORE UPDATE ON public.playlists
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_song_comments_updated_at BEFORE UPDATE ON public.song_comments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to update followers count
CREATE OR REPLACE FUNCTION update_followers_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.profiles SET followers_count = followers_count + 1 WHERE id = NEW.following_id;
    UPDATE public.profiles SET following_count = following_count + 1 WHERE id = NEW.follower_id;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.profiles SET followers_count = followers_count - 1 WHERE id = OLD.following_id;
    UPDATE public.profiles SET following_count = following_count - 1 WHERE id = OLD.follower_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ language 'plpgsql';

-- Add triggers for followers count
CREATE TRIGGER update_user_followers_count
  AFTER INSERT OR DELETE ON public.user_follows
  FOR EACH ROW EXECUTE FUNCTION update_followers_count();

-- Function to update playlist songs count
CREATE OR REPLACE FUNCTION update_playlist_songs_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.playlists SET songs_count = songs_count + 1 WHERE id = NEW.playlist_id;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.playlists SET songs_count = songs_count - 1 WHERE id = OLD.playlist_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ language 'plpgsql';

-- Add trigger for playlist songs count
CREATE TRIGGER update_playlist_songs_count_trigger
  AFTER INSERT OR DELETE ON public.playlist_songs
  FOR EACH ROW EXECUTE FUNCTION update_playlist_songs_count();

-- Function to update comment likes count
CREATE OR REPLACE FUNCTION update_comment_likes_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.song_comments SET likes_count = likes_count + 1 WHERE id = NEW.comment_id;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.song_comments SET likes_count = likes_count - 1 WHERE id = OLD.comment_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ language 'plpgsql';

-- Add trigger for comment likes count
CREATE TRIGGER update_comment_likes_count_trigger
  AFTER INSERT OR DELETE ON public.comment_likes
  FOR EACH ROW EXECUTE FUNCTION update_comment_likes_count();

-- ============================================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================================

-- Indexes for songs
CREATE INDEX idx_songs_artist_id ON public.songs(artist_id);
CREATE INDEX idx_songs_album_id ON public.songs(album_id);
CREATE INDEX idx_songs_genre ON public.songs(genre);
CREATE INDEX idx_songs_year ON public.songs(year);

-- Indexes for playlists
CREATE INDEX idx_playlists_user_id ON public.playlists(user_id);
CREATE INDEX idx_playlists_is_public ON public.playlists(is_public);

-- Indexes for playlist_songs
CREATE INDEX idx_playlist_songs_playlist_id ON public.playlist_songs(playlist_id);
CREATE INDEX idx_playlist_songs_song_id ON public.playlist_songs(song_id);
CREATE INDEX idx_playlist_songs_position ON public.playlist_songs(playlist_id, position);

-- Indexes for follows
CREATE INDEX idx_user_follows_follower_id ON public.user_follows(follower_id);
CREATE INDEX idx_user_follows_following_id ON public.user_follows(following_id);

-- Indexes for comments
CREATE INDEX idx_song_comments_song_id ON public.song_comments(song_id);
CREATE INDEX idx_song_comments_user_id ON public.song_comments(user_id);

-- Indexes for playback history
CREATE INDEX idx_playback_history_user_id ON public.playback_history(user_id);
CREATE INDEX idx_playback_history_played_at ON public.playback_history(played_at);

-- ============================================================================
-- SAMPLE DATA (Optional - for development)
-- ============================================================================

-- Insert sample artists
INSERT INTO public.artists (name, bio, image_url, is_verified) VALUES
('The Weeknd', 'Canadian singer-songwriter', 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400', true),
('Billie Eilish', 'American singer-songwriter', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', true),
('Drake', 'Canadian rapper and singer', 'https://images.unsplash.com/photo-1471478331149-c72f17e33c73?w=400', true),
('Taylor Swift', 'American singer-songwriter', 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400', true);

-- Insert sample albums
INSERT INTO public.albums (title, artist_id, release_date, image_url, genre) VALUES
('After Hours', (SELECT id FROM public.artists WHERE name = 'The Weeknd'), '2020-03-20', 'https://www.cartacapital.com.br/wp-content/uploads/2021/11/pluralmusica.jpg', 'R&B'),
('Happier Than Ever', (SELECT id FROM public.artists WHERE name = 'Billie Eilish'), '2021-07-30', 'https://cdn-images.dzcdn.net/images/artist/ea589fefdebdefd0624edda903d07672/1900x1900-000000-81-0-0.jpg', 'Pop'),
('Certified Lover Boy', (SELECT id FROM public.artists WHERE name = 'Drake'), '2021-09-03', 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop', 'Hip-Hop'),
('Midnights', (SELECT id FROM public.artists WHERE name = 'Taylor Swift'), '2022-10-21', 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400&h=300&fit=crop', 'Pop');

-- Insert sample songs
INSERT INTO public.songs (title, artist_id, album_id, duration, audio_url, image_url, genre, year, track_number) VALUES
('Blinding Lights', (SELECT id FROM public.artists WHERE name = 'The Weeknd'), (SELECT id FROM public.albums WHERE title = 'After Hours'), 200, 'https://audio.ehit.app/songs/blinding-lights.mp3', 'https://www.cartacapital.com.br/wp-content/uploads/2021/11/pluralmusica.jpg', 'R&B', 2020, 1),
('Therefore I Am', (SELECT id FROM public.artists WHERE name = 'Billie Eilish'), (SELECT id FROM public.albums WHERE title = 'Happier Than Ever'), 174, 'https://audio.ehit.app/songs/therefore-i-am.mp3', 'https://cdn-images.dzcdn.net/images/artist/ea589fefdebdefd0624edda903d07672/1900x1900-000000-81-0-0.jpg', 'Pop', 2021, 1),
('Way 2 Sexy', (SELECT id FROM public.artists WHERE name = 'Drake'), (SELECT id FROM public.albums WHERE title = 'Certified Lover Boy'), 180, 'https://audio.ehit.app/songs/way-2-sexy.mp3', 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop', 'Hip-Hop', 2021, 1),
('Anti-Hero', (SELECT id FROM public.artists WHERE name = 'Taylor Swift'), (SELECT id FROM public.albums WHERE title = 'Midnights'), 201, 'https://audio.ehit.app/songs/anti-hero.mp3', 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400&h=300&fit=crop', 'Pop', 2022, 1);
