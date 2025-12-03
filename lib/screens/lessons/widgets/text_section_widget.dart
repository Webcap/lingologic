import 'package:flutter/material.dart';
import '../../../models/lesson_content.dart';
import '../../../theme/app_theme.dart';

class TextSectionWidget extends StatelessWidget {
  final TextSection section;

  const TextSectionWidget({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.electricLavender.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: AppTheme.electricLavender,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (section.title.isNotEmpty)
                        Text(
                          section.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                        ),
                      if (section.title.isEmpty)
                        Text(
                          'Learn',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.electricLavender,
                              ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Text(
              section.content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    height: 1.7,
                    fontSize: 16,
                  ),
            ),
          ),
          
          // Examples section
          if (section.examples != null && section.examples!.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.softCyan.withOpacity(0.15),
                    AppTheme.electricLavender.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.softCyan.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.softCyan.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.lightbulb_rounded,
                          size: 20,
                          color: AppTheme.softCyan,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Examples',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppTheme.softCyan,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...section.examples!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final example = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < section.examples!.length - 1 ? 12 : 0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8, right: 12),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.softCyan,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              example,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: AppTheme.textPrimary,
                                    height: 1.6,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

