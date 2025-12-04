// ignore_for_file: unnecessary_cast

import 'package:flutter/foundation.dart';
import '../../models/word.dart';
import '../../models/word_mastery.dart';
import '../../models/user_profile.dart';
import '../../models/game_session.dart';
import '../../models/lesson.dart';
import '../../models/lesson_progress.dart';
import '../../models/user_language.dart';
import '../../models/feature_flag.dart';
import '../../models/game.dart';
import '../../config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRepository {
  SupabaseClient? _supabase;

  SupabaseClient? get _supabaseClient {
    if (_supabase == null) {
      _supabase = SupabaseConfig.client;
    }
    return _supabase;
  }

  // Helper to ensure client is available
  SupabaseClient _getClient() {
    final client = _supabaseClient;
    if (client == null) {
      throw Exception(
        'Supabase client is not initialized. Cannot perform database operations.',
      );
    }
    return client;
  }

  // Words
  Future<List<Word>> getWords({String? language, String? category}) async {
    try {
      final client = _supabaseClient;
      if (client == null) {
        throw Exception('Supabase not initialized');
      }

      var query = client.from('words').select();

      if (language != null) {
        query = query.eq('language', language);
      }
      if (category != null) {
        query = query.eq('category', category);
      }

      final response = await query;
      return (response as List).map((json) => Word.fromJson(json)).toList();
    } catch (e) {
      // Error handling will be done by caller
      rethrow;
    }
  }

  Future<Word?> getWordById(String id) async {
    final client = _supabaseClient;
    if (client == null) {
      throw Exception('Supabase not initialized');
    }

    final response = await client
        .from('words')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return Word.fromJson(response);
  }

  Future<Word?> getWordByText(String wordText, {String? language}) async {
    final client = _supabaseClient;
    if (client == null) {
      throw Exception('Supabase not initialized');
    }

    var query = client
        .from('words')
        .select()
        .eq('word_text', wordText.toLowerCase().trim());

    if (language != null) {
      query = query.eq('language', language);
    }

    final response = await query.maybeSingle();

    if (response == null) return null;
    return Word.fromJson(response);
  }

  // Word Mastery
  Future<List<WordMastery>> getWordMasteries(String userId) async {
    final client = _supabaseClient;
    if (client == null) {
      throw Exception('Supabase not initialized');
    }

    final response = await client
        .from('word_mastery')
        .select()
        .eq('user_id', userId);

    return (response as List)
        .map((json) => WordMastery.fromJson(json))
        .toList();
  }

  Future<void> upsertWordMastery(WordMastery mastery) async {
    final client = _supabaseClient;
    if (client == null) {
      throw Exception('Supabase not initialized');
    }

    await client.from('word_mastery').upsert(mastery.toJson());
  }

  // User Profiles
  Future<UserProfile?> getUserProfile(String userId) async {
    final client = _supabaseClient;
    if (client == null) {
      throw Exception('Supabase not initialized');
    }

    final response = await client
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserProfile.fromJson(response);
  }

  Future<void> upsertUserProfile(UserProfile profile) async {
    final client = _supabaseClient;
    if (client == null) {
      throw Exception('Supabase not initialized');
    }

    await client.from('user_profiles').upsert(profile.toJson());
  }

  // Game Sessions
  Future<void> createGameSession(GameSession session) async {
    final client = _supabaseClient;
    if (client == null) {
      throw Exception('Supabase not initialized');
    }

    await client.from('game_sessions').insert({
      ...session.toJson(),
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  Future<List<GameSession>> getGameSessions(
    String userId, {
    GameType? gameType,
  }) async {
    final client = _supabaseClient;
    if (client == null) {
      throw Exception('Supabase not initialized');
    }

    var query = client.from('game_sessions').select().eq('user_id', userId);

    if (gameType != null) {
      query = query.eq('game_type', gameType.name);
    }

    final response = await query;
    return (response as List)
        .map((json) => GameSession.fromJson(json))
        .toList();
  }

  // Lessons
  Future<List<Lesson>> getLessons({String? language, String? category}) async {
    final client = _getClient();
    try {
      var query = client.from('lessons').select();

      if (language != null) {
        debugPrint(
          'SupabaseRepository: Filtering lessons by language: $language',
        );
        query = query.eq('language', language);
      }
      if (category != null) {
        query = query.eq('category', category);
      }

      final response = await query.order('order_index');

      // Log raw response for debugging
      final responseList = response as List;
      debugPrint(
        'SupabaseRepository: Raw response count: ${responseList.length}',
      );

      if (responseList.isNotEmpty) {
        final firstItem = responseList.first;
        if (firstItem is Map) {
          debugPrint(
            'SupabaseRepository: First lesson raw data keys: ${firstItem.keys.toList()}',
          );
          debugPrint(
            'SupabaseRepository: First lesson data: id=${firstItem['id']}, title=${firstItem['title']}, language=${firstItem['language']}',
          );
        }

        // Log all lesson IDs from database
        final allIds = responseList.map((item) {
          if (item is Map) return item['id'] ?? 'NO_ID';
          return 'INVALID_ITEM';
        }).toList();
        debugPrint('SupabaseRepository: All lesson IDs from database: $allIds');
      }

      final lessons = <Lesson>[];
      final failedLessons = <Map<String, String>>[];

      for (final item in responseList) {
        try {
          if (item is Map<String, dynamic>) {
            final lessonId = item['id'] as String? ?? 'unknown';
            try {
              lessons.add(Lesson.fromJson(item));
              debugPrint(
                'SupabaseRepository: ✅ Successfully parsed lesson: $lessonId',
              );
            } catch (parseError, stackTrace) {
              final errorMessage = parseError.toString();
              failedLessons.add({'id': lessonId, 'error': errorMessage});
              debugPrint(
                'SupabaseRepository: ❌ ERROR parsing lesson $lessonId',
              );
              debugPrint('SupabaseRepository: Error message: $errorMessage');
              debugPrint(
                'SupabaseRepository: Lesson has content_json: ${item['content_json'] != null}',
              );

              // Check content_json structure
              final contentJson = item['content_json'];
              if (contentJson != null) {
                if (contentJson is Map) {
                  final contentMap = contentJson as Map;
                  debugPrint(
                    'SupabaseRepository: content_json is Map, has sections: ${contentMap.containsKey('sections')}',
                  );
                  if (contentMap.containsKey('sections')) {
                    final sections = contentMap['sections'];
                    debugPrint(
                      'SupabaseRepository: sections type: ${sections.runtimeType}',
                    );
                    if (sections is List) {
                      debugPrint(
                        'SupabaseRepository: sections array length: ${sections.length}',
                      );
                    }
                  }
                } else {
                  debugPrint(
                    'SupabaseRepository: content_json type: ${contentJson.runtimeType}',
                  );
                }
              }

              debugPrint('SupabaseRepository: Stack trace: $stackTrace');
            }
          } else {
            debugPrint(
              'SupabaseRepository: Skipping invalid lesson item (not a Map): ${item.runtimeType}',
            );
          }
        } catch (e, stackTrace) {
          debugPrint(
            'SupabaseRepository: Unexpected error processing lesson: $e',
          );
          debugPrint('SupabaseRepository: Stack trace: $stackTrace');
        }
      }

      debugPrint(
        'SupabaseRepository: Total lessons in database: ${responseList.length}',
      );
      debugPrint(
        'SupabaseRepository: Successfully parsed: ${lessons.length} lessons',
      );
      debugPrint(
        'SupabaseRepository: Failed to parse: ${failedLessons.length} lessons',
      );
      if (failedLessons.isNotEmpty) {
        debugPrint(
          'SupabaseRepository: Failed lesson IDs: ${failedLessons.map((f) => f['id']).toList()}',
        );
        for (final failed in failedLessons) {
          debugPrint(
            'SupabaseRepository:   - ${failed['id']}: ${failed['error']}',
          );
        }
      }

      if (lessons.isNotEmpty) {
        debugPrint(
          'SupabaseRepository: First lesson: ${lessons.first.id} - ${lessons.first.title} (level: ${lessons.first.level})',
        );
        debugPrint(
          'SupabaseRepository: All loaded lesson IDs: ${lessons.map((l) => l.id).toList()}',
        );
      }
      return lessons;
    } catch (e) {
      debugPrint('SupabaseRepository: Error getting lessons: $e');
      rethrow;
    }
  }

  Future<Lesson?> getLessonById(String id) async {
    final client = _getClient();
    final response = await client
        .from('lessons')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return Lesson.fromJson(response);
  }

  // Lesson Progress
  Future<List<LessonProgress>> getLessonProgress(String userId) async {
    final client = _getClient();
    final response = await client
        .from('lesson_progress')
        .select()
        .eq('user_id', userId);

    return (response as List)
        .map((json) => LessonProgress.fromJson(json))
        .toList();
  }

  Future<LessonProgress?> getLessonProgressById(
    String userId,
    String lessonId,
  ) async {
    final client = _getClient();
    final response = await client
        .from('lesson_progress')
        .select()
        .eq('user_id', userId)
        .eq('lesson_id', lessonId)
        .maybeSingle();

    if (response == null) return null;
    return LessonProgress.fromJson(response);
  }

  Future<void> upsertLessonProgress(LessonProgress progress) async {
    final client = _getClient();
    await client.from('lesson_progress').upsert(progress.toJson());
  }

  Future<void> deleteLessonProgress(String userId, String lessonId) async {
    final client = _getClient();
    await client
        .from('lesson_progress')
        .delete()
        .eq('user_id', userId)
        .eq('lesson_id', lessonId);
  }

  // User Languages
  Future<List<UserLanguage>> getUserLanguages(String userId) async {
    final client = _getClient();
    final response = await client
        .from('user_languages')
        .select()
        .eq('user_id', userId);

    return (response as List)
        .map((json) => UserLanguage.fromJson(json))
        .toList();
  }

  Future<void> upsertUserLanguage(UserLanguage userLanguage) async {
    final client = _getClient();
    await client.from('user_languages').upsert(userLanguage.toJson());
  }

  // Feature Flags
  Future<List<FeatureFlag>> getFeatureFlags() async {
    final client = _getClient();
    try {
      final response = await client.from('feature_flags').select().order('key');
      return (response as List)
          .map((json) => FeatureFlag.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<FeatureFlag?> getFeatureFlagByKey(String key) async {
    final client = _getClient();
    final response = await client
        .from('feature_flags')
        .select()
        .eq('key', key)
        .maybeSingle();

    if (response == null) return null;
    return FeatureFlag.fromJson(response);
  }

  /// Get game by game_id
  Future<Game?> getGameByGameId(String gameId) async {
    final client = _getClient();
    final response = await client
        .from('games')
        .select()
        .eq('game_id', gameId)
        .eq('is_active', true)
        .maybeSingle();

    if (response == null) return null;
    return Game.fromJson(response);
  }
}
