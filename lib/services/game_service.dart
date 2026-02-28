import 'package:flutter/foundation.dart';
import '../services/lesson_service.dart';
import '../services/auth_service.dart';
import '../services/language_service.dart';

class GameService {
  final LessonService _lessonService = LessonService();
  final AuthService _authService = authService;
  final LanguageService _languageService = LanguageService();

  /// Check if games are unlocked by verifying if the first lesson is completed
  /// Games unlock when the user completes the first lesson (sorted by CEFR level first, then orderIndex)
  Future<bool> areGamesUnlocked() async {
    // Ensure session is loaded before checking user
    await _authService.ensureSessionLoaded();
    
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

      // CEFR level order for sorting
      const cefrOrder = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
      
      // Sort lessons by level first (CEFR order), then by orderIndex within each level
      lessons.sort((a, b) {
        // Get level indices (handle null/unknown levels)
        final aLevelIndex = a.level != null ? cefrOrder.indexOf(a.level!) : -1;
        final bLevelIndex = b.level != null ? cefrOrder.indexOf(b.level!) : -1;
        
        // If levels are the same or both null/unknown, sort by orderIndex
        if (aLevelIndex == bLevelIndex) {
          return a.orderIndex.compareTo(b.orderIndex);
        }
        
        // If one has a valid level and the other doesn't, prioritize the one with level
        if (aLevelIndex == -1) return 1;
        if (bLevelIndex == -1) return -1;
        
        // Sort by CEFR level order
        return aLevelIndex.compareTo(bLevelIndex);
      });
      
      // Find the first lesson (first A1 lesson, or first lesson at lowest level)
      final firstLesson = lessons.first;

      debugPrint('GameService: First lesson is ${firstLesson.id} with level ${firstLesson.level} and order_index ${firstLesson.orderIndex}');

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

