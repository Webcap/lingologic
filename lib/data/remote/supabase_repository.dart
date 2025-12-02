import '../../models/word.dart';
import '../../models/word_mastery.dart';
import '../../models/user_profile.dart';
import '../../models/game_session.dart';
import '../../models/lesson.dart';
import '../../models/lesson_progress.dart';
import '../../models/user_language.dart';
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
      throw Exception('Supabase client is not initialized. Cannot perform database operations.');
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

  Future<List<GameSession>> getGameSessions(String userId, {GameType? gameType}) async {
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
        query = query.eq('language', language);
      }
      if (category != null) {
        query = query.eq('category', category);
      }

      final response = await query.order('order_index');
      return (response as List).map((json) => Lesson.fromJson(json)).toList();
    } catch (e) {
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
      String userId, String lessonId) async {
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
}

