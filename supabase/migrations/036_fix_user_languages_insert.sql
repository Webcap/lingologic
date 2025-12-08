-- Fix user_languages INSERT issue
-- The error "record new has no field updatedat" suggests a field name mismatch
-- This migration ensures the table structure is correct and handles inserts properly

-- Check and fix the table structure
DO $$
BEGIN
  -- Ensure updated_at column exists and has correct type
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_languages' 
    AND column_name = 'updated_at'
  ) THEN
    ALTER TABLE user_languages 
      ADD COLUMN updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
  END IF;
  
  -- Ensure the column name is exactly 'updated_at' (with underscore)
  -- PostgreSQL is case-sensitive for quoted identifiers, but unquoted are lowercased
  -- So 'updated_at' and 'updatedAt' would both be stored as 'updated_at'
  -- But if something is trying to access 'updatedat' (no underscore), that's the issue
  
END $$;

-- Make sure updated_at has a proper default for INSERT
ALTER TABLE user_languages 
  ALTER COLUMN updated_at SET DEFAULT NOW();

-- Drop any problematic triggers
DROP TRIGGER IF EXISTS update_user_languages_updated_at ON user_languages;

-- Recreate the trigger correctly (only for UPDATE, not INSERT)
-- For INSERT, the DEFAULT value handles it
CREATE TRIGGER update_user_languages_updated_at
  BEFORE UPDATE ON user_languages
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Verify the column exists and is accessible
DO $$
DECLARE
  col_exists BOOLEAN;
BEGIN
  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_languages' 
    AND column_name = 'updated_at'
  ) INTO col_exists;
  
  IF NOT col_exists THEN
    RAISE EXCEPTION 'Column updated_at does not exist on user_languages';
  END IF;
END $$;

