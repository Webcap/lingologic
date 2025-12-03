import 'package:flutter/material.dart';
import '../../models/word.dart';
import '../../models/word_mastery.dart';
import '../../models/game_session.dart';
import '../../services/srs_service.dart';
import '../../services/dda_service.dart';
import '../../data/remote/supabase_repository.dart';
import '../../services/auth_service.dart';
import '../../services/lesson_service.dart';
import '../../services/language_service.dart';
import '../../services/user_service.dart';
import '../../utils/error_handler.dart';
import '../../theme/app_theme.dart';
import 'widgets/falling_word_widget.dart';
import 'widgets/target_zone_widget.dart';

// Helper to map language name to language code used in database
String? _mapLanguageToCode(String? language) {
  if (language == null) return null;
  switch (language.toLowerCase()) {
    case 'spanish':
      return 'es';
    case 'french':
      return 'fr';
    default:
      return language; // Return as-is if already a code
  }
}

class NeuroMatchGame extends StatefulWidget {
  const NeuroMatchGame({super.key});

  @override
  State<NeuroMatchGame> createState() => _NeuroMatchGameState();
}

class _NeuroMatchGameState extends State<NeuroMatchGame>
    with SingleTickerProviderStateMixin {
  final _srsService = SRSService();
  final _ddaService = DDAService();
  final _supabaseRepository = SupabaseRepository();
  final _authService = AuthService();
  final _lessonService = LessonService();
  final _languageService = LanguageService();
  final _userService = UserService();

  late AnimationController _animationController;
  final List<Word> _allWords = [];
  final List<WordMastery> _allMasteries = [];
  final List<Word> _reviewQueue = [];
  
  Word? _currentWord;
  List<Word> _targetWords = [];
  Word? _selectedTarget;
  Word? _hoveredTarget; // Target currently being swiped over
  int _lives = 3;
  int _score = 0;
  double _fallingPosition = 0.0;
  double _difficultyMultiplier = 1.0;
  bool _isGameActive = false;
  bool _isPaused = false;
  bool _isLoadingWords = true;
  String? _loadingError;
  DateTime? _wordStartTime;
  DateTime? _gameStartTime;
  String? _gameSessionId;
  final Map<Word, GlobalKey> _targetKeys = {}; // Keys for target zones to get their positions

  @override
  void initState() {
    super.initState();
    // Use vsync for 60fps animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(_updateFallingPosition);
    
    _loadWordsAndMasteries();
  }

  void _updateFallingPosition() {
    if (!_isPaused && _isGameActive && mounted) {
      // Use setState only when necessary to maintain 60fps
      final newPosition = _animationController.value;
      if ((newPosition - _fallingPosition).abs() > 0.01) {
        setState(() {
          _fallingPosition = newPosition;
        });
      }
      
      // Check if word reached bottom without being matched
      if (newPosition >= 0.95 && _currentWord != null) {
        _handleWordMissed();
      }
    }
  }

  Future<void> _loadWordsAndMasteries() async {
    if (mounted) {
      setState(() {
        _isLoadingWords = true;
        _loadingError = null;
      });
    }
    
    try {
      final user = _authService.currentUser;
      if (user == null) {
        if (mounted) {
          setState(() {
            _isLoadingWords = false;
            _loadingError = 'Please log in to play';
          });
        }
        return;
      }

      // Get active language and load words
      var activeLanguage = await _languageService.getActiveLanguage();
      
      // If no active language, initialize default (Spanish)
      if (activeLanguage == null) {
        debugPrint('No active language found, initializing default...');
        await _languageService.initializeDefaultLanguage();
        activeLanguage = await _languageService.getActiveLanguage();
        debugPrint('Active language set to: $activeLanguage');
      }
      
      // Map language name to language code (e.g., 'spanish' -> 'es')
      final languageCode = _mapLanguageToCode(activeLanguage);
      
      // Try with language code first, then fallback to language name, then no filter
      List<Word> words = [];
      try {
        // First try with mapped language code
        if (languageCode != null) {
          words = await _supabaseRepository.getWords(language: languageCode);
          debugPrint('Loaded ${words.length} words with language code: $languageCode');
        }
        
        // If no words found with code, try with language name
        if (words.isEmpty && activeLanguage != null && languageCode != activeLanguage) {
          words = await _supabaseRepository.getWords(language: activeLanguage);
          debugPrint('Loaded ${words.length} words with language name: $activeLanguage');
        }
        
        // Final fallback: load all words if still empty
        if (words.isEmpty) {
          words = await _supabaseRepository.getWords();
          debugPrint('Loaded ${words.length} words without language filter (fallback)');
        }
      } catch (e) {
        debugPrint('Error loading words: $e');
        // Try one more time without filter as last resort
        try {
          words = await _supabaseRepository.getWords();
        } catch (e2) {
          debugPrint('Final fallback also failed: $e2');
          rethrow;
        }
      }
      
      // Get masteries and filter by active language words
      final allMasteries = await _supabaseRepository.getWordMasteries(user.id);
      final wordIds = words.map((w) => w.id).toSet();
      final masteries = allMasteries.where((m) => wordIds.contains(m.wordId)).toList();
      
      // Filter words based on lesson unlocks
      final unlockedWordIds = await _lessonService.getUnlockedWordIds(user.id);
      final filteredWords = words.where((word) {
        // If word is in unlocked list, allow it
        if (unlockedWordIds.contains(word.id)) return true;
        // If word is not in any lesson's unlock list, allow it (backward compatibility)
        // In production, you might want to require all words to be unlocked
        return true; // For MVP, allow all words but prioritize unlocked ones
      }).toList();

      if (mounted) {
        setState(() {
          _allWords.addAll(filteredWords);
          _allMasteries.addAll(masteries);
          _isLoadingWords = false;
        });

        _generateReviewQueue();
        
        // If still no words, show helpful message
        if (_reviewQueue.isEmpty && _allWords.isEmpty) {
          debugPrint('No words loaded. Total words: ${words.length}, Filtered: ${filteredWords.length}');
          if (mounted) {
            setState(() {
              _loadingError = 'No words available. Please complete a lesson first.';
            });
          }
        } else if (_reviewQueue.isEmpty) {
          debugPrint('Review queue is empty but words exist: ${_allWords.length}');
        }
      }
    } catch (e) {
      debugPrint('Error in _loadWordsAndMasteries: $e');
      if (mounted) {
        setState(() {
          _isLoadingWords = false;
          _loadingError = 'Unable to load words. Tap to retry.';
        });
      }
    }
  }

  void _generateReviewQueue() {
    // If no words available, queue stays empty
    if (_allWords.isEmpty) {
      setState(() {
        _reviewQueue.clear();
      });
      return;
    }
    
    // Generate SRS review queue
    final reviewMasteries = _srsService.generateReviewQueue(_allMasteries);
    
    // Get words for review, prioritizing Novice → Intermediate → Mastered
    final reviewWords = <Word>[];
    for (final mastery in reviewMasteries) {
      try {
        final word = _allWords.firstWhere(
          (w) => w.id == mastery.wordId,
        );
        reviewWords.add(word);
      } catch (e) {
        // Word not found, skip this mastery
        debugPrint('Word not found for mastery: ${mastery.wordId}');
      }
    }

    // If no words in review queue, use all words (or first 20 if many)
    setState(() {
      _reviewQueue.clear();
      if (reviewWords.isNotEmpty) {
        _reviewQueue.addAll(reviewWords);
      } else if (_allWords.isNotEmpty) {
        _reviewQueue.addAll(_allWords.take(20).toList());
      }
    });
    
    debugPrint('Generated review queue: ${_reviewQueue.length} words');
  }

  void _startGame() {
    _ddaService.resetSession();
    _gameStartTime = DateTime.now();
    _gameSessionId = DateTime.now().millisecondsSinceEpoch.toString();
    
    setState(() {
      _isGameActive = true;
      _isPaused = false;
      _lives = 3;
      _score = 0;
      _difficultyMultiplier = 1.0;
      _fallingPosition = 0.0;
    });
    
    _nextWord();
  }

  void _nextWord() {
    if (_reviewQueue.isEmpty) {
      _generateReviewQueue();
      if (_reviewQueue.isEmpty) {
        _endGame();
        return;
      }
    }

    // Get next word from review queue
    final word = _reviewQueue.removeAt(0);
    
    // Create 3-4 target options (1 correct + 2-3 distractors)
    final distractors = _allWords
        .where((w) => w.id != word.id && w.category == word.category)
        .take(3)
        .toList();
    
    final targets = [word, ...distractors]..shuffle();
    
    // Create keys for target zones
    _targetKeys.clear();
    for (final target in targets) {
      _targetKeys[target] = GlobalKey();
    }
    
    setState(() {
      _currentWord = word;
      _targetWords = targets;
      _selectedTarget = null;
      _hoveredTarget = null;
      _fallingPosition = 0.0;
      _wordStartTime = DateTime.now();
    });

    // Adjust animation duration based on DDA
    final baseDuration = 5.0; // seconds
    final adjustedDuration = baseDuration / _difficultyMultiplier;
    
    _animationController.duration = Duration(
      milliseconds: (adjustedDuration * 1000).round(),
    );
    
    _animationController.reset();
    _animationController.forward();
  }

  void _handleSwipeUpdate(Offset globalPosition) {
    if (_isPaused || _currentWord == null) return;
    
    // Find which target zone the swipe position is over
    Word? hoveredTarget;
    for (final target in _targetWords) {
      final key = _targetKeys[target];
      if (key?.currentContext != null) {
        final RenderBox? renderBox = key!.currentContext!.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final targetPosition = renderBox.localToGlobal(Offset.zero);
          final targetSize = renderBox.size;
          
          // Check if swipe position is within target bounds
          if (globalPosition.dx >= targetPosition.dx &&
              globalPosition.dx <= targetPosition.dx + targetSize.width &&
              globalPosition.dy >= targetPosition.dy &&
              globalPosition.dy <= targetPosition.dy + targetSize.height) {
            hoveredTarget = target;
            break;
          }
        }
      }
    }
    
    if (hoveredTarget != _hoveredTarget) {
      setState(() {
        _hoveredTarget = hoveredTarget;
      });
    }
  }

  void _handleSwipeEnd(Offset globalPosition) {
    if (_isPaused || _currentWord == null) return;
    
    // Find which target zone the swipe ended over
    Word? matchedTarget;
    for (final target in _targetWords) {
      final key = _targetKeys[target];
      if (key?.currentContext != null) {
        final RenderBox? renderBox = key!.currentContext!.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final targetPosition = renderBox.localToGlobal(Offset.zero);
          final targetSize = renderBox.size;
          
          // Check if swipe end position is within target bounds
          if (globalPosition.dx >= targetPosition.dx &&
              globalPosition.dx <= targetPosition.dx + targetSize.width &&
              globalPosition.dy >= targetPosition.dy &&
              globalPosition.dy <= targetPosition.dy + targetSize.height) {
            matchedTarget = target;
            break;
          }
        }
      }
    }
    
    if (matchedTarget != null) {
      _handleTargetMatch(matchedTarget);
    }
    
    setState(() {
      _hoveredTarget = null;
    });
  }

  void _handleTargetMatch(Word target) {
    if (_isPaused || _currentWord == null) return;
    
    setState(() {
      _selectedTarget = target;
    });

    final isCorrect = target.id == _currentWord!.id;
    final reactionTime = _wordStartTime != null
        ? DateTime.now().difference(_wordStartTime!).inMilliseconds
        : 2000;

    _ddaService.recordResult(
      isCorrect: isCorrect,
      reactionTimeMs: reactionTime,
    );

    _animationController.stop();

    // Update SRS mastery
    _updateWordMastery(isCorrect ? 4 : 1); // Quality: 4 = good, 1 = poor

    // Show feedback
    _showMatchFeedback(isCorrect);

    // Adjust difficulty
    setState(() {
      _difficultyMultiplier = _ddaService.adjustDifficulty(_difficultyMultiplier);
    });

    if (isCorrect) {
      setState(() {
        _score += 10;
      });
    } else {
      setState(() {
        _lives--;
      });
    }

    // Continue game after feedback
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted && _isGameActive) {
        if (_lives <= 0) {
          _endGame();
        } else {
          _nextWord();
        }
      }
    });
  }

  // Keep for backward compatibility, but redirect to swipe handler
  void _handleTargetTap(Word target) {
    _handleTargetMatch(target);
  }

  void _handleWordMissed() {
    if (_currentWord == null) return;
    
    _animationController.stop();
    _ddaService.recordResult(
      isCorrect: false,
      reactionTimeMs: 5000, // Timeout
    );

    _updateWordMastery(0); // Quality: 0 = complete blackout

    setState(() {
      _lives--;
    });

    if (_lives <= 0) {
      _endGame();
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && _isGameActive) {
          _nextWord();
        }
      });
    }
  }

  Future<void> _updateWordMastery(int quality) async {
    try {
      final user = _authService.currentUser;
      if (user == null || _currentWord == null) return;

      // Find existing mastery or create new one
      var mastery = _allMasteries.firstWhere(
        (m) => m.wordId == _currentWord!.id,
        orElse: () => _srsService.createInitialMastery(
          userId: user.id,
          wordId: _currentWord!.id,
        ),
      );

      // Update mastery using SRS algorithm
      mastery = _srsService.updateMastery(mastery, quality);

      // Update local list
      final index = _allMasteries.indexWhere((m) => m.wordId == mastery.wordId);
      if (index >= 0) {
        _allMasteries[index] = mastery;
      } else {
        _allMasteries.add(mastery);
      }

      // Save to Supabase
      await _supabaseRepository.upsertWordMastery(mastery);
    } catch (e) {
      // Handle error silently - mastery will be synced later
      if (mounted) {
        ErrorHandler.handleError(context, e, contextMessage: 'Error updating mastery');
      }
    }
  }

  void _showMatchFeedback(bool isCorrect) {
    // Show animated feedback overlay
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (context) => _MatchFeedbackOverlay(isCorrect: isCorrect),
    );
    
    // Auto-dismiss after animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  Future<void> _endGame() async {
    _animationController.stop();
    
    if (_gameStartTime != null && _gameSessionId != null) {
      try {
        final user = _authService.currentUser;
        if (user != null) {
          final activeLanguage = await _languageService.getActiveLanguage();
          final session = GameSession(
            userId: user.id,
            gameType: GameType.neuroMatch,
            startTime: _gameStartTime!,
            endTime: DateTime.now(),
            score: _score,
            difficultyLevel: _difficultyMultiplier.toStringAsFixed(2),
            language: activeLanguage,
          );
          
          await _supabaseRepository.createGameSession(session);
          
          // Update streaks (both user profile and language-specific)
          await _userService.updateStreak();
          if (activeLanguage != null) {
            await _languageService.updateLanguageStreak(activeLanguage);
          }
        }
      } catch (e) {
        // Handle error
        print('Error saving game session: $e');
      }
    }

    setState(() {
      _isGameActive = false;
      _isPaused = false;
    });

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _GameOverDialog(
          score: _score,
          lives: _lives,
          onPlayAgain: () {
            Navigator.pop(context);
            _startGame();
          },
          onExit: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Neuro-Match',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_isGameActive)
            Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  color: AppTheme.primaryMintGreen,
                ),
                onPressed: () {
                  setState(() {
                    _isPaused = !_isPaused;
                  });
                  if (_isPaused) {
                    _animationController.stop();
                  } else {
                    _animationController.forward();
                  }
                },
              ),
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.mainGradient,
        ),
        child: _isGameActive
            ? Column(
                children: [
                  const SizedBox(height: 100), // Space for app bar
                  // Modern Score and Lives Display
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Score
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppTheme.primaryMintGreen,
                                    AppTheme.softCyan,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryMintGreen.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.star_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$_score',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Score',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Lives
                        Row(
                          children: [
                            ...List.generate(3, (index) {
                              return Container(
                                margin: const EdgeInsets.only(left: 6),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: index < _lives
                                      ? AppTheme.salmonPink.withValues(alpha: 0.15)
                                      : Colors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.favorite_rounded,
                                  color: index < _lives
                                      ? AppTheme.salmonPink
                                      : Colors.grey.shade400,
                                  size: 20,
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Game Area
                  Expanded(
                    child: Stack(
                      children: [
                        // Background pattern or decoration
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  AppTheme.softCyan.withValues(alpha: 0.05),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Target zones at bottom
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 200,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 30,
                                  offset: const Offset(0, -8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Swipe the word to match',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: Row(
                                    children: _targetWords.map((target) {
                                      final isMatched = _selectedTarget?.id == target.id &&
                                          target.id == _currentWord?.id;
                                      final isWrong = _selectedTarget?.id == target.id &&
                                          target.id != _currentWord?.id;
                                      final isHovered = _hoveredTarget?.id == target.id;
                                      
                                      return TargetZoneWidget(
                                        key: _targetKeys[target],
                                        targetWord: target,
                                        onMatch: () => _handleTargetTap(target),
                                        isActive: _currentWord != null && !_isPaused,
                                        isMatched: isMatched || isWrong,
                                        isHovered: isHovered,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Falling word
                        if (_currentWord != null && !_isPaused)
                          FallingWordWidget(
                            word: _currentWord!,
                            position: _fallingPosition,
                            onReachedBottom: _handleWordMissed,
                            onSwipeUpdate: _handleSwipeUpdate,
                            onSwipeEnd: _handleSwipeEnd,
                            onTap: () {
                              // Allow tapping the falling word to pause/select
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Game Icon/Logo
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppTheme.primaryMintGreen,
                            AppTheme.softCyan,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryMintGreen.withValues(alpha: 0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Neuro-Match',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Swipe falling words to match\nthem with their translations',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppTheme.primaryMintGreen,
                            AppTheme.softCyan,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryMintGreen.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _reviewQueue.isNotEmpty ? _startGame : null,
                        icon: const Icon(Icons.play_arrow_rounded, size: 28),
                        label: const Text(
                          'Start Game',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                      ),
                    ),
                    if (_isLoadingWords)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryMintGreen,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Loading words...',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (_loadingError != null || _reviewQueue.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppTheme.textSecondary,
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _loadingError ?? 'No words available',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: _loadWordsAndMasteries,
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Retry'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.primaryMintGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

// Match Feedback Overlay Widget
class _MatchFeedbackOverlay extends StatefulWidget {
  final bool isCorrect;

  const _MatchFeedbackOverlay({required this.isCorrect});

  @override
  State<_MatchFeedbackOverlay> createState() => _MatchFeedbackOverlayState();
}

class _MatchFeedbackOverlayState extends State<_MatchFeedbackOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Center(
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                decoration: BoxDecoration(
                  color: widget.isCorrect
                      ? AppTheme.successGreen
                      : AppTheme.salmonPink,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: (widget.isCorrect
                              ? AppTheme.successGreen
                              : AppTheme.salmonPink)
                          .withValues(alpha: 0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.isCorrect
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.isCorrect ? 'Correct!' : 'Wrong!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Game Over Dialog Widget
class _GameOverDialog extends StatelessWidget {
  final int score;
  final int lives;
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;

  const _GameOverDialog({
    required this.score,
    required this.lives,
    required this.onPlayAgain,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppTheme.primaryMintGreen,
                    AppTheme.softCyan,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Game Over!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryMintGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppTheme.primaryMintGreen,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$score',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Final Score',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onExit,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Exit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPlayAgain,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryMintGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Play Again',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

