import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/user_language.dart';
import '../config/supported_languages.dart';
import '../services/language_service.dart';
import '../theme/app_theme.dart';

class LanguageSelector extends StatelessWidget {
  final Function(String)? onLanguageSelected;
  final bool showActiveIndicator;

  const LanguageSelector({
    super.key,
    this.onLanguageSelected,
    this.showActiveIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    final languageService = LanguageService();

    return FutureBuilder<List<UserLanguage>>(
      future: languageService.getUserLanguages(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final userLanguages = snapshot.data!;
        final activeLanguage = userLanguages
            .where((ul) => ul.isActive)
            .firstOrNull;

        if (activeLanguage == null) {
          return const SizedBox.shrink();
        }

        final languageInfo = SupportedLanguages.getByCode(activeLanguage.language);

        if (languageInfo == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () => _showLanguagePicker(context, languageService, userLanguages),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.cardWhite.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primaryMintGreen.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  languageInfo.flagEmoji,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  languageInfo.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                ),
                if (showActiveIndicator) ...[
                  const SizedBox(width: 6),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguagePicker(
    BuildContext context,
    LanguageService languageService,
    List<UserLanguage> userLanguages,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Select Language',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
              ),
            ),
            ...userLanguages.map((ul) {
              final langInfo = SupportedLanguages.getByCode(ul.language);
              if (langInfo == null) return const SizedBox.shrink();

              return ListTile(
                leading: Text(
                  langInfo.flagEmoji,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(
                  langInfo.name,
                  style: TextStyle(
                    fontWeight: ul.isActive ? FontWeight.w700 : FontWeight.w400,
                    color: AppTheme.textPrimary,
                  ),
                ),
                subtitle: Text(
                  langInfo.nativeName,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                trailing: ul.isActive
                    ? Icon(
                        Icons.check_circle,
                        color: AppTheme.successGreen,
                      )
                    : null,
                onTap: () async {
                  if (!ul.isActive) {
                    await languageService.setActiveLanguage(ul.language);
                    onLanguageSelected?.call(ul.language);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              );
            }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Add Language'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to language selection screen
                context.push('/languages');
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

