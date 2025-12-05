-- Add charades to the game_type CHECK constraint
ALTER TABLE games
DROP CONSTRAINT IF EXISTS games_game_type_check;

ALTER TABLE games
ADD CONSTRAINT games_game_type_check
CHECK (game_type IN (
  'vocabulary_review',
  'word_search',
  'neuro_match',
  'syntax_constructor',
  'pictionary',
  'image_to_word',
  'hangman',
  'charades'
));

-- Update the comment to reflect the new game type
COMMENT ON COLUMN games.game_type IS 'Type of game: vocabulary_review, word_search, neuro_match, syntax_constructor, pictionary, image_to_word, hangman, charades';

