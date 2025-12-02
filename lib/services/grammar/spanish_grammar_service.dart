import 'grammar_service_base.dart';
import '../../data/seed/spanish_grammar_rules.dart';

class SpanishGrammarService implements GrammarServiceBase {
  @override
  List<GrammarRule> getRules() {
    return SpanishGrammarRules.getRules();
  }

  @override
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

  @override
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

  @override
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

  @override
  List<List<String>> getSentenceTemplates() {
    return SpanishGrammarRules.getSentenceTemplates();
  }
}

