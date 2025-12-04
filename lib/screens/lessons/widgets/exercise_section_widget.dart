import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/lesson_content.dart';
import '../../../theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class ExerciseSectionWidget extends StatefulWidget {
  final ExerciseSection section;
  final ValueChanged<bool>? onAnswerSubmitted;
  final VoidCallback? onRetry;
  final bool isAnswered;
  final bool isCorrect;
  final bool canRetry;

  const ExerciseSectionWidget({
    super.key,
    required this.section,
    this.onAnswerSubmitted,
    this.onRetry,
    this.isAnswered = false,
    this.isCorrect = false,
    this.canRetry = false,
  });

  @override
  State<ExerciseSectionWidget> createState() => _ExerciseSectionWidgetState();
}

class _ExerciseSectionWidgetState extends State<ExerciseSectionWidget> {
  late List<ExerciseOption> _shuffledOptions;
  int? _selectedIndex;
  bool _showResult = false;
  bool? _isCorrect;
  void _showHintPopup(BuildContext context) {
    if (widget.section.hint == null) return;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: AppTheme.cardWhite,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 32),
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.electricLavender.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lightbulb_rounded,
                  color: AppTheme.electricLavender,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  AppLocalizations.of(context)!.hint,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              // Hint content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  widget.section.hint!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.6,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              // Close button
              Container(
                margin: const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.electricLavender,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.close,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Shuffle options on initialization to randomize the order
    _shuffledOptions = List<ExerciseOption>.from(widget.section.options);
    _shuffledOptions.shuffle(Random());
    
    // If already answered from parent, show result
    if (widget.isAnswered) {
      _showResult = true;
      _isCorrect = widget.isCorrect;
      // Find the correct answer index in shuffled options
      for (int i = 0; i < _shuffledOptions.length; i++) {
        if (_shuffledOptions[i].isCorrect) {
          _selectedIndex = i;
          break;
        }
      }
    }
  }

  @override
  void didUpdateWidget(ExerciseSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update if answer status changes
    if (widget.isAnswered && !oldWidget.isAnswered) {
      _showResult = true;
      _isCorrect = widget.isCorrect;
      // Find the correct answer index in shuffled options
      for (int i = 0; i < _shuffledOptions.length; i++) {
        if (_shuffledOptions[i].isCorrect) {
          _selectedIndex = i;
          break;
        }
      }
    }
    // Reset if section changes (for retry)
    if (widget.section.id != oldWidget.section.id) {
      // Reshuffle options when section changes
      _shuffledOptions = List<ExerciseOption>.from(widget.section.options);
      _shuffledOptions.shuffle(Random());
      _selectedIndex = null;
      _showResult = false;
      _isCorrect = null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          // Header with icon
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
                  child: Icon(
                    Icons.quiz_rounded,
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
                        'Practice',
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
          
          // Question
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.section.question,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                        height: 1.4,
                      ),
                ),
                // Hint button (show before answer is submitted)
                if (widget.section.hint != null && !_showResult) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _showHintPopup(context),
                    icon: const Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 18,
                    ),
                    label: Text(
                      AppLocalizations.of(context)!.showHint,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.electricLavender,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(
                        color: AppTheme.electricLavender,
                        width: 1.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Options
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Column(
              children: _shuffledOptions.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                final isSelected = _selectedIndex == index;
                final isCorrectAnswer = option.isCorrect;
                final showCorrect = _showResult && isCorrectAnswer;
                final showIncorrect = _showResult && isSelected && !isCorrectAnswer;

                Color? backgroundColor;
                Color? optionBorderColor;
                Color? textColor = AppTheme.textPrimary;
                Color? circleColor;

                if (_showResult) {
                  if (showCorrect) {
                    backgroundColor = AppTheme.successGreen.withOpacity(0.15);
                    optionBorderColor = AppTheme.successGreen;
                    circleColor = AppTheme.successGreen;
                  } else if (showIncorrect) {
                    backgroundColor = Colors.red.withOpacity(0.15);
                    optionBorderColor = Colors.red;
                    circleColor = Colors.red;
                  } else {
                    backgroundColor = Colors.grey.withOpacity(0.05);
                    optionBorderColor = Colors.grey.withOpacity(0.2);
                    circleColor = Colors.grey.withOpacity(0.4);
                  }
                } else {
                  backgroundColor = isSelected
                      ? AppTheme.goldenOrange.withOpacity(0.15)
                      : Colors.grey.withOpacity(0.05);
                  optionBorderColor = isSelected
                      ? AppTheme.goldenOrange
                      : Colors.grey.withOpacity(0.2);
                  circleColor = isSelected
                      ? AppTheme.goldenOrange
                      : Colors.grey.withOpacity(0.4);
                }

                return GestureDetector(
                  onTap: _showResult ? null : () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: optionBorderColor,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: circleColor,
                            boxShadow: _showResult && (showCorrect || showIncorrect)
                                ? [
                                    BoxShadow(
                                      color: circleColor.withOpacity(0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: _showResult
                              ? Icon(
                                  showCorrect
                                      ? Icons.check_rounded
                                      : showIncorrect
                                          ? Icons.close_rounded
                                          : null,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : Center(
                                  child: Text(
                                    String.fromCharCode(65 + index), // A, B, C, D
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            option.text,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: textColor,
                                  fontWeight: isSelected || showCorrect
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  height: 1.4,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Hint shown after wrong answer (to help them learn)
          if (_showResult && _isCorrect == false && widget.section.hint != null) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.electricLavender.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.electricLavender.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_rounded,
                    color: AppTheme.electricLavender,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.hint,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppTheme.electricLavender,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.section.hint!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textPrimary,
                                height: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

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
          
          // Retry button (shown when answer is incorrect)
          if (_showResult && _isCorrect == false && widget.canRetry && widget.onRetry != null) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.goldenOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.goldenOrange.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          color: AppTheme.goldenOrange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Try a different question',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.goldenOrange,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
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
                        side: BorderSide(
                          color: AppTheme.goldenOrange,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Submit button
          if (!_showResult && _selectedIndex != null) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final isCorrect = _shuffledOptions[_selectedIndex!].isCorrect;
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

