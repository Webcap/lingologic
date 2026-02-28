import 'package:flutter/foundation.dart';
import 'auth_service.dart';
import 'language_service.dart';

class TalkTutorService {
  final AuthService _auth = authService;
  final LanguageService _languageService = LanguageService();

  /// Sends user transcript to the Talk Tutor API and returns the AI response text.
  /// Returns null on error.
  /// [personality] optional: one of 'funny_serious', 'friendly', 'encouraging'.
  Future<String?> sendMessage(
    String transcript, {
    String? language,
    String? level,
    List<Map<String, String>>? history,
    String? personality,
  }) async {
    final lang = language ?? await _languageService.getActiveLanguage();
    if (lang == null || transcript.trim().isEmpty) {
      return null;
    }

    final body = <String, dynamic>{
      'transcript': transcript.trim(),
      'language': lang,
    };
    if (level != null && level.isNotEmpty) {
      body['level'] = level;
    }
    if (history != null && history.isNotEmpty) {
      body['conversationHistory'] = history;
    }
    if (personality != null && personality.isNotEmpty) {
      body['personality'] = personality;
    }

    try {
      final response = await _auth.postToApi('/api/talk-tutor/chat', body);
      if (response == null) return null;

      final error = response['error'] as String?;
      if (error != null) {
        debugPrint('TalkTutorService error: $error');
        return null;
      }

      return response['text'] as String?;
    } catch (e) {
      debugPrint('TalkTutorService sendMessage error: $e');
      return null;
    }
  }
}
