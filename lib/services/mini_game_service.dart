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

  /// Get the game type for a specific mini game number
  /// Mini game 3 always uses word search, others rotate through different types
  Future<MiniGameType?> getMiniGameType(int miniGameNumber) async {
    final user = _authService.currentUser;
    if (user == null) return null;

    final activeLanguage = await _languageService.getActiveLanguage();
    if (activeLanguage == null) return null;

    // Mini game 3 is always word search
    if (miniGameNumber == 3) {
      return MiniGameType.wordSearch;
    }

    // For other mini games, rotate through different types
    final playedTypes = await _getPlayedGameTypes(user.id, activeLanguage, miniGameNumber);

    // Available game types (excluding word search for now, except for mini game 3)
    final availableTypes = MiniGameType.values
        .where((type) => type != MiniGameType.wordSearch || miniGameNumber == 3)
        .toList();

    // Find a type that hasn't been played yet
    MiniGameType? selectedType;
    for (final type in availableTypes) {
      if (!playedTypes.contains(type)) {
        selectedType = type;
        break;
      }
    }

    // If all types have been played, cycle through based on mini game number
    if (selectedType == null && availableTypes.isNotEmpty) {
      final cycleIndex = (miniGameNumber - 1) % availableTypes.length;
      selectedType = availableTypes[cycleIndex];
    }

    // Default to vocabulary review if nothing else selected
    return selectedType ?? MiniGameType.vocabularyReview;
  }

  /// Get all game types that have been played for a specific mini game
  Future<Set<MiniGameType>> _getPlayedGameTypes(
    String userId,
    String language,
    int miniGameNumber,
  ) async {
    try {
      final response = await _supabase
          .from('mini_game_completions')
          .select('game_type')
          .eq('user_id', userId)
          .eq('mini_game_id', 'minigame_${language}_$miniGameNumber');

      final playedTypes = <MiniGameType>{};
      
      for (final row in response) {
        final gameTypeStr = row['game_type'] as String?;
        if (gameTypeStr != null) {
          try {
            final gameType = MiniGameType.values.firstWhere(
              (e) => e.name == gameTypeStr,
            );
            playedTypes.add(gameType);
          } catch (e) {
            debugPrint('MiniGameService: Unknown game type $gameTypeStr');
          }
        }
      }

      return playedTypes;
    } catch (e) {
      debugPrint('MiniGameService: Error getting played game types: $e');
      return {};
    }
  }

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


  /// Check if user has completed a specific mini game
  /// Returns true if ANY game type has been completed for this mini game
  Future<bool> _hasCompletedMiniGame(String userId, String miniGameId) async {
    try {
      final response = await _supabase
          .from('mini_game_completions')
          .select('id')
          .eq('user_id', userId)
          .eq('mini_game_id', miniGameId)
          .limit(1)
          .maybeSingle();

      return response != null;
    } catch (e) {
      debugPrint('MiniGameService: Error checking mini game completion: $e');
      return false;
    }
  }

  /// Mark a mini game as completed
  Future<void> completeMiniGame(
    String miniGameId,
    MiniGameType gameType,
  ) async {
    final user = _authService.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('mini_game_completions').insert({
        'user_id': user.id,
        'mini_game_id': miniGameId,
        'game_type': gameType.name,
        'completed_at': DateTime.now().toIso8601String(),
      });

      debugPrint('MiniGameService: Marked mini game $miniGameId (${gameType.name}) as completed');
    } catch (e) {
      debugPrint('MiniGameService: Error completing mini game: $e');
      rethrow;
    }
  }

  /// Get vocabulary words for mini game with progressive difficulty
  Future<List<Word>> getMiniGameWords(
    int miniGameNumber,
    MiniGameDifficulty difficulty,
  ) async {
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

    // Load the words - use difficulty to determine count
    final words = <Word>[];
    for (final wordId in wordIds.take(difficulty.wordCount)) {
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

  /// Get all unlocked mini games that the user can play
  /// Returns a list of mini game numbers and their types
  Future<List<({int miniGameNumber, MiniGameType gameType, bool isCompleted})>> getUnlockedMiniGames() async {
    final user = _authService.currentUser;
    if (user == null) return [];

    final activeLanguage = await _languageService.getActiveLanguage();
    if (activeLanguage == null) return [];

    try {
      // Get all completed lessons
      final lessons = await _lessonService.getLessons();
      final sortedLessons = lessons
        ..sort((a, b) => (a.orderIndex).compareTo(b.orderIndex));

      final progressList = await _lessonService.getUserLessonProgressAll();
      final completedLessonIds = progressList
          .where((p) => p.isCompleted)
          .map((p) => p.lessonId)
          .toSet();

      final completedLessons = sortedLessons
          .where((lesson) => completedLessonIds.contains(lesson.id))
          .toList();

      if (completedLessons.length < 2) {
        return []; // Need at least 2 completed lessons to unlock first mini game
      }

      // Calculate how many mini games are unlocked
      // Mini games unlock after 2, 4, 6, 8... lessons
      final maxMiniGameNumber = completedLessons.length ~/ 2;

      final unlockedMiniGames = <({int miniGameNumber, MiniGameType gameType, bool isCompleted})>[];

      // Check each unlocked mini game
      for (int i = 1; i <= maxMiniGameNumber; i++) {
        final miniGameId = 'minigame_${activeLanguage}_$i';
        final isCompleted = await _hasCompletedMiniGame(user.id, miniGameId);
        
        // Get the game type for this mini game
        final gameType = await getMiniGameType(i);
        
        if (gameType != null) {
          unlockedMiniGames.add((
            miniGameNumber: i,
            gameType: gameType,
            isCompleted: isCompleted,
          ));
        }
      }

      return unlockedMiniGames;
    } catch (e) {
      debugPrint('MiniGameService: Error getting unlocked mini games: $e');
      return [];
    }
  }

  /// Get game name from database, or fallback to fun random name
  /// Tries to fetch from database first, then falls back to generated name
  Future<String> getGameName(String gameId, MiniGameType gameType, int miniGameNumber) async {
    try {
      final game = await _repository.getGameByGameId(gameId);
      if (game != null && game.isActive) {
        return game.name;
      }
    } catch (e) {
      debugPrint('MiniGameService: Error fetching game name from database: $e');
    }
    
    // Fallback to fun random name
    return gameType.getFunName(miniGameNumber);
  }

  /// Get game description from database, or fallback to default description
  /// Tries to fetch from database first, then falls back to game type description
  Future<String> getGameDescription(String gameId, MiniGameType gameType) async {
    try {
      final game = await _repository.getGameByGameId(gameId);
      if (game != null && game.isActive && game.description != null && game.description!.isNotEmpty) {
        return game.description!;
      }
    } catch (e) {
      debugPrint('MiniGameService: Error fetching game description from database: $e');
    }
    
    // Fallback to game type default description
    return gameType.description;
  }

  /// Get full game info (name and description) from database
  /// Returns a map with 'name' and 'description' keys
  Future<Map<String, String>> getGameInfo(
    String gameId,
    MiniGameType gameType,
    int miniGameNumber,
  ) async {
    try {
      final game = await _repository.getGameByGameId(gameId);
      if (game != null && game.isActive) {
        return {
          'name': game.name,
          'description': game.description ?? gameType.description,
        };
      }
    } catch (e) {
      debugPrint('MiniGameService: Error fetching game info from database: $e');
    }
    
    // Fallback to generated values
    return {
      'name': gameType.getFunName(miniGameNumber),
      'description': gameType.description,
    };
  }
}

