-- Update mini game 4 to use pictionary game type
-- This updates the games table constraint and mini game 4 entries for both languages

-- First, update the CHECK constraint to include 'pictionary' game type
ALTER TABLE games
DROP CONSTRAINT IF EXISTS games_game_type_check;

ALTER TABLE games
ADD CONSTRAINT games_game_type_check 
CHECK (game_type IN ('vocabulary_review', 'word_search', 'neuro_match', 'syntax_constructor', 'pictionary'));

-- Update mini game 4 entries for both Spanish and English to pictionary
-- Using the fun name that would be generated with Random(4) seed
-- From the pictionary names list, index 3 is 'Draw Quest' (Random(4).nextInt(12) = 3)
UPDATE games
SET 
  name = 'Draw Quest',
  description = 'Draw words to reinforce visual memory',
  game_type = 'pictionary',
  updated_at = NOW()
WHERE game_id IN ('minigame_spanish_4', 'minigame_english_4');

COMMENT ON COLUMN games.game_type IS 'Type of game: vocabulary_review, word_search, neuro_match, syntax_constructor, pictionary';

