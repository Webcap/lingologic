import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/word.dart';
import '../../models/mini_game_type.dart';
import '../../theme/app_theme.dart';
import '../../services/mini_game_service.dart';
import '../../services/auth_service.dart';
import '../../services/language_service.dart';
import '../../l10n/app_localizations.dart';

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

class _PictionaryMiniGameState extends State<PictionaryMiniGame> {
  final _miniGameService = MiniGameService();
  final _authService = AuthService();
  final _languageService = LanguageService();
  
  List<Word> _shuffledWords = [];
  Word? _currentWord;
  int _currentWordIndex = 0;
  bool _isCompleted = false;
  bool _isLoading = true;
  
  // Drawing canvas state
  List<Offset> _points = [];

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  void _setupGame() {
    if (widget.words.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Shuffle words and take the appropriate amount for the mini game
    _shuffledWords = List<Word>.from(widget.words);
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
      _points = []; // Clear drawing canvas
      _currentWordIndex++;
    });
  }

  void _clearCanvas() {
    setState(() {
      _points = [];
    });
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
            MiniGameType.pictionary,
          );
        }
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
    final l10n = AppLocalizations.of(context)!;
    
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (widget.words.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
          child: Center(
            child: Text(
              l10n.noWordsAvailableForMiniGame,
              style: Theme.of(context).textTheme.titleLarge,
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
                    'You drew ${_shuffledWords.length} words!',
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
                            MiniGameType.pictionary.getFunName(widget.miniGameNumber),
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
                      // Word to draw
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryMintGreen.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Draw this word:',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _currentWord?.wordText ?? '',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.primaryMintGreen,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (_currentWord?.translation != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                _currentWord!.translation,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      // Drawing canvas
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.goldenOrange.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: _DrawingCanvas(
                              points: _points,
                              onPointAdded: (point) {
                                setState(() {
                                  _points.add(point);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      
                      // Controls
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Clear button
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _clearCanvas,
                                icon: const Icon(Icons.clear_rounded, size: 20),
                                label: const Text('Clear'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.textSecondary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: AppTheme.textSecondary.withOpacity(0.3),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Next button
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: _loadNextWord,
                                icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                                label: Text(
                                  _currentWordIndex >= _shuffledWords.length 
                                      ? 'Finish' 
                                      : 'Next Word',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.goldenOrange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0,
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
            ],
          ),
        ),
      ),
    );
  }
}

// Drawing canvas widget with proper coordinate handling
class _DrawingCanvas extends StatefulWidget {
  final List<Offset> points;
  final Function(Offset) onPointAdded;

  const _DrawingCanvas({
    required this.points,
    required this.onPointAdded,
  });

  @override
  State<_DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<_DrawingCanvas> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Drawing canvas
            CustomPaint(
              key: _key,
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: DrawingPainter(widget.points),
            ),
            // Gesture detector overlay
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanUpdate: (details) {
                  final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
                  if (renderBox != null) {
                    final localPosition = renderBox.globalToLocal(details.globalPosition);
                    widget.onPointAdded(Offset(
                      localPosition.dx.clamp(0.0, constraints.maxWidth),
                      localPosition.dy.clamp(0.0, constraints.maxHeight),
                    ));
                  }
                },
                onPanStart: (details) {
                  final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
                  if (renderBox != null) {
                    final localPosition = renderBox.globalToLocal(details.globalPosition);
                    widget.onPointAdded(Offset(
                      localPosition.dx.clamp(0.0, constraints.maxWidth),
                      localPosition.dy.clamp(0.0, constraints.maxHeight),
                    ));
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// Custom painter for drawing
class DrawingPainter extends CustomPainter {
  final List<Offset> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;

    // Draw path connecting all points for smooth lines
    if (points.length == 1) {
      // Single point - draw a circle
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(points.first, 5.0, paint);
    } else if (points.length > 1) {
      // Multiple points - draw connected path
      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.points.length != points.length;
  }
}
