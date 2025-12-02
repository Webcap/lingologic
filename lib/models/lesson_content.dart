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

  ExerciseSection({
    required String id,
    required this.question,
    required this.options,
    this.explanation,
  }) : super(type: 'exercise', id: id);

  factory ExerciseSection.fromJson(Map<String, dynamic> json) {
    return ExerciseSection(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List)
          .map((opt) => ExerciseOption.fromJson(opt as Map<String, dynamic>))
          .toList(),
      explanation: json['explanation'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'question': question,
      'options': options.map((opt) => opt.toJson()).toList(),
      'explanation': explanation,
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

  int get totalExercises => exercises.length;
}

