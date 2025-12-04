-- Add game_type column to mini_game_completions table to track which game type was played
ALTER TABLE mini_game_completions 
ADD COLUMN IF NOT EXISTS game_type TEXT;

-- Add index for faster lookups by game type
CREATE INDEX IF NOT EXISTS idx_mini_game_completions_game_type 
ON mini_game_completions(game_type);

COMMENT ON COLUMN mini_game_completions.game_type IS 'Type of mini game played: vocabulary_review, word_search, neuro_match, syntax_constructor';

-- Note: We keep the existing unique constraint (user_id, mini_game_id) since each mini game number
-- should only be completed once. The game_type is just for tracking which type was played.

