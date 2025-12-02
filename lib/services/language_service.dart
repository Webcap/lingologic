import '../models/user_language.dart';
import '../models/language_info.dart';
import '../config/supported_languages.dart';
import '../data/remote/supabase_repository.dart';
import '../services/auth_service.dart';

class LanguageService {
  final SupabaseRepository _repository = SupabaseRepository();
  final AuthService _authService = AuthService();

  /// Get all available languages
  List<LanguageInfo> getAvailableLanguages() {
    return SupportedLanguages.available;
  }

  /// Get all supported languages (including unavailable)
  List<LanguageInfo> getAllLanguages() {
    return SupportedLanguages.all;
  }

  /// Get languages that the current user is learning
  Future<List<UserLanguage>> getUserLanguages() async {
    final user = _authService.currentUser;
    if (user == null) return [];

    return await _repository.getUserLanguages(user.id);
  }

  /// Get the currently active language for the user
  Future<String?> getActiveLanguage() async {
    final user = _authService.currentUser;
    if (user == null) return null;

    final userLanguages = await _repository.getUserLanguages(user.id);
    final active = userLanguages.where((ul) => ul.isActive).firstOrNull;
    return active?.language;
  }

  /// Add a language for the user to learn
  Future<void> addUserLanguage(String language) async {
    final user = _authService.currentUser;
    if (user == null) {
      throw Exception('User must be authenticated to add a language');
    }

    if (!SupportedLanguages.isSupported(language)) {
      throw Exception('Language $language is not supported');
    }

    final userLanguage = UserLanguage(
      userId: user.id,
      language: language,
      isActive: false, // Will be set active if it's the first language
      startedAt: DateTime.now(),
      totalWordsLearned: 0,
      totalLessonsCompleted: 0,
      streakDays: 0,
      lastPracticedAt: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _repository.upsertUserLanguage(userLanguage);

    // If this is the first language, make it active
    final existingLanguages = await getUserLanguages();
    if (existingLanguages.length == 1) {
      await setActiveLanguage(language);
    }
  }

  /// Set the active language for the user
  Future<void> setActiveLanguage(String language) async {
    final user = _authService.currentUser;
    if (user == null) {
      throw Exception('User must be authenticated to set active language');
    }

    // First, deactivate all languages
    final userLanguages = await _repository.getUserLanguages(user.id);
    for (final ul in userLanguages) {
      if (ul.isActive && ul.language != language) {
        await _repository.upsertUserLanguage(
          ul.copyWith(
            isActive: false,
            updatedAt: DateTime.now(),
          ),
        );
      }
    }

    // Then activate the selected language
    final targetLanguage = userLanguages.firstWhere(
      (ul) => ul.language == language,
      orElse: () => UserLanguage(
        userId: user.id,
        language: language,
        isActive: true,
        startedAt: DateTime.now(),
        totalWordsLearned: 0,
        totalLessonsCompleted: 0,
        streakDays: 0,
        lastPracticedAt: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    await _repository.upsertUserLanguage(
      targetLanguage.copyWith(
        isActive: true,
        lastPracticedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Get progress statistics for a specific language
  Future<UserLanguage?> getLanguageProgress(String language) async {
    final user = _authService.currentUser;
    if (user == null) return null;

    final userLanguages = await _repository.getUserLanguages(user.id);
    return userLanguages.firstWhere(
      (ul) => ul.language == language,
      orElse: () => throw Exception('User is not learning $language'),
    );
  }

  /// Update language progress (called by other services)
  Future<void> updateLanguageProgress(
    String language, {
    int? wordsLearned,
    int? lessonsCompleted,
    int? streakDays,
  }) async {
    final user = _authService.currentUser;
    if (user == null) return;

    final current = await getLanguageProgress(language);
    if (current == null) return;

    await _repository.upsertUserLanguage(
      current.copyWith(
        totalWordsLearned: wordsLearned ?? current.totalWordsLearned,
        totalLessonsCompleted: lessonsCompleted ?? current.totalLessonsCompleted,
        streakDays: streakDays ?? current.streakDays,
        lastPracticedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Initialize default language for new users (Spanish)
  Future<void> initializeDefaultLanguage() async {
    final user = _authService.currentUser;
    if (user == null) return;

    final existingLanguages = await getUserLanguages();
    if (existingLanguages.isEmpty) {
      await addUserLanguage('spanish');
      await setActiveLanguage('spanish');
    }
  }
}

