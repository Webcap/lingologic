import 'better_auth_service.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

// Wrapper classes to maintain compatibility with existing code
class User {
  final String id;
  final String? email;
  final bool? isAnonymous;

  User({
    required this.id,
    this.email,
    this.isAnonymous,
  });
}

class Session {
  final User user;
  final String? accessToken;

  Session({
    required this.user,
    this.accessToken,
  });
}

class AuthResponse {
  final User? user;
  final Session? session;

  AuthResponse({this.user, this.session});
}

class UserResponse {
  final User user;

  UserResponse({required this.user});
}

class AuthState {
  final AuthChangeEvent event;
  final Session? session;

  AuthState(this.event, this.session);
}

enum AuthChangeEvent {
  signedIn,
  signedOut,
  tokenRefreshed,
  userUpdated,
  passwordRecovery,
}

class AuthService {
  final BetterAuthService _betterAuth = BetterAuthService();
  final _authStateController = StreamController<AuthState>.broadcast();
  Timer? _sessionPollTimer;

  AuthService() {
    _startSessionPolling();
  }

  // Convert Better Auth user to Supabase-like User
  User? get currentUser {
    final betterAuthUser = _betterAuth.currentUser;
    if (betterAuthUser == null) return null;
    return User(
      id: betterAuthUser.id,
      email: betterAuthUser.email,
      isAnonymous: betterAuthUser.isAnonymous ?? false,
    );
  }

  // Convert Better Auth session to Supabase-like Session
  Session? get currentSession {
    final betterAuthSession = _betterAuth.currentSession;
    if (betterAuthSession == null) return null;
    return Session(
      user: User(
        id: betterAuthSession.user.id,
        email: betterAuthSession.user.email,
        isAnonymous: betterAuthSession.user.isAnonymous ?? false,
      ),
    );
  }

  Stream<AuthState> get authStateChanges {
    return _authStateController.stream;
  }

  void _startSessionPolling() {
    // Poll for session changes every 30 seconds (reduced from 5 seconds)
    // Only poll if we have a cached session to avoid unnecessary requests
    _sessionPollTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      // Only poll if we think we have a session
      if (!_betterAuth.isAuthenticated) {
        return; // Skip polling if no session
      }

      try {
        final previousUser = currentUser;
        await _betterAuth.getSession();
        final currentUserNow = currentUser;

        if (previousUser?.id != currentUserNow?.id) {
          if (currentUserNow != null) {
            _authStateController.add(AuthState(
              AuthChangeEvent.signedIn,
              currentSession,
            ));
          } else {
            _authStateController.add(AuthState(
              AuthChangeEvent.signedOut,
              null,
            ));
          }
        }
      } catch (e) {
        // Silently handle errors during polling
        debugPrint('Session polling error: $e');
      }
    });
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _betterAuth.signUp(
        email: email,
        password: password,
      );
      _authStateController.add(AuthState(
        AuthChangeEvent.signedIn,
        currentSession,
      ));
      return AuthResponse(
        user: User(
          id: session.user.id,
          email: session.user.email,
          isAnonymous: false,
        ),
        session: Session(
          user: User(
            id: session.user.id,
            email: session.user.email,
            isAnonymous: false,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Sign up error: $e');
      rethrow;
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _betterAuth.signIn(
        email: email,
        password: password,
      );
      _authStateController.add(AuthState(
        AuthChangeEvent.signedIn,
        currentSession,
      ));
      return AuthResponse(
        user: User(
          id: session.user.id,
          email: session.user.email,
          isAnonymous: false,
        ),
        session: Session(
          user: User(
            id: session.user.id,
            email: session.user.email,
            isAnonymous: false,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Sign in error: $e');
      rethrow;
    }
  }

  Future<AuthResponse> signInAnonymously() async {
    try {
      final session = await _betterAuth.signInAnonymously();
      _authStateController.add(AuthState(
        AuthChangeEvent.signedIn,
        currentSession,
      ));
      return AuthResponse(
        user: User(
          id: session.user.id,
          email: session.user.email,
          isAnonymous: true,
        ),
        session: Session(
          user: User(
            id: session.user.id,
            email: session.user.email,
            isAnonymous: true,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Anonymous sign in error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _betterAuth.signOut();
      _authStateController.add(AuthState(
        AuthChangeEvent.signedOut,
        null,
      ));
    } catch (e) {
      debugPrint('Sign out error: $e');
      rethrow;
    }
  }

  Future<UserResponse> updateUser({
    String? email,
    String? password,
  }) async {
    try {
      final user = await _betterAuth.updateUser(
        email: email,
        password: password,
      );
      _authStateController.add(AuthState(
        AuthChangeEvent.userUpdated,
        currentSession,
      ));
      return UserResponse(
        user: User(
          id: user.id,
          email: user.email,
          isAnonymous: user.isAnonymous ?? false,
        ),
      );
    } catch (e) {
      debugPrint('Update user error: $e');
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    // Note: This requires server-side implementation
    // For now, we'll just sign out the user
    await signOut();
  }

  bool get isAuthenticated {
    return _betterAuth.isAuthenticated;
  }

  bool get isAnonymous {
    return _betterAuth.isAnonymous;
  }

  void dispose() {
    _sessionPollTimer?.cancel();
    _authStateController.close();
  }
}
