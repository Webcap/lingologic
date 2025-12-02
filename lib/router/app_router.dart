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

final appRouter = GoRouter(
  initialLocation: '/login', // Start at login screen
  // Removed redirect for now to prevent crashes - will add back after app is stable
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
