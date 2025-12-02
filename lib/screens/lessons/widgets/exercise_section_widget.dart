import 'package:flutter/material.dart';
import '../../../models/lesson_content.dart';
import '../../../theme/app_theme.dart';

class ExerciseSectionWidget extends StatefulWidget {
  final ExerciseSection section;
  final ValueChanged<bool>? onAnswerSubmitted;
  final bool isAnswered;
  final bool isCorrect;

  const ExerciseSectionWidget({
    super.key,
    required this.section,
    this.onAnswerSubmitted,
    this.isAnswered = false,
    this.isCorrect = false,
  });

  @override
  State<ExerciseSectionWidget> createState() => _ExerciseSectionWidgetState();
}

class _ExerciseSectionWidgetState extends State<ExerciseSectionWidget> {
  int? _selectedIndex;
  bool _showResult = false;
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    // If already answered from parent, show result
    if (widget.isAnswered) {
      _showResult = true;
      _isCorrect = widget.isCorrect;
      // Find the correct answer index
      for (int i = 0; i < widget.section.options.length; i++) {
        if (widget.section.options[i].isCorrect) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _showResult
              ? (_isCorrect == true
                  ? AppTheme.successGreen
                  : Colors.red.withOpacity(0.5))
              : AppTheme.goldenOrange.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.quiz,
                color: AppTheme.goldenOrange,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Exercise',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.goldenOrange,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.section.question,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
          ),
          const SizedBox(height: 16),
          ...widget.section.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _selectedIndex == index;
            final isCorrectAnswer = option.isCorrect;
            final showCorrect = _showResult && isCorrectAnswer;
            final showIncorrect = _showResult && isSelected && !isCorrectAnswer;

            Color? backgroundColor;
            Color? borderColor;
            Color? textColor = AppTheme.textPrimary;

            if (_showResult) {
              if (showCorrect) {
                backgroundColor = AppTheme.successGreen.withOpacity(0.2);
                borderColor = AppTheme.successGreen;
              } else if (showIncorrect) {
                backgroundColor = Colors.red.withOpacity(0.2);
                borderColor = Colors.red.withOpacity(0.5);
              } else {
                backgroundColor = Colors.grey.withOpacity(0.1);
                borderColor = Colors.grey.withOpacity(0.3);
              }
            } else {
              backgroundColor = isSelected
                  ? AppTheme.goldenOrange.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1);
              borderColor = isSelected
                  ? AppTheme.goldenOrange
                  : Colors.grey.withOpacity(0.3);
            }

            return GestureDetector(
              onTap: _showResult ? null : () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: borderColor,
                      ),
                      child: _showResult
                          ? Icon(
                              showCorrect
                                  ? Icons.check
                                  : showIncorrect
                                      ? Icons.close
                                      : null,
                              color: Colors.white,
                              size: 16,
                            )
                          : Center(
                              child: Text(
                                String.fromCharCode(65 + index), // A, B, C, D
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option.text,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: textColor,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          if (_showResult && widget.section.explanation != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (_isCorrect == true
                        ? AppTheme.successGreen
                        : Colors.red)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _isCorrect == true ? Icons.check_circle : Icons.error,
                    color: _isCorrect == true
                        ? AppTheme.successGreen
                        : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.section.explanation!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textPrimary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (!_showResult && _selectedIndex != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final isCorrect = widget.section.options[_selectedIndex!].isCorrect;
                  setState(() {
                    _showResult = true;
                    _isCorrect = isCorrect;
                  });
                  widget.onAnswerSubmitted?.call(isCorrect);
                },
                child: const Text('Submit Answer'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

