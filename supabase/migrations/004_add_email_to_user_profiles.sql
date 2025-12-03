-- Add email column to user_profiles table
-- Migration: 004_add_email_to_user_profiles.sql

ALTER TABLE user_profiles 
ADD COLUMN IF NOT EXISTS email TEXT;

-- Update existing profiles with email from auth.users
UPDATE user_profiles up
SET email = au.email
FROM auth.users au
WHERE up.id = au.id AND up.email IS NULL;

-- Make email NOT NULL for new records (but allow NULL for existing records during migration)
-- Note: You may want to make this NOT NULL after ensuring all existing records have emails

-- Add index on email for faster lookups
CREATE INDEX IF NOT EXISTS idx_user_profiles_email ON user_profiles(email);


