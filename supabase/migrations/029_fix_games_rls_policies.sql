-- Fix RLS policies for games table
-- Allow admins to view all games (not just active ones) and ensure update/delete policies work correctly

-- Drop existing SELECT policy
DROP POLICY IF EXISTS "Anyone can view active games" ON games;

-- Create new SELECT policy: Everyone can view active games, admins can view all games
CREATE POLICY "Anyone can view active games, admins can view all"
  ON games
  FOR SELECT
  USING (is_active = true OR is_admin());

-- Ensure UPDATE policy is correct (should already exist, but verify)
DROP POLICY IF EXISTS "Only admins can update games" ON games;
CREATE POLICY "Only admins can update games"
  ON games
  FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

-- Ensure DELETE policy is correct
DROP POLICY IF EXISTS "Only admins can delete games" ON games;
CREATE POLICY "Only admins can delete games"
  ON games
  FOR DELETE
  USING (is_admin());

-- Ensure INSERT policy is correct
DROP POLICY IF EXISTS "Only admins can insert games" ON games;
CREATE POLICY "Only admins can insert games"
  ON games
  FOR INSERT
  WITH CHECK (is_admin());

COMMENT ON POLICY "Anyone can view active games, admins can view all" ON games IS 
  'Regular users can only see active games. Admins can see all games for management purposes.';

