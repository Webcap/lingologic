-- Create table for feature flags
CREATE TABLE IF NOT EXISTS feature_flags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  description TEXT,
  enabled BOOLEAN NOT NULL DEFAULT false,
  enabled_for_percentage INTEGER DEFAULT 100 CHECK (enabled_for_percentage >= 0 AND enabled_for_percentage <= 100),
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  
  CONSTRAINT feature_flags_key_check CHECK (key ~ '^[a-z0-9_]+$')
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_feature_flags_key ON feature_flags(key);
CREATE INDEX IF NOT EXISTS idx_feature_flags_enabled ON feature_flags(enabled);

-- Enable RLS
ALTER TABLE feature_flags ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Anyone can view feature flags (they're public configuration)
CREATE POLICY "Anyone can view feature flags"
  ON feature_flags
  FOR SELECT
  USING (true);

-- RLS Policy: Only admins can modify feature flags
CREATE POLICY "Only admins can insert feature flags"
  ON feature_flags
  FOR INSERT
  WITH CHECK (is_admin());

CREATE POLICY "Only admins can update feature flags"
  ON feature_flags
  FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "Only admins can delete feature flags"
  ON feature_flags
  FOR DELETE
  USING (is_admin());

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_feature_flags_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_feature_flags_updated_at
  BEFORE UPDATE ON feature_flags
  FOR EACH ROW
  EXECUTE FUNCTION update_feature_flags_updated_at();

-- Insert some default feature flags
-- Note: Games are managed separately in the games table, not through feature flags
INSERT INTO feature_flags (key, name, description, enabled) VALUES
  ('pronunciation_exercises', 'Pronunciation Exercises', 'Enable pronunciation practice exercises', true),
  ('matching_exercises', 'Matching Exercises', 'Enable word matching exercises', true),
  ('streak_tracking', 'Streak Tracking', 'Enable daily streak tracking', true),
  ('spaced_repetition', 'Spaced Repetition System', 'Enable spaced repetition for vocabulary learning', true),
  ('daily_goals', 'Daily Goals', 'Enable daily learning goals feature', false),
  ('social_features', 'Social Features', 'Enable social sharing and leaderboards', false),
  ('ai_tutor', 'AI Tutor', 'Enable AI-powered learning assistant', false)
ON CONFLICT (key) DO NOTHING;

COMMENT ON TABLE feature_flags IS 'Feature flags to control which features are enabled in the application';
COMMENT ON COLUMN feature_flags.key IS 'Unique identifier for the feature flag (lowercase, alphanumeric, underscores only)';
COMMENT ON COLUMN feature_flags.name IS 'Human-readable name for the feature';
COMMENT ON COLUMN feature_flags.description IS 'Description of what the feature does';
COMMENT ON COLUMN feature_flags.enabled IS 'Whether the feature is enabled globally';
COMMENT ON COLUMN feature_flags.enabled_for_percentage IS 'Percentage of users who should see this feature (0-100, only used if enabled=true)';
COMMENT ON COLUMN feature_flags.metadata IS 'Additional configuration data for the feature flag';

