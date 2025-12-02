enum WordType {
  noun,
  verb,
  adjective,
  article,
  pronoun,
  preposition,
  conjunction,
}

class GrammarRule {
  final String id;
  final String description;
  final String pattern;
  final List<WordType> requiredTypes;

  GrammarRule({
    required this.id,
    required this.description,
    required this.pattern,
    required this.requiredTypes,
  });
}

/// Base interface for language-specific grammar services
abstract class GrammarServiceBase {
  /// Get all grammar rules for this language
  List<GrammarRule> getRules();

  /// Validate a sentence structure
  bool validateSentence(List<WordType> wordTypes);

  /// Generate grammar hints for Guided mode
  List<String> generateHints(List<WordType> currentSentence);

  /// Get word type from category string
  WordType? getWordTypeFromCategory(String category);

  /// Get sentence templates for this language
  List<List<String>> getSentenceTemplates();
}

