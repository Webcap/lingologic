import 'dart:convert';

// Base class for lesson sections
abstract class LessonSection {
  final String type;
  final String id;

  LessonSection({
    required this.type,
    required this.id,
  });

  Map<String, dynamic> toJson();
  factory LessonSection.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'text':
        return TextSection.fromJson(json);
      case 'exercise':
        return ExerciseSection.fromJson(json);
      case 'example':
        return ExampleSection.fromJson(json);
      case 'matching':
        return MatchingExerciseSection.fromJson(json);
      case 'pronunciation':
        return PronunciationExerciseSection.fromJson(json);
      default:
        throw Exception('Unknown lesson section type: $type');
    }
  }
}

// Text section for explanations and content
class TextSection extends LessonSection {
  final String title;
  final String content;
  final List<String>? examples;

  TextSection({
    required String id,
    required this.title,
    required this.content,
    this.examples,
  }) : super(type: 'text', id: id);

  factory TextSection.fromJson(Map<String, dynamic> json) {
    return TextSection(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      examples: json['examples'] != null
          ? List<String>.from(json['examples'] as List)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'title': title,
      'content': content,
      'examples': examples,
    };
  }
}

// Exercise option for multiple choice questions
class ExerciseOption {
  final String text;
  final bool isCorrect;

  ExerciseOption({
    required this.text,
    required this.isCorrect,
  });

  factory ExerciseOption.fromJson(Map<String, dynamic> json) {
    return ExerciseOption(
      text: json['text'] as String,
      isCorrect: json['is_correct'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'is_correct': isCorrect,
    };
  }
}

// Exercise section for interactive quizzes
class ExerciseSection extends LessonSection {
  final String question;
  final List<ExerciseOption> options;
  final String? explanation;
  final String? hint;

  ExerciseSection({
    required String id,
    required this.question,
    required this.options,
    this.explanation,
    this.hint,
  }) : super(type: 'exercise', id: id);

  factory ExerciseSection.fromJson(Map<String, dynamic> json) {
    return ExerciseSection(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List)
          .map((opt) => ExerciseOption.fromJson(opt as Map<String, dynamic>))
          .toList(),
      explanation: json['explanation'] as String?,
      hint: json['hint'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'question': question,
      'options': options.map((opt) => opt.toJson()).toList(),
      if (explanation != null) 'explanation': explanation,
      if (hint != null) 'hint': hint,
    };
  }

  int get correctAnswerIndex {
    return options.indexWhere((opt) => opt.isCorrect);
  }
}

// Example section for Spanish/English translations
class ExampleSection extends LessonSection {
  final String spanishExample;
  final String englishTranslation;
  final String? explanation;

  ExampleSection({
    required String id,
    required this.spanishExample,
    required this.englishTranslation,
    this.explanation,
  }) : super(type: 'example', id: id);

  factory ExampleSection.fromJson(Map<String, dynamic> json) {
    return ExampleSection(
      id: json['id'] as String,
      spanishExample: json['spanish_example'] as String,
      englishTranslation: json['english_translation'] as String,
      explanation: json['explanation'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'spanish_example': spanishExample,
      'english_translation': englishTranslation,
      'explanation': explanation,
    };
  }
}

// Main lesson content container
class LessonContent {
  final List<LessonSection> sections;

  LessonContent({
    required this.sections,
  });

