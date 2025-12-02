import 'package:go_router/go_router.dart';
import '../screens/main_menu_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../widgets/loading_screen.dart';
import '../services/auth_service.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final authService = AuthService();
    final isAuthenticated = authService.isAuthenticated;
    final isAuthRoute = state.matchedLocation == '/login' ||
        state.matchedLocation == '/signup';

    // Redirect to login if not authenticated and not on auth route
    if (!isAuthenticated && !isAuthRoute) {
      return '/login';
    }

    // Redirect to home if authenticated and on auth route
    if (isAuthenticated && isAuthRoute) {
      return '/';
    }

    return null;
  },
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
  ],
);

