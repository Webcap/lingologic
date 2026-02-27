import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/main_tabs_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/lessons/lessons_list_screen.dart';
import '../screens/lessons/lesson_detail_screen.dart';
import '../screens/language_selection_screen.dart';
import '../screens/onboarding/language_onboarding_screen.dart';
import '../screens/talk_tutor/talk_tutor_screen.dart';
import '../widgets/loading_screen.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

final _authService = AuthService();

// Determine initial location - start at login and let redirect handle routing
// This ensures session is loaded before making routing decisions
String _getInitialLocation() {
  // Always start at login - the redirect function will handle routing
  // based on the actual loaded session state
  return '/login';
}

final appRouter = GoRouter(
  initialLocation: _getInitialLocation(),
  redirect: (context, state) async {
    // CRITICAL: Always wait for session to load from storage first
    // This ensures we check the actual persisted session, not just in-memory state
    // This is especially important on app refresh/restart
    await _authService.ensureSessionLoaded();

    // Now check authentication status after session is loaded
    var isAuthenticated = _authService.isAuthenticated;

    debugPrint(
      'Router redirect: route=${state.matchedLocation}, isAuthenticated=$isAuthenticated (after session load)',
    );

    // For authenticated users, optionally verify session with server
    // But skip this for login/signup routes to avoid unnecessary delays
    final isLoginRoute =
        state.matchedLocation == '/login' || state.matchedLocation == '/signup';

    if (isAuthenticated && !isLoginRoute) {
      // For authenticated users on protected routes, verify session is still valid with server
      // This may make a network request to ensure the session hasn't expired
      try {
        // ensureSessionLoaded already loaded from storage, but we can verify with server
        // Only do this if we have a session to avoid unnecessary requests
        final session = await _authService.currentSession;
        if (session != null) {
          // Session exists, verify it's still valid (optional - can be skipped for performance)
          // For now, we trust the loaded session
        }
      } catch (e) {
        debugPrint('Router: Error verifying session: $e');
        // If there's an error, trust the loaded session state
        isAuthenticated = _authService.isAuthenticated;
      }
    }
    final isOnboardingRoute = state.matchedLocation == '/onboarding';

    debugPrint(
      'Router redirect: route=${state.matchedLocation}, isAuthenticated=$isAuthenticated',
    );

    // CRITICAL: Check authentication status FIRST and handle unauthenticated users immediately
    // This prevents any onboarding checks for signed-out users
    if (!isAuthenticated) {
      // Unauthenticated users can ONLY access login/signup
      // Onboarding is strictly for authenticated users only
      if (isOnboardingRoute) {
        debugPrint(
          'Router: Unauthenticated user trying to access onboarding, redirecting to login',
        );
        return '/login';
      }
      if (isLoginRoute) {
        debugPrint(
          'Router: Unauthenticated user on login/signup, allowing navigation',
        );
        return null;
      }
      // Redirect all other routes (including home, settings, etc.) to login
      debugPrint(
        'Router: Unauthenticated user on protected route, redirecting to login',
      );
      return '/login';
    }

    // From here on, user is authenticated - handle authenticated user routing

    // If authenticated user is on login/signup, redirect to home
    if (isLoginRoute) {
      debugPrint(
        'Router: Authenticated user on login/signup, redirecting to home',
      );
      return '/';
    }

    // Check onboarding status for authenticated users only
    if (!isLoginRoute) {
      try {
        debugPrint('Router redirect check for authenticated user:');
        debugPrint('  Route: ${state.matchedLocation}');
        debugPrint('  Is onboarding route: $isOnboardingRoute');
        debugPrint('  Current user: ${_authService.currentUser?.id}');

        final userService = UserService(authService: _authService);
        // Force a fresh fetch from database (don't use cache)
        final profile = await userService.getUserProfile();

        // CRITICAL: Re-check authentication after getUserProfile
        // because ensureSessionLoaded() inside getUserProfile() might have cleared the session
        final isStillAuthenticated = _authService.isAuthenticated;
        if (!isStillAuthenticated) {
          debugPrint(
            'Router: User became unauthenticated during profile fetch, redirecting to login',
          );
          return '/login';
        }

        debugPrint('  Profile: ${profile != null ? "exists" : "null"}');
        debugPrint('  Onboarding completed: ${profile?.onboardingCompleted}');

        // If user is on onboarding but already completed it, redirect to home
        if (isOnboardingRoute &&
            profile != null &&
            profile.onboardingCompleted) {
          debugPrint(
            'Router: User has completed onboarding, redirecting to home',
          );
          return '/';
        }

        // If user hasn't completed onboarding and is not on onboarding route, redirect to onboarding
        if (!isOnboardingRoute &&
            (profile == null || !profile.onboardingCompleted)) {
          debugPrint(
            'Router: User has not completed onboarding, redirecting to onboarding',
          );
          return '/onboarding';
        }

        debugPrint('Router: Allowing navigation to ${state.matchedLocation}');
      } catch (e, stackTrace) {
        // If there's an error checking profile, re-check auth and redirect appropriately
        debugPrint('Error checking user profile in router: $e');
        debugPrint('Stack trace: $stackTrace');

        // Re-check authentication status
        final isStillAuthenticated = _authService.isAuthenticated;
        if (!isStillAuthenticated) {
          debugPrint(
            'Router: User is not authenticated after error, redirecting to login',
          );
          return '/login';
        }

        // If still authenticated, allow navigation to avoid blocking
        return null;
      }
    }

    // Allow navigation
    return null;
  },
  refreshListenable: _AuthStateNotifier(),
  errorBuilder: (context, state) =>
      const LoadingScreen(message: 'Page not found'),
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MainTabsScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: '/progress',
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/lessons',
      builder: (context, state) => const LessonsListScreen(),
    ),
    GoRoute(
      path: '/lessons/:lessonId',
      builder: (context, state) {
        final lessonId = state.pathParameters['lessonId']!;
        return LessonDetailScreen(lessonId: lessonId);
      },
    ),
    GoRoute(
      path: '/languages',
      builder: (context, state) => const LanguageSelectionScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const LanguageOnboardingScreen(),
    ),
    GoRoute(
      path: '/talktutor',
      builder: (context, state) => const TalkTutorScreen(),
    ),
  ],
);

/// Listenable that notifies router when auth state changes
class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier() {
    _authService.authStateChanges.listen((authState) {
      notifyListeners();
    });
  }
}
