-- Add admin role to user_profiles for lesson builder admin panel
-- Run this migration to enable admin access to lesson CRUD operations

-- Add is_admin column to user_profiles
ALTER TABLE user_profiles 
ADD COLUMN IF NOT EXISTS is_admin BOOLEAN NOT NULL DEFAULT false;

-- Create index for admin lookups
CREATE INDEX IF NOT EXISTS idx_user_profiles_is_admin ON user_profiles(is_admin) WHERE is_admin = true;

-- Function to check if current user is admin
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM user_profiles 
    WHERE id = auth.uid() 
    AND is_admin = true
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION is_admin() TO authenticated;

-- Update RLS policies for lessons table to allow admin CRUD operations

-- Admin can insert lessons
CREATE POLICY "Admins can insert lessons"
  ON lessons FOR INSERT
  WITH CHECK (is_admin());

-- Admin can update lessons
CREATE POLICY "Admins can update lessons"
  ON lessons FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

-- Admin can delete lessons
CREATE POLICY "Admins can delete lessons"
  ON lessons FOR DELETE
  USING (is_admin());

-- Note: To make a user an admin, run:
-- UPDATE user_profiles SET is_admin = true WHERE id = '<user_uuid>';

