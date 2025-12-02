class UserProfile {
  final String id; // References auth.users.id
  final DateTime createdAt;
  final int streakDays;
  final int totalTimeMinutes;

  UserProfile({
    required this.id,
    required this.createdAt,
    required this.streakDays,
    required this.totalTimeMinutes,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      streakDays: json['streak_days'] as int,
      totalTimeMinutes: json['total_time_minutes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'streak_days': streakDays,
      'total_time_minutes': totalTimeMinutes,
    };
  }
}

