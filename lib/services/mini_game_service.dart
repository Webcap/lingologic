// ignore_for_file: dead_code

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/word.dart';
import '../models/mini_game_type.dart';
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
  /// Returns a tuple with mini game number and game type if one should be shown
  /// Returns null if no mini game should be shown
  Future<({int miniGameNumber, MiniGameType gameType})?> shouldShowMiniGame() async {
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
      // Calculate mini game number (1-6, cycling back to 1 after 6)
      // After 2 lessons: mini game 1, After 4: mini game 2, ..., After 12: mini game 6
      // After 14 lessons: cycles back to mini game 1
      final miniGameSequenceNumber = completedCount ~/ 2; // 1, 2, 3, 4, 5, 6, 7, 8, ...
      final miniGameNumber = ((miniGameSequenceNumber - 1) % 6) + 1; // Cycles 1-6
      
      // Check if user has already completed this mini game
      final miniGameId = 'minigame_${activeLanguage}_$miniGameNumber';
      final hasCompleted = await _hasCompletedMiniGame(user.id, miniGameId);

      if (!hasCompleted) {
        // Get game type from database
        try {
          debugPrint('MiniGameService: Looking up game type for miniGameId: $miniGameId (miniGameNumber: $miniGameNumber, sequenceNumber: $miniGameSequenceNumber)');
          
          final gameResponse = await _supabase
              .from('games')
              .select('game_type, name')
              .eq('game_id', miniGameId)
              .maybeSingle();

          MiniGameType gameType = MiniGameType.vocabularyReview; // Default fallback
          
          if (gameResponse != null) {
            final gameTypeString = gameResponse['game_type'] as String?;
            final gameName = gameResponse['name'] as String?;
            debugPrint('MiniGameService: Found game in database - game_id: $miniGameId, game_type: $gameTypeString, name: $gameName');
            
            if (gameTypeString != null) {
              gameType = MiniGameType.fromString(gameTypeString) ?? 
                  MiniGameType.vocabularyReview;
              debugPrint('MiniGameService: Parsed game type: ${gameType.value}');
            } else {
              debugPrint('MiniGameService: Warning - game_type is null in database, using default');
            }
          } else {
            debugPrint('MiniGameService: No game found in database for game_id: $miniGameId, using default type');
          }
          
          debugPrint('MiniGameService: Returning mini game - number: $miniGameNumber, type: ${gameType.value}');
          
          return (
            miniGameNumber: miniGameNumber,
            gameType: gameType,
          );
        } catch (e) {
          debugPrint('MiniGameService: Error getting game type for mini game $miniGameNumber: $e');
          // Return default type on error
          return (
            miniGameNumber: miniGameNumber,
            gameType: MiniGameType.vocabularyReview,
          );
        }
      }
    }

    return null;
  }

  /// Get vocabulary words from the last 2 completed lessons for the mini game
  Future<List<Word>> getMiniGameWords(
    int miniGameNumber, [
    MiniGameDifficulty? difficulty,
  ]) async {
    final user = _authService.currentUser;
    if (user == null) {
      debugPrint('MiniGameService: No user, returning empty words');
      return [];
    }

    final activeLanguage = await _languageService.getActiveLanguage();
    if (activeLanguage == null) {
      debugPrint('MiniGameService: No active language, returning empty words');
      return [];
    }

    debugPrint('MiniGameService: Getting words for mini game $miniGameNumber (language: $activeLanguage)');

    // Get all lessons for the active language, sorted by order_index
    final lessons = await _lessonService.getLessons();
    final sortedLessons = lessons
      ..sort((a, b) => (a.orderIndex).compareTo(b.orderIndex));

    debugPrint('MiniGameService: Found ${sortedLessons.length} total lessons');

    // Get all completed lessons
    final progressList = await _lessonService.getUserLessonProgressAll();
    final completedLessonIds = progressList
        .where((p) => p.isCompleted)
        .map((p) => p.lessonId)
        .toSet();

    final completedLessons = sortedLessons
        .where((lesson) => completedLessonIds.contains(lesson.id))
        .toList();

    debugPrint('MiniGameService: Found ${completedLessons.length} completed lessons');

    // Get the last 2 completed lessons for this mini game
    // Mini game 1 = lessons 1-2, Mini game 2 = lessons 3-4, etc.
    final startIndex = (miniGameNumber - 1) * 2;
    final endIndex = miniGameNumber * 2;

    debugPrint('MiniGameService: Looking for lessons at indices $startIndex to ${endIndex - 1}');

    if (completedLessons.length < endIndex) {
      debugPrint(
        'MiniGameService: Not enough completed lessons (${completedLessons.length} < $endIndex) for mini game $miniGameNumber',
      );
      return [];
    }

    final relevantLessons = completedLessons.sublist(startIndex, endIndex);
    debugPrint(
      'MiniGameService: Using ${relevantLessons.length} lessons: ${relevantLessons.map((l) => '${l.title} (order: ${l.orderIndex}, unlocks: ${l.unlocksWordIds.length} words)').join(', ')}',
    );

    // Collect all word IDs from these lessons
    final wordIds = <String>{};
    for (final lesson in relevantLessons) {
      debugPrint(
        'MiniGameService: Lesson "${lesson.title}" has ${lesson.unlocksWordIds.length} word IDs: ${lesson.unlocksWordIds}',
      );
      wordIds.addAll(lesson.unlocksWordIds);
    }

    debugPrint('MiniGameService: Collected ${wordIds.length} unique word IDs');

    if (wordIds.isEmpty) {
      debugPrint(
        'MiniGameService: No words found for mini game $miniGameNumber - lessons have no unlocksWordIds',
      );
      return [];
    }

    // Load the words - use bulk loading for efficiency
    final wordIdsList = wordIds.take(20).toList(); // Limit to 20 words for the mini game
    final words = await _repository.getWordsByIds(wordIdsList);
    
    debugPrint('MiniGameService: Bulk loaded ${words.length} words out of ${wordIdsList.length} requested');

    debugPrint(
      'MiniGameService: Loaded ${words.length} words for mini game $miniGameNumber (attempted: ${wordIds.length}, requested: ${wordIdsList.length})',
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
  /// If gameType is not provided, it will be looked up from the database
  Future<void> completeMiniGame(
    String miniGameId, [
    MiniGameType? gameType,
  ]) async {
    final user = _authService.currentUser;
    if (user == null) return;

    try {
      // If game type not provided, look it up from the database
      MiniGameType? finalGameType = gameType;
      if (finalGameType == null) {
        try {
          final gameResponse = await _supabase
              .from('games')
              .select('game_type')
              .eq('game_id', miniGameId)
              .maybeSingle();
          
          if (gameResponse != null) {
            final gameTypeString = gameResponse['game_type'] as String?;
            if (gameTypeString != null) {
              finalGameType = MiniGameType.fromString(gameTypeString);
            }
          }
        } catch (e) {
          debugPrint('MiniGameService: Error looking up game type: $e');
          // Continue with null if lookup fails
        }
      }
      
      await _supabase.from('mini_game_completions').insert({
        'user_id': user.id,
        'mini_game_id': miniGameId,
        'game_type': finalGameType?.value,
        'completed_at': DateTime.now().toIso8601String(),
      });

      debugPrint('MiniGameService: Marked mini game $miniGameId as completed (type: ${finalGameType?.value ?? 'unknown'})');
    } catch (e) {
      debugPrint('MiniGameService: Error completing mini game: $e');
      rethrow;
    }
  }

  /// Get list of unlocked mini games with their type and completion status
  Future<List<({int miniGameNumber, MiniGameType gameType, bool isCompleted})>>
      getUnlockedMiniGames() async {
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

    if (completedLessons.length < 2) {
      return [];
    }

    // Mini games unlock after every 2 lessons
    final completedCount = completedLessons.length;
    final unlockedCount = completedCount ~/ 2;

    final unlockedMiniGames = <({int miniGameNumber, MiniGameType gameType, bool isCompleted})>[];

    // Check each unlocked mini game
    for (int i = 1; i <= unlockedCount; i++) {
      final miniGameId = 'minigame_${activeLanguage}_$i';
      
      // Get game info from database to determine game type
      try {
        final gameResponse = await _supabase
            .from('games')
            .select('game_type')
            .eq('game_id', miniGameId)
            .maybeSingle();

        if (gameResponse != null) {
          final gameTypeString = gameResponse['game_type'] as String;
          final gameType = MiniGameType.fromString(gameTypeString) ??
              MiniGameType.vocabularyReview; // Default fallback

          // Check if completed
          final isCompleted = await _hasCompletedMiniGame(user.id, miniGameId);

          unlockedMiniGames.add((
            miniGameNumber: i,
            gameType: gameType,
            isCompleted: isCompleted,
          ));
        }
      } catch (e) {
        debugPrint(
          'MiniGameService: Error loading mini game $i info: $e',
        );
        // Continue with default type if error
        final isCompleted = await _hasCompletedMiniGame(user.id, miniGameId);
        unlockedMiniGames.add((
          miniGameNumber: i,
          gameType: MiniGameType.vocabularyReview,
          isCompleted: isCompleted,
        ));
      }
    }

    return unlockedMiniGames;
  }

  /// Get game info (name and description) from the games table
  Future<Map<String, String>> getGameInfo(
    String gameId,
    MiniGameType gameType,
    int miniGameNumber,
  ) async {
    try {
      final gameResponse = await _supabase
          .from('games')
          .select('name, description')
          .eq('game_id', gameId)
          .maybeSingle();

      if (gameResponse != null) {
        return {
          'name': gameResponse['name'] as String? ??
              gameType.getFunName(miniGameNumber),
          'description': gameResponse['description'] as String? ??
              gameType.description,
        };
      }

      // Return fallback values if not found in database
      return {
        'name': gameType.getFunName(miniGameNumber),
        'description': gameType.description,
      };
    } catch (e) {
      debugPrint('MiniGameService: Error getting game info: $e');
      // Return fallback values on error
      return {
        'name': gameType.getFunName(miniGameNumber),
        'description': gameType.description,
      };
    }
  }
}

