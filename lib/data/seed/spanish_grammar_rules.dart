import '../../services/grammar_service.dart';

class SpanishGrammarRules {
  static List<GrammarRule> getRules() {
    return [
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
      GrammarRule(
        id: 'adjective_noun_agreement',
        description: 'Adjective and noun must agree in gender and number',
        pattern: 'Noun + Adjective or Article + Noun + Adjective',
        requiredTypes: [WordType.noun, WordType.adjective],
      ),
    ];
  }

  static List<List<String>> getSentenceTemplates() {
    return [
      // Simple sentences
      ['article', 'noun', 'verb'],
      ['article', 'noun', 'verb', 'adjective'],
      ['noun', 'verb'],
      ['article', 'adjective', 'noun', 'verb'],

      // With objects
      ['article', 'noun', 'verb', 'article', 'noun'],
      ['noun', 'verb', 'article', 'noun'],
    ];
  }
}

