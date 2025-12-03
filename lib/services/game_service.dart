import 'package:flutter/foundation.dart';
import '../services/lesson_service.dart';
import '../services/auth_service.dart';
import '../services/language_service.dart';

class GameService {
  final LessonService _lessonService = LessonService();
  final AuthService _authService = AuthService();
  final LanguageService _languageService = LanguageService();

  /// Check if games are unlocked by verifying if the first lesson is completed
  /// Games unlock when the user completes the first lesson (order_index = 1, the first section)
  Future<bool> areGamesUnlocked() async {
    final user = _authService.currentUser;
    if (user == null) {
      debugPrint('GameService: No user authenticated');
      return false;
    }

    try {
      // Get the active language
      final activeLanguage = await _languageService.getActiveLanguage();
      if (activeLanguage == null) {
        debugPrint('GameService: No active language');
        return false;
      }

      debugPrint('GameService: Checking unlock for language: $activeLanguage');

      // Get all lessons for the active language
      final lessons = await _lessonService.getLessons(language: activeLanguage);
      if (lessons.isEmpty) {
        debugPrint('GameService: No lessons found for language: $activeLanguage');
        return false;
      }

      debugPrint('GameService: Found ${lessons.length} lessons');

      // Get all lesson progress for this user
      final allProgress = await _lessonService.getUserLessonProgressAll();
      final completedLessonIds = allProgress
          .where((p) => p.isCompleted)
          .map((p) => p.lessonId)
          .toSet();
      
      debugPrint('GameService: User has ${completedLessonIds.length} completed lessons: $completedLessonIds');

      // Find the first lesson (order_index = 1) - this is the "first section"
      lessons.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      final firstLesson = lessons.firstWhere(
        (l) => l.orderIndex == 1,
        orElse: () => lessons.first, // Fallback to lowest order_index
      );

      debugPrint('GameService: First lesson is ${firstLesson.id} with order_index ${firstLesson.orderIndex}');

      // Check if the first lesson is completed
      final progress = await _lessonService.getUserLessonProgress(
        user.id,
        firstLesson.id,
      );

      final isCompleted = progress?.isCompleted ?? false;
      debugPrint('GameService: First lesson completed status: $isCompleted');
      if (progress != null) {
        debugPrint('GameService: Progress status: ${progress.status.value}, percentage: ${progress.progressPercentage}');
      }

      if (isCompleted) {
        debugPrint('GameService: ✅ Games UNLOCKED! First lesson is completed.');
      } else {
        debugPrint('GameService: ❌ Games remain locked. First lesson not completed.');
      }

      return isCompleted;
    } catch (e, stackTrace) {
      debugPrint('GameService: Error checking unlock status: $e');
      debugPrint('GameService: Stack trace: $stackTrace');
      // If there's an error, return false (games remain locked)
      return false;
    }
  }

  /// Check if a specific game is unlocked
  /// For now, all games unlock together when the first lesson is completed
  Future<bool> isGameUnlocked(String gameType) async {
    return areGamesUnlocked();
  }
}

