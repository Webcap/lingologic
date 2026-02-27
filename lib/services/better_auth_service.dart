import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import '../config/better_auth_config.dart';

class BetterAuthUser {
  final String id;
  final String? email;
  final String? name;
  final bool? emailVerified;
  final bool? isAnonymous;

  BetterAuthUser({
    required this.id,
    this.email,
    this.name,
    this.emailVerified,
    this.isAnonymous,
  });

  factory BetterAuthUser.fromJson(Map<String, dynamic> json) {
    return BetterAuthUser(
      id: json['id'] as String,
      email: json['email'] as String?,
      name: json['name'] as String?,
      emailVerified: json['emailVerified'] as bool?,
      isAnonymous: json['isAnonymous'] as bool?,
    );
  }
}

class BetterAuthSession {
  final BetterAuthUser user;
  final DateTime? expiresAt;

  BetterAuthSession({
    required this.user,
    this.expiresAt,
  });

  factory BetterAuthSession.fromJson(Map<String, dynamic> json) {
    return BetterAuthSession(
      user: BetterAuthUser.fromJson(json['user'] as Map<String, dynamic>),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
    );
  }
}

class BetterAuthService {
  static const _storage = FlutterSecureStorage();
  static const _sessionKey = 'better_auth_session';
  static const _cookieKey = 'better_auth_cookies';

  final String baseUrl = BetterAuthConfig.apiBaseUrl;
  BetterAuthSession? _currentSession;
  Map<String, String> _cookies = {};
  Future<void>? _loadSessionFuture;

  BetterAuthService() {
    _loadSessionFuture = _loadSession();
  }

  Future<void> _loadSession() async {
    try {
      final sessionJson = await _storage.read(key: _sessionKey);
      if (sessionJson != null) {
        final sessionData = json.decode(sessionJson) as Map<String, dynamic>;
        _currentSession = BetterAuthSession.fromJson(sessionData);
        debugPrint('BetterAuthService: Session loaded from storage, user: ${_currentSession?.user.id}');
      } else {
        debugPrint('BetterAuthService: No session found in storage');
      }

      final cookiesJson = await _storage.read(key: _cookieKey);
      if (cookiesJson != null) {
        _cookies = Map<String, String>.from(json.decode(cookiesJson) as Map);
      }
    } catch (e) {
      debugPrint('Error loading session: $e');
    }
  }

  /// Wait for initial session load to complete
  Future<void> waitForSessionLoad() async {
    if (_loadSessionFuture != null) {
      await _loadSessionFuture;
    }
  }

  Future<void> _saveSession(BetterAuthSession? session) async {
    _currentSession = session;
    if (session != null) {
      await _storage.write(
        key: _sessionKey,
        value: json.encode({
          'user': {
            'id': session.user.id,
            'email': session.user.email,
            'name': session.user.name,
            'emailVerified': session.user.emailVerified,
            'isAnonymous': session.user.isAnonymous,
          },
          'expiresAt': session.expiresAt?.toIso8601String(),
        }),
      );
    } else {
      await _storage.delete(key: _sessionKey);
      await _storage.delete(key: _cookieKey);
      _cookies.clear();
    }
  }

  void _updateCookies(http.Response response) {
    final setCookieHeaders = response.headers['set-cookie'];
    if (setCookieHeaders != null) {
      final cookies = setCookieHeaders.split(', ');
      for (final cookie in cookies) {
        final parts = cookie.split(';')[0].split('=');
        if (parts.length == 2) {
          _cookies[parts[0]] = parts[1];
        }
      }
      _storage.write(key: _cookieKey, value: json.encode(_cookies));
    }
  }

  String _getCookieHeader() {
    if (_cookies.isEmpty) return '';
    return _cookies.entries
        .map((e) => '${e.key}=${e.value}')
        .join('; ');
  }

  Future<http.Response> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final cookieHeader = _getCookieHeader();
    if (cookieHeader.isNotEmpty) {
      headers['Cookie'] = cookieHeader;
    }

    http.Response response;
    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(uri, headers: headers);
        break;
      case 'POST':
        response = await http.post(
          uri,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
        break;
      default:
        throw Exception('Unsupported HTTP method: $method');
    }

