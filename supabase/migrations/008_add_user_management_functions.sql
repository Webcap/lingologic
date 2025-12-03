-- User Management Functions for Admin Panel
-- Allows admins to view and manage users

-- Function to get all users with their profile data (admin only)
CREATE OR REPLACE FUNCTION get_all_users()
RETURNS TABLE(
  id UUID,
  email TEXT,
  created_at TIMESTAMPTZ,
  streak_days INTEGER,
  total_time_minutes INTEGER,
  is_admin BOOLEAN,
  last_activity TIMESTAMPTZ
) AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Access denied. Admin privileges required.';
  END IF;
  RETURN QUERY
  SELECT 
    up.id,
    up.email,
    up.created_at,
    up.streak_days,
    up.total_time_minutes,
    COALESCE(up.is_admin, false) as is_admin,
    up.updated_at as last_activity
  FROM user_profiles up
  ORDER BY up.created_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get user details with activity stats (admin only)
CREATE OR REPLACE FUNCTION get_user_details(user_uuid UUID)
RETURNS TABLE(
  id UUID,
  email TEXT,
  created_at TIMESTAMPTZ,
  streak_days INTEGER,
  total_time_minutes INTEGER,
  is_admin BOOLEAN,
  lessons_completed INTEGER,
  words_mastered INTEGER,
  game_sessions INTEGER,
  languages_learning TEXT[]
) AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Access denied. Admin privileges required.';
  END IF;
  RETURN QUERY
  SELECT 
    up.id,
    up.email,
    up.created_at,
    up.streak_days,
    up.total_time_minutes,
    COALESCE(up.is_admin, false) as is_admin,
    (SELECT COUNT(*) FROM lesson_progress WHERE user_id = user_uuid AND status = 'completed') as lessons_completed,
    (SELECT COUNT(*) FROM word_mastery WHERE user_id = user_uuid AND mastery_level >= 3) as words_mastered,
    (SELECT COUNT(*) FROM game_sessions WHERE user_id = user_uuid) as game_sessions,
    (SELECT ARRAY_AGG(language) FROM user_languages WHERE user_id = user_uuid AND is_active = true) as languages_learning
  FROM user_profiles up
  WHERE up.id = user_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to update user admin status (admin only)
CREATE OR REPLACE FUNCTION update_user_admin_status(user_uuid UUID, admin_status BOOLEAN)
RETURNS BOOLEAN AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Access denied. Admin privileges required.';
  END IF;
  
  -- Prevent removing your own admin status
  IF user_uuid = auth.uid() AND admin_status = false THEN
    RAISE EXCEPTION 'Cannot remove your own admin status.';
  END IF;
  
  UPDATE user_profiles
  SET is_admin = admin_status
  WHERE id = user_uuid;
  
  RETURN FOUND;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION get_all_users() TO authenticated;
GRANT EXECUTE ON FUNCTION get_user_details(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION update_user_admin_status(UUID, BOOLEAN) TO authenticated;

