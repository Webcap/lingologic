import '../models/word.dart';
import '../models/lesson.dart';
import '../data/seed/vocabulary/spanish_vocabulary.dart';
import '../data/seed/lessons/spanish_lessons.dart';

/// Service for loading seed data by language
/// Provides a centralized way to access seed data for different languages
class SeedDataLoader {
  /// Get vocabulary words for a specific language
  static List<Word> getVocabularyForLanguage(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'es':
      case 'spanish':
        return SpanishVocabulary.getSeedWords();
      // Add more languages here as they become available
      // case 'fr':
      // case 'french':
      //   return FrenchVocabulary.getSeedWords();
      default:
        throw ArgumentError('Unsupported language code: $languageCode');
    }
  }

  /// Get lessons for a specific language
  static List<Lesson> getLessonsForLanguage(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'es':
      case 'spanish':
        return SpanishLessons.getLessons();
      // Add more languages here as they become available
      // case 'fr':
      // case 'french':
      //   return FrenchLessons.getLessons();
      default:
        throw ArgumentError('Unsupported language code: $languageCode');
    }
  }

  /// Check if a language has seed data available
  static bool hasSeedDataForLanguage(String languageCode) {
    try {
      getVocabularyForLanguage(languageCode);
      getLessonsForLanguage(languageCode);
      return true;
    } catch (e) {
      return false;
    }
  }
}

