-- Add trigger to automatically update updated_at for user_languages
-- This ensures updated_at is always set, even if not provided in insert/update

-- The function update_updated_at_column() already exists from 001_initial_schema.sql
-- We just need to add the trigger for user_languages

CREATE TRIGGER update_user_languages_updated_at
  BEFORE UPDATE ON user_languages
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Note: For INSERT, the default value (NOW()) in the schema handles it
-- This trigger only handles UPDATE operations




