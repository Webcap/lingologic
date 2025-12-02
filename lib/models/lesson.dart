import 'lesson_content.dart';

class Lesson {
  final String id;
  final String title;
  final String? description;
  final String language;
  final String? category;
  final int orderIndex;
  final int estimatedMinutes;
  final LessonContent content;
  final List<String> unlocksWordIds;
  final List<String> unlocksGrammarConcepts;
  final DateTime createdAt;
  final DateTime updatedAt;

  Lesson({
    required this.id,
    required this.title,
    this.description,
    required this.language,
    this.category,
    required this.orderIndex,
    required this.estimatedMinutes,
    required this.content,
    required this.unlocksWordIds,
    required this.unlocksGrammarConcepts,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    // Parse content_json from JSONB
    final contentJson = json['content_json'];
    LessonContent content;
    if (contentJson is String) {
      content = LessonContent.fromJsonString(contentJson);
    } else if (contentJson is Map) {
      content = LessonContent.fromJson(contentJson as Map<String, dynamic>);
    } else {
      throw Exception('Invalid content_json format');
    }

    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      language: json['language'] as String,
      category: json['category'] as String?,
      orderIndex: json['order_index'] as int,
      estimatedMinutes: json['estimated_minutes'] as int,
      content: content,
      unlocksWordIds: json['unlocks_word_ids'] != null
          ? List<String>.from(json['unlocks_word_ids'] as List)
          : [],
      unlocksGrammarConcepts: json['unlocks_grammar_concepts'] != null
          ? List<String>.from(json['unlocks_grammar_concepts'] as List)
          : [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'language': language,
      'category': category,
      'order_index': orderIndex,
      'estimated_minutes': estimatedMinutes,
      'content_json': content.toJson(),
      'unlocks_word_ids': unlocksWordIds,
      'unlocks_grammar_concepts': unlocksGrammarConcepts,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Lesson copyWith({
    String? id,
    String? title,
    String? description,
    String? language,
    String? category,
    int? orderIndex,
    int? estimatedMinutes,
    LessonContent? content,
    List<String>? unlocksWordIds,
    List<String>? unlocksGrammarConcepts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      language: language ?? this.language,
      category: category ?? this.category,
      orderIndex: orderIndex ?? this.orderIndex,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      content: content ?? this.content,
      unlocksWordIds: unlocksWordIds ?? this.unlocksWordIds,
      unlocksGrammarConcepts: unlocksGrammarConcepts ?? this.unlocksGrammarConcepts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

