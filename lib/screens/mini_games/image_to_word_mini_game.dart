import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/word.dart';
import '../../models/mini_game_type.dart';
import '../../theme/app_theme.dart';
import '../../services/mini_game_service.dart';
import '../../services/auth_service.dart';
import '../../services/language_service.dart';

class ImageToWordMiniGame extends StatefulWidget {
  final int miniGameNumber;
  final List<Word> words;

  const ImageToWordMiniGame({
    super.key,
    required this.miniGameNumber,
    required this.words,
  });

  @override
  State<ImageToWordMiniGame> createState() => _ImageToWordMiniGameState();
}

class _ImageToWordMiniGameState extends State<ImageToWordMiniGame>
    with SingleTickerProviderStateMixin {
  final _miniGameService = MiniGameService();
  final _authService = AuthService();
  final _languageService = LanguageService();
  late AnimationController _animationController;

  List<Word> _shuffledWords = [];
  Word? _currentWord;
  int _currentWordIndex = 0;
  List<Word> _options = [];
  Word? _selectedAnswer;
  bool _showResult = false;
  bool _isCorrect = false;
  bool _isCompleted = false;
  bool _isLoading = true;
  int _score = 0;
  int _totalWords = 0;

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
    _shuffledWords = _shuffledWords.take(10).toList();
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

    // Create options: correct answer + 3 random wrong answers
    final wrongAnswers = widget.words
        .where((w) => w.id != _currentWord!.id && w.language == _currentWord!.language)
        .toList()
      ..shuffle(Random());

    _options = [
      _currentWord!,
      wrongAnswers[0],
      wrongAnswers.length > 1 ? wrongAnswers[1] : _currentWord!,
      wrongAnswers.length > 2 ? wrongAnswers[2] : _currentWord!,
    ];
    _options.shuffle(Random());

    _selectedAnswer = null;
    _showResult = false;
    _isCorrect = false;

    setState(() {});
    _animationController.forward(from: 0);
  }

  void _selectAnswer(Word word) {
    if (_showResult) return;

    setState(() {
      _selectedAnswer = word;
      _showResult = true;
      _isCorrect = word.id == _currentWord!.id;
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

  IconData _getIconForWord(Word word) {
    // Simple icon mapping based on word category or common words
    final text = word.wordText.toLowerCase();
    if (text.contains('food') || text.contains('eat') || text.contains('apple')) {
      return Icons.restaurant;
    } else if (text.contains('water') || text.contains('drink')) {
      return Icons.water_drop;
    } else if (text.contains('home') || text.contains('house')) {
      return Icons.home;
    } else if (text.contains('car') || text.contains('vehicle')) {
      return Icons.directions_car;
    } else if (text.contains('person') || text.contains('people')) {
      return Icons.person;
    } else if (text.contains('time') || text.contains('clock')) {
      return Icons.access_time;
    } else if (text.contains('book') || text.contains('read')) {
      return Icons.book;
    } else if (text.contains('music') || text.contains('song')) {
      return Icons.music_note;
    } else if (text.contains('sun') || text.contains('weather')) {
      return Icons.wb_sunny;
    } else if (text.contains('heart') || text.contains('love')) {
      return Icons.favorite;
    } else {
      // Default icons based on category
      switch (word.category.toLowerCase()) {
        case 'food':
          return Icons.restaurant;
        case 'animal':
          return Icons.pets;
        case 'color':
          return Icons.palette;
        case 'body':
          return Icons.accessibility;
        case 'clothing':
          return Icons.checkroom;
        default:
          return Icons.image;
      }
    }
  }

  Color _getColorForWord(Word word) {
    if (!_showResult) return AppTheme.primaryMintGreen;
    if (word.id == _currentWord!.id) {
      return AppTheme.successGreen;
    }
    if (word.id == _selectedAnswer?.id && !_isCorrect) {
      return Colors.red;
    }
    return AppTheme.textSecondary.withOpacity(0.3);
  }

  Future<void> _completeGame() async {
    final user = _authService.currentUser;
    final activeLanguage = await _languageService.getActiveLanguage();

    if (user != null && activeLanguage != null) {
      final miniGameId = 'minigame_${activeLanguage}_${widget.miniGameNumber}';
      try {
        await _miniGameService.completeMiniGame(miniGameId, MiniGameType.imageToWord);
      } catch (e) {
        debugPrint('Error completing image to word mini game: $e');
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
                        'Image to Word - ${_currentWordIndex + 1}/$_totalWords',
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

              // Image/Icon display
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.all(16),
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
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _currentWord != null
                              ? _getIconForWord(_currentWord!)
                              : Icons.image,
                          size: 150,
                          color: AppTheme.primaryMintGreen,
                        ),
                        const SizedBox(height: 24),
                        if (_showResult)
                          Text(
                            _currentWord?.translation ?? '',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Question
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Select the correct word:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 16),

              // Answer options
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: _options.length,
                    itemBuilder: (context, index) {
                      final word = _options[index];
                      final isSelected = _selectedAnswer?.id == word.id;
                      final isCorrect = word.id == _currentWord!.id;

                      return GestureDetector(
                        onTap: () => _selectAnswer(word),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getColorForWord(word),
                            borderRadius: BorderRadius.circular(16),
                            border: isSelected && _showResult
                                ? Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  )
                                : null,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_showResult && isCorrect)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                if (_showResult && isSelected && !isCorrect)
                                  const Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                if (_showResult && isCorrect || isSelected && !isCorrect)
                                  const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    word.wordText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _showResult && (isCorrect || isSelected)
                                          ? Colors.white
                                          : Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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

