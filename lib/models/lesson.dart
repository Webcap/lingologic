import 'lesson_content.dart';

class Lesson {
  final String id;
  final String title;
  final String? description;
  final String language;
  final String? category;
  final String? level; // CEFR level: A1, A2, B1, B2, C1, C2
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
    this.level,
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

    // Safely parse required fields with null checks
    final id = json['id'] as String?;
    if (id == null) {
      throw Exception('Lesson id is null');
    }

    final title = json['title'] as String?;
    if (title == null) {
      throw Exception('Lesson title is null');
    }

    final language = json['language'] as String?;
    if (language == null) {
      throw Exception('Lesson language is null');
    }

    final orderIndex = json['order_index'];
    final orderIndexInt = orderIndex is int
        ? orderIndex
        : (orderIndex is num ? orderIndex.toInt() : 0);

    final estimatedMinutes = json['estimated_minutes'];
    final estimatedMinutesInt = estimatedMinutes is int
        ? estimatedMinutes
        : (estimatedMinutes is num ? estimatedMinutes.toInt() : 5);

    final createdAtStr = json['created_at'];
    DateTime createdAt;
    if (createdAtStr is String) {
      createdAt = DateTime.parse(createdAtStr);
    } else if (createdAtStr is DateTime) {
      createdAt = createdAtStr;
    } else {
      createdAt = DateTime.now();
    }

    final updatedAtStr = json['updated_at'];
    DateTime updatedAt;
    if (updatedAtStr is String) {
      updatedAt = DateTime.parse(updatedAtStr);
    } else if (updatedAtStr is DateTime) {
      updatedAt = updatedAtStr;
    } else {
      updatedAt = DateTime.now();
    }

    return Lesson(
      id: id,
      title: title,
      description: json['description'] as String?,
      language: language,
      category: json['category'] as String?,
      level: json['level'] as String?,
      orderIndex: orderIndexInt,
      estimatedMinutes: estimatedMinutesInt,
      content: content,
      unlocksWordIds: json['unlocks_word_ids'] != null
          ? List<String>.from(json['unlocks_word_ids'] as List)
          : [],
      unlocksGrammarConcepts: json['unlocks_grammar_concepts'] != null
          ? List<String>.from(json['unlocks_grammar_concepts'] as List)
          : [],
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'language': language,
      'category': category,
      'level': level,
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
    String? level,
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
      level: level ?? this.level,
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

