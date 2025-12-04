class LevelProgressionTest {
  final String id;
  final String userId;
  final String language;
  final String level;
  final bool passed;
  final int score;
  final int totalQuestions;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  LevelProgressionTest({
    required this.id,
    required this.userId,
    required this.language,
    required this.level,
    required this.passed,
    required this.score,
    required this.totalQuestions,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LevelProgressionTest.fromJson(Map<String, dynamic> json) {
    return LevelProgressionTest(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      language: json['language'] as String,
      level: json['level'] as String,
      passed: json['passed'] as bool? ?? false,
      score: json['score'] as int? ?? 0,
      totalQuestions: json['total_questions'] as int? ?? 0,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'language': language,
      'level': level,
      'passed': passed,
      'score': score,
      'total_questions': totalQuestions,
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  LevelProgressionTest copyWith({
    String? id,
    String? userId,
    String? language,
    String? level,
    bool? passed,
    int? score,
    int? totalQuestions,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LevelProgressionTest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      language: language ?? this.language,
      level: level ?? this.level,
      passed: passed ?? this.passed,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


