-- Remove game-related feature flags
-- Games should only be managed in the game manager, not through feature flags

-- Delete game-related feature flags
DELETE FROM feature_flags 
WHERE key IN ('mini_games', 'neuro_match_game');

COMMENT ON TABLE feature_flags IS 'Feature flags to control which features are enabled in the application. Note: Games are managed separately in the games table, not through feature flags.';

