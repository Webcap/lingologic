import 'package:supabase_flutter/supabase_flutter.dart';
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
      
      // Check if profile exists
      final response = await client
          .from('user_profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

    if (response != null) {
      return UserProfile.fromJson(response);
    }

    // Create new profile
    final newProfile = UserProfile(
      id: user.id,
      createdAt: DateTime.now(),
      streakDays: 0,
      totalTimeMinutes: 0,
    );

      await client.from('user_profiles').insert(newProfile.toJson());

    return newProfile;
  }

  /// Update streak days based on daily login
  Future<void> updateStreak() async {
    final user = _authService.currentUser;
    if (user == null) return;

    final profile = await getOrCreateUserProfile();
    final lastLogin = profile.createdAt; // In a real app, track last login separately
    final now = DateTime.now();

    // Check if it's a new day
    if (now.difference(lastLogin).inDays >= 1) {
      int newStreak = profile.streakDays;
      if (now.difference(lastLogin).inDays == 1) {
        // Consecutive day
        newStreak += 1;
      } else {
        // Streak broken
        newStreak = 1;
      }

              final client = _supabaseClient;
              if (client != null) {
                await client.from('user_profiles').update({
                  'streak_days': newStreak,
                }).eq('id', user.id);
              }
    }
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

  User? get currentUser => _authService.currentUser;
}

