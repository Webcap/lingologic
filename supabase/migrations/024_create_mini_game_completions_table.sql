-- Create table to track mini game completions
CREATE TABLE IF NOT EXISTS mini_game_completions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  mini_game_id TEXT NOT NULL,
  completed_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  
  -- Ensure a user can only complete each mini game once
  UNIQUE(user_id, mini_game_id)
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_mini_game_completions_user_id ON mini_game_completions(user_id);
CREATE INDEX IF NOT EXISTS idx_mini_game_completions_mini_game_id ON mini_game_completions(mini_game_id);

-- Enable RLS
ALTER TABLE mini_game_completions ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can only see their own mini game completions
CREATE POLICY "Users can view their own mini game completions"
  ON mini_game_completions
  FOR SELECT
  USING (auth.uid() = user_id);

-- RLS Policy: Users can insert their own mini game completions
CREATE POLICY "Users can insert their own mini game completions"
  ON mini_game_completions
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

COMMENT ON TABLE mini_game_completions IS 'Tracks completion of mini games that appear between lessons';
COMMENT ON COLUMN mini_game_completions.mini_game_id IS 'Identifier for the mini game, e.g., minigame_spanish_1, minigame_english_2';

