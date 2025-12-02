import '../../models/word.dart';
import '../../models/word_mastery.dart';
import '../../models/user_profile.dart';
import '../../models/game_session.dart';
import '../../config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class SupabaseRepository {
  final SupabaseClient _supabase = SupabaseConfig.client;

  // Words
  Future<List<Word>> getWords({String? language, String? category}) async {
    try {
      var query = _supabase.from('words').select();

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
    final response = await _supabase
        .from('words')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return Word.fromJson(response);
  }

  // Word Mastery
  Future<List<WordMastery>> getWordMasteries(String userId) async {
    final response = await _supabase
        .from('word_mastery')
        .select()
        .eq('user_id', userId);

    return (response as List)
        .map((json) => WordMastery.fromJson(json))
        .toList();
  }

  Future<void> upsertWordMastery(WordMastery mastery) async {
    await _supabase.from('word_mastery').upsert(mastery.toJson());
  }

  // User Profiles
  Future<UserProfile?> getUserProfile(String userId) async {
    final response = await _supabase
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserProfile.fromJson(response);
  }

  Future<void> upsertUserProfile(UserProfile profile) async {
    await _supabase.from('user_profiles').upsert(profile.toJson());
  }

  // Game Sessions
  Future<void> createGameSession(GameSession session) async {
    await _supabase.from('game_sessions').insert({
      ...session.toJson(),
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  Future<List<GameSession>> getGameSessions(String userId, {GameType? gameType}) async {
    var query = _supabase.from('game_sessions').select().eq('user_id', userId);

    if (gameType != null) {
      query = query.eq('game_type', gameType.name);
    }

    final response = await query;
    return (response as List)
        .map((json) => GameSession.fromJson(json))
        .toList();
  }
}

