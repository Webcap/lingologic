-- Create games table for managing game IDs and names
CREATE TABLE IF NOT EXISTS games (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  game_id TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  description TEXT,
  game_type TEXT NOT NULL CHECK (game_type IN ('vocabulary_review', 'word_search', 'neuro_match', 'syntax_constructor')),
  language TEXT,
  mini_game_number INTEGER,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_games_game_id ON games(game_id);
CREATE INDEX IF NOT EXISTS idx_games_game_type ON games(game_type);
CREATE INDEX IF NOT EXISTS idx_games_language ON games(language);
CREATE INDEX IF NOT EXISTS idx_games_active ON games(is_active);

-- Seed initial games BEFORE enabling RLS (migrations run with elevated privileges)
-- This includes mini games and practice games that are already created in the app

-- Insert practice games (these are always available and shown in the Games tab)
-- Note: These don't use the minigame_ prefix and don't have language/mini_game_number
INSERT INTO games (game_id, name, description, game_type, is_active)
VALUES
  (
    'neuro_match',
    'Neuro Match',
    'Fast-paced word matching game where you match words as they fall from the top',
    'neuro_match',
    true
  ),
  (
    'syntax_constructor',
    'Syntax Constructor',
    'Build sentences by dragging and dropping words into the correct order',
    'syntax_constructor',
    true
  )
ON CONFLICT (game_id) DO UPDATE
SET 
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  game_type = EXCLUDED.game_type,
  updated_at = NOW();

-- Insert initial mini games for Spanish and English
-- These use the exact fun names from the getFunName function based on mini game number
-- Mini game 3 is always word_search, others default to vocabulary_review initially
-- Names are computed using Random(seed) where seed = miniGameNumber for consistency
INSERT INTO games (game_id, name, description, game_type, language, mini_game_number, is_active)
VALUES
  -- Spanish Mini Games (first 10)
  (
    'minigame_spanish_1',
    'Lexicon Quest',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'spanish',
    1,
    true
  ),
  (
    'minigame_spanish_2',
    'Word Wizard',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'spanish',
    2,
    true
  ),
  (
    'minigame_spanish_3',
    'Letter Quest',
    'Find hidden words in a letter grid',
    'word_search',
    'spanish',
    3,
    true
  ),
  (
    'minigame_spanish_4',
    'Word Warrior',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'spanish',
    4,
    true
  ),
  (
    'minigame_spanish_5',
    'Dictionary Dash',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'spanish',
    5,
    true
  ),
  (
    'minigame_spanish_6',
    'Dictionary Dash',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'spanish',
    6,
    true
  ),
  (
    'minigame_spanish_7',
    'Word Whiz',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'spanish',
    7,
    true
  ),
  (
    'minigame_spanish_8',
    'Word Warrior',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'spanish',
    8,
    true
  ),
  (
    'minigame_spanish_9',
    'Vocab Venture',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'spanish',
    9,
    true
  ),
  (
    'minigame_spanish_10',
    'Dictionary Dash',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'spanish',
    10,
    true
  ),
  -- English Mini Games (first 10)
  (
    'minigame_english_1',
    'Lexicon Quest',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'english',
    1,
    true
  ),
  (
    'minigame_english_2',
    'Word Wizard',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'english',
    2,
    true
  ),
  (
    'minigame_english_3',
    'Letter Quest',
    'Find hidden words in a letter grid',
    'word_search',
    'english',
    3,
    true
  ),
  (
    'minigame_english_4',
    'Word Warrior',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'english',
    4,
    true
  ),
  (
    'minigame_english_5',
    'Dictionary Dash',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'english',
    5,
    true
  ),
  (
    'minigame_english_6',
    'Dictionary Dash',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'english',
    6,
    true
  ),
  (
    'minigame_english_7',
    'Word Whiz',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'english',
    7,
    true
  ),
  (
    'minigame_english_8',
    'Word Warrior',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'english',
    8,
    true
  ),
  (
    'minigame_english_9',
    'Vocab Venture',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'english',
    9,
    true
  ),
  (
    'minigame_english_10',
    'Dictionary Dash',
    'Test your vocabulary knowledge with multiple choice questions',
    'vocabulary_review',
    'english',
    10,
    true
  )
ON CONFLICT (game_id) DO UPDATE
SET 
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  game_type = EXCLUDED.game_type,
  language = EXCLUDED.language,
  mini_game_number = EXCLUDED.mini_game_number,
  updated_at = NOW();

-- Enable RLS after inserting seed data
ALTER TABLE games ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Everyone can view active games
CREATE POLICY "Anyone can view active games"
  ON games
  FOR SELECT
  USING (is_active = true);

-- RLS Policy: Only admins can insert games
CREATE POLICY "Only admins can insert games"
  ON games
  FOR INSERT
  WITH CHECK (is_admin());

-- RLS Policy: Only admins can update games
CREATE POLICY "Only admins can update games"
  ON games
  FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

-- RLS Policy: Only admins can delete games
CREATE POLICY "Only admins can delete games"
  ON games
  FOR DELETE
  USING (is_admin());

-- Create trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_games_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_games_updated_at
  BEFORE UPDATE ON games
  FOR EACH ROW
  EXECUTE FUNCTION update_games_updated_at();

COMMENT ON TABLE games IS 'Stores game IDs and names for mini games and practice games. Practice games are always available, mini games unlock as users progress through lessons.';
COMMENT ON COLUMN games.game_id IS 'Unique identifier for the game (e.g., minigame_spanish_1, minigame_english_2)';
COMMENT ON COLUMN games.name IS 'Display name for the game (e.g., Word Wizard, Letter Hunt)';
COMMENT ON COLUMN games.game_type IS 'Type of game: vocabulary_review, word_search, neuro_match, syntax_constructor';
COMMENT ON COLUMN games.language IS 'Language code (e.g., spanish, english)';
COMMENT ON COLUMN games.mini_game_number IS 'Mini game number (1, 2, 3, etc.)';
