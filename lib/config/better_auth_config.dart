import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class BetterAuthConfig {
  static String get baseUrl {
    if (kDebugMode) {
      // Prefer BETTER_AUTH_URL when set. Required for real device: in .env set
      // BETTER_AUTH_URL=http://<your-pc-lan-ip>:3000 (same WiFi as device).
      final envUrl = dotenv.env['BETTER_AUTH_URL'];
      if (envUrl != null && envUrl.isNotEmpty) {
        return envUrl;
      }
      // No env set: assume emulator/simulator
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:3000'; // Android emulator → host machine
      } else if (Platform.isIOS) {
        return 'http://localhost:3000'; // iOS simulator
      } else {
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

