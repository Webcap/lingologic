class WordMastery {
  final String userId;
  final String wordId;
  final int masteryLevel; // 0-2: Novice, 3-4: Intermediate, 5+: Mastered
  final DateTime? nextReviewDate;
  final double easeFactor;
  final int intervalDays;
  final DateTime? lastReviewed;

  WordMastery({
    required this.userId,
    required this.wordId,
    required this.masteryLevel,
    this.nextReviewDate,
    required this.easeFactor,
    required this.intervalDays,
    this.lastReviewed,
  });

  factory WordMastery.fromJson(Map<String, dynamic> json) {
    return WordMastery(
      userId: json['user_id'] as String,
      wordId: json['word_id'] as String,
      masteryLevel: json['mastery_level'] as int,
      nextReviewDate: json['next_review_date'] != null
          ? DateTime.parse(json['next_review_date'] as String)
          : null,
      easeFactor: (json['ease_factor'] as num).toDouble(),
      intervalDays: json['interval_days'] as int,
      lastReviewed: json['last_reviewed'] != null
          ? DateTime.parse(json['last_reviewed'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'word_id': wordId,
      'mastery_level': masteryLevel,
      'next_review_date': nextReviewDate?.toIso8601String(),
      'ease_factor': easeFactor,
      'interval_days': intervalDays,
      'last_reviewed': lastReviewed?.toIso8601String(),
    };
  }

  String get masteryTier {
    if (masteryLevel <= 2) return 'Novice';
    if (masteryLevel <= 4) return 'Intermediate';
    return 'Mastered';
  }
}

