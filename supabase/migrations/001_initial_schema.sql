-- LingoLogic MVP Database Schema
-- Run this in your Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- User Profiles Table
-- Links to auth.users via id
CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  streak_days INTEGER NOT NULL DEFAULT 0,
  total_time_minutes INTEGER NOT NULL DEFAULT 0,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Words Table
-- Vocabulary database for all languages
CREATE TABLE IF NOT EXISTS words (
  id TEXT PRIMARY KEY,
  language TEXT NOT NULL,
  word_text TEXT NOT NULL,
  translation TEXT NOT NULL,
  image_url TEXT,
  audio_url TEXT,
  category TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Word Mastery Table
-- SRS tracking for user word progress
CREATE TABLE IF NOT EXISTS word_mastery (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  word_id TEXT NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  mastery_level INTEGER NOT NULL DEFAULT 0,
  next_review_date TIMESTAMPTZ,
  ease_factor REAL NOT NULL DEFAULT 2.5,
  interval_days INTEGER NOT NULL DEFAULT 1,
  last_reviewed TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (user_id, word_id)
);

-- Game Sessions Table
-- Track user game sessions
CREATE TABLE IF NOT EXISTS game_sessions (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  game_type TEXT NOT NULL CHECK (game_type IN ('neuro_match', 'syntax_constructor')),
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ,
  score INTEGER NOT NULL DEFAULT 0,
  difficulty_level TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Sync Queue Table
-- Offline sync tracking
CREATE TABLE IF NOT EXISTS sync_queue (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  table_name TEXT NOT NULL,
  operation TEXT NOT NULL CHECK (operation IN ('insert', 'update', 'delete')),
  data JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  synced_at TIMESTAMPTZ
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_word_mastery_user ON word_mastery(user_id);
CREATE INDEX IF NOT EXISTS idx_word_mastery_review ON word_mastery(next_review_date);
CREATE INDEX IF NOT EXISTS idx_word_mastery_word ON word_mastery(word_id);
CREATE INDEX IF NOT EXISTS idx_game_sessions_user ON game_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_game_sessions_type ON game_sessions(game_type);
CREATE INDEX IF NOT EXISTS idx_sync_queue_user ON sync_queue(user_id);
CREATE INDEX IF NOT EXISTS idx_sync_queue_synced ON sync_queue(synced_at);
CREATE INDEX IF NOT EXISTS idx_words_language ON words(language);
CREATE INDEX IF NOT EXISTS idx_words_category ON words(category);

-- Row Level Security (RLS) Policies

-- Enable RLS on all tables
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE word_mastery ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE sync_queue ENABLE ROW LEVEL SECURITY;

-- Words table is public (read-only for all authenticated users)
ALTER TABLE words ENABLE ROW LEVEL SECURITY;

-- User Profiles Policies
CREATE POLICY "Users can view their own profile"
  ON user_profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile"
  ON user_profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
  ON user_profiles FOR UPDATE
  USING (auth.uid() = id);

-- Word Mastery Policies
CREATE POLICY "Users can view their own word mastery"
  ON word_mastery FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own word mastery"
  ON word_mastery FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own word mastery"
  ON word_mastery FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own word mastery"
  ON word_mastery FOR DELETE
  USING (auth.uid() = user_id);

-- Game Sessions Policies
CREATE POLICY "Users can view their own game sessions"
  ON game_sessions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own game sessions"
  ON game_sessions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own game sessions"
  ON game_sessions FOR UPDATE
  USING (auth.uid() = user_id);

-- Sync Queue Policies
CREATE POLICY "Users can view their own sync queue items"
  ON sync_queue FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own sync queue items"
  ON sync_queue FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own sync queue items"
  ON sync_queue FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own sync queue items"
  ON sync_queue FOR DELETE
  USING (auth.uid() = user_id);

-- Words Policies (public read for authenticated users)
CREATE POLICY "Authenticated users can view words"
  ON words FOR SELECT
  TO authenticated
  USING (true);

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers to auto-update updated_at
CREATE TRIGGER update_user_profiles_updated_at
  BEFORE UPDATE ON user_profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_word_mastery_updated_at
  BEFORE UPDATE ON word_mastery
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