    _updateCookies(response);
    return response;
  }

  /// Safely parse JSON from response body, handling empty responses
  Map<String, dynamic>? _parseJsonResponse(String body) {
    if (body.isEmpty || body.trim().isEmpty) {
      return null;
    }
    try {
      return json.decode(body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error parsing JSON response: $e');
      debugPrint('Response body: $body');
      return null;
    }
  }

  Future<BetterAuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _makeRequest(
      'POST',
      'sign-in',
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = _parseJsonResponse(response.body);
      if (data == null || data['user'] == null) {
        throw Exception('Invalid response from server: empty or missing user data');
      }
      final user = BetterAuthUser.fromJson(data['user'] as Map<String, dynamic>);
      final session = BetterAuthSession(user: user);
      await _saveSession(session);
      return session;
    } else {
      final error = _parseJsonResponse(response.body);
      final errorMessage = error?['error'] as String? ?? 
          'Sign in failed (${response.statusCode})';
      throw Exception(errorMessage);
    }
  }

  Future<BetterAuthSession> signUp({
    required String email,
    required String password,
  }) async {
    final response = await _makeRequest(
      'POST',
      'sign-up',
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = _parseJsonResponse(response.body);
      if (data == null || data['user'] == null) {
        throw Exception('Invalid response from server: empty or missing user data');
      }
      final user = BetterAuthUser.fromJson(data['user'] as Map<String, dynamic>);
      final session = BetterAuthSession(user: user);
      await _saveSession(session);
      return session;
    } else {
      final error = _parseJsonResponse(response.body);
      final errorMessage = error?['error'] as String? ?? 
          'Sign up failed (${response.statusCode})';
      throw Exception(errorMessage);
    }
  }

  Future<void> signOut() async {
    try {
      await _makeRequest('POST', 'sign-out');
    } catch (e) {
      debugPrint('Error signing out: $e');
    } finally {
      await _saveSession(null);
    }
  }

  Future<BetterAuthSession?> getSession() async {
    // Wait for initial session load to complete
    await waitForSessionLoad();
    
    // Check if we have a cached session
    if (_currentSession != null) {
      // Check if session is expired
      if (_currentSession!.expiresAt != null &&
          _currentSession!.expiresAt!.isBefore(DateTime.now())) {
        await _saveSession(null);
        return null;
      }
      return _currentSession;
    }

    // Try to fetch session from server
    try {
      final response = await _makeRequest('GET', 'session');
      if (response.statusCode == 200) {
        final data = _parseJsonResponse(response.body);
        if (data != null && data['user'] != null) {
          final user = BetterAuthUser.fromJson(data['user'] as Map<String, dynamic>);
          final session = BetterAuthSession(
            user: user,
            expiresAt: data['expiresAt'] != null
                ? DateTime.parse(data['expiresAt'] as String)
                : null,
          );
          await _saveSession(session);
          return session;
        }
      }
    } catch (e) {
      debugPrint('Error getting session: $e');
    }

    return null;
  }

  Future<BetterAuthSession> signInAnonymously() async {
    final response = await _makeRequest('POST', 'anonymous');

    if (response.statusCode == 200) {
      final data = _parseJsonResponse(response.body);
      if (data == null || data['user'] == null) {
        throw Exception('Invalid response from server: empty or missing user data');
      }
      final user = BetterAuthUser.fromJson(data['user'] as Map<String, dynamic>);
      final session = BetterAuthSession(user: user);
      await _saveSession(session);
      return session;
    } else {
      final error = _parseJsonResponse(response.body);
      final errorMessage = error?['error'] as String? ?? 
          'Anonymous sign in failed (${response.statusCode})';
      throw Exception(errorMessage);
    }
  }

  Future<BetterAuthUser> updateUser({
    String? email,
    String? password,
  }) async {
    final body = <String, dynamic>{};
    if (email != null) body['email'] = email;
    if (password != null) body['password'] = password;

    final response = await _makeRequest('POST', 'update-user', body: body);

    if (response.statusCode == 200) {
      final data = _parseJsonResponse(response.body);
      if (data == null || data['user'] == null) {
        throw Exception('Invalid response from server: empty or missing user data');
      }
      final user = BetterAuthUser.fromJson(data['user'] as Map<String, dynamic>);
      // Update current session
      if (_currentSession != null) {
        final updatedSession = BetterAuthSession(
          user: user,
          expiresAt: _currentSession!.expiresAt,
        );
        await _saveSession(updatedSession);
      }
      return user;
    } else {
      final error = _parseJsonResponse(response.body);
      final errorMessage = error?['error'] as String? ?? 
          'Update user failed (${response.statusCode})';
      throw Exception(errorMessage);
    }
  }

  BetterAuthUser? get currentUser => _currentSession?.user;
  BetterAuthSession? get currentSession => _currentSession;
  bool get isAuthenticated => _currentSession != null;
  bool get isAnonymous => _currentSession?.user.isAnonymous ?? false;

  /// Makes an authenticated POST request to a non-auth API path (e.g. /api/talk-tutor/chat).
  /// Uses stored session cookies. Returns parsed JSON or null.
  Future<Map<String, dynamic>?> postToApi(
    String path,
    Map<String, dynamic> body,
  ) async {
    await waitForSessionLoad();
    if (_currentSession == null) return null;

    final uri = Uri.parse('${BetterAuthConfig.baseUrl}$path');
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final cookieHeader = _getCookieHeader();
    if (cookieHeader.isNotEmpty) {
      headers['Cookie'] = cookieHeader;
    }
    final response = await http.post(
      uri,
      headers: headers,
      body: json.encode(body),
    );
    _updateCookies(response);
    if (response.body.isEmpty) return null;
    try {
      return json.decode(response.body) as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }
}

