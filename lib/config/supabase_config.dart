import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    try {
      // Load environment variables from .env file
      await dotenv.load(fileName: '.env');
    } catch (e) {
      // .env file might not exist, that's okay - use defaults
      debugPrint('Could not load .env file: $e');
    }

    // Get Supabase configuration from environment variables
    // Falls back to compile-time constants if .env is not available
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ??
        const String.fromEnvironment(
          'SUPABASE_URL',
          defaultValue: 'https://kqqtpthxbugymrmqqkzt.supabase.co',
        );
    
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ??
        const String.fromEnvironment(
          'SUPABASE_ANON_KEY',
          defaultValue: 'YOUR_SUPABASE_ANON_KEY',
        );

    if (supabaseAnonKey == 'YOUR_SUPABASE_ANON_KEY' || supabaseAnonKey.isEmpty) {
      // For MVP, allow app to start even without key (will show errors when trying to use Supabase)
      debugPrint('WARNING: Supabase publishable key not configured. Some features may not work.');
    }

    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
      );
    } catch (e) {
      debugPrint('Supabase initialization error: $e');
      // Allow app to continue - it will work in offline mode
    }
  }

  static SupabaseClient get client => Supabase.instance.client;
}

