-- User Time Tracking Function for Admin Panel
-- Allows admins to view detailed time tracking data for any user

CREATE OR REPLACE FUNCTION get_user_time_tracking(user_uuid UUID, days_count INTEGER DEFAULT 30)
RETURNS JSONB AS $$
DECLARE
  result JSONB;
  game_sessions_data JSONB;
  lesson_sessions_data JSONB;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Access denied. Admin privileges required.';
  END IF;

  -- Get game sessions with calculated duration
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'id', id,
      'activity_type', 'game',
      'start_time', start_time,
      'end_time', end_time,
      'duration_minutes', CASE 
        WHEN end_time IS NOT NULL THEN 
          EXTRACT(EPOCH FROM (end_time - start_time)) / 60
        ELSE 
          EXTRACT(EPOCH FROM (NOW() - start_time)) / 60
      END,
      'details', jsonb_build_object(
        'game_type', game_type,
        'score', score
      )
    )
    ORDER BY start_time DESC
  ), '[]'::jsonb)
  INTO game_sessions_data
  FROM game_sessions
  WHERE user_id = user_uuid
    AND start_time > NOW() - (days_count || ' days')::INTERVAL
  LIMIT 100;

  -- Get lesson progress with time spent
  SELECT COALESCE(jsonb_agg(
    jsonb_build_object(
      'id', 'lesson-' || lesson_id,
      'activity_type', 'lesson',
      'start_time', updated_at,
      'end_time', updated_at,
      'duration_minutes', COALESCE(time_spent_minutes, 0),
      'details', jsonb_build_object(
        'lesson_id', lesson_id
      )
    )
    ORDER BY updated_at DESC
  ), '[]'::jsonb)
  INTO lesson_sessions_data
  FROM lesson_progress
  WHERE user_id = user_uuid
    AND updated_at > NOW() - (days_count || ' days')::INTERVAL
    AND time_spent_minutes > 0
  LIMIT 100;

  -- Build result with daily breakdown and sessions
  SELECT jsonb_build_object(
    'game_sessions', COALESCE(game_sessions_data, '[]'::jsonb),
    'lesson_sessions', COALESCE(lesson_sessions_data, '[]'::jsonb)
  )
  INTO result;

  RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_user_time_tracking(UUID, INTEGER) TO authenticated;

