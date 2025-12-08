-- Fix user_languages table structure for Better Auth
-- The original table had user_id as UUID referencing auth.users(id)
-- We need to ensure it's properly set up for TEXT user IDs

-- First, ensure user_id is TEXT (should already be done by 032, but just in case)
DO $$ 
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_languages' 
    AND column_name = 'user_id' 
    AND data_type = 'uuid'
  ) THEN
    -- Drop the old foreign key if it exists
    ALTER TABLE user_languages 
      DROP CONSTRAINT IF EXISTS user_languages_user_id_fkey;
    
    -- Change to TEXT
    ALTER TABLE user_languages 
      ALTER COLUMN user_id TYPE TEXT;
  END IF;
END $$;

-- Ensure updated_at has a default (should already exist, but ensure it)
ALTER TABLE user_languages 
  ALTER COLUMN updated_at SET DEFAULT NOW();

-- Add trigger for updated_at if it doesn't exist
DROP TRIGGER IF EXISTS update_user_languages_updated_at ON user_languages;

CREATE TRIGGER update_user_languages_updated_at
  BEFORE UPDATE ON user_languages
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Ensure foreign key to user_profiles exists
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE constraint_name = 'user_languages_user_id_fkey'
    AND table_name = 'user_languages'
  ) THEN
    ALTER TABLE user_languages 
      ADD CONSTRAINT user_languages_user_id_fkey 
      FOREIGN KEY (user_id) REFERENCES user_profiles(id) ON DELETE CASCADE;
  END IF;
END $$;

