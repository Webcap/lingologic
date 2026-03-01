-- Fix Better Auth session update error: record "new" has no field "updated_at"
-- Better Auth session table uses camelCase columns (updatedAt, expiresAt, etc.).
-- The update_updated_at_column() trigger sets NEW.updated_at (snake_case), so it must
-- not run on the session table. This migration drops any such trigger on session.

-- Drop by common name first
DROP TRIGGER IF EXISTS update_session_updated_at ON session;

-- Drop any other trigger on session that uses update_updated_at_column (e.g. different naming)
DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN
    SELECT t.tgname AS trigger_name
    FROM pg_trigger t
    JOIN pg_class c ON t.tgrelid = c.oid
    JOIN pg_proc p ON t.tgfoid = p.oid
    WHERE c.relname = 'session'
      AND p.proname = 'update_updated_at_column'
      AND NOT t.tgisinternal
  LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS %I ON session', r.trigger_name);
  END LOOP;
END $$;
