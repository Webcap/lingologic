import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/lesson.dart';
import '../models/lesson_progress.dart';
import '../models/level_progression_test.dart';
import '../services/auth_service.dart';
import '../services/language_service.dart';
import '../config/supabase_config.dart';

class LevelProgressionService {
  final AuthService _authService = AuthService();
  final LanguageService _languageService = LanguageService();

  SupabaseClient get _supabase {
    final client = SupabaseConfig.client;
    if (client == null) {
      throw Exception('Supabase client is not initialized');
    }
    return client;
  }

  /// Check if user has completed 60% of lessons in a level
  Future<bool> hasCompleted60Percent(String level, List<Lesson> allLessons, Map<String, LessonProgress> progressMap) async {
    final levelLessons = allLessons.where((l) => l.level == level).toList();
    if (levelLessons.isEmpty) return false;

    final completedCount = levelLessons.where((lesson) {
      final progress = progressMap[lesson.id];
      return progress?.isCompleted == true;
    }).length;

    final completionPercentage = (completedCount / levelLessons.length) * 100;
    return completionPercentage >= 60;
  }

  /// Check if user can take the level progression test (60% completed and hasn't passed yet)
  Future<bool> canTakeLevelTest(String level) async {
    final user = _authService.currentUser;
    if (user == null) return false;

    final activeLanguage = await _languageService.getActiveLanguage();
    if (activeLanguage == null) return false;

    // Check if user already passed the test
    final existingTest = await getLevelTest(level);
    if (existingTest?.passed == true) {
      return false; // Already passed, no need to retake
    }

    // Check 60% completion (this will be checked by the caller with actual lesson data)
    return true;
  }

  /// Get level progression test for a specific level
  Future<LevelProgressionTest?> getLevelTest(String level) async {
    final user = _authService.currentUser;
    if (user == null) return null;

    final activeLanguage = await _languageService.getActiveLanguage();
    if (activeLanguage == null) return null;

    try {
      final response = await _supabase
          .from('level_progression_tests')
          .select()
          .eq('user_id', user.id)
          .eq('language', activeLanguage)
          .eq('level', level)
          .maybeSingle();

      if (response == null) return null;
      return LevelProgressionTest.fromJson(response);
    } catch (e) {
      // Table doesn't exist yet - this is expected if the feature isn't fully set up
      // Silently return null instead of logging error to avoid noise
      if (e.toString().contains('Could not find the table') ||
          e.toString().contains('PGRST205')) {
        debugPrint('Level progression tests table not available');
        return null;
      }
      debugPrint('Error getting level test: $e');
      return null;
    }
  }

  /// Save or update level progression test result
  Future<void> saveTestResult({
    required String level,
    required int score,
    required int totalQuestions,
    required bool passed,
  }) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final activeLanguage = await _languageService.getActiveLanguage();
    if (activeLanguage == null) throw Exception('No active language');

    try {
      // Upsert the test result
      await _supabase.from('level_progression_tests').upsert({
        'user_id': user.id,
        'language': activeLanguage,
        'level': level,
        'score': score,
        'total_questions': totalQuestions,
        'passed': passed,
        'completed_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Table doesn't exist yet - this is expected if the feature isn't fully set up
      if (e.toString().contains('Could not find the table') ||
          e.toString().contains('PGRST205')) {
        debugPrint('Level progression tests table not available - test result not saved');
        // Don't throw error - allow app to continue working
        return;
      }
      debugPrint('Error saving test result: $e');
      rethrow;
    }
  }

  /// Check if user has passed the level test (can advance early)
  Future<bool> hasPassedLevelTest(String level) async {
    final test = await getLevelTest(level);
    return test?.passed == true;
  }

  /// Calculate completion percentage for a level
  double calculateLevelCompletionPercentage(
    String level,
    List<Lesson> allLessons,
    Map<String, LessonProgress> progressMap,
  ) {
    final levelLessons = allLessons.where((l) => l.level == level).toList();
    if (levelLessons.isEmpty) return 0.0;

    final completedCount = levelLessons.where((lesson) {
      final progress = progressMap[lesson.id];
      return progress?.isCompleted == true;
    }).length;

    return (completedCount / levelLessons.length) * 100;
  }
}

