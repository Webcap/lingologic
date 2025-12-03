import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/word.dart';
import '../../theme/app_theme.dart';
import '../../services/mini_game_service.dart';
import '../../services/auth_service.dart';
import '../../services/language_service.dart';

class VocabularyReviewMiniGame extends StatefulWidget {
  final int miniGameNumber;
  final List<Word> words;

  const VocabularyReviewMiniGame({
    super.key,
    required this.miniGameNumber,
    required this.words,
  });

  @override
  State<VocabularyReviewMiniGame> createState() =>
      _VocabularyReviewMiniGameState();
}

class _VocabularyReviewMiniGameState extends State<VocabularyReviewMiniGame>
    with SingleTickerProviderStateMixin {
  final _miniGameService = MiniGameService();
  final _authService = AuthService();
  final _languageService = LanguageService();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  List<Word> _shuffledWords = [];
  List<Word> _retryQueue = []; // Words that were answered incorrectly
  Word? _currentWord; // Store the current word being displayed
  int _currentWordIndex = 0;
  List<String> _options = [];
  String? _selectedAnswer;
  bool _showResult = false;
  int _score = 0;
  int _totalWords = 0;
  int _questionsAnswered = 0; // Total questions shown (including retries)
  bool _isCompleted = false;
  bool _isLoading = true;
  bool _isInRetryPhase = false; // Track if we're in the retry phase

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _setupGame();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setupGame() {
    if (widget.words.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Shuffle words and take up to 10 for the mini game
    _shuffledWords = List<Word>.from(widget.words);
    _shuffledWords.shuffle(Random());
    _shuffledWords = _shuffledWords.take(10).toList();
    _totalWords = _shuffledWords.length;

    _loadNextWord();
    setState(() {
      _isLoading = false;
    });
  }

  void _loadNextWord() {
    Word? currentWord;

    // Check if we're in retry phase
    if (_isInRetryPhase) {
      if (_retryQueue.isEmpty) {
        // All retries done, game complete
        _completeGame();
        return;
      }
      // Get next word from retry queue
      currentWord = _retryQueue.removeAt(0);
    } else {
      // Normal phase - check if we've finished initial questions
      if (_currentWordIndex >= _shuffledWords.length) {
        // Finished initial questions, check if we have retries
        if (_retryQueue.isNotEmpty) {
          _isInRetryPhase = true;
          _retryQueue.shuffle(Random()); // Shuffle retry queue
          currentWord = _retryQueue.removeAt(0);
        } else {
          _completeGame();
          return;
        }
      } else {
        currentWord = _shuffledWords[_currentWordIndex];
      }
    }

    // Store current word
    _currentWord = currentWord;

    // Create options: correct answer + 3 random wrong answers
    final wrongAnswers =
        widget.words
            .where(
              (w) =>
                  w.id != _currentWord!.id &&
                  w.language == _currentWord!.language,
            )
            .toList()
          ..shuffle(Random());

    _options = [
      _currentWord!.translation,
      wrongAnswers[0].translation,
      wrongAnswers.length > 1
          ? wrongAnswers[1].translation
          : _currentWord!.translation,
      wrongAnswers.length > 2
          ? wrongAnswers[2].translation
          : _currentWord!.translation,
    ];
    _options.shuffle(Random());

    _selectedAnswer = null;
    _showResult = false;
    _animationController.forward(from: 0);
  }

  void _selectAnswer(String answer) {
    if (_showResult) return;

    if (_currentWord == null) {
      _loadNextWord();
      return;
    }

    final isCorrect = answer == _currentWord!.translation;

    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
      _questionsAnswered++;

      if (isCorrect) {
        _score++;
        HapticFeedback.mediumImpact();
      } else {
        // Add to retry queue if not already there
        if (_currentWord != null &&
            !_retryQueue.contains(_currentWord!) &&
            !_isInRetryPhase) {
          _retryQueue.add(_currentWord!);
        }
        HapticFeedback.heavyImpact();
      }
    });

    // Move to next word immediately for wrong answers, slight delay for correct
    final delay = isCorrect ? 800 : 400;

    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) {
        setState(() {
          if (!_isInRetryPhase) {
            _currentWordIndex++;
          }
        });
        _loadNextWord();
      }
    });
  }

  Future<void> _completeGame() async {
    final user = _authService.currentUser;
    final activeLanguage = await _languageService.getActiveLanguage();

    if (user != null && activeLanguage != null) {
      final miniGameId = 'minigame_${activeLanguage}_${widget.miniGameNumber}';
      try {
        await _miniGameService.completeMiniGame(miniGameId);
      } catch (e) {
        debugPrint('Error completing mini game: $e');
      }
    }

    setState(() {
      _isCompleted = true;
    });
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

    if (widget.words.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
          child: Center(
            child: Text(
              'No words available for review',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      );
    }

    if (_isCompleted) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.cardWhite,
                borderRadius: BorderRadius.circular(32),
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
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.celebration_rounded,
                      color: AppTheme.successGreen,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Mini Game Complete!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Score: $_score / $_totalWords',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.successGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryMintGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text('Continue Learning'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (_currentWord == null) {
      return const SizedBox.shrink();
    }

    // Calculate progress
    final totalQuestions =
        _totalWords + (_isInRetryPhase ? 0 : _retryQueue.length);
    final progress = totalQuestions > 0
        ? _questionsAnswered / totalQuestions.clamp(1, double.infinity)
        : 0.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppTheme.textPrimary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vocabulary Review',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                          ),
                          Text(
                            'Mini Game ${widget.miniGameNumber}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$_score / $_totalWords',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppTheme.successGreen,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              // Progress bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryMintGreen,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Word card
              Expanded(
                child: Center(
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppTheme.cardWhite,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryMintGreen.withOpacity(
                                0.15,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.language_rounded,
                              color: AppTheme.primaryMintGreen,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _currentWord!.wordText,
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'What does this word mean?',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: _options.map((option) {
                    final isSelected = _selectedAnswer == option;
                    final isCorrectOption =
                        _currentWord != null &&
                        option == _currentWord!.translation;

                    Color backgroundColor;
                    Color borderColor;

                    if (_showResult) {
                      if (isSelected && isCorrectOption) {
                        backgroundColor = AppTheme.successGreen.withOpacity(
                          0.15,
                        );
                        borderColor = AppTheme.successGreen;
                      } else if (isSelected && !isCorrectOption) {
                        backgroundColor = Colors.red.withOpacity(0.15);
                        borderColor = Colors.red;
                      } else if (!isSelected && isCorrectOption) {
                        backgroundColor = AppTheme.successGreen.withOpacity(
                          0.1,
                        );
                        borderColor = AppTheme.successGreen.withOpacity(0.5);
                      } else {
                        backgroundColor = Colors.white;
                        borderColor = Colors.grey.shade300;
                      }
                    } else {
                      backgroundColor = isSelected
                          ? AppTheme.goldenOrange.withOpacity(0.15)
                          : Colors.white;
                      borderColor = isSelected
                          ? AppTheme.goldenOrange
                          : Colors.grey.shade300;
                    }

                    return GestureDetector(
                      onTap: () => _selectAnswer(option),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: borderColor, width: 2),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: borderColor,
                              ),
                              child: Center(
                                child: _showResult && isSelected
                                    ? Icon(
                                        isCorrectOption
                                            ? Icons.check_rounded
                                            : Icons.close_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    : Text(
                                        String.fromCharCode(
                                          65 + _options.indexOf(option),
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
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

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
