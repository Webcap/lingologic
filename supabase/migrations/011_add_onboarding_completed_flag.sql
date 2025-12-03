-- Add onboarding_completed flag to user_profiles table
-- This explicitly tracks whether a user has completed the language selection onboarding

ALTER TABLE user_profiles 
ADD COLUMN IF NOT EXISTS onboarding_completed BOOLEAN NOT NULL DEFAULT false;

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_user_profiles_onboarding ON user_profiles(onboarding_completed) 
WHERE onboarding_completed = false;

-- Set existing users with languages to have completed onboarding
-- (assuming they've already selected languages)
UPDATE user_profiles
SET onboarding_completed = true
WHERE id IN (
  SELECT DISTINCT user_id 
  FROM user_languages
);

-- Add comment for documentation
COMMENT ON COLUMN user_profiles.onboarding_completed IS 'Tracks whether user has completed the initial language selection onboarding flow';

