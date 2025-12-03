import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/lesson_content.dart';
import '../../../theme/app_theme.dart';

class MatchingExerciseWidget extends StatefulWidget {
  final MatchingExerciseSection section;
  final ValueChanged<bool>? onAnswerSubmitted;
  final VoidCallback? onRetry;
  final bool isAnswered;
  final bool isCorrect;
  final bool canRetry;

  const MatchingExerciseWidget({
    super.key,
    required this.section,
    this.onAnswerSubmitted,
    this.onRetry,
    this.isAnswered = false,
    this.isCorrect = false,
    this.canRetry = false,
  });

  @override
  State<MatchingExerciseWidget> createState() => _MatchingExerciseWidgetState();
}

class _MatchingExerciseWidgetState extends State<MatchingExerciseWidget> {
  // Track which words are matched
  final Map<String, String?> _matches = {}; // word -> translation
  final Map<String, String?> _reverseMatches = {}; // translation -> word
  bool _showResult = false;
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    // Initialize match maps
    for (final pair in widget.section.pairs) {
      _matches[pair.word] = null;
      _reverseMatches[pair.translation] = null;
    }
    
    if (widget.isAnswered) {
      _showResult = true;
      _isCorrect = widget.isCorrect;
      // If already answered correctly, show all matches
      if (widget.isCorrect) {
        for (final pair in widget.section.pairs) {
          _matches[pair.word] = pair.translation;
          _reverseMatches[pair.translation] = pair.word;
        }
      }
    }
  }

  @override
  void didUpdateWidget(MatchingExerciseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnswered && !oldWidget.isAnswered) {
      _showResult = true;
      _isCorrect = widget.isCorrect;
      if (widget.isCorrect) {
        for (final pair in widget.section.pairs) {
          _matches[pair.word] = pair.translation;
          _reverseMatches[pair.translation] = pair.word;
        }
      }
    }
    if (widget.section.id != oldWidget.section.id) {
      // Reset for new exercise
      _matches.clear();
      _reverseMatches.clear();
      for (final pair in widget.section.pairs) {
        _matches[pair.word] = null;
        _reverseMatches[pair.translation] = null;
      }
      _showResult = false;
      _isCorrect = null;
    }
  }

  void _selectMatch(String word, String translation) {
    if (_showResult) return; // Don't allow changes after submission

    setState(() {
      // Check if translation is already matched to another word
      final existingWord = _reverseMatches[translation];
      if (existingWord != null && existingWord != word) {
        // Unmatch the previous word
        _matches[existingWord] = null;
      }

      // Check if word is already matched to another translation
      final existingTranslation = _matches[word];
      if (existingTranslation != null && existingTranslation != translation) {
        // Unmatch the previous translation
        _reverseMatches[existingTranslation] = null;
      }

      // Create new match
      _matches[word] = translation;
      _reverseMatches[translation] = word;
    });

    HapticFeedback.selectionClick();
  }

  void _clearMatch(String word) {
    if (_showResult) return;

    setState(() {
      final translation = _matches[word];
      if (translation != null) {
        _matches[word] = null;
        _reverseMatches[translation] = null;
      }
    });
  }

  bool _checkAnswer() {
    if (_matches.values.any((translation) => translation == null)) {
      return false; // Not all words are matched
    }

    // Check if all matches are correct
    for (final pair in widget.section.pairs) {
      if (_matches[pair.word] != pair.translation) {
        return false;
      }
    }

    return true;
  }

  List<String> _getAllTranslations() {
    final translations = widget.section.pairs.map((p) => p.translation).toList();
    if (widget.section.distractors != null) {
      translations.addAll(widget.section.distractors!);
    }
    translations.shuffle();
    return translations;
  }

  @override
  Widget build(BuildContext context) {
    final allTranslations = _getAllTranslations();
    final allMatched = _matches.values.every((translation) => translation != null);
    final borderColor = _showResult
        ? (_isCorrect == true
            ? AppTheme.successGreen
            : Colors.red)
        : AppTheme.goldenOrange;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: borderColor.withOpacity(_showResult ? 0.4 : 0.2),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          if (_showResult && _isCorrect == true)
            BoxShadow(
              color: AppTheme.successGreen.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 0),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.goldenOrange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.link_rounded,
                    color: AppTheme.goldenOrange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Match the Words',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.goldenOrange,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      if (_showResult)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(
                                _isCorrect == true
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                size: 16,
                                color: _isCorrect == true
                                    ? AppTheme.successGreen
                                    : Colors.red,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _isCorrect == true ? 'Correct!' : 'Try again',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: _isCorrect == true
                                          ? AppTheme.successGreen
                                          : Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Instruction
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Text(
              widget.section.instruction,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
            ),
          ),

          // Matching pairs
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Column(
              children: widget.section.pairs.map((pair) {
                final matchedTranslation = _matches[pair.word];
                final isCorrectMatch = matchedTranslation == pair.translation;

                return _MatchRow(
                  word: pair.word,
                  matchedTranslation: matchedTranslation,
                  availableTranslations: allTranslations,
                  isCorrect: _showResult && isCorrectMatch,
                  isIncorrect: _showResult && matchedTranslation != null && !isCorrectMatch,
                  correctTranslation: _showResult ? pair.translation : null,
                  onSelect: (translation) => _selectMatch(pair.word, translation),
                  onClear: () => _clearMatch(pair.word),
                  disabled: _showResult,
                );
              }).toList(),
            ),
          ),

          // Translation options (if not all matched, show available options)
          if (!_showResult && !allMatched)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.softCyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.softCyan.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: allTranslations
                      .where((translation) =>
                          !_reverseMatches.containsKey(translation) ||
                          _reverseMatches[translation] == null)
                      .map((translation) {
                    return GestureDetector(
                      onTap: () {
                        // Find an unmatched word to match
                        final unmatchedWord = widget.section.pairs
                            .firstWhere(
                              (p) => _matches[p.word] == null,
                              orElse: () => widget.section.pairs.first,
                            )
                            .word;
                        _selectMatch(unmatchedWord, translation);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.softCyan,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          translation,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

          // Explanation
          if (_showResult && widget.section.explanation != null) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (_isCorrect == true
                        ? AppTheme.successGreen
                        : Colors.red)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (_isCorrect == true
                          ? AppTheme.successGreen
                          : Colors.red)
                      .withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: (_isCorrect == true
                              ? AppTheme.successGreen
                              : Colors.red)
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _isCorrect == true
                          ? Icons.check_circle_rounded
                          : Icons.error_rounded,
                      color: _isCorrect == true
                          ? AppTheme.successGreen
                          : Colors.red,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.section.explanation!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            height: 1.5,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Retry button
          if (_showResult && _isCorrect == false && widget.canRetry && widget.onRetry != null) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: widget.onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text('Retry with Different Question'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.goldenOrange,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    side: const BorderSide(
                      color: AppTheme.goldenOrange,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],

          // Submit button
          if (!_showResult && allMatched) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final isCorrect = _checkAnswer();
                  setState(() {
                    _showResult = true;
                    _isCorrect = isCorrect;
                  });
                  widget.onAnswerSubmitted?.call(isCorrect);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.goldenOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Submit Answer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MatchRow extends StatelessWidget {
  final String word;
  final String? matchedTranslation;
  final List<String> availableTranslations;
  final bool isCorrect;
  final bool isIncorrect;
  final String? correctTranslation;
  final Function(String) onSelect;
  final VoidCallback onClear;
  final bool disabled;

  const _MatchRow({
    required this.word,
    required this.matchedTranslation,
    required this.availableTranslations,
    required this.isCorrect,
    required this.isIncorrect,
    required this.correctTranslation,
    required this.onSelect,
    required this.onClear,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Word side
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryMintGreen.withOpacity(0.15),
                    AppTheme.softCyan.withOpacity(0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.primaryMintGreen.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Text(
                word,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Match indicator
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: matchedTranslation != null
                  ? (isCorrect
                      ? AppTheme.successGreen
                      : isIncorrect
                          ? Colors.red
                          : AppTheme.goldenOrange)
                  : Colors.grey.shade300,
            ),
            child: matchedTranslation != null
                ? Icon(
                    isCorrect
                        ? Icons.check_rounded
                        : isIncorrect
                            ? Icons.close_rounded
                            : Icons.link_rounded,
                    color: Colors.white,
                    size: 24,
                  )
                : Icon(
                    Icons.remove_rounded,
                    color: Colors.grey.shade600,
                    size: 24,
                  ),
          ),

          // Translation side
          Expanded(
            child: GestureDetector(
              onTap: disabled
                  ? null
                  : () {
                      if (matchedTranslation != null) {
                        onClear();
                      } else {
                        // Show selection dialog
                        _showTranslationSelector(context);
                      }
                    },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: matchedTranslation != null
                        ? (isCorrect
                            ? [
                                AppTheme.successGreen.withOpacity(0.15),
                                AppTheme.successGreen.withOpacity(0.1),
                              ]
                            : isIncorrect
                                ? [
                                    Colors.red.withOpacity(0.15),
                                    Colors.red.withOpacity(0.1),
                                  ]
                                : [
                                    AppTheme.goldenOrange.withOpacity(0.15),
                                    AppTheme.goldenOrange.withOpacity(0.1),
                                  ])
                        : [
                            Colors.grey.shade100,
                            Colors.grey.shade50,
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: matchedTranslation != null
                        ? (isCorrect
                            ? AppTheme.successGreen
                            : isIncorrect
                                ? Colors.red
                                : AppTheme.goldenOrange)
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Text(
                  matchedTranslation ?? 'Tap to match',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: matchedTranslation != null
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: matchedTranslation != null
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                        fontStyle: matchedTranslation == null
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTranslationSelector(BuildContext context) {
    final unmatchedTranslations = availableTranslations
        .where((t) => t != matchedTranslation)
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select translation for "$word"',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: unmatchedTranslations.map((translation) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    tileColor: AppTheme.softCyan.withOpacity(0.1),
                    title: Text(
                      translation,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onSelect(translation);
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            if (matchedTranslation != null)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onClear();
                  },
                  child: const Text('Clear Match'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

