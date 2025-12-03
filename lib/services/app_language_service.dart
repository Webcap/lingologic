import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AppLanguageService {
  static const String _languageKey = 'app_language_code';
  static Function(Locale)? onLanguageChanged;
  
  // Supported app UI languages
  static const List<AppLanguage> supportedLanguages = [
    AppLanguage(code: 'en', name: 'English', locale: Locale('en')),
    AppLanguage(code: 'es', name: 'Español', locale: Locale('es')),
    // Add more languages as needed
  ];

  /// Get the current app language
  Future<Locale?> getAppLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey);
    
    Locale? locale;
    if (languageCode == null) {
      // Default to device locale if available, otherwise English
      locale = _getDeviceLocale();
    } else {
      final language = supportedLanguages.firstWhere(
        (lang) => lang.code == languageCode,
        orElse: () => supportedLanguages.first,
      );
      locale = language.locale;
    }

    // Update Intl default locale
    if (locale != null) {
      Intl.defaultLocale = locale.languageCode;
    }

    return locale;
  }

  /// Set the app language
  Future<void> setAppLanguage(String languageCode) async {
    if (!supportedLanguages.any((lang) => lang.code == languageCode)) {
      throw Exception('Language code $languageCode is not supported');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);

    // Update Intl default locale
    Intl.defaultLocale = languageCode;

    // Notify listeners of language change
    final language = supportedLanguages.firstWhere((lang) => lang.code == languageCode);
    onLanguageChanged?.call(language.locale);
  }

  /// Get current language code
  Future<String> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'en';
  }

  /// Get current language name
  Future<String> getLanguageName() async {
    final code = await getLanguageCode();
    final language = supportedLanguages.firstWhere(
      (lang) => lang.code == code,
      orElse: () => supportedLanguages.first,
    );
    return language.name;
  }

  /// Get device locale as fallback
  Locale? _getDeviceLocale() {
    try {
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      // Check if device locale is supported
      final supported = supportedLanguages.firstWhere(
        (lang) => lang.code == deviceLocale.languageCode,
        orElse: () => supportedLanguages.first,
      );
      return supported.locale;
    } catch (e) {
      return supportedLanguages.first.locale;
    }
  }

  /// Reset to default (English)
  Future<void> resetToDefault() async {
    await setAppLanguage('en');
  }
}

class AppLanguage {
  final String code;
  final String name;
  final Locale locale;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.locale,
  });
}

