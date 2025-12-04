import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage skipped pronunciation exercises with a 1-hour timeout
class PronunciationSkipService {
  static const String _skipKeyPrefix = 'pronunciation_skipped_';
  static const int _skipDurationHours = 1;
  static const int _skipDurationSeconds = _skipDurationHours * 60 * 60;

  /// Skip pronunciation exercises for 1 hour
  /// Returns true if successfully skipped
  Future<bool> skipPronunciation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await prefs.setInt('${_skipKeyPrefix}timestamp', timestamp);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if pronunciation exercises are currently skipped
  /// Returns true if skipped and the 1-hour period hasn't expired
  Future<bool> isPronunciationSkipped() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt('${_skipKeyPrefix}timestamp');
      
      if (timestamp == null) {
        return false;
      }

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final elapsed = now - timestamp;

      // If more than 1 hour has passed, skip has expired
      if (elapsed >= _skipDurationSeconds) {
        // Clean up expired skip
        await prefs.remove('${_skipKeyPrefix}timestamp');
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get the remaining time in seconds until the skip expires
  /// Returns 0 if not skipped or already expired
  Future<int> getRemainingSkipSeconds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt('${_skipKeyPrefix}timestamp');
      
      if (timestamp == null) {
        return 0;
      }

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final elapsed = now - timestamp;
      final remaining = _skipDurationSeconds - elapsed;

      if (remaining <= 0) {
        // Clean up expired skip
        await prefs.remove('${_skipKeyPrefix}timestamp');
        return 0;
      }

      return remaining;
    } catch (e) {
      return 0;
    }
  }

  /// Manually clear the skip (useful for testing or user action)
  Future<void> clearSkip() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('${_skipKeyPrefix}timestamp');
    } catch (e) {
      // Ignore errors
    }
  }
}

