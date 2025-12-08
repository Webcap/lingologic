-- Update user_profiles and related tables to support Better Auth TEXT IDs
-- Better Auth uses TEXT IDs (not UUIDs), so we need to change all user_id columns

-- Step 1: Drop RLS policies that depend on user_id columns (must be done before altering columns)
DROP POLICY IF EXISTS "Users can view their own profile" ON user_profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON user_profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON user_profiles;

DROP POLICY IF EXISTS "Users can view their own word mastery" ON word_mastery;
DROP POLICY IF EXISTS "Users can insert their own word mastery" ON word_mastery;
DROP POLICY IF EXISTS "Users can update their own word mastery" ON word_mastery;
DROP POLICY IF EXISTS "Users can delete their own word mastery" ON word_mastery;

DROP POLICY IF EXISTS "Users can view their own game sessions" ON game_sessions;
DROP POLICY IF EXISTS "Users can insert their own game sessions" ON game_sessions;
DROP POLICY IF EXISTS "Users can update their own game sessions" ON game_sessions;

DROP POLICY IF EXISTS "Users can view their own sync queue items" ON sync_queue;
DROP POLICY IF EXISTS "Users can insert their own sync queue items" ON sync_queue;
DROP POLICY IF EXISTS "Users can update their own sync queue items" ON sync_queue;
DROP POLICY IF EXISTS "Users can delete their own sync queue items" ON sync_queue;

-- Drop policies for other tables that might exist
DROP POLICY IF EXISTS "Users can view their own lesson progress" ON lesson_progress;
DROP POLICY IF EXISTS "Users can insert their own lesson progress" ON lesson_progress;
DROP POLICY IF EXISTS "Users can update their own lesson progress" ON lesson_progress;

DROP POLICY IF EXISTS "Users can view their own languages" ON user_languages;
DROP POLICY IF EXISTS "Users can insert their own languages" ON user_languages;
DROP POLICY IF EXISTS "Users can update their own languages" ON user_languages;
DROP POLICY IF EXISTS "Users can delete their own languages" ON user_languages;

-- Drop policies for mini_game_completions and level_progression_tests if they exist
DROP POLICY IF EXISTS "Users can view their own mini game completions" ON mini_game_completions;
DROP POLICY IF EXISTS "Users can insert their own mini game completions" ON mini_game_completions;
DROP POLICY IF EXISTS "Users can update their own mini game completions" ON mini_game_completions;

DROP POLICY IF EXISTS "Users can view their own level progression tests" ON level_progression_tests;
DROP POLICY IF EXISTS "Users can insert their own level progression tests" ON level_progression_tests;
DROP POLICY IF EXISTS "Users can update their own level progression tests" ON level_progression_tests;

