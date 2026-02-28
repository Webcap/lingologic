import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/word.dart';
import '../../models/mini_game_type.dart';
import '../../theme/app_theme.dart';
import '../../services/mini_game_service.dart';
import '../../services/auth_service.dart';
import '../../services/language_service.dart';

class CharadesMiniGame extends StatefulWidget {
  final int miniGameNumber;
  final List<Word> words;

  const CharadesMiniGame({
    super.key,
    required this.miniGameNumber,
    required this.words,
  });

  @override
  State<CharadesMiniGame> createState() => _CharadesMiniGameState();
}

class _CharadesMiniGameState extends State<CharadesMiniGame>
    with SingleTickerProviderStateMixin {
  final _miniGameService = MiniGameService();
  final _authService = authService;
  final _languageService = LanguageService();
  late AnimationController _animationController;

  List<Word> _shuffledWords = [];
  Word? _currentWord;
  int _currentWordIndex = 0;
  List<String> _options = [];
  String? _selectedAnswer;
  bool _showResult = false;
  bool _isCorrect = false;
  bool _isCompleted = false;
  bool _isLoading = true;
  int _score = 0;
  int _totalWords = 0;
  bool _showWord = false; // Whether to show the word to act out

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
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

    _shuffledWords = List<Word>.from(widget.words);
    _shuffledWords.shuffle(Random());
    _shuffledWords = _shuffledWords.take(5).toList();
    _totalWords = _shuffledWords.length;
    _loadNextWord();
    setState(() {
      _isLoading = false;
    });
  }

  void _loadNextWord() {
    if (_currentWordIndex >= _shuffledWords.length) {
      _completeGame();
      return;
    }

    _currentWord = _shuffledWords[_currentWordIndex];
    _showResult = false;
    _isCorrect = false;
    _showWord = false;

    // Create options: correct answer + 3 random wrong answers
    final wrongAnswers = widget.words
        .where((w) => w.id != _currentWord!.id && w.language == _currentWord!.language)
        .toList()
      ..shuffle(Random());

    _options = [
      _currentWord!.translation,
      wrongAnswers[0].translation,
      wrongAnswers.length > 1 ? wrongAnswers[1].translation : _currentWord!.translation,
      wrongAnswers.length > 2 ? wrongAnswers[2].translation : _currentWord!.translation,
    ];
    _options.shuffle(Random());

    setState(() {});
    _animationController.forward(from: 0);
  }

  void _selectAnswer(String answer) {
    if (_showResult) return;

    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
      _isCorrect = answer == _currentWord!.translation;
      if (_isCorrect) {
        _score++;
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    });

    Future.delayed(Duration(milliseconds: _isCorrect ? 1000 : 2000), () {
      if (mounted) {
        _currentWordIndex++;
        _loadNextWord();
      }
    });
  }

  void _toggleShowWord() {
    setState(() {
      _showWord = !_showWord;
    });
    HapticFeedback.lightImpact();
  }

  List<String> _getActionHints() {
    if (_currentWord == null) return [];
    final word = _currentWord!.wordText.toLowerCase();
    final hints = <String>[];

    // Category-based hints
    if (_currentWord!.category.isNotEmpty) {
      hints.add('Category: ${_currentWord!.category}');
    }

    // Action hints based on word
    if (word.contains('run') || word.contains('walk')) {
      hints.add('💨 Use body movement');
    } else if (word.contains('eat') || word.contains('drink')) {
      hints.add('🍽️ Pretend to use an action');
    } else if (word.contains('animal')) {
      hints.add('🐾 Act like an animal');
    } else if (word.contains('emotion') || word.contains('feel')) {
      hints.add('😊 Show with your face');
    } else {
      hints.add('🎭 Act it out or describe it');
    }

    hints.add('Use gestures, body language, or sounds');
    hints.add('No speaking the word!');

    return hints;
  }

  Future<void> _completeGame() async {
    final user = _authService.currentUser;
    final activeLanguage = await _languageService.getActiveLanguage();

    if (user != null && activeLanguage != null) {
      final miniGameId = 'minigame_${activeLanguage}_${widget.miniGameNumber}';
      try {
        await _miniGameService.completeMiniGame(miniGameId, MiniGameType.charades);
      } catch (e) {
        debugPrint('Error completing charades mini game: $e');
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

    if (_isCompleted) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.celebration_rounded, size: 80, color: Colors.white),
                const SizedBox(height: 24),
                Text(
                  'Game Complete!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Score: $_score / $_totalWords',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryMintGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Charades - Word ${_currentWordIndex + 1}/$_totalWords',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Score
              Text(
                'Score: $_score / $_totalWords',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 24),

              // Word to act out (shown/hidden)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Act out this word:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        IconButton(
                          icon: Icon(
                            _showWord ? Icons.visibility_off : Icons.visibility,
                            color: AppTheme.primaryMintGreen,
                          ),
                          onPressed: _toggleShowWord,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _showWord ? _currentWord!.wordText : '???',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: _showWord
                                ? AppTheme.primaryMintGreen
                                : AppTheme.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action hints
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getActionHints().map((hint) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb_outline,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              hint,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // Instructions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _showResult
                      ? (_isCorrect
                          ? 'Correct! 🎉'
                          : 'Incorrect. The answer was: ${_currentWord!.translation}')
                      : 'Select the correct translation:',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _showResult
                            ? (_isCorrect ? Colors.green : Colors.red)
                            : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 16),

              // Answer options
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    itemCount: _options.length,
                    itemBuilder: (context, index) {
                      final option = _options[index];
                      final isSelected = _selectedAnswer == option;
                      final isCorrect = option == _currentWord!.translation;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _selectAnswer(option),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: _showResult
                                  ? (isCorrect
                                      ? AppTheme.successGreen
                                      : isSelected
                                          ? Colors.red
                                          : Colors.white.withOpacity(0.3))
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: isSelected && _showResult
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null,
                            ),
                            child: Row(
                              children: [
                                if (_showResult && isCorrect)
                                  const Icon(Icons.check_circle,
                                      color: Colors.white, size: 28),
                                if (_showResult && isSelected && !isCorrect)
                                  const Icon(Icons.cancel,
                                      color: Colors.white, size: 28),
                                if (_showResult && (isCorrect || isSelected))
                                  const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: _showResult &&
                                              (isCorrect || isSelected)
                                          ? Colors.white
                                          : AppTheme.textPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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

