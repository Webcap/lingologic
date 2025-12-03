import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/main_menu_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/lessons/lessons_list_screen.dart';
import '../screens/lessons/lesson_detail_screen.dart';
import '../screens/language_selection_screen.dart';
import '../widgets/loading_screen.dart';
import '../services/auth_service.dart';

final _authService = AuthService();

// Determine initial location based on auth state
String _getInitialLocation() {
  return _authService.isAuthenticated ? '/' : '/login';
}

final appRouter = GoRouter(
  initialLocation: _getInitialLocation(),
  redirect: (context, state) {
    final isAuthenticated = _authService.isAuthenticated;
    final isLoginRoute = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
    
    // If user is authenticated and trying to access login/signup, redirect to home
    if (isAuthenticated && isLoginRoute) {
      return '/';
    }
    
    // If user is not authenticated and trying to access protected routes, redirect to login
    if (!isAuthenticated && !isLoginRoute) {
      return '/login';
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
      builder: (context, state) => const MainMenuScreen(),
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
