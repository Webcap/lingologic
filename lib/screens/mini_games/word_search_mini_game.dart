import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/word.dart';
import '../../models/mini_game_type.dart';
import '../../theme/app_theme.dart';
import '../../services/mini_game_service.dart';
import '../../services/auth_service.dart';
import '../../services/language_service.dart';

class WordSearchMiniGame extends StatefulWidget {
  final int miniGameNumber;
  final List<Word> words;
  final MiniGameDifficulty difficulty;

  const WordSearchMiniGame({
    super.key,
    required this.miniGameNumber,
    required this.words,
    required this.difficulty,
  });

  @override
  State<WordSearchMiniGame> createState() => _WordSearchMiniGameState();
}

class _WordSearchMiniGameState extends State<WordSearchMiniGame>
    with SingleTickerProviderStateMixin {
  final _miniGameService = MiniGameService();
  final _authService = AuthService();
  final _languageService = LanguageService();
  late AnimationController _animationController;

  static const int _gridSize = 12; // 12x12 grid
  List<List<String>> _grid = [];
  List<Word> _wordsToFind = [];
  Set<String> _foundWords = {}; // Word IDs that have been found
  Set<String> _selectedCells = {};
  String? _currentSelection;
  bool _isSelecting = false;
  bool _isCompleted = false;
  int _score = 0;
  DateTime? _startTime;
  int? _timeRemaining;
  // Map to track which cells belong to which word (wordId -> Set of cell keys)
  Map<String, Set<String>> _wordPositions = {};

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
      return;
    }

    _startTime = DateTime.now();

    // Select words for the puzzle based on difficulty
    final shuffledWords = List<Word>.from(widget.words)..shuffle(Random());
    _wordsToFind = shuffledWords.take(widget.difficulty.wordCount.clamp(5, 10)).toList();

    // Generate the word search grid
    _generateGrid();

    // Start timer with time limit
    _timeRemaining = widget.difficulty.timeLimitSeconds;
    _startTimer();

    setState(() {});
  }

  void _generateGrid() {
    // Initialize empty grid
    _grid = List.generate(
      _gridSize,
      (_) => List.generate(_gridSize, (_) => ''),
    );

    // Initialize word positions map
    _wordPositions = {};

    // Place words in the grid
    final random = Random();
    for (final word in _wordsToFind) {
      final wordText = word.wordText.toUpperCase().replaceAll(' ', '');
      if (wordText.length > _gridSize) continue;

      bool placed = false;
      int attempts = 0;
      while (!placed && attempts < 100) {
        final direction = random.nextInt(3); // 0: horizontal, 1: vertical, 2: diagonal
        final row = random.nextInt(_gridSize);
        final col = random.nextInt(_gridSize);

        if (_canPlaceWord(wordText, row, col, direction)) {
          _placeWord(wordText, row, col, direction, word.id);
          placed = true;
        }
        attempts++;
      }
    }

    // Fill remaining empty cells with random letters
    final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    for (int i = 0; i < _gridSize; i++) {
      for (int j = 0; j < _gridSize; j++) {
        if (_grid[i][j].isEmpty) {
          _grid[i][j] = letters[random.nextInt(letters.length)];
        }
      }
    }
  }

  bool _canPlaceWord(String word, int row, int col, int direction) {
    if (direction == 0) {
      // Horizontal
      if (col + word.length > _gridSize) return false;
      for (int i = 0; i < word.length; i++) {
        final cell = _grid[row][col + i];
        if (cell.isNotEmpty && cell != word[i]) return false;
      }
    } else if (direction == 1) {
      // Vertical
      if (row + word.length > _gridSize) return false;
      for (int i = 0; i < word.length; i++) {
        final cell = _grid[row + i][col];
        if (cell.isNotEmpty && cell != word[i]) return false;
      }
    } else {
      // Diagonal (down-right)
      if (row + word.length > _gridSize || col + word.length > _gridSize) {
        return false;
      }
      for (int i = 0; i < word.length; i++) {
        final cell = _grid[row + i][col + i];
        if (cell.isNotEmpty && cell != word[i]) return false;
      }
    }
    return true;
  }

  void _placeWord(String word, int row, int col, int direction, String wordId) {
    final wordCells = <String>{};
    
    if (direction == 0) {
      // Horizontal
      for (int i = 0; i < word.length; i++) {
        _grid[row][col + i] = word[i];
        wordCells.add('$row,${col + i}');
      }
    } else if (direction == 1) {
      // Vertical
      for (int i = 0; i < word.length; i++) {
        _grid[row + i][col] = word[i];
        wordCells.add('${row + i},$col');
      }
    } else {
      // Diagonal
      for (int i = 0; i < word.length; i++) {
        _grid[row + i][col + i] = word[i];
        wordCells.add('${row + i},${col + i}');
      }
    }
    
    // Store the word positions for later highlighting
    _wordPositions[wordId] = wordCells;
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && _timeRemaining != null && _timeRemaining! > 0 && !_isCompleted) {
        setState(() {
          _timeRemaining = _timeRemaining! - 1;
        });
        if (_timeRemaining == 0) {
          _completeGame();
          return false;
        }
        return true;
      }
      return false;
    });
  }

  void _onCellTap(int row, int col) {
    if (_isCompleted) return;

    final cellKey = '$row,$col';

    if (!_isSelecting) {
      // Start selection
      setState(() {
        _isSelecting = true;
        _selectedCells = {cellKey};
        _currentSelection = cellKey;
      });
      HapticFeedback.selectionClick();
    } else {
      // Continue selection - check if we can extend the line
      if (_selectedCells.contains(cellKey)) {
        // Tapping same cell twice - check word
        _checkSelectedWord();
      } else {
        // Try to extend selection in a straight line
        _extendSelection(row, col);
      }
    }
  }

  void _onCellLongPress(int row, int col) {
    if (_isSelecting) {
      _checkSelectedWord();
    } else {
      // Start selection on long press
      _onCellTap(row, col);
    }
  }

  void _extendSelection(int row, int col) {
    if (_selectedCells.isEmpty || _currentSelection == null) {
      _onCellTap(row, col);
      return;
    }

    // Get all selected cells in order
    final sortedCells = _selectedCells.toList()
      ..sort((a, b) {
        final aParts = a.split(',');
        final bParts = b.split(',');
        final aRow = int.parse(aParts[0]);
        final aCol = int.parse(aParts[1]);
        final bRow = int.parse(bParts[0]);
        final bCol = int.parse(bParts[1]);
        
        // Sort by row first, then column
        if (aRow != bRow) return aRow.compareTo(bRow);
        return aCol.compareTo(bCol);
      });

    if (sortedCells.isEmpty) return;

    final firstCell = sortedCells.first.split(',');
    final firstRow = int.parse(firstCell[0]);
    final firstCol = int.parse(firstCell[1]);
    final lastCell = sortedCells.last.split(',');
    final lastRow = int.parse(lastCell[0]);
    final lastCol = int.parse(lastCell[1]);

    // Determine direction of current selection
    int rowDir = 0;
    int colDir = 0;
    
    if (sortedCells.length > 1) {
      rowDir = lastRow - firstRow;
      colDir = lastCol - firstCol;
      
      // Normalize direction
      if (rowDir != 0) rowDir = rowDir > 0 ? 1 : -1;
      if (colDir != 0) colDir = colDir > 0 ? 1 : -1;
    }

    // Calculate direction from last cell to new cell
    final newRowDir = row - lastRow;
    final newColDir = col - lastCol;

    // Check if new cell continues in the same direction (or starts a new direction if no direction yet)
    bool canExtend = false;
    
    if (sortedCells.length == 1) {
      // First extension - allow any adjacent cell
      canExtend = (newRowDir.abs() <= 1 && newColDir.abs() <= 1) &&
                  !(newRowDir == 0 && newColDir == 0);
    } else {
      // Must continue in same direction
      final normRowDir = newRowDir != 0 ? (newRowDir > 0 ? 1 : -1) : 0;
      final normColDir = newColDir != 0 ? (newColDir > 0 ? 1 : -1) : 0;
      
      canExtend = (normRowDir == rowDir && normColDir == colDir) &&
                  !(newRowDir == 0 && newColDir == 0);
    }

    if (canExtend) {
      setState(() {
        _selectedCells.add('$row,$col');
        _currentSelection = '$row,$col';
      });
      HapticFeedback.selectionClick();
    } else {
      // Invalid direction - clear and start new selection
      _clearSelection();
      _onCellTap(row, col);
    }
  }

  void _checkSelectedWord() {
    if (_selectedCells.length < 2) {
      _clearSelection();
      return;
    }

    // Get selected letters in order (keep selection order, don't sort)
    final selectedLetters = <String>[];
    
    // Convert Set to List while preserving order (using insertion order)
    final cellList = _selectedCells.toList();
    
    // Sort cells to get them in a consistent order (by row, then col)
    cellList.sort((a, b) {
      final aParts = a.split(',');
      final bParts = b.split(',');
      final aRow = int.parse(aParts[0]);
      final aCol = int.parse(aParts[1]);
      final bRow = int.parse(bParts[0]);
      final bCol = int.parse(bParts[1]);
      
      // Sort by row first, then column
      if (aRow != bRow) return aRow.compareTo(bRow);
      return aCol.compareTo(bCol);
    });
    
    for (final cellKey in cellList) {
      final parts = cellKey.split(',');
      final row = int.parse(parts[0]);
      final col = int.parse(parts[1]);
      selectedLetters.add(_grid[row][col]);
    }

    final selectedWord = selectedLetters.join('');
    final reversedWord = selectedLetters.reversed.join('');

    // Check if it matches any word (forward or reverse)
    Word? foundWord;
    for (final word in _wordsToFind) {
      final wordText = word.wordText.toUpperCase().replaceAll(' ', '');
      if (selectedWord == wordText || reversedWord == wordText) {
        foundWord = word;
        break;
      }
    }

    if (foundWord != null && !_foundWords.contains(foundWord.id)) {
      // Word found! The word position is already stored in _wordPositions when placed
      // We just need to mark it as found - the highlighting will use the original position
      
      setState(() {
        _foundWords.add(foundWord!.id);
        _score++;
        _selectedCells.clear();
        _isSelecting = false;
        _currentSelection = null;
      });

      HapticFeedback.mediumImpact();

      // Check if all words found
      if (_foundWords.length == _wordsToFind.length) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _completeGame();
        });
      }
    } else {
      // Wrong selection
      _clearSelection();
      HapticFeedback.lightImpact();
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedCells.clear();
      _isSelecting = false;
      _currentSelection = null;
    });
  }

  Future<void> _completeGame() async {
    if (_isCompleted) return;

    setState(() {
      _isCompleted = true;
    });

    final user = _authService.currentUser;
    final activeLanguage = await _languageService.getActiveLanguage();

    if (user != null && activeLanguage != null) {
      final miniGameId = 'minigame_${activeLanguage}_${widget.miniGameNumber}';
      try {
        await _miniGameService.completeMiniGame(
          miniGameId,
          MiniGameType.wordSearch,
        );
      } catch (e) {
        debugPrint('Error completing word search mini game: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.words.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
          child: Center(
            child: Text(
              'No words available for word search',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      );
    }

    if (_isCompleted) {
      final timeSpent = _startTime != null
          ? DateTime.now().difference(_startTime!).inSeconds
          : 0;

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
                    'Word Search Complete!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Found: $_score / ${_wordsToFind.length} words',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.successGreen,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (timeSpent > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Time: ${timeSpent}s',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
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
                    child: const Text('Continue Learning'),
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
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppTheme.textPrimary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            MiniGameType.wordSearch.getFunName(widget.miniGameNumber),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                          ),
                          Text(
                            'Mini Game ${widget.miniGameNumber}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (_timeRemaining != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _timeRemaining! < 30
                              ? Colors.red.withOpacity(0.15)
                              : AppTheme.goldenOrange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_timeRemaining}s',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: _timeRemaining! < 30
                                    ? Colors.red
                                    : AppTheme.goldenOrange,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                  ],
                ),
              ),

              // Progress and word list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardWhite,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$_score / ${_wordsToFind.length}',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppTheme.successGreen,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Words Found',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardWhite,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Find these words:',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: _wordsToFind.map((word) {
                                final isFound = _foundWords.contains(word.id);
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isFound
                                        ? AppTheme.successGreen.withOpacity(0.15)
                                        : Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    word.wordText,
                                    style: TextStyle(
                                      color: isFound
                                          ? AppTheme.successGreen
                                          : AppTheme.textPrimary,
                                      fontWeight: isFound
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      decoration: isFound
                                          ? TextDecoration.lineThrough
                                          : null,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Instructions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.electricLavender.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppTheme.electricLavender,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tap to select, tap again to confirm. Drag to select multiple cells.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Grid
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate cell size based on available width
                    // Account for padding (24 on each side = 48 total) and margins (2 on each side = 4 per cell)
                    final padding = 24.0;
                    final availableWidth = constraints.maxWidth - (padding * 2);
                    final cellMargin = 2.0;
                    final totalMarginPerCell = cellMargin * 2; // Margin on both sides
                    // Calculate cell size precisely to fit within available width
                    // Use floor to ensure we don't exceed available space
                    final cellSize = ((availableWidth / _gridSize) - totalMarginPerCell).floorToDouble().clamp(24.0, 32.0);
                    final fontSize = (cellSize * 0.57).clamp(12.0, 18.0); // Scale font with cell size
                    
                    return Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: _grid.asMap().entries.map((rowEntry) {
                              final row = rowEntry.key;
                              return FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: _grid[row].asMap().entries.map((colEntry) {
                                  final col = colEntry.key;
                                  final letter = colEntry.value;
                                  final cellKey = '$row,$col';
                                  final isSelected = _selectedCells.contains(cellKey);
                                  final isFound = _isCellPartOfFoundWord(row, col);

                                  return GestureDetector(
                                    onTap: () => _onCellTap(row, col),
                                    onLongPress: () => _onCellLongPress(row, col),
                                    child: Container(
                                      width: cellSize,
                                      height: cellSize,
                                      margin: EdgeInsets.all(cellMargin),
                                      decoration: BoxDecoration(
                                        color: isFound
                                            ? AppTheme.successGreen.withOpacity(0.3)
                                            : isSelected
                                                ? AppTheme.goldenOrange.withOpacity(0.3)
                                                : AppTheme.cardWhite,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppTheme.goldenOrange
                                              : isFound
                                                  ? AppTheme.successGreen
                                                  : Colors.grey.withOpacity(0.2),
                                          width: isSelected || isFound ? 2 : 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          letter,
                                          style: TextStyle(
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.w700,
                                            color: isFound
                                                ? AppTheme.successGreen
                                                : AppTheme.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isCellPartOfFoundWord(int row, int col) {
    // Check if this cell is part of any found word
    final cellKey = '$row,$col';
    for (final wordId in _foundWords) {
      final wordCells = _wordPositions[wordId];
      if (wordCells != null && wordCells.contains(cellKey)) {
        return true;
      }
    }
    return false;
  }
}

