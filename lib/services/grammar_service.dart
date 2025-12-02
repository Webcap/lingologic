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

class GrammarService {
  // Spanish grammar rules
  final List<GrammarRule> _rules = [
    GrammarRule(
      id: 'subject_verb_agreement',
      description: 'Subject and verb must agree in number and person',
      pattern: 'Subject + Verb',
      requiredTypes: [WordType.noun, WordType.verb],
    ),
    GrammarRule(
      id: 'article_noun_agreement',
      description: 'Article and noun must agree in gender and number',
      pattern: 'Article + Noun',
      requiredTypes: [WordType.article, WordType.noun],
    ),
  ];

  /// Validate a sentence structure
  bool validateSentence(List<WordType> wordTypes) {
    // Basic validation: check if sentence has at least a subject and verb
    final hasNoun = wordTypes.contains(WordType.noun);
    final hasVerb = wordTypes.contains(WordType.verb);

    if (!hasNoun || !hasVerb) {
      return false;
    }

    // Check subject-verb agreement (simplified for MVP)
    // In a real implementation, this would check number and person
    final nounIndex = wordTypes.indexOf(WordType.noun);
    final verbIndex = wordTypes.indexOf(WordType.verb);

    // Subject should come before verb in Spanish (simplified rule)
    return nounIndex < verbIndex;
  }

  /// Generate grammar hints for Guided mode
  List<String> generateHints(List<WordType> currentSentence) {
    final hints = <String>[];

    if (!currentSentence.contains(WordType.noun)) {
      hints.add('You need a noun (subject)');
    }

    if (!currentSentence.contains(WordType.verb)) {
      hints.add('You need a verb');
    }

    // Check article-noun agreement
    final hasArticle = currentSentence.contains(WordType.article);
    final hasNoun = currentSentence.contains(WordType.noun);

    if (hasArticle && hasNoun) {
      final articleIndex = currentSentence.indexOf(WordType.article);
      final nounIndex = currentSentence.indexOf(WordType.noun);

      if (articleIndex > nounIndex) {
        hints.add('Article should come before noun');
      }
    }

    return hints;
  }

  /// Get word type from category string
  WordType? getWordTypeFromCategory(String category) {
    switch (category.toLowerCase()) {
      case 'noun':
      case 'nouns':
        return WordType.noun;
      case 'verb':
      case 'verbs':
        return WordType.verb;
      case 'adjective':
      case 'adjectives':
        return WordType.adjective;
      case 'article':
      case 'articles':
        return WordType.article;
      case 'pronoun':
      case 'pronouns':
        return WordType.pronoun;
      case 'preposition':
      case 'prepositions':
        return WordType.preposition;
      case 'conjunction':
      case 'conjunctions':
        return WordType.conjunction;
      default:
        return null;
    }
  }

  /// Get all grammar rules
  List<GrammarRule> getRules() => List.unmodifiable(_rules);
}

