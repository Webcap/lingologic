// ignore_for_file: unused_field, unused_local_variable, unused_element

import 'package:flutter/material.dart';
import '../../models/word.dart';
import '../../models/game_session.dart';
import '../../services/grammar_service_factory.dart';
import '../../services/grammar/grammar_service_base.dart';
import '../../services/srs_service.dart';
import '../../services/dda_service.dart';
import '../../data/remote/supabase_repository.dart';
import '../../services/auth_service.dart';
import '../../services/lesson_service.dart';
import '../../services/language_service.dart';
import '../../utils/error_handler.dart';
import '../../theme/app_theme.dart';

enum GameMode {
  guided,
  expert,
}

class SyntaxConstructorGame extends StatefulWidget {
  const SyntaxConstructorGame({super.key});

  @override
  State<SyntaxConstructorGame> createState() => _SyntaxConstructorGameState();
}

class _SyntaxConstructorGameState extends State<SyntaxConstructorGame>
    with TickerProviderStateMixin {
  GrammarServiceBase? _grammarService;
  final _srsService = SRSService();
  final _ddaService = DDAService();
  final _supabaseRepository = SupabaseRepository();
  final _authService = AuthService();
  final _lessonService = LessonService();
  final _languageService = LanguageService();

  GameMode _mode = GameMode.guided;
  final List<Word> _allWords = [];
  final List<Word> _availableWords = [];
  final List<Word> _sentenceWords = [];
  List<String> _currentTemplate = [];
  WordType? _expectedNextType;
  
  bool _isGameActive = false;
  bool _isValidating = false;
  bool _showSuccessAnimation = false;
  bool _showErrorAnimation = false;
  int _score = 0;
  int _level = 1;
  int _consecutiveCorrect = 0;
  double _complexityMultiplier = 1.0;
  
  DateTime? _sentenceStartTime;
  DateTime? _gameStartTime;
  String? _gameSessionId;
  
  late AnimationController _successController;
  late AnimationController _errorController;
  late AnimationController _snapController;
  late Animation<double> _successAnimation;
  late Animation<double> _errorAnimation;
  late Animation<double> _snapAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation controllers - optimized for 60fps
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _errorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _successAnimation = CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    );
    _errorAnimation = CurvedAnimation(
      parent: _errorController,
      curve: Curves.easeInOut,
    );
    _snapAnimation = CurvedAnimation(
      parent: _snapController,
      curve: Curves.easeOut,
    );
    
    _loadWords();
  }

  Future<void> _loadWords() async {
    try {
      final user = _authService.currentUser;
      if (user == null) return;

      // Get active language and initialize grammar service
      final activeLanguage = await _languageService.getActiveLanguage();
      if (activeLanguage != null) {
        _grammarService = GrammarServiceFactory.getGrammarService(activeLanguage);
      } else {
        // Fallback to Spanish
        _grammarService = GrammarServiceFactory.getGrammarService('spanish');
      }

      // Load words from repository
      final words = await _supabaseRepository.getWords(language: activeLanguage);
      
      // Filter words based on lesson unlocks
      final unlockedWordIds = await _lessonService.getUnlockedWordIds(user.id);
      final filteredWords = words.where((word) {
        // If word is in unlocked list, allow it
        if (unlockedWordIds.contains(word.id)) return true;
        // For MVP, allow all words but prioritize unlocked ones
        return true;
      }).toList();

      if (mounted) {
        setState(() {
          _allWords.addAll(filteredWords);
          _availableWords.addAll(filteredWords);
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleError(context, e, contextMessage: 'Error loading words');
      }
    }
  }

  void _startGame() {
    _ddaService.resetSession();
    _gameStartTime = DateTime.now();
    _gameSessionId = DateTime.now().millisecondsSinceEpoch.toString();
    
    setState(() {
      _isGameActive = true;
      _score = 0;
      _level = 1;
      _consecutiveCorrect = 0;
      _complexityMultiplier = 1.0;
      _sentenceWords.clear();
    });
    
    _generateNewSentence();
  }

  void _generateNewSentence() {
    if (_grammarService == null) return;
    
    // Get sentence template based on difficulty
    final templates = _grammarService!.getSentenceTemplates();
    final templateIndex = (_level - 1) % templates.length;
    final template = templates[templateIndex];
    
    // Adjust complexity based on DDA
    final adjustedTemplate = _adjustTemplateComplexity(template);
    
    // Select words for the sentence
    final selectedWords = <Word>[];
    final availableForSelection = List<Word>.from(_allWords);
    
    for (final category in adjustedTemplate) {
      final wordType = _grammarService!.getWordTypeFromCategory(category);
      if (wordType != null) {
        final matchingWords = availableForSelection.where((w) {
          return _grammarService!.getWordTypeFromCategory(w.category) == wordType;
        }).toList();
        
        if (matchingWords.isNotEmpty) {
          matchingWords.shuffle();
          selectedWords.add(matchingWords.first);
          availableForSelection.remove(matchingWords.first);
        }
      }
    }
    
    // Create word pool with correct words + distractors
    final distractors = <Word>[];
    final usedCategories = adjustedTemplate.toSet();
    
    for (final word in _allWords) {
      if (distractors.length >= 5) break;
      if (!selectedWords.contains(word) && 
          !usedCategories.contains(word.category.toLowerCase())) {
        distractors.add(word);
      }
    }
    
    setState(() {
      _currentTemplate = adjustedTemplate;
      _availableWords.clear();
      _availableWords.addAll(selectedWords);
      _availableWords.addAll(distractors);
      _availableWords.shuffle();
      _sentenceWords.clear();
      _sentenceStartTime = DateTime.now();
      _expectedNextType = adjustedTemplate.isNotEmpty && _grammarService != null
          ? _grammarService!.getWordTypeFromCategory(adjustedTemplate[0])
          : null;
    });
  }

  List<String> _adjustTemplateComplexity(List<String> template) {
    // Increase complexity based on DDA multiplier
    if (_complexityMultiplier >= 1.5 && template.length < 5) {
      // Add adjective or additional words
      if (!template.contains('adjective')) {
        final newTemplate = List<String>.from(template);
        newTemplate.insert(1, 'adjective');
        return newTemplate;
      }
    }
    return template;
  }

  void _addWordToSentence(Word word, int targetIndex) {
    if (_isValidating || _grammarService == null) return;
    
    final wordType = _grammarService!.getWordTypeFromCategory(word.category);
    final expectedType = _sentenceWords.length < _currentTemplate.length
        ? _grammarService!.getWordTypeFromCategory(
            _currentTemplate[_sentenceWords.length],
          )
        : null;
    
    // Check if word type matches expected
    final isValidPlacement = wordType == expectedType;
    
    if (isValidPlacement) {
      setState(() {
        _sentenceWords.add(word);
        _availableWords.remove(word);
        
        // Update expected next type
        if (_sentenceWords.length < _currentTemplate.length) {
          _expectedNextType = _grammarService!.getWordTypeFromCategory(
            _currentTemplate[_sentenceWords.length],
          );
        } else {
          _expectedNextType = null;
        }
      });
      
      // Snap animation
      _snapController.forward(from: 0.0).then((_) {
        _snapController.reverse();
      });
    } else {
      // Error animation
      _errorController.forward(from: 0.0).then((_) {
        _errorController.reverse();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong word type for this position'),
          duration: Duration(milliseconds: 800),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeWordFromSentence(int index) {
    if (_isValidating) return;
    
    setState(() {
      final word = _sentenceWords.removeAt(index);
      _availableWords.add(word);
      _availableWords.shuffle();
      
      // Update expected next type
      if (_sentenceWords.length < _currentTemplate.length) {
        _expectedNextType = _grammarService!.getWordTypeFromCategory(
          _currentTemplate[_sentenceWords.length],
        );
      } else {
        _expectedNextType = null;
      }
    });
  }

  Future<void> _validateSentence() async {
    if (_isValidating || _sentenceWords.isEmpty || _grammarService == null) return;
    
    setState(() {
      _isValidating = true;
    });
    
    final wordTypes = _sentenceWords
        .map((w) => _grammarService!.getWordTypeFromCategory(w.category))
        .whereType<WordType>()
        .toList();
    
    final isValid = _grammarService!.validateSentence(wordTypes);
    final reactionTime = _sentenceStartTime != null
        ? DateTime.now().difference(_sentenceStartTime!).inMilliseconds
        : 5000;
    
    // Record DDA result
    _ddaService.recordResult(
      isCorrect: isValid,
      reactionTimeMs: reactionTime,
    );
    
    if (isValid) {
      // Success animation
      _successController.forward();
      setState(() {
        _showSuccessAnimation = true;
        _score += 10 * _level;
        _consecutiveCorrect++;
        _level++;
      });
      
      // Adjust complexity based on DDA
      setState(() {
        _complexityMultiplier = _ddaService.adjustDifficulty(_complexityMultiplier);
      });
      
      // Update grammar concept mastery (simplified - track as word mastery)
      await _updateGrammarMastery(true);
      
      await Future.delayed(const Duration(milliseconds: 1500));
      
      setState(() {
        _showSuccessAnimation = false;
        _successController.reset();
      });
      
      _generateNewSentence();
    } else {
      // Error animation
      _errorController.forward();
      setState(() {
        _showErrorAnimation = true;
        _consecutiveCorrect = 0;
      });
      
      await _updateGrammarMastery(false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Incorrect sentence structure. Try again!'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      
      await Future.delayed(const Duration(milliseconds: 1000));
      
      setState(() {
        _showErrorAnimation = false;
        _errorController.reset();
      });
    }
    
    setState(() {
      _isValidating = false;
    });
  }

  Future<void> _updateGrammarMastery(bool isCorrect) async {
    // For MVP, we'll track grammar concepts similar to word mastery
    // In a full implementation, you'd have a separate grammar_mastery table
    try {
      final user = _authService.currentUser;
      if (user == null) return;
      
      // Track grammar rule mastery (simplified approach)
      // Quality: 4 = correct, 1 = incorrect
      final quality = isCorrect ? 4 : 1;
      
      // For now, we'll just track that grammar was practiced
      // In a full implementation, you'd update grammar concept mastery
    } catch (e) {
      // Handle error
    }
  }

  List<String> _getHints() {
    if (_mode != GameMode.guided || _grammarService == null) return [];
    
    final hints = <String>[];
    final currentTypes = _sentenceWords
        .map((w) => _grammarService!.getWordTypeFromCategory(w.category))
        .whereType<WordType>()
        .toList();
    
    if (_expectedNextType != null) {
      switch (_expectedNextType!) {
        case WordType.article:
          hints.add('Next: Add an article (el, la, un, una)');
          break;
        case WordType.noun:
          hints.add('Next: Add a noun (subject or object)');
          break;
        case WordType.verb:
          hints.add('Next: Add a verb');
          break;
        case WordType.adjective:
          hints.add('Next: Add an adjective');
          break;
        default:
          break;
      }
    }
    
    // Add grammar hints
    hints.addAll(_grammarService!.generateHints(currentTypes));
    
    return hints;
  }

  Color? _getWordTypeColor(Word word) {
    if (_mode != GameMode.guided || _grammarService == null) return null;
    
    final wordType = _grammarService!.getWordTypeFromCategory(word.category);
    if (wordType == _expectedNextType) {
      return Colors.amber.shade200; // Highlight expected type
    }
    
    return null;
  }

  Future<void> _endGame() async {
    if (_gameStartTime != null && _gameSessionId != null) {
      try {
        final user = _authService.currentUser;
        if (user != null) {
          final activeLanguage = await _languageService.getActiveLanguage();
          final session = GameSession(
            userId: user.id,
            gameType: GameType.syntaxConstructor,
            startTime: _gameStartTime!,
            endTime: DateTime.now(),
            score: _score,
            difficultyLevel: _complexityMultiplier.toStringAsFixed(2),
            language: activeLanguage,
          );
          
          await _supabaseRepository.createGameSession(session);
        }
      } catch (e) {
        // Handle error
      }
    }
    
    setState(() {
      _isGameActive = false;
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
              Text('Level Reached: $_level'),
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
    _successController.dispose();
    _errorController.dispose();
    _snapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syntax Constructor'),
        actions: [
          if (!_isGameActive)
            PopupMenuButton<GameMode>(
              icon: const Icon(Icons.settings),
              onSelected: (mode) {
                setState(() {
                  _mode = mode;
                });
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: GameMode.guided,
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: _mode == GameMode.guided
                            ? Colors.amber
                            : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      const Text('Guided Mode'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: GameMode.expert,
                  child: Row(
                    children: [
                      Icon(
                        Icons.school,
                        color: _mode == GameMode.expert
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      const Text('Expert Mode'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _isGameActive
          ? Column(
              children: [
                // Score and Level
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
                                      AppTheme.softCyan,
                                      AppTheme.electricLavender,
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
                            'Level: $_level | Complexity: ${_complexityMultiplier.toStringAsFixed(2)}x',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (_mode == GameMode.guided)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.goldenOrange,
                                AppTheme.goldenOrange.withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.lightbulb, size: 16, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Guided',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                // Hints (Guided mode)
                if (_mode == GameMode.guided && _getHints().isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _getHints().map((hint) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppTheme.goldenOrange.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.lightbulb_outline,
                                  size: 16,
                                  color: AppTheme.goldenOrange,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  hint,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                // Sentence construction area (Bridge)
                Expanded(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _successAnimation,
                      _errorAnimation,
                      _snapAnimation,
                    ]),
                    builder: (context, child) {
                      Color borderColor = Colors.blue;
                      Color backgroundColor = Colors.white;
                      
                      if (_showSuccessAnimation) {
                        borderColor = Colors.green;
                        backgroundColor = Colors.green.shade50;
                      } else if (_showErrorAnimation) {
                        borderColor = Colors.red;
                        backgroundColor = Colors.red.shade50;
                      }
                      
                      return Transform.scale(
                        scale: _snapAnimation.value * 0.05 + 1.0,
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            border: Border.all(
                              color: borderColor,
                              width: 2 + (_successAnimation.value * 2),
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: borderColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: _successAnimation.value * 4,
                              ),
                            ],
                          ),
                              child: _sentenceWords.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: AppTheme.textSecondary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Icon(
                                          Icons.construction,
                                          size: 48,
                                          color: AppTheme.textSecondary.withValues(alpha: 0.5),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Build your sentence here',
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: List.generate(
                                    _sentenceWords.length,
                                    (index) => GestureDetector(
                                      onTap: () => _removeWordFromSentence(index),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppTheme.softCyan,
                                              AppTheme.electricLavender,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.softCyan.withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              _sentenceWords[index].wordText,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(alpha: 0.3),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
                // Available words
                Container(
                  height: 120,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        AppTheme.electricLavender.withValues(alpha: 0.1),
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
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _availableWords.length,
                    itemBuilder: (context, index) {
                      final word = _availableWords[index];
                      final highlightColor = _getWordTypeColor(word);
                      
                      return DragTarget<Word>(
                        onAcceptWithDetails: (details) {
                          _addWordToSentence(word, index);
                        },
                        builder: (context, candidateData, rejectedData) {
                          final isDraggingOver = candidateData.isNotEmpty;
                          
                          return Draggable<Word>(
                            data: word,
                            feedback: Material(
                              elevation: 8,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade600,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  word.wordText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: highlightColor != null
                                    ? LinearGradient(
                                        colors: [
                                          AppTheme.goldenOrange,
                                          AppTheme.goldenOrange.withValues(alpha: 0.7),
                                        ],
                                      )
                                    : LinearGradient(
                                        colors: [
                                          AppTheme.primaryMintGreen,
                                          AppTheme.primaryMintGreen.withValues(alpha: 0.8),
                                        ],
                                      ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isDraggingOver
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: isDraggingOver ? 3 : 0,
                                ),
                                boxShadow: isDraggingOver
                                    ? [
                                        BoxShadow(
                                          color: (highlightColor ?? AppTheme.primaryMintGreen)
                                              .withValues(alpha: 0.5),
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : [
                                        BoxShadow(
                                          color: (highlightColor ?? AppTheme.primaryMintGreen)
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    word.wordText,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (_mode == GameMode.guided)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        word.category,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                // Validate button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: _sentenceWords.isNotEmpty && !_isValidating
                        ? AppTheme.pillDecoration(AppTheme.primaryMintGreen)
                        : null,
                    child: ElevatedButton.icon(
                      onPressed: _sentenceWords.isNotEmpty && !_isValidating
                          ? _validateSentence
                          : null,
                      icon: _isValidating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.check_circle),
                      label: Text(
                        _isValidating ? 'Validating...' : 'Validate Sentence',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _sentenceWords.isNotEmpty && !_isValidating
                            ? Colors.transparent
                            : null,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        minimumSize: const Size(double.infinity, 56),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.mainGradient,
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: AppTheme.cardDecoration(),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.softCyan,
                                    AppTheme.electricLavender,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.construction,
                                size: 64,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Syntax Constructor',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _mode == GameMode.guided
                                  ? 'Build sentences with helpful hints'
                                  : 'Build sentences without hints',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            Container(
                              decoration: AppTheme.pillDecoration(
                                AppTheme.primaryMintGreen,
                              ),
                              child: ElevatedButton.icon(
                                onPressed: _allWords.isNotEmpty ? _startGame : null,
                                icon: const Icon(Icons.play_arrow),
                                label: const Text(
                                  'Start Game',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                ),
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
