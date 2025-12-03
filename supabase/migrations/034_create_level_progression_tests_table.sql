-- Create table to track level progression tests
-- Users can take a knowledge test after completing 60% of a level to advance early

CREATE TABLE IF NOT EXISTS level_progression_tests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  language TEXT NOT NULL,
  level TEXT NOT NULL CHECK (level IN ('A1', 'A2', 'B1', 'B2', 'C1', 'C2')),
  passed BOOLEAN NOT NULL DEFAULT false,
  score INTEGER NOT NULL DEFAULT 0 CHECK (score >= 0 AND score <= 100),
  total_questions INTEGER NOT NULL DEFAULT 0,
  completed_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  
  -- Ensure a user can only have one test record per level per language
  UNIQUE(user_id, language, level)
);

-- Create indexes for faster lookups
CREATE INDEX IF NOT EXISTS idx_level_progression_tests_user_id ON level_progression_tests(user_id);
CREATE INDEX IF NOT EXISTS idx_level_progression_tests_language_level ON level_progression_tests(language, level);
CREATE INDEX IF NOT EXISTS idx_level_progression_tests_passed ON level_progression_tests(passed);

-- Enable RLS
ALTER TABLE level_progression_tests ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can view their own level progression tests
CREATE POLICY "Users can view their own level progression tests"
  ON level_progression_tests
  FOR SELECT
  USING (auth.uid() = user_id);

-- RLS Policy: Users can insert their own level progression tests
CREATE POLICY "Users can insert their own level progression tests"
  ON level_progression_tests
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- RLS Policy: Users can update their own level progression tests
CREATE POLICY "Users can update their own level progression tests"
  ON level_progression_tests
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_level_progression_tests_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_level_progression_tests_updated_at
  BEFORE UPDATE ON level_progression_tests
  FOR EACH ROW
  EXECUTE FUNCTION update_level_progression_tests_updated_at();

COMMENT ON TABLE level_progression_tests IS 'Tracks level progression knowledge tests. Users can take a test after completing 60% of a level to advance early.';
COMMENT ON COLUMN level_progression_tests.level IS 'CEFR level (A1, A2, B1, B2, C1, C2)';
COMMENT ON COLUMN level_progression_tests.passed IS 'Whether the user passed the test (typically requires 70% or higher score)';
COMMENT ON COLUMN level_progression_tests.score IS 'Test score as a percentage (0-100)';

