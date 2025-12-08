import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/user_profile.dart';
import '../config/supabase_config.dart';
import 'auth_service.dart';

class UserService {
  SupabaseClient? _supabase;
  final AuthService _authService = AuthService();
  
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
  Future<UserProfile?> getUserProfile() async {
    final user = _authService.currentUser;
    if (user == null) return null;

            try {
              final client = _supabaseClient;
              if (client == null) return null;
              
              final response = await client
                  .from('user_profiles')
                  .select()
                  .eq('id', user.id)
                  .maybeSingle();

      if (response == null) return null;
      return UserProfile.fromJson(response);
    } catch (e) {
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

    await client.from('user_profiles').update({
      'onboarding_completed': true,
    }).eq('id', user.id);
  }

  User? get currentUser => _authService.currentUser;
}

