-- Fix RLS policies for Better Auth
-- Since we're using Better Auth, RLS policies using auth.uid() won't work
-- The backend uses service role key to manage user data
-- Disable RLS on all user-related tables to allow backend to manage data

-- Disable RLS on all tables that reference user_id
ALTER TABLE user_profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_languages DISABLE ROW LEVEL SECURITY;
ALTER TABLE word_mastery DISABLE ROW LEVEL SECURITY;
ALTER TABLE game_sessions DISABLE ROW LEVEL SECURITY;
ALTER TABLE sync_queue DISABLE ROW LEVEL SECURITY;
ALTER TABLE lesson_progress DISABLE ROW LEVEL SECURITY;
ALTER TABLE mini_game_completions DISABLE ROW LEVEL SECURITY;
ALTER TABLE level_progression_tests DISABLE ROW LEVEL SECURITY;

-- Note: Authorization is handled by the backend API, not by Supabase RLS
-- The backend uses service role key which would bypass RLS anyway,
-- but disabling RLS makes it explicit and avoids policy conflicts
