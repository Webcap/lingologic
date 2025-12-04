// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import '../models/language_info.dart';
import '../models/user_language.dart';
import '../config/supported_languages.dart';
import '../services/language_service.dart';
import '../theme/app_theme.dart';
import '../utils/error_handler.dart';
import '../l10n/app_localizations.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final _languageService = LanguageService();
  List<UserLanguage> _userLanguages = [];
  List<LanguageInfo> _availableLanguages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userLanguages = await _languageService.getUserLanguages();
      final availableLanguages = _languageService.getAvailableLanguages();

      if (mounted) {
        setState(() {
          _userLanguages = userLanguages;
          _availableLanguages = availableLanguages;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleError(context, e, contextMessage: AppLocalizations.of(context)!.errorLoadingLanguages);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addLanguage(LanguageInfo language) async {
    try {
      await _languageService.addUserLanguage(language.code);
      await _loadLanguages(); // Reload to show new language

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.addedLanguageToYourLanguages(language.name)),
            backgroundColor: AppTheme.successGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleError(context, e, contextMessage: AppLocalizations.of(context)!.errorAddingLanguage);
      }
    }
  }

  Future<void> _setActiveLanguage(String language) async {
    try {
      await _languageService.setActiveLanguage(language);
      await _loadLanguages(); // Reload to update active status

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.languageSwitched),
            backgroundColor: AppTheme.successGreen,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleError(context, e, contextMessage: AppLocalizations.of(context)!.errorSwitchingLanguage);
      }
    }
  }

  bool _isUserLearning(String languageCode) {
    return _userLanguages.any((ul) => ul.language == languageCode);
  }

  bool _isActive(String languageCode) {
    return _userLanguages
        .where((ul) => ul.language == languageCode)
        .any((ul) => ul.isActive);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languages),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.mainGradient,
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.yourLanguages,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (_userLanguages.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.cardWhite,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.language,
                              size: 48,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noLanguagesYet,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.addLanguageToGetStarted,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      )
                    else
                      ..._userLanguages.map((ul) {
                        final langInfo = SupportedLanguages.getByCode(ul.language);
                        if (langInfo == null) return const SizedBox.shrink();

                        return _buildLanguageCard(
                          context,
                          langInfo,
                          ul,
                          isActive: ul.isActive,
                          onTap: () => _setActiveLanguage(ul.language),
                        );
                      }),
                    const SizedBox(height: 32),
                    Text(
                      l10n.availableLanguages,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    ..._availableLanguages.where((lang) => !_isUserLearning(lang.code)).map(
                          (lang) => _buildLanguageCard(
                            context,
                            lang,
                            null,
                            isActive: false,
                            onTap: () => _addLanguage(lang),
                            showAddButton: true,
                          ),
                        ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context,
    LanguageInfo language,
    UserLanguage? userLanguage, {
    required bool isActive,
    required VoidCallback onTap,
    bool showAddButton = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? AppTheme.primaryMintGreen
              : AppTheme.textSecondary.withOpacity(0.2),
          width: isActive ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.softCyan.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              language.flagEmoji,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
        title: Text(
          language.name,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              language.nativeName,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            if (userLanguage != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildStatChip(
                    '${userLanguage.totalWordsLearned} ${l10n.words}',
                    Icons.book,
                  ),
                  const SizedBox(width: 8),
                  _buildStatChip(
                    '${userLanguage.totalLessonsCompleted} ${l10n.lessonsLowercase}',
                    Icons.school,
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: isActive
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppTheme.successGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.active,
                      style: TextStyle(
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            : showAddButton
                ? IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: AppTheme.primaryMintGreen,
                    ),
                    onPressed: onTap,
                  )
                : Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
        onTap: isActive ? null : onTap,
      ),
    );
  }

  Widget _buildStatChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.softCyan.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppTheme.softCyan,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: AppTheme.softCyan,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

