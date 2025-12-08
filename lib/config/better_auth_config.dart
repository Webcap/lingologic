import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class BetterAuthConfig {
  static String get baseUrl {
    if (kDebugMode) {
      // For Android emulator, ALWAYS use 10.0.2.2 (even if BETTER_AUTH_URL is set)
      // This ensures emulator can connect to host machine
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:3000';
      } else if (Platform.isIOS) {
        // iOS simulator: localhost works
        return 'http://localhost:3000';
      } else {
        // Web or other platforms: check .env first, then default
        final envUrl = dotenv.env['BETTER_AUTH_URL'];
        if (envUrl != null && envUrl.isNotEmpty) {
          return envUrl;
        }
        return 'http://localhost:3000';
      }
    } else {
      // Production: use environment variable or default
      final envUrl = dotenv.env['BETTER_AUTH_URL'];
      if (envUrl != null && envUrl.isNotEmpty) {
        return envUrl;
      }
      return 'https://api.lingologic.com';
    }
  }

  static String get apiBaseUrl => '$baseUrl/api/auth';
}

