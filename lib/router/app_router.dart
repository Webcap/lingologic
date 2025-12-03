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
    
    // Check if authenticated user needs onboarding
    if (isAuthenticated && !isLoginRoute && !isOnboardingRoute) {
      try {
        final userService = UserService();
        final profile = await userService.getUserProfile();
        
        // If user hasn't completed onboarding, redirect to onboarding
        if (profile == null || !profile.onboardingCompleted) {
          return '/onboarding';
        }
      } catch (e) {
        // If there's an error checking profile, allow navigation to avoid blocking
        debugPrint('Error checking user profile: $e');
      }
    }
    
    // If user is on onboarding but already completed it, redirect to home
    if (isAuthenticated && isOnboardingRoute) {
      try {
        final userService = UserService();
        final profile = await userService.getUserProfile();
        
        if (profile != null && profile.onboardingCompleted) {
          return '/';
        }
      } catch (e) {
        debugPrint('Error checking user profile: $e');
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
