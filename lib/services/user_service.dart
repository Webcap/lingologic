import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/user_profile.dart';
import '../config/supabase_config.dart';
import 'auth_service.dart';

class UserService {
  SupabaseClient? _supabase;
  final AuthService _authService;
  
  UserService({AuthService? authService}) 
      : _authService = authService ?? AuthService();
  
  SupabaseClient? get _supabaseClient {
    if (_supabase == null) {
      _supabase = SupabaseConfig.client;
    }
    return _supabase;
  }

  /// Create or get user profile
  Future<UserProfile> getOrCreateUserProfile() async {
    final user = _authService.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final client = _supabaseClient;
    if (client == null) {
      throw Exception('Supabase not initialized');
    }
    
    try {
      // Check if profile exists
      final response = await client
          .from('user_profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        final profile = UserProfile.fromJson(response);
        // Sync email if it's missing or different from auth user
        final currentEmail = user.email ?? '';
        if (profile.email != currentEmail && currentEmail.isNotEmpty) {
          await client.from('user_profiles').update({
            'email': currentEmail,
          }).eq('id', user.id);
          return profile.copyWith(email: currentEmail);
        }
        return profile;
      }

      // Create new profile
      final newProfile = UserProfile(
        id: user.id,
        email: user.email ?? '',
        createdAt: DateTime.now(),
        streakDays: 0,
        totalTimeMinutes: 0,
      );

      final insertResponse = await client
          .from('user_profiles')
          .insert(newProfile.toJson())
          .select()
          .single();

      return UserProfile.fromJson(insertResponse);
    } catch (e) {
      // Re-throw with more context
      throw Exception('Failed to create user profile: $e');
    }
  }

  /// Update streak days based on activity date
  /// This should be called whenever a user completes an activity (lesson, game, etc.)
  Future<void> updateStreak() async {
    final user = _authService.currentUser;
    if (user == null) return;

    final profile = await getOrCreateUserProfile();
    final client = _supabaseClient;
    if (client == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Get last activity date, defaulting to createdAt if never set
    final lastActivity = profile.lastActivityDate ?? profile.createdAt;
    final lastActivityDate = DateTime(lastActivity.year, lastActivity.month, lastActivity.day);
    
    // Calculate days difference
    final daysDifference = today.difference(lastActivityDate).inDays;
    
    int newStreak = profile.streakDays;
    
    if (daysDifference == 0) {
      // Same day - no streak update needed, but update last_activity_date
      await client.from('user_profiles').update({
        'last_activity_date': now.toIso8601String(),
      }).eq('id', user.id);
      return;
    } else if (daysDifference == 1) {
      // Consecutive day - increment streak
      newStreak = profile.streakDays + 1;
    } else {
      // Streak broken (more than 1 day gap) - reset to 1
      newStreak = 1;
    }

    // Update streak and last activity date
    await client.from('user_profiles').update({
      'streak_days': newStreak,
      'last_activity_date': now.toIso8601String(),
    }).eq('id', user.id);
  }

  /// Add time spent in a game session
  Future<void> addTimeSpent(int minutes) async {
    final user = _authService.currentUser;
    if (user == null) return;

            final profile = await getOrCreateUserProfile();
            final client = _supabaseClient;
            if (client != null) {
              await client.from('user_profiles').update({
                'total_time_minutes': profile.totalTimeMinutes + minutes,
              }).eq('id', user.id);
            }
  }

  /// Get user profile
  Future<UserProfile?> getUserProfile({bool forceRefresh = false}) async {
    debugPrint('getUserProfile: Starting, isAuthenticated: ${_authService.isAuthenticated}');
    
    // Wait for session to be loaded if we have a cached session
    // This ensures that if this is a new AuthService instance, it loads the session from storage
    if (_authService.isAuthenticated) {
      // Only wait for session load if we think we're authenticated
      // This avoids unnecessary waits for unauthenticated users
      await _authService.ensureSessionLoaded();
    }
    
    // Re-check authentication after ensuring session is loaded
    if (!_authService.isAuthenticated) {
      debugPrint('getUserProfile: User is not authenticated after session load, returning null');
      return null;
    }
    
    // Get user from cached session (no network request needed)
    final user = _authService.currentUser;
    if (user == null) {
      debugPrint('getUserProfile: User is null even though isAuthenticated is true');
      return null;
    }
    
    debugPrint('getUserProfile: User found: ${user.id}');

    try {
      final client = _supabaseClient;
      if (client == null) {
        debugPrint('getUserProfile: Supabase client is null');
        return null;
      }
      
      debugPrint('Fetching user profile for user: ${user.id}');
      
      final response = await client
          .from('user_profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) {
        debugPrint('No profile found for user: ${user.id}');
        return null;
      }
      
      debugPrint('Raw profile response: $response');
      
      final profile = UserProfile.fromJson(response);
      debugPrint('Profile fetched - onboarding_completed: ${profile.onboardingCompleted}');
      return profile;
    } catch (e, stackTrace) {
      debugPrint('Error fetching user profile: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Mark onboarding as completed
  Future<void> markOnboardingCompleted() async {
    final user = _authService.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final client = _supabaseClient;
    if (client == null) {
      throw Exception('Supabase not initialized');
    }

    try {
      debugPrint('Marking onboarding as completed for user: ${user.id}');
      
      // Update the profile - don't use .select().single, just update
      await client
          .from('user_profiles')
          .update({
            'onboarding_completed': true,
          })
          .eq('id', user.id);
      
      debugPrint('Onboarding marked as completed successfully');
      
      // Refresh the cached profile to ensure it's up to date
      final refreshedProfile = await getUserProfile();
      debugPrint('Refreshed profile - onboarding_completed: ${refreshedProfile?.onboardingCompleted}');
      
      if (refreshedProfile == null) {
        throw Exception('Failed to refresh user profile after marking onboarding as completed');
      }
      
      if (!refreshedProfile.onboardingCompleted) {
        throw Exception('Onboarding status was not updated correctly');
      }
    } catch (e) {
      debugPrint('Error marking onboarding as completed: $e');
      rethrow;
    }
  }

  User? get currentUser => _authService.currentUser;
}

