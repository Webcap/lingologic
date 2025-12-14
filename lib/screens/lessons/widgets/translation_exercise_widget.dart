import 'package:flutter/material.dart';
import '../../../models/lesson_content.dart';
import '../../../theme/app_theme.dart';

class TranslationExerciseWidget extends StatefulWidget {
  final TranslationSection section;
  final ValueChanged<bool>? onAnswerSubmitted;
  final bool isAnswered;
  final bool isCorrect;
  final String languageCode; // Language code for the lesson language

  const TranslationExerciseWidget({
    super.key,
    required this.section,
    this.onAnswerSubmitted,
    this.isAnswered = false,
    this.isCorrect = false,
    this.languageCode = 'es',
  });

  @override
  State<TranslationExerciseWidget> createState() => _TranslationExerciseWidgetState();
}

class _TranslationExerciseWidgetState extends State<TranslationExerciseWidget> {
  final TextEditingController _answerController = TextEditingController();
  bool _showResult = false;
  bool? _isCorrect;
  String? _correctAnswer;

  @override
  void initState() {
    super.initState();
    // If word pairs exist, use the first one as the correct answer
    if (widget.section.wordPairs != null && widget.section.wordPairs!.isNotEmpty) {
      // The correct answer is the word in the lesson language (first item in pair)
      _correctAnswer = widget.section.wordPairs!.first.word.trim().toLowerCase();
    }
    
    if (widget.isAnswered) {
      _showResult = true;
      _isCorrect = widget.isCorrect;
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TranslationExerciseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnswered && !oldWidget.isAnswered) {
      _showResult = true;
      _isCorrect = widget.isCorrect;
    }
  }

  void _checkAnswer() {
    if (_answerController.text.trim().isEmpty) {
      return;
    }

    final userAnswer = _answerController.text.trim().toLowerCase();
    bool isCorrect = false;

    if (_correctAnswer != null) {
      // Check if user answer matches the correct answer (case-insensitive, ignoring extra spaces)
      isCorrect = userAnswer == _correctAnswer;
    } else if (widget.section.wordPairs != null && widget.section.wordPairs!.isNotEmpty) {
      // Check against all word pairs
      isCorrect = widget.section.wordPairs!.any((pair) =>
          pair.word.trim().toLowerCase() == userAnswer);
    }

    setState(() {
      _showResult = true;
      _isCorrect = isCorrect;
    });

    widget.onAnswerSubmitted?.call(isCorrect);
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
              : AppTheme.electricLavender.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.translate,
                color: AppTheme.electricLavender,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                widget.section.title ?? 'Translation Exercise',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.electricLavender,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          if (widget.section.instruction != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.section.instruction!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
          if (widget.section.content != null) ...[
            const SizedBox(height: 12),
            Text(
              widget.section.content!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
          if (widget.section.wordPairs != null && widget.section.wordPairs!.isNotEmpty) ...[
            const SizedBox(height: 16),
            // Show the translation to translate FROM (the target language)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.electricLavender.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.electricLavender.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Translate to ${_getLanguageName(widget.languageCode)}:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.section.wordPairs!.first.translation,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          TextField(
            controller: _answerController,
            enabled: !_showResult,
            decoration: InputDecoration(
              hintText: 'Type your translation here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _showResult
                      ? (_isCorrect == true
                          ? AppTheme.successGreen
                          : Colors.red)
                      : AppTheme.electricLavender.withOpacity(0.5),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.electricLavender.withOpacity(0.5),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.electricLavender,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: _showResult
                  ? (_isCorrect == true
                      ? AppTheme.successGreen.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1))
                  : Colors.grey.withOpacity(0.05),
            ),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textPrimary,
                ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _checkAnswer(),
          ),
          if (_showResult) ...[
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isCorrect == true
                              ? 'Correct!'
                              : 'Incorrect',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: _isCorrect == true
                                    ? AppTheme.successGreen
                                    : Colors.red,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        if (!_isCorrect! && _correctAnswer != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Correct answer: $_correctAnswer',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                          ),
                        ],
                        if (widget.section.explanation != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.section.explanation!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (!_showResult && _answerController.text.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.electricLavender,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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

  String _getLanguageName(String code) {
    switch (code.toLowerCase()) {
      case 'es':
        return 'Spanish';
      case 'en':
        return 'English';
      case 'fr':
        return 'French';
      case 'de':
        return 'German';
      case 'it':
        return 'Italian';
      case 'pt':
        return 'Portuguese';
      default:
        return code.toUpperCase();
    }
  }
}

