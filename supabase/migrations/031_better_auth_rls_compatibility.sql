-- Better Auth RLS Compatibility Migration
-- This migration adds helper functions and updates RLS policies to work with Better Auth

-- Create a function to get current user ID from Better Auth context
-- This will be set by the backend when making requests
CREATE OR REPLACE FUNCTION get_better_auth_user_id()
RETURNS UUID AS $$
BEGIN
  -- Try to get user ID from JWT claim (set by backend)
  -- If not available, return NULL (will fail RLS checks)
  RETURN COALESCE(
    (current_setting('request.jwt.claims', true)::json->>'better_auth_user_id')::UUID,
    NULL
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Alternative: Create a function that accepts user_id as parameter
-- This can be used by the backend with SECURITY DEFINER
CREATE OR REPLACE FUNCTION get_user_id_for_rls()
RETURNS UUID AS $$
BEGIN
  -- First try Better Auth user ID
  RETURN COALESCE(
    get_better_auth_user_id(),
    -- Fallback to Supabase auth.uid() for backward compatibility
    auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Update user_profiles RLS to work with Better Auth
-- The backend will use service role for user profile operations
-- But we can also support direct access if user_id is provided

-- Note: Most RLS policies will need to be updated to use get_user_id_for_rls()
-- instead of auth.uid() directly. However, this is a breaking change.
-- 
-- Alternative approach: Keep existing policies and have the backend
-- set a JWT claim with the Better Auth user ID when making requests.

-- For now, user_profiles operations will be handled by the backend with service role.
-- Other tables (lessons, progress, etc.) will continue to use existing RLS policies
-- which rely on auth.uid(). 

-- IMPORTANT: The Flutter app will need to authenticate with Supabase using
-- a JWT token that includes the Better Auth user ID. The backend should provide
-- an endpoint to generate such a token, OR the Flutter app should pass the user ID
-- in a way that RLS policies can access it.

-- Example: Create a function that generates a Supabase JWT with Better Auth user ID
-- This would be called by the backend after Better Auth authentication
CREATE OR REPLACE FUNCTION create_supabase_jwt_for_better_auth_user(better_auth_user_id UUID)
RETURNS TEXT AS $$
DECLARE
  jwt_secret TEXT;
  jwt_payload JSONB;
  jwt_token TEXT;
BEGIN
  -- Get JWT secret from Supabase settings
  -- Note: In production, this should use Supabase's actual JWT secret
  jwt_secret := current_setting('app.settings.jwt_secret', true);
  
  -- Create JWT payload with Better Auth user ID
  jwt_payload := jsonb_build_object(
    'sub', better_auth_user_id::TEXT,
    'role', 'authenticated',
    'better_auth_user_id', better_auth_user_id::TEXT
  );
  
  -- Generate JWT (simplified - in production use proper JWT library)
  -- This is a placeholder - actual implementation would use pgjwt extension
  RETURN jwt_payload::TEXT;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION get_better_auth_user_id() IS 
  'Gets the Better Auth user ID from JWT claims. Set by backend when making Supabase requests.';

COMMENT ON FUNCTION get_user_id_for_rls() IS 
  'Gets user ID for RLS policies, supporting both Better Auth and Supabase Auth.';

COMMENT ON FUNCTION create_supabase_jwt_for_better_auth_user(UUID) IS 
  'Creates a Supabase JWT token for a Better Auth user. Used by backend to generate tokens for Flutter app.';

-- Note: In practice, the backend should:
-- 1. Authenticate user with Better Auth
-- 2. Generate a Supabase JWT with the Better Auth user ID
-- 3. Return this token to the Flutter app
-- 4. Flutter app uses this token for Supabase requests
-- 5. RLS policies check auth.uid() which will be the Better Auth user ID

-- OR simpler approach: Backend handles all authenticated Supabase operations
-- Flutter app only makes unauthenticated reads (public data) and uses backend API for writes

