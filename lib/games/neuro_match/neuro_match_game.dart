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
import '../../utils/error_handler.dart';
import '../../theme/app_theme.dart';
import 'widgets/falling_word_widget.dart';
import 'widgets/target_zone_widget.dart';

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

  late AnimationController _animationController;
  final List<Word> _allWords = [];
  final List<WordMastery> _allMasteries = [];
  final List<Word> _reviewQueue = [];
  
  Word? _currentWord;
  List<Word> _targetWords = [];
  Word? _selectedTarget;
  int _lives = 3;
  int _score = 0;
  double _fallingPosition = 0.0;
  double _difficultyMultiplier = 1.0;
  bool _isGameActive = false;
  bool _isPaused = false;
  DateTime? _wordStartTime;
  DateTime? _gameStartTime;
  String? _gameSessionId;

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
    try {
      final user = _authService.currentUser;
      if (user == null) return;

      // Get active language and load words
      final activeLanguage = await _languageService.getActiveLanguage();
      final words = await _supabaseRepository.getWords(language: activeLanguage);
      
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
        });

        _generateReviewQueue();
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleError(context, e, contextMessage: 'Error loading words');
      }
    }
  }

  void _generateReviewQueue() {
    // Generate SRS review queue
    final reviewMasteries = _srsService.generateReviewQueue(_allMasteries);
    
    // Get words for review, prioritizing Novice → Intermediate → Mastered
    final reviewWords = <Word>[];
    for (final mastery in reviewMasteries) {
      final word = _allWords.firstWhere(
        (w) => w.id == mastery.wordId,
        orElse: () => _allWords.first, // Fallback if word not found
      );
      reviewWords.add(word);
    }

    // If no words in review queue, use all words
    setState(() {
      _reviewQueue.clear();
      _reviewQueue.addAll(
        reviewWords.isNotEmpty ? reviewWords : _allWords.take(20).toList(),
      );
    });
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
    
    setState(() {
      _currentWord = word;
      _targetWords = targets;
      _selectedTarget = null;
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

  void _handleTargetTap(Word target) {
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(isCorrect ? 'Correct!' : 'Wrong!'),
          ],
        ),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(milliseconds: 800),
      ),
    );
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
        builder: (context) => AlertDialog(
          title: const Text('Game Over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Final Score: $_score'),
              const SizedBox(height: 8),
              Text('Lives Remaining: $_lives'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _startGame();
              },
              child: const Text('Play Again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Exit'),
            ),
          ],
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
      appBar: AppBar(
        title: const Text('Neuro-Match'),
        actions: [
          if (_isGameActive)
            IconButton(
              icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
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
        ],
      ),
      body: _isGameActive
          ? Column(
              children: [
                // Score and Lives
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: AppTheme.cardDecoration(),
                  margin: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryMintGreen,
                                      AppTheme.softCyan,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$_score',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Difficulty: ${_difficultyMultiplier.toStringAsFixed(2)}x',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: index < _lives
                                    ? AppTheme.salmonPink.withValues(alpha: 0.15)
                                    : AppTheme.textSecondary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.favorite,
                                color: index < _lives
                                    ? AppTheme.salmonPink
                                    : AppTheme.textSecondary.withValues(alpha: 0.3),
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Game Area
                Expanded(
                  child: Stack(
                    children: [
                      // Target zones at bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 150,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white,
                                AppTheme.softCyan.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, -4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: _targetWords.map((target) {
                              final isMatched = _selectedTarget?.id == target.id &&
                                  target.id == _currentWord?.id;
                              final isWrong = _selectedTarget?.id == target.id &&
                                  target.id != _currentWord?.id;
                              
                              return TargetZoneWidget(
                                targetWord: target,
                                onMatch: () => _handleTargetTap(target),
                                isActive: _currentWord != null && !_isPaused,
                                isMatched: isMatched || isWrong,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      // Falling word
                      if (_currentWord != null && !_isPaused)
                        FallingWordWidget(
                          word: _currentWord!,
                          position: _fallingPosition,
                          onReachedBottom: _handleWordMissed,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Neuro-Match',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Match falling words to their translations',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _reviewQueue.isNotEmpty ? _startGame : null,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Game'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                  if (_reviewQueue.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Loading words...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
