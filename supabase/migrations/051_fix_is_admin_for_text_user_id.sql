-- Fix is_admin() for Better Auth: user_profiles.id is TEXT (migration 032) but auth.uid() returns UUID
-- The comparison id = auth.uid() fails with "operator does not exist: text = uuid"
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM user_profiles 
    WHERE id = auth.uid()::text 
    AND is_admin = true
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
