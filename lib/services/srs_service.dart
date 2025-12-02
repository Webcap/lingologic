import '../models/word_mastery.dart';

class SRSService {
  // Modified SuperMemo 2 algorithm constants
  static const double initialEaseFactor = 2.5;
  static const int initialInterval = 1; // days
  static const double minEaseFactor = 1.3;
  static const double maxEaseFactor = 2.5;

  /// Calculate next review date and update ease factor based on performance
  /// Quality: 0-5 scale (0 = complete blackout, 5 = perfect response)
  WordMastery updateMastery(
    WordMastery currentMastery,
    int quality, {
    DateTime? reviewDate,
  }) {
    final now = reviewDate ?? DateTime.now();
    final oldEaseFactor = currentMastery.easeFactor;
    final oldInterval = currentMastery.intervalDays;

    // Calculate new ease factor based on quality
    double newEaseFactor = oldEaseFactor +
        (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));

    // Clamp ease factor
    newEaseFactor = newEaseFactor.clamp(minEaseFactor, maxEaseFactor).toDouble();

    // Calculate new interval
    int newInterval;
    if (quality < 3) {
      // If quality is low, reset interval to 1 day
      newInterval = 1;
    } else {
      // Calculate new interval based on ease factor
      if (oldInterval == 0) {
        newInterval = 1;
      } else {
        newInterval = (oldInterval * newEaseFactor).round();
      }
    }

    // Calculate mastery level (0-2: Novice, 3-4: Intermediate, 5+: Mastered)
    int newMasteryLevel = currentMastery.masteryLevel;
    if (quality >= 4) {
      newMasteryLevel = (newMasteryLevel + 1).clamp(0, 10);
    } else if (quality <= 1) {
      newMasteryLevel = (newMasteryLevel - 1).clamp(0, 10);
    }

    // Calculate next review date
    final nextReviewDate = now.add(Duration(days: newInterval));

    return WordMastery(
      userId: currentMastery.userId,
      wordId: currentMastery.wordId,
      masteryLevel: newMasteryLevel,
      nextReviewDate: nextReviewDate,
      easeFactor: newEaseFactor,
      intervalDays: newInterval,
      lastReviewed: now,
    );
  }

  /// Create initial mastery record for a new word
  WordMastery createInitialMastery({
    required String userId,
    required String wordId,
  }) {
    return WordMastery(
      userId: userId,
      wordId: wordId,
      masteryLevel: 0, // Start as Novice
      nextReviewDate: DateTime.now().add(const Duration(days: 1)),
      easeFactor: initialEaseFactor,
      intervalDays: initialInterval,
      lastReviewed: null,
    );
  }

  /// Generate review queue prioritizing Novice → Intermediate → Mastered
  List<WordMastery> generateReviewQueue(
    List<WordMastery> allMasteries,
  ) {
    final now = DateTime.now();

    // Filter words that are due for review
    final dueForReview = allMasteries.where((mastery) {
      if (mastery.nextReviewDate == null) return true;
      return mastery.nextReviewDate!.isBefore(now) ||
          mastery.nextReviewDate!.isAtSameMomentAs(now);
    }).toList();

    // Sort by priority: Novice first, then Intermediate, then Mastered
    // Within each tier, sort by how overdue they are
    dueForReview.sort((a, b) {
      // First, sort by mastery level (lower = higher priority)
      if (a.masteryLevel != b.masteryLevel) {
        return a.masteryLevel.compareTo(b.masteryLevel);
      }

      // Then sort by how overdue (more overdue = higher priority)
      final aOverdue = a.nextReviewDate != null
          ? now.difference(a.nextReviewDate!).inDays
          : 999;
      final bOverdue = b.nextReviewDate != null
          ? now.difference(b.nextReviewDate!).inDays
          : 999;

      return bOverdue.compareTo(aOverdue);
    });

    return dueForReview;
  }

  /// Get mastery tier name
  String getMasteryTier(int masteryLevel) {
    if (masteryLevel <= 2) return 'Novice';
    if (masteryLevel <= 4) return 'Intermediate';
    return 'Mastered';
  }
}

