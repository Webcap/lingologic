-- Update mini game 4 to use imageToWord game type
-- This updates the games table constraint and mini game 4 entries for both languages

-- First, update the CHECK constraint to include 'imageToWord' game type and remove 'pictionary'
ALTER TABLE games
DROP CONSTRAINT IF EXISTS games_game_type_check;

ALTER TABLE games
ADD CONSTRAINT games_game_type_check 
CHECK (game_type IN ('vocabulary_review', 'word_search', 'neuro_match', 'syntax_constructor', 'pictionary', 'image_to_word'));

-- Update mini game 4 entries for both Spanish and English to imageToWord
-- Using the fun name that would be generated with Random(4) seed
-- From the imageToWord names list, index 2 is 'Image Quest' (Random(4).nextInt(12) = 2)
UPDATE games
SET 
  name = 'Image Quest',
  description = 'Type the word shown in the image',
  game_type = 'image_to_word',
  updated_at = NOW()
WHERE game_id IN ('minigame_spanish_4', 'minigame_english_4');

COMMENT ON COLUMN games.game_type IS 'Type of game: vocabulary_review, word_search, neuro_match, syntax_constructor, pictionary, image_to_word';

