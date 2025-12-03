import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../models/word.dart';
import '../../theme/app_theme.dart';
import '../../services/level_progression_service.dart';
import '../../services/lesson_service.dart';
import '../../services/auth_service.dart';
import '../../services/language_service.dart';
import '../../data/remote/supabase_repository.dart';
import '../../utils/error_handler.dart';

class LevelKnowledgeTestScreen extends StatefulWidget {
  final String level;

  const LevelKnowledgeTestScreen({
    super.key,
    required this.level,
  });

  @override
  State<LevelKnowledgeTestScreen> createState() => _LevelKnowledgeTestScreenState();
}

class _LevelKnowledgeTestScreenState extends State<LevelKnowledgeTestScreen> {
  final _levelProgressionService = LevelProgressionService();
  final _lessonService = LessonService();
  final _authService = AuthService();
  final _languageService = LanguageService();
  final _repository = SupabaseRepository();

  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  int _correctAnswers = 0;
  bool _isLoading = true;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadTest();
  }

  Future<void> _loadTest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _authService.currentUser;
      if (user == null) {
        if (mounted) context.go('/login');
        return;
      }

      final activeLanguage = await _languageService.getActiveLanguage();
      if (activeLanguage == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No active language selected')),
          );
          context.pop();
        }
        return;
      }

      // Get all lessons for the current level
      final allLessons = await _lessonService.getLessons();
      final levelLessons = allLessons.where((l) => l.level == widget.level).toList();

      if (levelLessons.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No lessons found for this level')),
          );
          context.pop();
        }
        return;
      }

      // Collect all words from level lessons
      final wordIds = <String>{};
      for (final lesson in levelLessons) {
        wordIds.addAll(lesson.unlocksWordIds);
      }

      if (wordIds.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No vocabulary found for this level')),
          );
          context.pop();
        }
        return;
      }

      // Load words
      final words = <Word>[];
      for (final wordId in wordIds.take(50)) {
        // Limit to 50 words
        try {
          final word = await _repository.getWordById(wordId);
          if (word != null) {
            words.add(word);
          }
        } catch (e) {
          debugPrint('Error loading word $wordId: $e');
        }
      }

      if (words.length < 10) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Not enough vocabulary for the test. Complete more lessons first.')),
          );
          context.pop();
        }
        return;
      }

      // Generate 15 questions from the words
      _generateQuestions(words.take(30).toList());

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleError(context, e, contextMessage: 'Error loading test');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _generateQuestions(List<Word> words) {
    final questions = <Map<String, dynamic>>[];
    final random = Random();

    // Shuffle words
    words.shuffle(random);

    // Generate 15 multiple-choice questions
    for (int i = 0; i < 15 && i < words.length; i++) {
      final correctWord = words[i];
      final wrongWords = words.where((w) => w.id != correctWord.id).toList();
      wrongWords.shuffle(random);

      // Pick 3 wrong answers
      final wrongAnswers = wrongWords.take(3).map((w) => w.translation).toList();

      // Create options
      final options = [correctWord.translation, ...wrongAnswers];
      options.shuffle(random);

      questions.add({
        'word': correctWord.wordText,
        'correctAnswer': correctWord.translation,
        'options': options,
        'wordId': correctWord.id,
      });
    }

    setState(() {
      _questions = questions;
    });
  }

  void _selectAnswer(String answer) {
    if (_showResult) return;

    setState(() {
      _selectedAnswer = answer;
      _showResult = true;

      if (answer == _questions[_currentQuestionIndex]['correctAnswer']) {
        _correctAnswers++;
        HapticFeedback.lightImpact();
      } else {
        HapticFeedback.heavyImpact();
      }
    });

    // Move to next question after delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      _completeTest();
    }
  }

  Future<void> _completeTest() async {
    final percentage = (_correctAnswers / _questions.length) * 100;
    final passed = percentage >= 70; // Need 70% to pass

    try {
      await _levelProgressionService.saveTestResult(
        level: widget.level,
        score: percentage.round(),
        totalQuestions: _questions.length,
        passed: passed,
      );

      if (mounted) {
        setState(() {
          _isCompleted = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleError(context, e, contextMessage: 'Error saving test result');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_isCompleted) {
      final percentage = (_correctAnswers / _questions.length) * 100;
      final passed = percentage >= 70;

      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: passed
                            ? AppTheme.successGreen.withOpacity(0.2)
                            : Colors.orange.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        passed ? Icons.check_circle_rounded : Icons.close_rounded,
                        size: 60,
                        color: passed ? AppTheme.successGreen : Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      passed ? 'Congratulations!' : 'Test Complete',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      passed
                          ? 'You passed the ${widget.level} knowledge test!'
                          : 'You scored ${percentage.round()}%. You need 70% to pass.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Score: $_correctAnswers / ${_questions.length}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 32),
                    if (passed)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.successGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.successGreen.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_open_rounded, color: AppTheme.successGreen),
                            const SizedBox(width: 12),
                            Text(
                              'You can now access ${_getNextLevel(widget.level)} lessons!',
                              style: TextStyle(
                                color: AppTheme.successGreen,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => context.pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: passed ? AppTheme.successGreen : AppTheme.primaryMintGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
          child: const Center(child: Text('No questions available')),
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppTheme.textPrimary),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.level} Knowledge Test',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryMintGreen),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Question
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.cardWhite,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'What is the translation of:',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              currentQuestion['word'],
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Options
                      ...(currentQuestion['options'] as List<String>).map((option) {
                        final isSelected = _selectedAnswer == option;
                        final isCorrect = option == currentQuestion['correctAnswer'];
                        final showCorrect = _showResult && isCorrect;
                        final showWrong = _showResult && isSelected && !isCorrect;

                        Color? backgroundColor;
                        Color? borderColor;
                        Color? textColor;

                        if (showCorrect) {
                          backgroundColor = AppTheme.successGreen.withOpacity(0.15);
                          borderColor = AppTheme.successGreen;
                          textColor = AppTheme.successGreen;
                        } else if (showWrong) {
                          backgroundColor = Colors.red.withOpacity(0.15);
                          borderColor = Colors.red;
                          textColor = Colors.red;
                        } else if (isSelected && _showResult) {
                          backgroundColor = Colors.grey.withOpacity(0.1);
                          borderColor = Colors.grey;
                          textColor = AppTheme.textPrimary;
                        } else {
                          backgroundColor = AppTheme.cardWhite;
                          borderColor = Colors.transparent;
                          textColor = AppTheme.textPrimary;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _selectAnswer(option),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: borderColor,
                                    width: showCorrect || showWrong ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: showCorrect
                                            ? AppTheme.successGreen
                                            : showWrong
                                                ? Colors.red
                                                : AppTheme.textSecondary.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        showCorrect
                                            ? Icons.check_rounded
                                            : showWrong
                                                ? Icons.close_rounded
                                                : null,
                                        color: showCorrect || showWrong ? Colors.white : null,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: textColor,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getNextLevel(String currentLevel) {
    const cefrOrder = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
    final index = cefrOrder.indexOf(currentLevel);
    if (index >= 0 && index < cefrOrder.length - 1) {
      return cefrOrder[index + 1];
    }
    return 'next level';
  }
}

