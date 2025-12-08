---
name: Migrate lingologic to Better Auth
overview: Migrate the lingologic Flutter app from Supabase Auth to Better Auth by creating a separate backend service and updating the Flutter app to use REST API endpoints for authentication.
todos: []
---

# Migrate lingologic Authentication to Better Auth

## Overview

Replace Supabase Auth with Better Auth by creating a separate backend service (Next.js) that handles authentication and exposes REST API endpoints. The Flutter app will call these endpoints instead of using Supabase Auth directly. Supabase will continue to be used for database operations (lessons, progress, user profiles, etc.).

## Architecture

### Backend Service (New)

- **Location**: Create a new Next.js project (e.g., `lingologic-api` or add to existing backend)
- **Purpose**: Handle Better Auth authentication and provide REST API endpoints
- **Database**: Better Auth will use the same Supabase PostgreSQL database
- **Integration**: Backend will also access Supabase for user profile operations

### Flutter App (Update)

- **Remove**: Direct Supabase Auth calls
- **Add**: HTTP client to call Better Auth API endpoints
- **Keep**: Supabase client for database operations (lessons, progress, etc.)

## Implementation Steps

### Phase 1: Backend Setup

#### 1.1 Create Backend Service

- Create new Next.js project or add to existing backend
- Install Better Auth: `npm install better-auth`
- Set up Better Auth configuration in `src/lib/auth/better-auth.ts`:
  - Use Supabase PostgreSQL connection string for database
  - Configure email/password authentication
  - Set up session management
  - Configure CORS for Flutter app

#### 1.2 Create Auth API Routes

Create REST API endpoints in `src/app/api/auth/`:

- `POST /api/auth/sign-in` - Email/password login
- `POST /api/auth/sign-up` - User registration
- `POST /api/auth/sign-out` - Logout
- `GET /api/auth/session` - Get current session
- `POST /api/auth/anonymous` - Anonymous login (if needed)
- `POST /api/auth/update-user` - Update user email/password
- `GET /api/auth/user-profile` - Get user profile with admin check

#### 1.3 Integrate with Supabase for User Profiles

- Install Supabase client in backend: `npm install @supabase/supabase-js`
- Create service to sync Better Auth users with `user_profiles` table
- Ensure `user_profiles.id` matches Better Auth `user.id`
- Handle profile creation on sign-up

#### 1.4 Environment Configuration

Add to backend `.env.local`:

```
DATABASE_URL=postgresql://... (Supabase connection string)
BETTER_AUTH_SECRET=... (random secret)
BETTER_AUTH_URL=http://localhost:3000
NEXT_PUBLIC_SUPABASE_URL=...
NEXT_PUBLIC_SUPABASE_ANON_KEY=...
SUPABASE_SERVICE_ROLE_KEY=... (for admin operations)
```

### Phase 2: Flutter App Updates

#### 2.1 Update Dependencies

In `pubspec.yaml`:

- Keep `supabase_flutter` for database operations
- Add `http` or `dio` package for API calls
- Optionally add `flutter_secure_storage` for token storage

#### 2.2 Create Better Auth Client Service

Create `lib/services/better_auth_service.dart`:

- HTTP client wrapper for Better Auth API endpoints
- Session token management
- Error handling
- Methods: `signIn()`, `signUp()`, `signOut()`, `signInAnonymously()`, `getSession()`, `updateUser()`

#### 2.3 Update AuthService

Modify `lib/services/auth_service.dart`:

- Replace Supabase Auth calls with Better Auth API calls
- Keep same interface for compatibility
- Update `currentUser` to fetch from Better Auth session
- Update `authStateChanges` to poll or use WebSocket if available
- Maintain `isAuthenticated` and `isAnonymous` properties

#### 2.4 Update Configuration

Modify `lib/config/supabase_config.dart`:

- Keep Supabase initialization for database operations
- Remove or disable Supabase Auth initialization
- Add Better Auth API base URL configuration

