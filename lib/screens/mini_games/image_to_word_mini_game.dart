import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/word.dart';
import '../../models/mini_game_type.dart';
import '../../theme/app_theme.dart';
import '../../services/mini_game_service.dart';
import '../../services/auth_service.dart';
import '../../services/language_service.dart';
import '../../l10n/app_localizations.dart';

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

class _ImageToWordMiniGameState extends State<ImageToWordMiniGame> {
  final _miniGameService = MiniGameService();
  final _authService = AuthService();
  final _languageService = LanguageService();
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  
  List<Word> _shuffledWords = [];
  Word? _currentWord;
  int _currentWordIndex = 0;
  bool _isCompleted = false;
  bool _isLoading = true;
  bool _showResult = false;
  bool? _isCorrect;
  
  @override
  void initState() {
    super.initState();
    _setupGame();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _setupGame() {
    // Filter words that have images
    final wordsWithImages = widget.words.where((word) => 
      word.imageUrl != null && word.imageUrl!.isNotEmpty
    ).toList();

    if (wordsWithImages.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Shuffle words and take the appropriate amount for the mini game
    _shuffledWords = List<Word>.from(wordsWithImages);
    _shuffledWords.shuffle(Random());
    
    // Get difficulty-based word count
    final difficulty = MiniGameDifficulty.fromMiniGameNumber(widget.miniGameNumber);
    _shuffledWords = _shuffledWords.take(difficulty.wordCount).toList();

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

    setState(() {
      _currentWord = _shuffledWords[_currentWordIndex];
      _currentWordIndex++;
      _textController.clear();
      _showResult = false;
      _isCorrect = null;
    });
    
    // Focus the text field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  String _normalizeText(String text) {
    return text.toLowerCase().trim().replaceAll(RegExp(r'[^\w\s]'), '');
  }

  void _checkAnswer() {
    if (_currentWord == null || _textController.text.trim().isEmpty) {
      return;
    }

    final userAnswer = _normalizeText(_textController.text);
    final correctAnswer = _normalizeText(_currentWord!.wordText);
    final isCorrect = userAnswer == correctAnswer;

    setState(() {
      _showResult = true;
      _isCorrect = isCorrect;
    });

    // Auto-advance after 2 seconds if correct
    if (isCorrect) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _loadNextWord();
        }
      });
    }
  }

  Future<void> _completeGame() async {
    final user = _authService.currentUser;
    if (user != null) {
      try {
        final activeLanguage = await _languageService.getActiveLanguage();
        if (activeLanguage != null) {
          final miniGameId = 'minigame_${activeLanguage}_${widget.miniGameNumber}';
          await _miniGameService.completeMiniGame(
            miniGameId,
            MiniGameType.imageToWord,
          );
        }
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
    final l10n = AppLocalizations.of(context)!;
    
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final wordsWithImages = widget.words.where((word) => 
      word.imageUrl != null && word.imageUrl!.isNotEmpty
    ).toList();

    if (wordsWithImages.isEmpty) {
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
                  const Icon(
                    Icons.image_not_supported_rounded,
                    size: 64,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Images Available',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Words with images are required for this game.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
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
                    'You typed ${_shuffledWords.length} words!',
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
                    child: Text(l10n.continueLearning),
                  ),
                ],
              ),
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
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            MiniGameType.imageToWord.getFunName(widget.miniGameNumber),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Word $_currentWordIndex / ${_shuffledWords.length}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48), // Balance close button
                  ],
                ),
              ),
              
              // Game content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardWhite,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      
                      // Image display
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.goldenOrange.withOpacity(0.3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: _currentWord?.imageUrl != null
                                ? Image.network(
                                    _currentWord!.imageUrl!,
                                    fit: BoxFit.contain,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.image_not_supported_rounded,
                                              size: 64,
                                              color: AppTheme.textSecondary,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Failed to load image',
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: AppTheme.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.image_rounded,
                                      size: 64,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Instruction
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Type the word for this image:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Text input
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: TextField(
                          controller: _textController,
                          focusNode: _focusNode,
                          enabled: !_showResult || _isCorrect == false,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _checkAnswer(),
                          decoration: InputDecoration(
                            hintText: 'Type the word...',
                            filled: true,
                            fillColor: Colors.white,
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
                                color: _showResult
                                    ? (_isCorrect == true 
                                        ? AppTheme.successGreen 
                                        : Colors.red)
                                    : AppTheme.goldenOrange,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: _showResult
                                    ? (_isCorrect == true 
                                        ? AppTheme.successGreen 
                                        : Colors.red)
                                    : AppTheme.primaryMintGreen,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            suffixIcon: _showResult
                                ? Icon(
                                    _isCorrect == true
                                        ? Icons.check_circle_rounded
                                        : Icons.cancel_rounded,
                                    color: _isCorrect == true
                                        ? AppTheme.successGreen
                                        : Colors.red,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      
                      // Show correct answer if wrong
                      if (_showResult && _isCorrect == false && _currentWord != null) ...[
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Correct answer: ${_currentWord!.wordText}',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Submit/Next button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _showResult && _isCorrect == true
                                ? null
                                : (_showResult && _isCorrect == false
                                    ? _loadNextWord
                                    : _checkAnswer),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _showResult && _isCorrect == true
                                  ? AppTheme.successGreen
                                  : AppTheme.goldenOrange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                              disabledBackgroundColor: AppTheme.successGreen.withOpacity(0.6),
                            ),
                            child: Text(
                              _showResult && _isCorrect == true
                                  ? 'Correct!'
                                  : (_showResult && _isCorrect == false
                                      ? 'Continue'
                                      : 'Submit'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
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
}

