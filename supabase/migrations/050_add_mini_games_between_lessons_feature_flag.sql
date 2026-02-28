-- Add feature flag to control mini games shown between lessons
-- When disabled, users proceed directly to the next lesson without mini game breaks
INSERT INTO feature_flags (key, name, description, enabled) VALUES
  ('mini_games_between_lessons', 'Mini Games Between Lessons', 'Show vocabulary mini games (e.g. hangman, word search) after every 2 completed lessons', true)
ON CONFLICT (key) DO NOTHING;
