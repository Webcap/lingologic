// ignore_for_file: dead_code

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/word.dart';
import 'lesson_service.dart';
import 'auth_service.dart';
import 'language_service.dart';
import '../data/remote/supabase_repository.dart';
import '../config/supabase_config.dart';

class MiniGameService {
  final LessonService _lessonService;
  final AuthService _authService;
  final LanguageService _languageService;
  final SupabaseRepository _repository = SupabaseRepository();

  SupabaseClient get _supabase {
    final client = SupabaseConfig.client;
    if (client == null) {
      throw Exception('Supabase client is not initialized');
    }
    return client;
  }

  MiniGameService()
    : _lessonService = LessonService(),
      _authService = AuthService(),
      _languageService = LanguageService();

  /// Check if a mini game should be shown based on completed lessons
  /// Returns the mini game index if one should be shown (e.g., after lessons 2, 4, 6...)
  /// Returns null if no mini game should be shown
  Future<int?> shouldShowMiniGame() async {
    final user = _authService.currentUser;
    if (user == null) return null;

    final activeLanguage = await _languageService.getActiveLanguage();
    if (activeLanguage == null) return null;

    // Get all lessons for the active language, sorted by order_index
    final lessons = await _lessonService.getLessons();
    final sortedLessons = lessons
      ..sort((a, b) => (a.orderIndex).compareTo(b.orderIndex));

    // Get all completed lessons
    final progressList = await _lessonService.getUserLessonProgressAll();
    final completedLessonIds = progressList
        .where((p) => p.isCompleted)
        .map((p) => p.lessonId)
        .toSet();

    // Find completed lessons in order
    final completedLessons = sortedLessons
        .where((lesson) => completedLessonIds.contains(lesson.id))
        .toList();

    if (completedLessons.length < 2) {
      return null; // Need at least 2 completed lessons
    }

    // Mini games appear after every 2 lessons
    final completedCount = completedLessons.length;

    // Mini game should appear after lessons 2, 4, 6, 8, etc.
    // So if completedCount is 2, 4, 6, 8... we should show a mini game
    if (completedCount >= 2 && completedCount % 2 == 0) {
      // Check if user has already completed this mini game
      final miniGameId = 'minigame_${activeLanguage}_${completedCount ~/ 2}';
      final hasCompleted = await _hasCompletedMiniGame(user.id, miniGameId);

      if (!hasCompleted) {
        return completedCount ~/ 2; // Return mini game number (1, 2, 3, etc.)
      }
    }

    return null;
  }

  /// Get vocabulary words from the last 2 completed lessons for the mini game
  Future<List<Word>> getMiniGameWords(int miniGameNumber) async {
    final user = _authService.currentUser;
    if (user == null) return [];

    final activeLanguage = await _languageService.getActiveLanguage();
    if (activeLanguage == null) return [];

    // Get all lessons for the active language, sorted by order_index
    final lessons = await _lessonService.getLessons();
    final sortedLessons = lessons
      ..sort((a, b) => (a.orderIndex).compareTo(b.orderIndex));

    // Get all completed lessons
    final progressList = await _lessonService.getUserLessonProgressAll();
    final completedLessonIds = progressList
        .where((p) => p.isCompleted)
        .map((p) => p.lessonId)
        .toSet();

    final completedLessons = sortedLessons
        .where((lesson) => completedLessonIds.contains(lesson.id))
        .toList();

    // Get the last 2 completed lessons for this mini game
    // Mini game 1 = lessons 1-2, Mini game 2 = lessons 3-4, etc.
    final startIndex = (miniGameNumber - 1) * 2;
    final endIndex = miniGameNumber * 2;

    if (completedLessons.length < endIndex) {
      return [];
    }

    final relevantLessons = completedLessons.sublist(startIndex, endIndex);

    // Collect all word IDs from these lessons
    final wordIds = <String>{};
    for (final lesson in relevantLessons) {
      wordIds.addAll(lesson.unlocksWordIds);
    }

    if (wordIds.isEmpty) {
      debugPrint(
        'MiniGameService: No words found for mini game $miniGameNumber',
      );
      return [];
    }

    // Load the words
    final words = <Word>[];
    for (final wordId in wordIds.take(20)) {
      // Limit to 20 words for the mini game
      try {
        final word = await _repository.getWordById(wordId);
        if (word != null) {
          words.add(word);
        }
      } catch (e) {
        debugPrint('MiniGameService: Error loading word $wordId: $e');
      }
    }

    debugPrint(
      'MiniGameService: Loaded ${words.length} words for mini game $miniGameNumber',
    );
    return words;
  }

  /// Check if user has completed a specific mini game
  Future<bool> _hasCompletedMiniGame(String userId, String miniGameId) async {
    try {
      final response = await _supabase
          .from('mini_game_completions')
          .select('id')
          .eq('user_id', userId)
          .eq('mini_game_id', miniGameId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      debugPrint('MiniGameService: Error checking mini game completion: $e');
      return false;
    }
  }

  /// Mark a mini game as completed
  Future<void> completeMiniGame(String miniGameId) async {
    final user = _authService.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('mini_game_completions').insert({
        'user_id': user.id,
        'mini_game_id': miniGameId,
        'completed_at': DateTime.now().toIso8601String(),
      });

      debugPrint('MiniGameService: Marked mini game $miniGameId as completed');
    } catch (e) {
      debugPrint('MiniGameService: Error completing mini game: $e');
      rethrow;
    }
  }
}
