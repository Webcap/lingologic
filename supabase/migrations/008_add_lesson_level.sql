-- Add level column to lessons table for CEFR proficiency grouping (A1, A2, B1, B2, C1, C2)
ALTER TABLE lessons ADD COLUMN IF NOT EXISTS level TEXT;

-- Create index for level-based queries
CREATE INDEX IF NOT EXISTS idx_lessons_level ON lessons(language, level);

-- Add comment for documentation
COMMENT ON COLUMN lessons.level IS 'CEFR proficiency level: A1 (Beginner), A2 (Elementary), B1 (Intermediate), B2 (Upper Intermediate), C1 (Advanced), C2 (Proficient)';

