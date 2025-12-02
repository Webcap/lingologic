import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class AuthService {
  SupabaseClient? _supabase;
  
  SupabaseClient? get _supabaseClient {
    if (_supabase == null) {
      _supabase = SupabaseConfig.client;
    }
    return _supabase;
  }

  User? get currentUser {
    try {
      final client = _supabaseClient;
      if (client == null) return null;
      return client.auth.currentUser;
    } catch (e) {
      return null;
    }
  }
  
  Session? get currentSession {
    try {
      final client = _supabaseClient;
      if (client == null) return null;
      return client.auth.currentSession;
    } catch (e) {
      return null;
    }
  }

  Stream<AuthState> get authStateChanges {
    try {
      final client = _supabaseClient;
      if (client == null) {
        return Stream.value(AuthState(AuthChangeEvent.signedOut, null));
      }
      return client.auth.onAuthStateChange;
    } catch (e) {
      // Return a stream that immediately emits no user if Supabase isn't initialized
      return Stream.value(AuthState(AuthChangeEvent.signedOut, null));
    }
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    final client = _supabaseClient;
    if (client == null) {
      throw Exception('Supabase not initialized');
    }
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final client = _supabaseClient;
    if (client == null) {
      throw Exception('Supabase not initialized');
    }
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signInAnonymously() async {
    final client = _supabaseClient;
    if (client == null) {
      throw Exception('Supabase not initialized');
    }
    return await client.auth.signInAnonymously();
  }

  Future<void> signOut() async {
    final client = _supabaseClient;
    if (client == null) return;
    await client.auth.signOut();
  }

  Future<UserResponse> updateUser({
    String? email,
    String? password,
  }) async {
    final client = _supabaseClient;
    if (client == null) {
      throw Exception('Supabase not initialized');
    }
    return await client.auth.updateUser(
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

  bool get isAuthenticated {
    try {
      return currentUser != null;
    } catch (e) {
      return false;
    }
  }
  
  bool get isAnonymous {
    try {
      return currentUser?.isAnonymous ?? false;
    } catch (e) {
      return false;
    }
  }
}

