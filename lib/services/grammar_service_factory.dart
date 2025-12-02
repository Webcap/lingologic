import 'grammar/grammar_service_base.dart';
import 'grammar/spanish_grammar_service.dart';

class GrammarServiceFactory {
  /// Get the appropriate grammar service for a language
  static GrammarServiceBase getGrammarService(String language) {
    switch (language.toLowerCase()) {
      case 'spanish':
      case 'es':
        return SpanishGrammarService();
      // Add more languages as they become available
      // case 'french':
      // case 'fr':
      //   return FrenchGrammarService();
      default:
        // Default to Spanish for now
        return SpanishGrammarService();
    }
  }
}

