import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/word.dart';
import '../../models/mini_game_type.dart';
import '../../theme/app_theme.dart';
import '../../services/mini_game_service.dart';
import '../../services/auth_service.dart';
import '../../services/language_service.dart';

class PictionaryMiniGame extends StatefulWidget {
  final int miniGameNumber;
  final List<Word> words;

  const PictionaryMiniGame({
    super.key,
    required this.miniGameNumber,
    required this.words,
  });

  @override
  State<PictionaryMiniGame> createState() => _PictionaryMiniGameState();
}

class _PictionaryMiniGameState extends State<PictionaryMiniGame>
    with SingleTickerProviderStateMixin {
  final _miniGameService = MiniGameService();
  final _authService = AuthService();
  final _languageService = LanguageService();
  late AnimationController _animationController;

  List<Word> _shuffledWords = [];
  Word? _currentWord;
  int _currentWordIndex = 0;
  String _userGuess = '';
  bool _isCompleted = false;
  bool _isCorrect = false;
  bool _isLoading = true;
  int _score = 0;
  int _totalWords = 0;
  int _hintLevel = 0; // 0 = no hint, 1 = category, 2 = first letter, 3 = translation

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
    _userGuess = '';
    _isCorrect = false;
    _hintLevel = 0;

    setState(() {});
    _animationController.forward(from: 0);
  }

  void _checkGuess() {
    if (_userGuess.trim().isEmpty) return;

    final guess = _userGuess.trim().toLowerCase();
    final correctWord = _currentWord!.wordText.toLowerCase().trim();

    if (guess == correctWord) {
      setState(() {
        _isCorrect = true;
        _score++;
      });
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          _currentWordIndex++;
          _loadNextWord();
        }
      });
    } else {
      HapticFeedback.lightImpact();
      setState(() {
        _userGuess = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Try again!'),
          duration: Duration(milliseconds: 1000),
        ),
      );
    }
  }

  void _showHint() {
    if (_hintLevel < 3) {
      setState(() {
        _hintLevel++;
      });
      HapticFeedback.lightImpact();
    }
  }

  String _getHintText() {
    if (_currentWord == null) return '';
    switch (_hintLevel) {
      case 1:
        return 'Category: ${_currentWord!.category.isNotEmpty ? _currentWord!.category : 'General'}';
      case 2:
        return 'Starts with: ${_currentWord!.wordText[0].toUpperCase()}';
      case 3:
        return 'Translation: ${_currentWord!.translation}';
      default:
        return '';
    }
  }

  Future<void> _completeGame() async {
    final user = _authService.currentUser;
    final activeLanguage = await _languageService.getActiveLanguage();

    if (user != null && activeLanguage != null) {
      final miniGameId = 'minigame_${activeLanguage}_${widget.miniGameNumber}';
      try {
        await _miniGameService.completeMiniGame(miniGameId, MiniGameType.pictionary);
      } catch (e) {
        debugPrint('Error completing pictionary mini game: $e');
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
                        'Pictionary - Word ${_currentWordIndex + 1}/$_totalWords',
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

              // Drawing area (simplified - shows icon representation)
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
                          Icons.draw_rounded,
                          size: 120,
                          color: AppTheme.primaryMintGreen,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _isCorrect ? _currentWord!.wordText : '???',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: _isCorrect
                                    ? AppTheme.successGreen
                                    : AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (!_isCorrect) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Draw this word!',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // Hint section
              if (_hintLevel > 0)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _getHintText(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // Input section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _userGuess = value;
                        });
                      },
                      onSubmitted: (_) => _checkGuess(),
                      enabled: !_isCorrect,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Enter the word',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      style: const TextStyle(fontSize: 18),
                      textCapitalization: TextCapitalization.none,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _hintLevel < 3 ? _showHint : null,
                            icon: const Icon(Icons.lightbulb_outline),
                            label: Text('Hint (${_hintLevel}/3)'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.3),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _isCorrect ? null : _checkGuess,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppTheme.primaryMintGreen,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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

