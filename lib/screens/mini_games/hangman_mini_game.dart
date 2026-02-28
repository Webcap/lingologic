import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/word.dart';
import '../../models/mini_game_type.dart';
import '../../theme/app_theme.dart';
import '../../services/mini_game_service.dart';
import '../../services/auth_service.dart';
import '../../services/language_service.dart';

class HangmanMiniGame extends StatefulWidget {
  final int miniGameNumber;
  final List<Word> words;

  const HangmanMiniGame({
    super.key,
    required this.miniGameNumber,
    required this.words,
  });

  @override
  State<HangmanMiniGame> createState() => _HangmanMiniGameState();
}

class _HangmanMiniGameState extends State<HangmanMiniGame>
    with SingleTickerProviderStateMixin {
  final _miniGameService = MiniGameService();
  final _authService = authService;
  final _languageService = LanguageService();
  late AnimationController _animationController;

  List<Word> _shuffledWords = [];
  Word? _currentWord;
  int _currentWordIndex = 0;
  String _secretWord = '';
  List<String> _guessedLetters = [];
  List<String> _wrongGuesses = [];
  int _maxWrongGuesses = 6;
  bool _isCompleted = false;
  bool _isGameOver = false;
  bool _isLoading = true;
  int _score = 0;
  int _totalWords = 0;

  final List<String> _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

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
    _shuffledWords = _shuffledWords.take(5).toList(); // 5 words per game
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
    _secretWord = _currentWord!.wordText.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    _guessedLetters = [];
    _wrongGuesses = [];
    _isGameOver = false;

    setState(() {});
    _animationController.forward(from: 0);
  }

  void _guessLetter(String letter) {
    if (_isGameOver || _isCompleted || _guessedLetters.contains(letter)) {
      return;
    }

    setState(() {
      _guessedLetters.add(letter);
      if (!_secretWord.contains(letter)) {
        _wrongGuesses.add(letter);
        HapticFeedback.lightImpact();
        if (_wrongGuesses.length >= _maxWrongGuesses) {
          _isGameOver = true;
          HapticFeedback.heavyImpact();
          _handleWrongAnswer();
        }
      } else {
        HapticFeedback.mediumImpact();
        // Check if word is complete
        final wordComplete = _secretWord.split('').every((char) => _guessedLetters.contains(char));
        if (wordComplete) {
          _isGameOver = true;
          _score++;
          HapticFeedback.heavyImpact();
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              _currentWordIndex++;
              _loadNextWord();
            }
          });
        }
      }
    });
  }

  void _handleWrongAnswer() {
    // Show correct answer briefly, then move to next word
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _currentWordIndex++;
        _loadNextWord();
      }
    });
  }

  String _getDisplayWord() {
    return _secretWord.split('').map((char) {
      if (char == ' ') return ' ';
      return _guessedLetters.contains(char) ? char : '_';
    }).join(' ');
  }

  int _getHangmanStage() {
    return _wrongGuesses.length;
  }

  Widget _buildHangmanDrawing() {
    final stage = _getHangmanStage();
    return CustomPaint(
      size: const Size(200, 250),
      painter: HangmanPainter(stage: stage),
    );
  }

  Future<void> _completeGame() async {
    final user = _authService.currentUser;
    final activeLanguage = await _languageService.getActiveLanguage();

    if (user != null && activeLanguage != null) {
      final miniGameId = 'minigame_${activeLanguage}_${widget.miniGameNumber}';
      try {
        await _miniGameService.completeMiniGame(miniGameId, MiniGameType.hangman);
      } catch (e) {
        debugPrint('Error completing hangman mini game: $e');
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
                        'Hangman - Word ${_currentWordIndex + 1}/$_totalWords',
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

              // Hangman drawing
              Expanded(
                flex: 2,
                child: Center(child: _buildHangmanDrawing()),
              ),

              // Word display
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_currentWord != null)
                        Text(
                          _currentWord!.translation,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white.withOpacity(0.8),
                              ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        _getDisplayWord(),
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 8,
                            ),
                      ),
                      if (_isGameOver && _wrongGuesses.length >= _maxWrongGuesses)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            'Correct word: $_secretWord',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.red.shade300,
                                ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Alphabet keyboard
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: _alphabet.length,
                    itemBuilder: (context, index) {
                      final letter = _alphabet[index];
                      final isGuessed = _guessedLetters.contains(letter);
                      final isWrong = _wrongGuesses.contains(letter);
                      final isCorrect = _guessedLetters.contains(letter) && !isWrong;

                      return ElevatedButton(
                        onPressed: isGuessed ? null : () => _guessLetter(letter),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCorrect
                              ? Colors.green
                              : isWrong
                                  ? Colors.red
                                  : Colors.white,
                          foregroundColor: isCorrect || isWrong
                              ? Colors.white
                              : AppTheme.primaryMintGreen,
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HangmanPainter extends CustomPainter {
  final int stage; // 0-6

  HangmanPainter({required this.stage});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Gallows base
    if (stage >= 1) {
      canvas.drawLine(
        Offset(size.width * 0.1, size.height * 0.9),
        Offset(size.width * 0.9, size.height * 0.9),
        paint,
      );
    }

    // Gallows post
    if (stage >= 2) {
      canvas.drawLine(
        Offset(size.width * 0.1, size.height * 0.9),
        Offset(size.width * 0.1, size.height * 0.1),
        paint,
      );
    }

    // Gallows top
    if (stage >= 3) {
      canvas.drawLine(
        Offset(size.width * 0.1, size.height * 0.1),
        Offset(size.width * 0.5, size.height * 0.1),
        paint,
      );
    }

    // Rope
    if (stage >= 4) {
      canvas.drawLine(
        Offset(size.width * 0.5, size.height * 0.1),
        Offset(size.width * 0.5, size.height * 0.25),
        paint,
      );
    }

    // Head
    if (stage >= 5) {
      canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.3),
        size.width * 0.08,
        paint,
      );
    }

    // Body
    if (stage >= 6) {
      canvas.drawLine(
        Offset(size.width * 0.5, size.height * 0.38),
        Offset(size.width * 0.5, size.height * 0.65),
        paint,
      );

      // Arms
      canvas.drawLine(
        Offset(size.width * 0.5, size.height * 0.45),
        Offset(size.width * 0.4, size.height * 0.55),
        paint,
      );
      canvas.drawLine(
        Offset(size.width * 0.5, size.height * 0.45),
        Offset(size.width * 0.6, size.height * 0.55),
        paint,
      );

      // Legs
      canvas.drawLine(
        Offset(size.width * 0.5, size.height * 0.65),
        Offset(size.width * 0.4, size.height * 0.75),
        paint,
      );
      canvas.drawLine(
        Offset(size.width * 0.5, size.height * 0.65),
        Offset(size.width * 0.6, size.height * 0.75),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


