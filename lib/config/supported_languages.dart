import '../models/language_info.dart';

class SupportedLanguages {
  static const List<LanguageInfo> all = [
    LanguageInfo(
      code: 'spanish',
      name: 'Spanish',
      nativeName: 'Español',
      flagEmoji: '🇪🇸',
      isAvailable: true,
    ),
    LanguageInfo(
      code: 'english',
      name: 'English',
      nativeName: 'English',
      flagEmoji: '🇬🇧',
      isAvailable: true,
    ),
    LanguageInfo(
      code: 'french',
      name: 'French',
      nativeName: 'Français',
      flagEmoji: '🇫🇷',
      isAvailable: false, // Set to true when content is ready
    ),
  ];

  /// Get language info by code
  static LanguageInfo? getByCode(String code) {
    try {
      return all.firstWhere((lang) => lang.code == code);
    } catch (e) {
      return null;
    }
  }

  /// Get all available languages (with content)
  static List<LanguageInfo> get available {
    return all.where((lang) => lang.isAvailable).toList();
  }

  /// Check if a language code is supported
  static bool isSupported(String code) {
    return all.any((lang) => lang.code == code);
  }
}

