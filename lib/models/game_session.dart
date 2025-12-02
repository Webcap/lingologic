enum GameType {
  neuroMatch,
  syntaxConstructor,
}

class GameSession {
  final String userId;
  final GameType gameType;
  final DateTime startTime;
  final DateTime? endTime;
  final int score;
  final String difficultyLevel;
  final String? language; // Language being practiced

  GameSession({
    required this.userId,
    required this.gameType,
    required this.startTime,
    this.endTime,
    required this.score,
    required this.difficultyLevel,
    this.language,
  });

  factory GameSession.fromJson(Map<String, dynamic> json) {
    return GameSession(
      userId: json['user_id'] as String,
      gameType: GameType.values.firstWhere(
        (e) => e.name == json['game_type'] as String,
      ),
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      score: json['score'] as int,
      difficultyLevel: json['difficulty_level'] as String,
      language: json['language'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'game_type': gameType.name,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'score': score,
      'difficulty_level': difficultyLevel,
      'language': language,
    };
  }
}