  factory LessonContent.fromJson(Map<String, dynamic> json) {
    final sectionsJson = json['sections'] as List;
    return LessonContent(
      sections: sectionsJson
          .map((section) => LessonSection.fromJson(section as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sections': sections.map((section) => section.toJson()).toList(),
    };
  }

  factory LessonContent.fromJsonString(String jsonString) {
    return LessonContent.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  List<ExerciseSection> get exercises {
    return sections
        .whereType<ExerciseSection>()
        .toList();
  }

  List<MatchingExerciseSection> get matchingExercises {
    return sections
        .whereType<MatchingExerciseSection>()
        .toList();
  }

  List<PronunciationExerciseSection> get pronunciationExercises {
    return sections
        .whereType<PronunciationExerciseSection>()
        .toList();
  }

  int get totalExercises => exercises.length + matchingExercises.length + pronunciationExercises.length;
}

// Pronunciation exercise section for practicing pronunciation
class PronunciationExerciseSection extends LessonSection {
  final String instruction;
  final List<PronunciationWord> words; // Words to practice pronouncing
  final String? explanation;
  final String? languageCode; // Language code for TTS (e.g., 'es' for Spanish, 'en' for English)

  PronunciationExerciseSection({
    required String id,
    required this.instruction,
    required this.words,
    this.explanation,
    this.languageCode,
  }) : super(type: 'pronunciation', id: id);

  factory PronunciationExerciseSection.fromJson(Map<String, dynamic> json) {
    return PronunciationExerciseSection(
      id: json['id'] as String,
      instruction: json['instruction'] as String? ?? 'Pronounce the following words',
      words: (json['words'] as List)
          .map((word) => PronunciationWord.fromJson(word as Map<String, dynamic>))
          .toList(),
      explanation: json['explanation'] as String?,
      languageCode: json['language_code'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'instruction': instruction,
      'words': words.map((word) => word.toJson()).toList(),
      if (explanation != null) 'explanation': explanation,
      if (languageCode != null) 'language_code': languageCode,
    };
  }
}

// Word to practice pronunciation
class PronunciationWord {
  final String word; // The word to pronounce
  final String? phonetic; // Optional phonetic spelling (e.g., "ha-LOW")
  final String? translation; // Optional translation
  final String? wordId; // Optional: reference to word from lesson vocabulary
  final double? similarityThreshold; // Optional: minimum similarity score (0.0-1.0)

  PronunciationWord({
    required this.word,
    this.phonetic,
    this.translation,
    this.wordId,
    this.similarityThreshold,
  });

  factory PronunciationWord.fromJson(Map<String, dynamic> json) {
    return PronunciationWord(
      word: json['word'] as String,
      phonetic: json['phonetic'] as String?,
      translation: json['translation'] as String?,
      wordId: json['word_id'] as String?,
      similarityThreshold: json['similarity_threshold'] != null
          ? (json['similarity_threshold'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      if (phonetic != null) 'phonetic': phonetic,
      if (translation != null) 'translation': translation,
      if (wordId != null) 'word_id': wordId,
      if (similarityThreshold != null) 'similarity_threshold': similarityThreshold,
    };
  }
}

// Word pair for matching exercises
class WordPair {
  final String word;
  final String translation;
  final String? wordId; // Optional: reference to word from lesson vocabulary

  WordPair({
    required this.word,
    required this.translation,
    this.wordId,
  });

  factory WordPair.fromJson(Map<String, dynamic> json) {
    return WordPair(
      word: json['word'] as String,
      translation: json['translation'] as String,
      wordId: json['word_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'translation': translation,
      if (wordId != null) 'word_id': wordId,
    };
  }
}

// Matching exercise section for word matching
class MatchingExerciseSection extends LessonSection {
  final String instruction;
  final List<WordPair> pairs; // Correct word pairs to match
  final List<String>? distractors; // Optional extra words to make it harder
  final String? explanation;

  MatchingExerciseSection({
    required String id,
    required this.instruction,
    required this.pairs,
    this.distractors,
    this.explanation,
  }) : super(type: 'matching', id: id);

  factory MatchingExerciseSection.fromJson(Map<String, dynamic> json) {
    return MatchingExerciseSection(
      id: json['id'] as String,
      instruction: json['instruction'] as String? ?? 'Match the words with their translations',
      pairs: (json['pairs'] as List)
          .map((pair) => WordPair.fromJson(pair as Map<String, dynamic>))
          .toList(),
      distractors: json['distractors'] != null
          ? List<String>.from(json['distractors'] as List)
          : null,
      explanation: json['explanation'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'instruction': instruction,
      'pairs': pairs.map((pair) => pair.toJson()).toList(),
      if (distractors != null) 'distractors': distractors,
      if (explanation != null) 'explanation': explanation,
    };
  }
}

