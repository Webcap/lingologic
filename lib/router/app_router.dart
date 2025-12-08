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
import '../widgets/loading_screen.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

final _authService = AuthService();

// Determine initial location based on auth state
String _getInitialLocation() {
  return _authService.isAuthenticated ? '/' : '/login';
}

final appRouter = GoRouter(
  initialLocation: _getInitialLocation(),
  redirect: (context, state) async {
    final isAuthenticated = _authService.isAuthenticated;
    final isLoginRoute = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
    final isOnboardingRoute = state.matchedLocation == '/onboarding';
    
    // If user is authenticated and trying to access login/signup, redirect to home
    if (isAuthenticated && isLoginRoute) {
      return '/';
    }
    
    // If user is not authenticated and trying to access protected routes, redirect to login
    if (!isAuthenticated && !isLoginRoute && !isOnboardingRoute) {
      return '/login';
    }
    
    // If user is authenticated, check onboarding status
    if (isAuthenticated) {
      try {
        debugPrint('Router redirect check:');
        debugPrint('  Route: ${state.matchedLocation}');
        debugPrint('  Is onboarding route: $isOnboardingRoute');
        debugPrint('  Current user: ${_authService.currentUser?.id}');
        
        final userService = UserService();
        // Force a fresh fetch from database (don't use cache)
        final profile = await userService.getUserProfile();
        
        debugPrint('  Profile: ${profile != null ? "exists" : "null"}');
        debugPrint('  Onboarding completed: ${profile?.onboardingCompleted}');
        
        // If user is on onboarding but already completed it, redirect to home
        if (isOnboardingRoute && profile != null && profile.onboardingCompleted) {
          debugPrint('Router: User has completed onboarding, redirecting to home');
          return '/';
        }
        
        // If user hasn't completed onboarding and is not on onboarding route, redirect to onboarding
        if (!isOnboardingRoute && (profile == null || !profile.onboardingCompleted)) {
          debugPrint('Router: User has not completed onboarding, redirecting to onboarding');
          return '/onboarding';
        }
        
        debugPrint('Router: Allowing navigation to ${state.matchedLocation}');
      } catch (e, stackTrace) {
        // If there's an error checking profile, allow navigation to avoid blocking
        debugPrint('Error checking user profile in router: $e');
        debugPrint('Stack trace: $stackTrace');
      }
    }
    
    // Allow navigation
    return null;
  },
  refreshListenable: _AuthStateNotifier(),
  errorBuilder: (context, state) => const LoadingScreen(
    message: 'Page not found',
  ),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainTabsScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
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
