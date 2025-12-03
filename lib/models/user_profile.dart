class UserProfile {
  final String id; // References auth.users.id
  final String email;
  final DateTime createdAt;
  final int streakDays;
  final int totalTimeMinutes;
  final DateTime? lastActivityDate;
  final bool onboardingCompleted;

  UserProfile({
    required this.id,
    required this.email,
    required this.createdAt,
    required this.streakDays,
    required this.totalTimeMinutes,
    this.lastActivityDate,
    this.onboardingCompleted = false,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      streakDays: json['streak_days'] as int,
      totalTimeMinutes: json['total_time_minutes'] as int,
      lastActivityDate: json['last_activity_date'] != null
          ? DateTime.parse(json['last_activity_date'] as String)
          : null,
      onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'streak_days': streakDays,
      'total_time_minutes': totalTimeMinutes,
      if (lastActivityDate != null)
        'last_activity_date': lastActivityDate!.toIso8601String(),
      'onboarding_completed': onboardingCompleted,
    };
  }

  UserProfile copyWith({
    String? id,
    String? email,
    DateTime? createdAt,
    int? streakDays,
    int? totalTimeMinutes,
    DateTime? lastActivityDate,
    bool? onboardingCompleted,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      streakDays: streakDays ?? this.streakDays,
      totalTimeMinutes: totalTimeMinutes ?? this.totalTimeMinutes,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}

