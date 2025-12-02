import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class AuthService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  User? get currentUser => _supabase.auth.currentUser;
  Session? get currentSession => _supabase.auth.currentSession;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signInAnonymously() async {
    return await _supabase.auth.signInAnonymously();
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<UserResponse> updateUser({
    String? email,
    String? password,
  }) async {
    final updates = <String, dynamic>{};
    if (email != null) updates['email'] = email;
    if (password != null) updates['password'] = password;

    return await _supabase.auth.updateUser(
      UserAttributes(
        email: email,
        password: password,
      ),
    );
  }

  Future<void> deleteAccount() async {
    // Note: This requires server-side implementation or Supabase admin API
    // For MVP, we'll just sign out the user
    await signOut();
  }

  bool get isAuthenticated => currentUser != null;
  bool get isAnonymous => currentUser?.isAnonymous ?? false;
}

