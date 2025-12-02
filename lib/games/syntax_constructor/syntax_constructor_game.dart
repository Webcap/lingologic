import 'package:flutter/material.dart';
import '../../models/word.dart';
import '../../models/game_session.dart';
import '../../services/grammar_service.dart';
import '../../services/srs_service.dart';
import '../../services/dda_service.dart';
import '../../data/remote/supabase_repository.dart';
import '../../services/auth_service.dart';
import '../../utils/error_handler.dart';
import '../../data/seed/spanish_grammar_rules.dart';

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
  final _grammarService = GrammarService();
  final _srsService = SRSService();
  final _ddaService = DDAService();
  final _supabaseRepository = SupabaseRepository();
  final _authService = AuthService();

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
      final words = await _supabaseRepository.getWords(language: 'es');
      if (mounted) {
        setState(() {
          _allWords.addAll(words);
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
    // Get sentence template based on difficulty
    final templates = SpanishGrammarRules.getSentenceTemplates();
    final templateIndex = (_level - 1) % templates.length;
    final template = templates[templateIndex];
    
    // Adjust complexity based on DDA
    final adjustedTemplate = _adjustTemplateComplexity(template);
    
    // Select words for the sentence
    final selectedWords = <Word>[];
    final availableForSelection = List<Word>.from(_allWords);
    
    for (final category in adjustedTemplate) {
      final wordType = _grammarService.getWordTypeFromCategory(category);
      if (wordType != null) {
        final matchingWords = availableForSelection.where((w) {
          return _grammarService.getWordTypeFromCategory(w.category) == wordType;
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
      _expectedNextType = adjustedTemplate.isNotEmpty
          ? _grammarService.getWordTypeFromCategory(adjustedTemplate[0])
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
    if (_isValidating) return;
    
    final wordType = _grammarService.getWordTypeFromCategory(word.category);
    final expectedType = _sentenceWords.length < _currentTemplate.length
        ? _grammarService.getWordTypeFromCategory(
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
          _expectedNextType = _grammarService.getWordTypeFromCategory(
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
        _expectedNextType = _grammarService.getWordTypeFromCategory(
          _currentTemplate[_sentenceWords.length],
        );
      } else {
        _expectedNextType = null;
      }
    });
  }

  Future<void> _validateSentence() async {
    if (_isValidating || _sentenceWords.isEmpty) return;
    
    setState(() {
      _isValidating = true;
    });
    
    final wordTypes = _sentenceWords
        .map((w) => _grammarService.getWordTypeFromCategory(w.category))
        .whereType<WordType>()
        .toList();
    
    final isValid = _grammarService.validateSentence(wordTypes);
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
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Incorrect sentence structure. Try again!'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      
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
    if (_mode != GameMode.guided) return [];
    
    final hints = <String>[];
    final currentTypes = _sentenceWords
        .map((w) => _grammarService.getWordTypeFromCategory(w.category))
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
    hints.addAll(_grammarService.generateHints(currentTypes));
    
    return hints;
  }

  Color? _getWordTypeColor(Word word) {
    if (_mode != GameMode.guided) return null;
    
    final wordType = _grammarService.getWordTypeFromCategory(word.category);
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
          final session = GameSession(
            userId: user.id,
            gameType: GameType.syntaxConstructor,
            startTime: _gameStartTime!,
            endTime: DateTime.now(),
            score: _score,
            difficultyLevel: _complexityMultiplier.toStringAsFixed(2),
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
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Score: $_score',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Level: $_level | Complexity: ${_complexityMultiplier.toStringAsFixed(2)}x',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
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
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lightbulb, size: 16, color: Colors.amber.shade800),
                              const SizedBox(width: 4),
                              Text(
                                'Guided',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.amber.shade800,
                                  fontWeight: FontWeight.bold,
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
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Icon(Icons.lightbulb_outline,
                                  size: 16, color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  hint,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue.shade900,
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
                                      Icon(
                                        Icons.construction,
                                        size: 48,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Build your sentence here',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 16,
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
                                          color: Colors.blue.shade100,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.blue.shade300,
                                            width: 2,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              _sentenceWords[index].wordText,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Icon(
                                              Icons.close,
                                              size: 16,
                                              color: Colors.grey.shade600,
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
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
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
                                color: highlightColor ?? Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDraggingOver
                                      ? Colors.green.shade600
                                      : Colors.green.shade300,
                                  width: isDraggingOver ? 3 : 2,
                                ),
                                boxShadow: isDraggingOver
                                    ? [
                                        BoxShadow(
                                          color: Colors.green.withOpacity(0.3),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    word.wordText,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  if (_mode == GameMode.guided)
                                    Text(
                                      word.category,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade600,
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
                  child: ElevatedButton.icon(
                    onPressed: _sentenceWords.isNotEmpty && !_isValidating
                        ? _validateSentence
                        : null,
                    icon: _isValidating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_circle),
                    label: Text(_isValidating ? 'Validating...' : 'Validate Sentence'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Syntax Constructor',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _mode == GameMode.guided
                        ? 'Build sentences with helpful hints'
                        : 'Build sentences without hints',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _allWords.isNotEmpty ? _startGame : null,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Game'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
