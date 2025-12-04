import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/lesson_content.dart';
import '../../../theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class TranslationExerciseWidget extends StatefulWidget {
  final TranslationExerciseSection section;
  final ValueChanged<bool>? onAnswerSubmitted;
  final VoidCallback? onRetry;
  final bool isAnswered;
  final bool isCorrect;
  final bool canRetry;

  const TranslationExerciseWidget({
    super.key,
    required this.section,
    this.onAnswerSubmitted,
    this.onRetry,
    this.isAnswered = false,
    this.isCorrect = false,
    this.canRetry = false,
  });

  @override
  State<TranslationExerciseWidget> createState() => _TranslationExerciseWidgetState();
}

class _TranslationExerciseWidgetState extends State<TranslationExerciseWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showResult = false;
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    if (widget.isAnswered) {
      _showResult = true;
      _isCorrect = widget.isCorrect;
      if (widget.isCorrect) {
        _controller.text = widget.section.correctAnswer;
      }
    }
    // Request focus when widget is built to show keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isAnswered) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void didUpdateWidget(TranslationExerciseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnswered && !oldWidget.isAnswered) {
      _showResult = true;
      _isCorrect = widget.isCorrect;
      if (widget.isCorrect) {
        _controller.text = widget.section.correctAnswer;
      }
      _focusNode.unfocus();
    }
    if (widget.section.id != oldWidget.section.id) {
      // Reset for new exercise
      _controller.clear();
      _showResult = false;
      _isCorrect = null;
      if (!widget.isAnswered) {
        _focusNode.requestFocus();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final userAnswer = _controller.text.trim();
    final correctAnswer = widget.section.correctAnswer.trim();
    
    // Normalize answers for comparison (case-insensitive, ignore extra spaces)
    final normalizedUser = userAnswer.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    final normalizedCorrect = correctAnswer.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    
    final isCorrect = normalizedUser == normalizedCorrect;
    
    setState(() {
      _showResult = true;
      _isCorrect = isCorrect;
    });
    
    _focusNode.unfocus();
    HapticFeedback.mediumImpact();
    widget.onAnswerSubmitted?.call(isCorrect);
  }

  void _showWordTranslation(String word) {
    final translation = widget.section.words.firstWhere(
      (w) => w.word.toLowerCase() == word.toLowerCase(),
      orElse: () => TranslationWord(word: word, translation: 'Translation not found'),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryMintGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.translate_rounded,
                color: AppTheme.primaryMintGreen,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                word,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          translation.translation,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryMintGreen,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              AppLocalizations.of(context)!.close,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildClickableWords(String sentence) {
    final words = sentence.split(RegExp(r'\s+'));
    return words.map((word) {
      // Remove punctuation for matching but keep it in display
      final cleanWord = word.replaceAll(RegExp(r'[^\w\s]'), '');
      final hasTranslation = widget.section.words.any(
        (w) => w.word.toLowerCase() == cleanWord.toLowerCase(),
      );

      if (!hasTranslation || cleanWord.isEmpty) {
        return Text(
          word,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        );
      }

      return GestureDetector(
        onTap: () => _showWordTranslation(cleanWord),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.primaryMintGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: AppTheme.primaryMintGreen.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            word,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryMintGreen,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              decorationColor: AppTheme.primaryMintGreen,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final borderColor = _showResult
        ? (_isCorrect == true ? AppTheme.successGreen : Colors.red)
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
                    Icons.translate_rounded,
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
                        l10n.translation,
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
                                _isCorrect == true
                                    ? l10n.correct
                                    : l10n.tryAgain,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
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

          // English sentence with clickable words
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Container(
              padding: const EdgeInsets.all(20),
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
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _buildClickableWords(widget.section.sentence),
              ),
            ),
          ),

          // Hint text
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppTheme.textSecondary.withOpacity(0.6),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tap words above to see translations. Type your translation below.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Translation input
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: !_showResult,
              maxLines: 3,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                if (!_showResult && _controller.text.trim().isNotEmpty) {
                  _checkAnswer();
                }
              },
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Type your translation here...',
                hintStyle: TextStyle(
                  color: AppTheme.textSecondary.withOpacity(0.5),
                ),
                filled: true,
                fillColor: _showResult
                    ? (_isCorrect == true
                        ? AppTheme.successGreen.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1))
                    : Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: _showResult
                        ? (_isCorrect == true
                            ? AppTheme.successGreen
                            : Colors.red)
                        : AppTheme.goldenOrange,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: AppTheme.goldenOrange,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: AppTheme.goldenOrange,
                    width: 2.5,
                  ),
                ),
                contentPadding: const EdgeInsets.all(20),
              ),
            ),
          ),

          // Explanation
          if (_showResult && widget.section.explanation != null) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (_isCorrect == true ? AppTheme.successGreen : Colors.red)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      (_isCorrect == true ? AppTheme.successGreen : Colors.red)
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
                      color:
                          (_isCorrect == true
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
          if (_showResult &&
              _isCorrect == false &&
              widget.canRetry &&
              widget.onRetry != null) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: widget.onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: Text(l10n.retryWithDifferentQuestion),
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
          if (!_showResult) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _controller.text.trim().isEmpty
                    ? null
                    : _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.goldenOrange,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  l10n.submitAnswer,
                  style: const TextStyle(
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

