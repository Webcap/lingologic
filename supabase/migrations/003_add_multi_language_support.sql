-- Multi-Language Support Migration
-- Run this after 002_add_lessons.sql migration

-- User Languages Table
-- Tracks which languages users are learning
CREATE TABLE IF NOT EXISTS user_languages (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  language TEXT NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT true,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  total_words_learned INTEGER NOT NULL DEFAULT 0,
  total_lessons_completed INTEGER NOT NULL DEFAULT 0,
  streak_days INTEGER NOT NULL DEFAULT 0,
  last_practiced_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (user_id, language)
);

-- Add language index for faster queries
CREATE INDEX IF NOT EXISTS idx_user_languages_user ON user_languages(user_id);
CREATE INDEX IF NOT EXISTS idx_user_languages_active ON user_languages(user_id, is_active);

-- Update game_sessions table to include language
ALTER TABLE game_sessions ADD COLUMN IF NOT EXISTS language TEXT;

-- Create index for language filtering in game_sessions
CREATE INDEX IF NOT EXISTS idx_game_sessions_language ON game_sessions(user_id, language);

-- Row Level Security Policies for user_languages
ALTER TABLE user_languages ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only see their own languages
CREATE POLICY "Users can view their own languages"
  ON user_languages
  FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: Users can insert their own languages
CREATE POLICY "Users can insert their own languages"
  ON user_languages
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own languages
CREATE POLICY "Users can update their own languages"
  ON user_languages
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can delete their own languages
CREATE POLICY "Users can delete their own languages"
  ON user_languages
  FOR DELETE
  USING (auth.uid() = user_id);

