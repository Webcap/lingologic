// ignore_for_file: unused_import

import 'package:supabase_flutter/supabase_flutter.dart';

enum LessonStatus {
  notStarted('not_started'),
  inProgress('in_progress'),
  completed('completed');

  final String value;
  const LessonStatus(this.value);

  static LessonStatus fromString(String value) {
    return LessonStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => LessonStatus.notStarted,
    );
  }
}

class LessonProgress {
  final String userId;
  final String lessonId;
  final LessonStatus status;
  final int progressPercentage;
  final DateTime? completedAt;
  final int timeSpentMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;

  LessonProgress({
    required this.userId,
    required this.lessonId,
    required this.status,
    required this.progressPercentage,
    this.completedAt,
    required this.timeSpentMinutes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      userId: json['user_id'] as String,
      lessonId: json['lesson_id'] as String,
      status: LessonStatus.fromString(json['status'] as String),
      progressPercentage: json['progress_percentage'] as int,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      timeSpentMinutes: json['time_spent_minutes'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'lesson_id': lessonId,
      'status': status.value,
      'progress_percentage': progressPercentage,
      'completed_at': completedAt?.toIso8601String(),
      'time_spent_minutes': timeSpentMinutes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  LessonProgress copyWith({
    String? userId,
    String? lessonId,
    LessonStatus? status,
    int? progressPercentage,
    DateTime? completedAt,
    int? timeSpentMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LessonProgress(
      userId: userId ?? this.userId,
      lessonId: lessonId ?? this.lessonId,
      status: status ?? this.status,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      completedAt: completedAt ?? this.completedAt,
      timeSpentMinutes: timeSpentMinutes ?? this.timeSpentMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isCompleted => status == LessonStatus.completed;
  bool get isInProgress => status == LessonStatus.inProgress;
  bool get isNotStarted => status == LessonStatus.notStarted;
}

