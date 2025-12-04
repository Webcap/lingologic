import '../models/lesson.dart';
import '../models/lesson_content.dart';
import 'app_language_service.dart';

/// Service to handle translation of lesson content based on app language
class LessonTranslationService {
  final AppLanguageService _appLanguageService = AppLanguageService();
  
  /// Get the current app language code (e.g., 'en', 'es')
  Future<String> _getAppLanguageCode() async {
    return await _appLanguageService.getLanguageCode();
  }

  /// Translate a lesson based on the current app language
  /// Falls back to original content if translation not available
  Future<Lesson> translateLesson(Lesson lesson) async {
    final appLanguage = await _getAppLanguageCode();
    
    // If app language is English (default), return original
    if (appLanguage == 'en') {
      return lesson;
    }

    // Try to get translated content
    final translatedContent = await _translateContent(lesson.content, appLanguage);
    
    // Get translated title and description from content_json.translations
    final translatedTitle = _getLessonTranslation(lesson.content, 'title', appLanguage) ?? lesson.title;
    final translatedDescription = lesson.description != null
        ? (_getLessonTranslation(lesson.content, 'description', appLanguage) ?? lesson.description)
        : null;

    return lesson.copyWith(
      title: translatedTitle,
      description: translatedDescription,
      content: translatedContent,
    );
  }

  /// Translate lesson content sections
  Future<LessonContent> _translateContent(LessonContent content, String targetLanguage) async {
    final translatedSections = <LessonSection>[];

    for (int i = 0; i < content.sections.length; i++) {
      // Get original section JSON to access translations
      final sectionJson = content.getSectionJson(i);
      if (sectionJson != null) {
        // Use original JSON which includes translations
        final translatedSection = _translateSection(sectionJson, targetLanguage);
        if (translatedSection != null) {
          translatedSections.add(translatedSection);
        } else {
          // Fallback to original if translation fails
          translatedSections.add(content.sections[i]);
        }
      } else {
        // Fallback if we can't access original JSON
        translatedSections.add(content.sections[i]);
      }
    }

    return LessonContent(sections: translatedSections, translations: content.translations);
  }

  /// Translate a single section
  LessonSection? _translateSection(Map<String, dynamic> sectionJson, String targetLanguage) {
    try {
      final translations = sectionJson['translations'] as Map<String, dynamic>?;
      if (translations == null || !translations.containsKey(targetLanguage)) {
        return null; // No translation available, will use original
      }

      final sectionTranslations = translations[targetLanguage] as Map<String, dynamic>?;
      if (sectionTranslations == null) {
        return null;
      }

      // Create a copy of the section JSON with translated fields
      final translatedJson = Map<String, dynamic>.from(sectionJson);
      
      // Apply translations based on section type
      final sectionType = sectionJson['type'] as String;
      switch (sectionType) {
        case 'text':
          return _translateTextSection(translatedJson, sectionTranslations);
        case 'exercise':
          return _translateExerciseSection(translatedJson, sectionTranslations);
        case 'matching':
          return _translateMatchingSection(translatedJson, sectionTranslations);
        case 'pronunciation':
          return _translatePronunciationSection(translatedJson, sectionTranslations);
        case 'example':
          return _translateExampleSection(translatedJson, sectionTranslations);
        default:
          return null;
      }
    } catch (e) {
      return null; // Error in translation, fallback to original
    }
  }

  /// Translate TextSection
  LessonSection _translateTextSection(Map<String, dynamic> json, Map<String, dynamic> translations) {
    if (translations.containsKey('title')) {
      json['title'] = translations['title'];
    }
    if (translations.containsKey('content')) {
      json['content'] = translations['content'];
    }
    if (translations.containsKey('examples')) {
      json['examples'] = translations['examples'];
    }
    if (translations.containsKey('explanation')) {
      json['explanation'] = translations['explanation'];
    }
    return LessonSection.fromJson(json);
  }

  /// Translate ExerciseSection
  LessonSection _translateExerciseSection(Map<String, dynamic> json, Map<String, dynamic> translations) {
    if (translations.containsKey('instruction')) {
      json['instruction'] = translations['instruction'];
    }
    if (translations.containsKey('question')) {
      json['question'] = translations['question'];
    }
    if (translations.containsKey('explanation')) {
      json['explanation'] = translations['explanation'];
    }
    if (translations.containsKey('hint')) {
      json['hint'] = translations['hint'];
    }
    if (translations.containsKey('options')) {
      json['options'] = translations['options'];
    }
    return LessonSection.fromJson(json);
  }

  /// Translate MatchingExerciseSection
  LessonSection _translateMatchingSection(Map<String, dynamic> json, Map<String, dynamic> translations) {
    if (translations.containsKey('instruction')) {
      json['instruction'] = translations['instruction'];
    }
    if (translations.containsKey('explanation')) {
      json['explanation'] = translations['explanation'];
    }
    return LessonSection.fromJson(json);
  }

  /// Translate PronunciationExerciseSection
  LessonSection _translatePronunciationSection(Map<String, dynamic> json, Map<String, dynamic> translations) {
    if (translations.containsKey('instruction')) {
      json['instruction'] = translations['instruction'];
    }
    if (translations.containsKey('explanation')) {
      json['explanation'] = translations['explanation'];
    }
    return LessonSection.fromJson(json);
  }

  /// Translate ExampleSection
  LessonSection _translateExampleSection(Map<String, dynamic> json, Map<String, dynamic> translations) {
    if (translations.containsKey('explanation')) {
      json['explanation'] = translations['explanation'];
    }
    return LessonSection.fromJson(json);
  }

  /// Get translation from content_json.translations (for lesson title/description)
  String? _getLessonTranslation(LessonContent content, String field, String targetLanguage) {
    try {
      final translations = content.translations;
      if (translations == null) return null;
      
      final languageTranslations = translations[targetLanguage] as Map<String, dynamic>?;
      if (languageTranslations == null) return null;
      
      return languageTranslations[field] as String?;
    } catch (e) {
      return null;
    }
  }
}

