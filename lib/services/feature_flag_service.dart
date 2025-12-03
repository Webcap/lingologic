import 'package:flutter/foundation.dart';
import '../models/feature_flag.dart';
import '../data/remote/supabase_repository.dart';
import '../config/supabase_config.dart';

class FeatureFlagService {
  final SupabaseRepository _repository = SupabaseRepository();
  Map<String, FeatureFlag>? _cachedFlags;
  DateTime? _lastFetchTime;
  static const Duration _cacheDuration = Duration(minutes: 5);

  /// Get all feature flags from the database
  Future<Map<String, FeatureFlag>> getAllFeatureFlags({bool forceRefresh = false}) async {
    // Return cached flags if available and not expired
    if (!forceRefresh &&
        _cachedFlags != null &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
      return _cachedFlags!;
    }

    try {
      final flags = await _repository.getFeatureFlags();
      _cachedFlags = {for (var flag in flags) flag.key: flag};
      _lastFetchTime = DateTime.now();
      return _cachedFlags!;
    } catch (e) {
      debugPrint('Error fetching feature flags: $e');
      // Return cached flags if available, even if expired
      if (_cachedFlags != null) {
        return _cachedFlags!;
      }
      // Return empty map if no cache available
      return {};
    }
  }

  /// Check if a specific feature flag is enabled
  /// Returns false by default if flag doesn't exist
  Future<bool> isFeatureEnabled(String featureKey) async {
    try {
      final flags = await getAllFeatureFlags();
      final flag = flags[featureKey];
      
      if (flag == null) {
        debugPrint('Feature flag "$featureKey" not found, returning false');
        return false;
      }

      if (!flag.enabled) {
        return false;
      }

      // If enabled and percentage is less than 100, check if user should see it
      if (flag.enabledForPercentage < 100) {
        // Simple hash-based percentage rollout
        // This ensures consistent experience for each user
        try {
          final client = SupabaseConfig.client;
          final userId = client?.auth.currentUser?.id;
          if (userId != null) {
            final hash = _hashString('$userId:$featureKey');
            final percentage = (hash % 100);
            return percentage < flag.enabledForPercentage;
          }
        } catch (e) {
          debugPrint('Error getting user ID for feature flag: $e');
        }
        // If no user, use a random approach (not ideal, but better than nothing)
        return DateTime.now().millisecondsSinceEpoch % 100 < flag.enabledForPercentage;
      }

      return true;
    } catch (e) {
      debugPrint('Error checking feature flag "$featureKey": $e');
      return false; // Fail closed - if error, assume feature is disabled
    }
  }

  /// Get a specific feature flag by key
  Future<FeatureFlag?> getFeatureFlag(String featureKey) async {
    try {
      final flags = await getAllFeatureFlags();
      return flags[featureKey];
    } catch (e) {
      debugPrint('Error getting feature flag "$featureKey": $e');
      return null;
    }
  }

  /// Invalidate the cache and force a refresh on next request
  void invalidateCache() {
    _cachedFlags = null;
    _lastFetchTime = null;
  }

  /// Simple hash function for percentage rollout
  int _hashString(String input) {
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = ((hash << 5) - hash) + input.codeUnitAt(i);
      hash = hash & hash; // Convert to 32-bit integer
    }
    return hash.abs();
  }
}

/// Singleton instance for easy access
final featureFlagService = FeatureFlagService();

