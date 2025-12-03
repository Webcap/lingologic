-- Add last_activity_date to user_profiles for streak tracking
-- Run this migration to enable proper streak calculation

ALTER TABLE user_profiles 
ADD COLUMN IF NOT EXISTS last_activity_date TIMESTAMPTZ;

-- Set existing records' last_activity_date to created_at if null
UPDATE user_profiles 
SET last_activity_date = created_at 
WHERE last_activity_date IS NULL;

