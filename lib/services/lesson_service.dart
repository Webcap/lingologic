import 'package:flutter/foundation.dart';
import '../models/lesson.dart';
import '../models/lesson_progress.dart';
import '../data/remote/supabase_repository.dart';
import '../services/auth_service.dart';
import 'language_service.dart';
import 'lesson_translation_service.dart';

class LessonService {
  final SupabaseRepository _repository = SupabaseRepository();
  final AuthService _authService = AuthService();
  final LanguageService _languageService = LanguageService();
  final LessonTranslationService _translationService = LessonTranslationService();

  /// Get all available lessons, optionally filtered by language and category
  /// If language is not provided, uses the active language
  Future<List<Lesson>> getLessons({
    String? language,
    String? category,
  }) async {
    // If no language specified, use active language
    final activeLanguage = language ?? await _languageService.getActiveLanguage();
    
    if (activeLanguage == null) {
      debugPrint('LessonService: No active language set');
      return [];
    }
    
    debugPrint('LessonService: Getting lessons for language: $activeLanguage');
    final lessons = await _repository.getLessons(
      language: activeLanguage,
      category: category,
    );
    debugPrint('LessonService: Found ${lessons.length} lessons for language: $activeLanguage');
    
    // Translate lessons based on app language
    final translatedLessons = await Future.wait(
      lessons.map((lesson) => _translationService.translateLesson(lesson)),
    );
    
    return translatedLessons;
  }

  /// Get a specific lesson by ID
  Future<Lesson?> getLessonById(String id) async {
    final lesson = await _repository.getLessonById(id);
    if (lesson == null) return null;
    
    // Translate lesson based on app language
    return await _translationService.translateLesson(lesson);
  }

  /// Get user's progress for a specific lesson
  Future<LessonProgress?> getUserLessonProgress(
      String userId, String lessonId) async {
    return await _repository.getLessonProgressById(userId, lessonId);
  }

  /// Get all lesson progress for the current user
  Future<List<LessonProgress>> getUserLessonProgressAll() async {
    // Ensure session is loaded before checking user
    await _authService.ensureSessionLoaded();
    
    final user = _authService.currentUser;
    if (user == null) return [];

    return await _repository.getLessonProgress(user.id);
  }

  /// Start a lesson (mark as in progress)
  Future<void> startLesson(String userId, String lessonId) async {
    final existing = await getUserLessonProgress(userId, lessonId);

    final progress = existing != null
        ? existing.copyWith(
            status: LessonStatus.inProgress,
            updatedAt: DateTime.now(),
          )
        : LessonProgress(
            userId: userId,
            lessonId: lessonId,
            status: LessonStatus.inProgress,
            progressPercentage: 0,
            timeSpentMinutes: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

    await _repository.upsertLessonProgress(progress);
  }

  /// Update lesson progress percentage
  Future<void> updateLessonProgress(
      String userId, String lessonId, int progressPercentage) async {
    final existing = await getUserLessonProgress(userId, lessonId);
    if (existing == null) {
      await startLesson(userId, lessonId);
      return;
    }

    final progress = existing.copyWith(
      progressPercentage: progressPercentage,
      status: progressPercentage == 100
          ? LessonStatus.completed
          : LessonStatus.inProgress,
      updatedAt: DateTime.now(),
    );

    await _repository.upsertLessonProgress(progress);
  }

  /// Complete a lesson (mark as completed and unlock content)
  Future<void> completeLesson(String userId, String lessonId, int timeSpent) async {
    final progress = LessonProgress(
      userId: userId,
      lessonId: lessonId,
      status: LessonStatus.completed,
      progressPercentage: 100,
      completedAt: DateTime.now(),
      timeSpentMinutes: timeSpent,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _repository.upsertLessonProgress(progress);
  }

  /// Get all word IDs unlocked by completed lessons for a user
  /// Optionally filters by language if provided
  Future<List<String>> getUnlockedWordIds(String userId, {String? language}) async {
    final progressList = await _repository.getLessonProgress(userId);
    final completedLessonIds = progressList
        .where((p) => p.isCompleted)
        .map((p) => p.lessonId)
        .toSet(); // Use Set for faster lookup

    if (completedLessonIds.isEmpty) {
      debugPrint('LessonService: No completed lessons found for user');
      return [];
    }

    debugPrint('LessonService: Found ${completedLessonIds.length} completed lessons: $completedLessonIds');

    // Get lessons - use provided language or active language
    final targetLanguage = language ?? await _languageService.getActiveLanguage();
    final lessons = await _repository.getLessons(language: targetLanguage);
    
    debugPrint('LessonService: Found ${lessons.length} lessons for language: $targetLanguage');
    
    final unlockedWordIds = <String>[];

    for (final lesson in lessons) {
      if (completedLessonIds.contains(lesson.id)) {
        debugPrint('LessonService: Lesson ${lesson.id} is completed. Unlocks ${lesson.unlocksWordIds.length} words: ${lesson.unlocksWordIds.take(5)}...');
        unlockedWordIds.addAll(lesson.unlocksWordIds);
      }
    }

    final uniqueWordIds = unlockedWordIds.toSet().toList(); // Remove duplicates
    debugPrint('LessonService: Total unlocked word IDs: ${uniqueWordIds.length}');
    return uniqueWordIds;
  }
  
  /// Get unlocked word IDs for a specific lesson (useful after completion)
  Future<List<String>> getUnlockedWordIdsForLesson(String lessonId) async {
    final lesson = await getLessonById(lessonId);
    return lesson?.unlocksWordIds ?? [];
  }

  /// Check if a word is unlocked for the current user
  Future<bool> isWordUnlocked(String userId, String wordId) async {
    final unlockedWordIds = await getUnlockedWordIds(userId);
    return unlockedWordIds.contains(wordId);
  }

  /// Get the next recommended lesson for a user
  Future<Lesson?> getNextRecommendedLesson(String userId) async {
    final progressList = await _repository.getLessonProgress(userId);
    final completedLessonIds = progressList
        .where((p) => p.isCompleted)
        .map((p) => p.lessonId)
        .toSet();

    // Get lessons for the active language (already translated via getLessons)
    final activeLanguage = await _languageService.getActiveLanguage();
    final lessons = await getLessons(language: activeLanguage);
    
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

    // Find first lesson that's not completed
    for (final lesson in lessons) {
      if (!completedLessonIds.contains(lesson.id)) {
        return lesson;
      }
    }

    return null; // All lessons completed
  }

  /// Get lesson status for current user
  Future<LessonStatus> getLessonStatus(String userId, String lessonId) async {
    final progress = await getUserLessonProgress(userId, lessonId);
    return progress?.status ?? LessonStatus.notStarted;
  }

  /// Get progress percentage for a lesson
  Future<int> getLessonProgressPercentage(
      String userId, String lessonId) async {
    final progress = await getUserLessonProgress(userId, lessonId);
    return progress?.progressPercentage ?? 0;
  }

  /// Check if user has completed all required lessons for a word
  Future<bool> canAccessWord(String userId, String wordId) async {
    // First check if word requires a lesson
    final word = await _repository.getWordById(wordId);
    if (word == null) return false;

    // If word doesn't require a lesson, it's accessible
    // Note: We'd need to add required_lesson_id to Word model if we want to check this
    // For now, we'll check if the word is in any unlocked list
    final unlockedWordIds = await getUnlockedWordIds(userId);
    return unlockedWordIds.contains(wordId);
  }

  /// Reset a lesson (delete progress and start from beginning)
  Future<void> resetLesson(String userId, String lessonId) async {
    await _repository.deleteLessonProgress(userId, lessonId);
  }
}