#### 2.5 Update Router

Modify `lib/router/app_router.dart`:

- Update `_AuthStateNotifier` to listen to Better Auth session changes
- Ensure redirects work with new auth system

#### 2.6 Update Screens

- `lib/screens/auth/login_screen.dart`: No UI changes, but will use new auth service
- `lib/screens/auth/signup_screen.dart`: No UI changes, but will use new auth service
- `lib/screens/settings_screen.dart`: Update sign out to use new auth service

### Phase 3: Database Migration

#### 3.1 Run Better Auth Migrations

- Run `npx @better-auth/cli migrate` to create Better Auth tables
- This creates `user`, `session`, `account`, `verification` tables

#### 3.2 Migrate Existing Users (Optional)

- Create migration script to copy Supabase Auth users to Better Auth
- Map Supabase `auth.users.id` to Better Auth `user.id`
- Update `user_profiles.id` to match Better Auth user IDs
- Handle password migration (users will need to reset passwords or use OAuth)

#### 3.3 Update RLS Policies

- Update Supabase RLS policies to work with Better Auth user IDs
- Ensure `user_profiles` table can be accessed with Better Auth session tokens
- May need to create a service role function for profile operations

### Phase 4: Testing & Validation

#### 4.1 Test Authentication Flow

- Test sign up, sign in, sign out
- Test anonymous login (if applicable)
- Test session persistence
- Test error handling

#### 4.2 Test Integration

- Verify user profiles are created/updated correctly
- Verify database operations still work with Supabase
- Test offline mode (if applicable)

#### 4.3 Test Edge Cases

- Network failures
- Invalid credentials
- Session expiration
- Token refresh

## Files to Create/Modify

### Backend (New/Modified)

- `backend/src/lib/auth/better-auth.ts` - Better Auth configuration
- `backend/src/app/api/auth/sign-in/route.ts` - Login endpoint
- `backend/src/app/api/auth/sign-up/route.ts` - Signup endpoint
- `backend/src/app/api/auth/sign-out/route.ts` - Logout endpoint
- `backend/src/app/api/auth/session/route.ts` - Session endpoint
- `backend/src/app/api/auth/user-profile/route.ts` - User profile endpoint
- `backend/src/services/supabase-service.ts` - Supabase integration service
- `backend/.env.local` - Environment variables

### Flutter (Modified)

- `lib/services/better_auth_service.dart` - New Better Auth client
- `lib/services/auth_service.dart` - Update to use Better Auth
- `lib/config/supabase_config.dart` - Update configuration
- `lib/config/better_auth_config.dart` - New Better Auth config
- `lib/router/app_router.dart` - Update auth state listener
- `pubspec.yaml` - Add HTTP client dependency

## Migration Strategy

### Option A: Big Bang Migration

- Complete migration in one go
- Requires downtime
- All users need to re-authenticate

### Option B: Gradual Migration (Recommended)

1. Deploy backend with Better Auth
2. Update Flutter app to support both auth methods
3. Migrate users gradually
4. Remove Supabase Auth once all users migrated

## Considerations

1. **Session Management**: Better Auth uses cookie-based sessions. Flutter app will need to handle cookies or use token-based approach with custom implementation.

2. **User ID Mapping**: Ensure Better Auth user IDs match `user_profiles.id` for seamless integration.

3. **Password Migration**: Existing users' passwords cannot be migrated. Options:

   - Force password reset on first login
   - Use OAuth providers
   - Allow anonymous login to continue

4. **Offline Support**: If app supports offline mode, ensure Better Auth session can be stored locally.

5. **Anonymous Users**: Better Auth may not support anonymous users natively. May need custom implementation or keep Supabase Auth for anonymous users only.

6. **Testing**: Set up test environment with separate database for testing migration.

## Rollback Plan

- Keep Supabase Auth code commented/feature-flagged
- Can quickly revert to Supabase Auth if issues arise
- Database changes are additive (Better Auth tables), so rollback is safe