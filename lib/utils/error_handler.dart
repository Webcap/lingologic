import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class ErrorHandler {
  static void handleError(BuildContext? context, dynamic error, {String? contextMessage}) {
    String message = 'An error occurred';
    
    if (error is AuthException) {
      message = _handleAuthError(error);
    } else if (error is PostgrestException) {
      message = _handleDatabaseError(error);
    } else if (error is SocketException || error.toString().contains('network')) {
      message = 'Network error. Please check your connection.';
    } else if (error is Exception) {
      message = error.toString();
    } else {
      message = error.toString();
    }
    
    if (context != null && contextMessage != null) {
      message = '$contextMessage: $message';
    }
    
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  static String _handleAuthError(AuthException error) {
    switch (error.statusCode) {
      case 'invalid_credentials':
        return 'Invalid email or password';
      case 'email_not_confirmed':
        return 'Please confirm your email address';
      case 'user_not_found':
        return 'User not found';
      case 'email_already_registered':
        return 'Email already registered';
      default:
        return 'Authentication error: ${error.message}';
    }
  }

  static String _handleDatabaseError(PostgrestException error) {
    if (error.code == 'PGRST116') {
      return 'No data found';
    } else if (error.code == '23505') {
      return 'This record already exists';
    } else if (error.code == '23503') {
      return 'Invalid reference';
    } else {
      return 'Database error: ${error.message}';
    }
  }

  static Widget buildErrorWidget(String message, {VoidCallback? onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

