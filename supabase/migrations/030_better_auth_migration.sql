-- Better Auth Migration
-- This migration creates the necessary tables for Better Auth
-- Run this after setting up Better Auth in the backend

-- Note: Better Auth CLI will create its own tables (user, session, account, verification)
-- This migration is for reference and to ensure compatibility with existing user_profiles

-- Ensure user_profiles table can work with Better Auth user IDs
-- The user_profiles.id should match Better Auth user.id

-- If migrating from Supabase Auth, you may need to update user_profiles.id values
-- to match Better Auth user.id values after running Better Auth migrations

-- Example migration script (run separately after Better Auth setup):
-- UPDATE user_profiles 
-- SET id = (SELECT id FROM better_auth_user WHERE email = user_profiles.email)
-- WHERE EXISTS (SELECT 1 FROM better_auth_user WHERE email = user_profiles.email);

-- RLS policies should continue to work as long as user_profiles.id matches Better Auth user.id
-- The backend will handle authentication and pass the user ID for RLS checks

