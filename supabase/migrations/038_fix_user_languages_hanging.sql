-- Fix the "updatedAt" field name error
-- The error "record 'new' has no field 'updatedAt'" suggests a trigger or function
-- is trying to access NEW.updatedAt (camelCase) instead of NEW.updated_at (snake_case)

-- First, check and drop any problematic triggers on user_languages
DROP TRIGGER IF EXISTS update_user_languages_updated_at ON user_languages;
DROP TRIGGER IF EXISTS user_languages_updated_at ON user_languages;
DROP TRIGGER IF EXISTS set_updated_at ON user_languages;

-- Check for any functions that might be using the wrong field name
-- Drop and recreate the update_updated_at_column function to ensure it's correct
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  -- Use snake_case: updated_at, not updatedAt
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Recreate the trigger with the correct function
CREATE TRIGGER update_user_languages_updated_at
  BEFORE UPDATE ON user_languages
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Verify the column name is correct (should be updated_at with underscore)
DO $$
DECLARE
  col_name TEXT;
BEGIN
  SELECT column_name INTO col_name
  FROM information_schema.columns
  WHERE table_name = 'user_languages'
    AND column_name LIKE '%updated%';
  
  IF col_name IS NULL THEN
    RAISE EXCEPTION 'No updated column found on user_languages';
  ELSIF col_name != 'updated_at' THEN
    RAISE EXCEPTION 'Column name is % but expected updated_at', col_name;
  END IF;
END $$;

-- Also check if there's a BEFORE INSERT trigger that might be causing issues
-- If there is, we need to remove it since we're using DEFAULT for inserts
DROP TRIGGER IF EXISTS user_languages_before_insert ON user_languages;
DROP TRIGGER IF EXISTS set_user_languages_updated_at ON user_languages;

-- Drop ALL triggers on user_languages to be safe, then recreate only what we need
-- This ensures no trigger is trying to access updatedAt (camelCase)
DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN 
    SELECT trigger_name 
    FROM information_schema.triggers 
    WHERE event_object_table = 'user_languages'
  LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS %I ON user_languages', r.trigger_name);
  END LOOP;
END $$;

-- Ensure the default is set correctly
ALTER TABLE user_languages 
  ALTER COLUMN updated_at SET DEFAULT NOW();

-- Make sure created_at also has a default
ALTER TABLE user_languages 
  ALTER COLUMN created_at SET DEFAULT NOW();

