class DDAService {
  // Performance thresholds
  static const double successRateThreshold = 0.9; // 90%
  static const int reactionTimeThreshold = 2000; // 2 seconds in milliseconds

  // Difficulty adjustment parameters
  static const double difficultyIncrease = 0.1; // 10% increase
  static const double difficultyDecrease = 0.05; // 5% decrease

  // Session performance tracking
  final List<bool> _sessionResults = [];
  final List<int> _reactionTimes = [];

  /// Record a game result
  void recordResult({
    required bool isCorrect,
    required int reactionTimeMs,
  }) {
    _sessionResults.add(isCorrect);
    _reactionTimes.add(reactionTimeMs);
  }

  /// Calculate current session success rate
  double getSuccessRate() {
    if (_sessionResults.isEmpty) return 0.0;
    final correctCount = _sessionResults.where((r) => r).length;
    return correctCount / _sessionResults.length;
  }

  /// Calculate average reaction time
  double getAverageReactionTime() {
    if (_reactionTimes.isEmpty) return 0.0;
    final sum = _reactionTimes.reduce((a, b) => a + b);
    return sum / _reactionTimes.length;
  }

  /// Check if performance meets threshold for difficulty increase
  bool shouldIncreaseDifficulty() {
    final successRate = getSuccessRate();
    final avgReactionTime = getAverageReactionTime();

    return successRate >= successRateThreshold &&
        avgReactionTime < reactionTimeThreshold;
  }

  /// Check if performance is below threshold (needs difficulty decrease)
  bool shouldDecreaseDifficulty() {
    final successRate = getSuccessRate();
    return successRate < 0.7; // Below 70% success rate
  }

  /// Adjust difficulty multiplier based on performance
  double adjustDifficulty(double currentDifficulty) {
    if (shouldIncreaseDifficulty()) {
      return currentDifficulty * (1 + difficultyIncrease);
    } else if (shouldDecreaseDifficulty()) {
      return (currentDifficulty * (1 - difficultyDecrease)).clamp(0.5, 2.0);
    }
    return currentDifficulty;
  }

  /// Adjust speed based on difficulty multiplier
  double adjustSpeed(double baseSpeed, double difficultyMultiplier) {
    return baseSpeed * difficultyMultiplier;
  }

  /// Adjust time limit based on difficulty multiplier
  int adjustTimeLimit(int baseTimeLimit, double difficultyMultiplier) {
    // Higher difficulty = less time
    return (baseTimeLimit / difficultyMultiplier).round();
  }

  /// Reset session tracking
  void resetSession() {
    _sessionResults.clear();
    _reactionTimes.clear();
  }

  /// Get current session stats
  Map<String, dynamic> getSessionStats() {
    return {
      'success_rate': getSuccessRate(),
      'average_reaction_time': getAverageReactionTime(),
      'total_attempts': _sessionResults.length,
      'correct_attempts': _sessionResults.where((r) => r).length,
    };
  }
}

