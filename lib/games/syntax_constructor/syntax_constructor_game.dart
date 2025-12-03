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
import '../../services/user_service.dart';
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
  final _userService = UserService();

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
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _successAnimation;
  late Animation<double> _errorAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation controllers
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _errorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    
    _successAnimation = CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    );
    _errorAnimation = CurvedAnimation(
      parent: _errorController,
      curve: Curves.easeInOut,
    );
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
    _shimmerAnimation = CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    );
    
    _loadWords();
  }

  Future<void> _loadWords() async {
    try {
      final user = _authService.currentUser;
      if (user == null) return;

      final activeLanguage = await _languageService.getActiveLanguage();
      if (activeLanguage != null) {
        _grammarService = GrammarServiceFactory.getGrammarService(activeLanguage);
      } else {
        _grammarService = GrammarServiceFactory.getGrammarService('spanish');
      }

      final words = await _supabaseRepository.getWords(language: activeLanguage);
      final unlockedWordIds = await _lessonService.getUnlockedWordIds(user.id);
      final filteredWords = words.where((word) {
        if (unlockedWordIds.contains(word.id)) return true;
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
    
    final templates = _grammarService!.getSentenceTemplates();
    final templateIndex = (_level - 1) % templates.length;
    final template = templates[templateIndex];
    final adjustedTemplate = _adjustTemplateComplexity(template);
    
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
    if (_complexityMultiplier >= 1.5 && template.length < 5) {
      if (!template.contains('adjective')) {
        final newTemplate = List<String>.from(template);
        newTemplate.insert(1, 'adjective');
        return newTemplate;
      }
    }
    return template;
  }

  void _addWordToSentence(Word word) {
    if (_isValidating || _grammarService == null) return;
    
    final wordType = _grammarService!.getWordTypeFromCategory(word.category);
    final expectedType = _sentenceWords.length < _currentTemplate.length
        ? _grammarService!.getWordTypeFromCategory(
            _currentTemplate[_sentenceWords.length],
          )
        : null;
    
    final isValidPlacement = wordType == expectedType;
    
    if (isValidPlacement) {
      setState(() {
        _sentenceWords.add(word);
        _availableWords.remove(word);
        
        if (_sentenceWords.length < _currentTemplate.length) {
          _expectedNextType = _grammarService!.getWordTypeFromCategory(
            _currentTemplate[_sentenceWords.length],
          );
        } else {
          _expectedNextType = null;
        }
      });
      
      // Haptic feedback would go here
    } else {
      _errorController.forward(from: 0.0).then((_) {
        _errorController.reverse();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Wrong word type for this position'),
            ],
          ),
          duration: const Duration(milliseconds: 1000),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    
    _ddaService.recordResult(
      isCorrect: isValid,
      reactionTimeMs: reactionTime,
    );
    
    if (isValid) {
      _successController.forward();
      setState(() {
        _showSuccessAnimation = true;
        _score += 10 * _level;
        _consecutiveCorrect++;
        _level++;
      });
      
      setState(() {
        _complexityMultiplier = _ddaService.adjustDifficulty(_complexityMultiplier);
      });
      
      await _updateGrammarMastery(true);
      
      await Future.delayed(const Duration(milliseconds: 1500));
      
      setState(() {
        _showSuccessAnimation = false;
        _successController.reset();
      });
      
      _generateNewSentence();
    } else {
      _errorController.forward();
      setState(() {
        _showErrorAnimation = true;
        _consecutiveCorrect = 0;
      });
      
      await _updateGrammarMastery(false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.close, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Incorrect sentence structure. Try again!'),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    try {
      final user = _authService.currentUser;
      if (user == null) return;
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
    
    hints.addAll(_grammarService!.generateHints(currentTypes));
    
    return hints;
  }

  Color? _getWordTypeColor(Word word) {
    if (_mode != GameMode.guided || _grammarService == null) return null;
    
    final wordType = _grammarService!.getWordTypeFromCategory(word.category);
    if (wordType == _expectedNextType) {
      return AppTheme.goldenOrange;
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
          await _userService.updateStreak();
          if (activeLanguage != null) {
            await _languageService.updateLanguageStreak(activeLanguage);
          }
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
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryMintGreen, AppTheme.softCyan],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.celebration, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Game Complete!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.electricLavender.withOpacity(0.1),
                      AppTheme.softCyan.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      '$_score',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryMintGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('Level', '$_level', Icons.trending_up),
                  _buildStatItem('Streak', '$_consecutiveCorrect', Icons.local_fire_department),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Exit'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _startGame();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryMintGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Play Again'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.electricLavender, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _successController.dispose();
    _errorController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.mainGradient,
        ),
        child: _isGameActive ? _buildGameView() : _buildStartScreen(),
      ),
    );
  }

  Widget _buildStartScreen() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Game Icon
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.softCyan, AppTheme.electricLavender],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.electricLavender.withOpacity(0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.construction_rounded,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              
              // Title
              Text(
                'Syntax Constructor',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              
              // Description
              Text(
                _mode == GameMode.guided
                    ? 'Build sentences with helpful hints'
                    : 'Build sentences without hints',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Mode Selector
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.cardWhite.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildModeButton(
                        mode: GameMode.guided,
                        icon: Icons.lightbulb_rounded,
                        label: 'Guided',
                        isSelected: _mode == GameMode.guided,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildModeButton(
                        mode: GameMode.expert,
                        icon: Icons.school_rounded,
                        label: 'Expert',
                        isSelected: _mode == GameMode.expert,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Start Button
              Container(
                decoration: AppTheme.pillDecoration(AppTheme.primaryMintGreen),
                child: ElevatedButton.icon(
                  onPressed: _allWords.isNotEmpty ? _startGame : null,
                  icon: const Icon(Icons.play_arrow_rounded, size: 24),
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
                    minimumSize: const Size(double.infinity, 64),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton({
    required GameMode mode,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _mode = mode;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppTheme.goldenOrange, AppTheme.goldenOrange.withOpacity(0.8)],
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppTheme.textSecondary,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameView() {
    return SafeArea(
      child: Column(
        children: [
          // Header with Score and Level
          _buildHeader(),
          
          // Hints (Guided mode)
          if (_mode == GameMode.guided && _getHints().isNotEmpty)
            _buildHintsSection(),
          
          // Sentence Construction Area
          Expanded(
            child: _buildSentenceArea(),
          ),
          
          // Available Words
          _buildWordsSection(),
          
          // Validate Button
          _buildValidateButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.softCyan, AppTheme.electricLavender],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          '$_score',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Level $_level • ${_complexityMultiplier.toStringAsFixed(1)}x',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          // Mode Badge & Exit
          Row(
            children: [
              if (_mode == GameMode.guided)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.goldenOrange, AppTheme.goldenOrange.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lightbulb_rounded, size: 16, color: Colors.white),
                      const SizedBox(width: 4),
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
              const SizedBox(width: 12),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.close, color: AppTheme.textPrimary, size: 20),
                ),
                onPressed: _endGame,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHintsSection() {
    final hints = _getHints();
    if (hints.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.goldenOrange.withOpacity(0.15),
            AppTheme.goldenOrange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.goldenOrange.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: hints.map((hint) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.goldenOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.lightbulb_rounded,
                    size: 16,
                    color: AppTheme.goldenOrange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hint,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSentenceArea() {
    return AnimatedBuilder(
      animation: Listenable.merge([_successAnimation, _errorAnimation, _pulseAnimation]),
      builder: (context, child) {
        Color borderColor = AppTheme.primaryMintGreen.withOpacity(0.3);
        Color backgroundColor = AppTheme.cardWhite.withOpacity(0.7);
        double borderWidth = 2;
        
        if (_showSuccessAnimation) {
          borderColor = AppTheme.successGreen;
          backgroundColor = AppTheme.successGreen.withOpacity(0.1);
          borderWidth = 3 + (_successAnimation.value * 2);
        } else if (_showErrorAnimation) {
          borderColor = Colors.red.shade600;
          backgroundColor = Colors.red.withOpacity(0.1);
          borderWidth = 3;
        } else if (_sentenceWords.isEmpty) {
          borderColor = AppTheme.textSecondary.withOpacity(0.2);
        }
        
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(0.2),
                blurRadius: 16,
                spreadRadius: _showSuccessAnimation ? _successAnimation.value * 4 : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _sentenceWords.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + (_pulseAnimation.value * 0.1),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppTheme.textSecondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Icon(
                                Icons.auto_awesome_rounded,
                                size: 48,
                                color: AppTheme.textSecondary.withOpacity(0.5),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Build your sentence here',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap words below to add them',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                )
              : Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(
                    _sentenceWords.length,
                    (index) => _buildSentenceWord(_sentenceWords[index], index),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildSentenceWord(Word word, int index) {
    return GestureDetector(
      onTap: () => _removeWordFromSentence(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.softCyan, AppTheme.electricLavender],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.electricLavender.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              word.wordText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              'Available Words',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _availableWords.length,
              itemBuilder: (context, index) {
                final word = _availableWords[index];
                final highlightColor = _getWordTypeColor(word);
                final isHighlighted = highlightColor != null;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => _addWordToSentence(word),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: isHighlighted
                            ? LinearGradient(
                                colors: [
                                  AppTheme.goldenOrange,
                                  AppTheme.goldenOrange.withOpacity(0.8),
                                ],
                              )
                            : LinearGradient(
                                colors: [
                                  AppTheme.primaryMintGreen,
                                  AppTheme.primaryMintGreen.withOpacity(0.8),
                                ],
                              ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: (isHighlighted ? AppTheme.goldenOrange : AppTheme.primaryMintGreen)
                                .withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            word.wordText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          if (_mode == GameMode.guided) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidateButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: _sentenceWords.isNotEmpty && !_isValidating
            ? AppTheme.pillDecoration(AppTheme.primaryMintGreen)
            : null,
        child: ElevatedButton.icon(
          onPressed: _sentenceWords.isNotEmpty && !_isValidating
              ? _validateSentence
              : null,
          icon: _isValidating
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.check_circle_rounded, size: 24),
          label: Text(
            _isValidating ? 'Validating...' : 'Validate Sentence',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _sentenceWords.isNotEmpty && !_isValidating
                ? Colors.transparent
                : null,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            minimumSize: const Size(double.infinity, 60),
          ),
        ),
      ),
    );
  }
}
