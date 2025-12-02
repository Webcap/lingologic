class UserLanguage {
  final String userId;
  final String language; // e.g., 'spanish', 'french'
  final bool isActive;
  final DateTime startedAt;
  final int totalWordsLearned;
  final int totalLessonsCompleted;
  final int streakDays;
  final DateTime? lastPracticedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserLanguage({
    required this.userId,
    required this.language,
    required this.isActive,
    required this.startedAt,
    required this.totalWordsLearned,
    required this.totalLessonsCompleted,
    required this.streakDays,
    this.lastPracticedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserLanguage.fromJson(Map<String, dynamic> json) {
    return UserLanguage(
      userId: json['user_id'] as String,
      language: json['language'] as String,
      isActive: json['is_active'] as bool,
      startedAt: DateTime.parse(json['started_at'] as String),
      totalWordsLearned: json['total_words_learned'] as int,
      totalLessonsCompleted: json['total_lessons_completed'] as int,
      streakDays: json['streak_days'] as int,
      lastPracticedAt: json['last_practiced_at'] != null
          ? DateTime.parse(json['last_practiced_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'language': language,
      'is_active': isActive,
      'started_at': startedAt.toIso8601String(),
      'total_words_learned': totalWordsLearned,
      'total_lessons_completed': totalLessonsCompleted,
      'streak_days': streakDays,
      'last_practiced_at': lastPracticedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserLanguage copyWith({
    String? userId,
    String? language,
    bool? isActive,
    DateTime? startedAt,
    int? totalWordsLearned,
    int? totalLessonsCompleted,
    int? streakDays,
    DateTime? lastPracticedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserLanguage(
      userId: userId ?? this.userId,
      language: language ?? this.language,
      isActive: isActive ?? this.isActive,
      startedAt: startedAt ?? this.startedAt,
      totalWordsLearned: totalWordsLearned ?? this.totalWordsLearned,
      totalLessonsCompleted: totalLessonsCompleted ?? this.totalLessonsCompleted,
      streakDays: streakDays ?? this.streakDays,
      lastPracticedAt: lastPracticedAt ?? this.lastPracticedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

