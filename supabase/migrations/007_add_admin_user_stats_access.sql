-- Admin User Statistics Access Migration
-- Allows admins to view aggregated user statistics for dashboard

-- Function to get total user count (admin only)
-- Counts all users including admins (total registered users)
CREATE OR REPLACE FUNCTION get_total_users()
RETURNS INTEGER AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Access denied. Admin privileges required.';
  END IF;
  -- Count all users from user_profiles table (real data from database)
  RETURN (SELECT COUNT(*) FROM user_profiles);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get active users (users with activity in last 30 days)
CREATE OR REPLACE FUNCTION get_active_users()
RETURNS INTEGER AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Access denied. Admin privileges required.';
  END IF;
  RETURN (
    SELECT COUNT(DISTINCT user_id)
    FROM (
      SELECT user_id FROM lesson_progress WHERE updated_at > NOW() - INTERVAL '30 days'
      UNION
      SELECT user_id FROM word_mastery WHERE updated_at > NOW() - INTERVAL '30 days'
      UNION
      SELECT user_id FROM game_sessions WHERE created_at > NOW() - INTERVAL '30 days'
    ) AS active_users
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get total lessons completed
CREATE OR REPLACE FUNCTION get_total_lessons_completed()
RETURNS INTEGER AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Access denied. Admin privileges required.';
  END IF;
  RETURN (
    SELECT COUNT(*) 
    FROM lesson_progress 
    WHERE status = 'completed'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get total words mastered
CREATE OR REPLACE FUNCTION get_total_words_mastered()
RETURNS INTEGER AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Access denied. Admin privileges required.';
  END IF;
  RETURN (
    SELECT COUNT(*) 
    FROM word_mastery 
    WHERE mastery_level >= 3
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get users by language
CREATE OR REPLACE FUNCTION get_users_by_language()
RETURNS TABLE(language TEXT, user_count BIGINT) AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Access denied. Admin privileges required.';
  END IF;
  RETURN QUERY
  SELECT 
    ul.language,
    COUNT(DISTINCT ul.user_id) as user_count
  FROM user_languages ul
  WHERE ul.is_active = true
  GROUP BY ul.language
  ORDER BY user_count DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get total game sessions
CREATE OR REPLACE FUNCTION get_total_game_sessions()
RETURNS INTEGER AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Access denied. Admin privileges required.';
  END IF;
  RETURN (SELECT COUNT(*) FROM game_sessions);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get average streak days
CREATE OR REPLACE FUNCTION get_average_streak_days()
RETURNS NUMERIC AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Access denied. Admin privileges required.';
  END IF;
  RETURN (
    SELECT COALESCE(AVG(streak_days), 0)
    FROM user_profiles
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get total time spent learning (in minutes)
CREATE OR REPLACE FUNCTION get_total_time_spent()
RETURNS INTEGER AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Access denied. Admin privileges required.';
  END IF;
  RETURN (
    SELECT COALESCE(SUM(total_time_minutes), 0)
    FROM user_profiles
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permissions to authenticated users
GRANT EXECUTE ON FUNCTION get_total_users() TO authenticated;
GRANT EXECUTE ON FUNCTION get_active_users() TO authenticated;
GRANT EXECUTE ON FUNCTION get_total_lessons_completed() TO authenticated;
GRANT EXECUTE ON FUNCTION get_total_words_mastered() TO authenticated;
GRANT EXECUTE ON FUNCTION get_users_by_language() TO authenticated;
GRANT EXECUTE ON FUNCTION get_total_game_sessions() TO authenticated;
GRANT EXECUTE ON FUNCTION get_average_streak_days() TO authenticated;
GRANT EXECUTE ON FUNCTION get_total_time_spent() TO authenticated;