-- Step 2: Drop foreign key constraints to auth.users (we're using Better Auth now)
ALTER TABLE user_profiles 
  DROP CONSTRAINT IF EXISTS user_profiles_id_fkey;

ALTER TABLE word_mastery 
  DROP CONSTRAINT IF EXISTS word_mastery_user_id_fkey;

ALTER TABLE game_sessions 
  DROP CONSTRAINT IF EXISTS game_sessions_user_id_fkey;

ALTER TABLE sync_queue 
  DROP CONSTRAINT IF EXISTS sync_queue_user_id_fkey;

ALTER TABLE lesson_progress 
  DROP CONSTRAINT IF EXISTS lesson_progress_user_id_fkey;

ALTER TABLE user_languages 
  DROP CONSTRAINT IF EXISTS user_languages_user_id_fkey;

-- Also drop the old foreign key constraint that references auth.users
ALTER TABLE user_languages 
  DROP CONSTRAINT IF EXISTS user_languages_user_id_fkey;

ALTER TABLE mini_game_completions 
  DROP CONSTRAINT IF EXISTS mini_game_completions_user_id_fkey;

ALTER TABLE level_progression_tests 
  DROP CONSTRAINT IF EXISTS level_progression_tests_user_id_fkey;

-- Step 3: Change user_profiles.id from UUID to TEXT
ALTER TABLE user_profiles 
  ALTER COLUMN id TYPE TEXT;

-- Step 4: Change all user_id columns from UUID to TEXT
ALTER TABLE word_mastery 
  ALTER COLUMN user_id TYPE TEXT;

ALTER TABLE game_sessions 
  ALTER COLUMN user_id TYPE TEXT;

ALTER TABLE sync_queue 
  ALTER COLUMN user_id TYPE TEXT;

ALTER TABLE lesson_progress 
  ALTER COLUMN user_id TYPE TEXT;

ALTER TABLE user_languages 
  ALTER COLUMN user_id TYPE TEXT;

ALTER TABLE mini_game_completions 
  ALTER COLUMN user_id TYPE TEXT;

ALTER TABLE level_progression_tests 
  ALTER COLUMN user_id TYPE TEXT;

-- Step 5: Re-add foreign key constraints (now referencing user_profiles instead of auth.users)
ALTER TABLE word_mastery 
  ADD CONSTRAINT word_mastery_user_id_fkey 
  FOREIGN KEY (user_id) REFERENCES user_profiles(id) ON DELETE CASCADE;

ALTER TABLE game_sessions 
  ADD CONSTRAINT game_sessions_user_id_fkey 
  FOREIGN KEY (user_id) REFERENCES user_profiles(id) ON DELETE CASCADE;

ALTER TABLE sync_queue 
  ADD CONSTRAINT sync_queue_user_id_fkey 
  FOREIGN KEY (user_id) REFERENCES user_profiles(id) ON DELETE CASCADE;

ALTER TABLE lesson_progress 
  ADD CONSTRAINT lesson_progress_user_id_fkey 
  FOREIGN KEY (user_id) REFERENCES user_profiles(id) ON DELETE CASCADE;

ALTER TABLE user_languages 
  ADD CONSTRAINT user_languages_user_id_fkey 
  FOREIGN KEY (user_id) REFERENCES user_profiles(id) ON DELETE CASCADE;

ALTER TABLE mini_game_completions 
  ADD CONSTRAINT mini_game_completions_user_id_fkey 
  FOREIGN KEY (user_id) REFERENCES user_profiles(id) ON DELETE CASCADE;

ALTER TABLE level_progression_tests 
  ADD CONSTRAINT level_progression_tests_user_id_fkey 
  FOREIGN KEY (user_id) REFERENCES user_profiles(id) ON DELETE CASCADE;

-- Step 6: Recreate RLS policies (updated for Better Auth - using service role for now)
-- Note: Since we're using Better Auth, RLS policies using auth.uid() won't work
-- The backend uses service role for user profile operations
-- These policies are kept for future use if we implement Better Auth JWT tokens

-- User Profiles Policies (disabled for now - backend uses service role)
-- CREATE POLICY "Users can view their own profile"
--   ON user_profiles FOR SELECT
--   USING (true); -- Will be updated when Better Auth JWT is implemented

-- Step 7: Add comments
COMMENT ON COLUMN user_profiles.id IS 'Better Auth user ID (TEXT format)';
COMMENT ON COLUMN word_mastery.user_id IS 'Better Auth user ID (TEXT format)';
COMMENT ON COLUMN game_sessions.user_id IS 'Better Auth user ID (TEXT format)';
COMMENT ON COLUMN sync_queue.user_id IS 'Better Auth user ID (TEXT format)';
COMMENT ON COLUMN lesson_progress.user_id IS 'Better Auth user ID (TEXT format)';
COMMENT ON COLUMN user_languages.user_id IS 'Better Auth user ID (TEXT format)';
COMMENT ON COLUMN mini_game_completions.user_id IS 'Better Auth user ID (TEXT format)';
COMMENT ON COLUMN level_progression_tests.user_id IS 'Better Auth user ID (TEXT format)';

-- Note: RLS policies using auth.uid() will need to be updated separately
-- For now, the backend uses service role for user profile operations
