-- Add Talk Tutor feature flag for AI conversational speaking practice
INSERT INTO feature_flags (key, name, description, enabled) VALUES
  ('talk_tutor', 'Talk Tutor', 'AI conversational speaking practice', true)
ON CONFLICT (key) DO NOTHING;
