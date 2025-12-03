import 'package:flutter/material.dart';
import '../../../models/word.dart';
import '../../../theme/app_theme.dart';

class FallingWordWidget extends StatefulWidget {
  final Word word;
  final double position;
  final VoidCallback? onReachedBottom;
  final VoidCallback? onTap;
  final Function(Offset)? onSwipeUpdate;
  final Function(Offset)? onSwipeEnd;

  const FallingWordWidget({
    super.key,
    required this.word,
    required this.position,
    this.onReachedBottom,
    this.onTap,
    this.onSwipeUpdate,
    this.onSwipeEnd,
  });

  @override
  State<FallingWordWidget> createState() => _FallingWordWidgetState();
}

class _FallingWordWidgetState extends State<FallingWordWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Offset? _swipeOffset;
  bool _isSwiping = false;

  @override
  void initState() {
    super.initState();
    // Optimize animation for 60fps
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    setState(() {
      _isSwiping = true;
      _swipeOffset = details.localPosition;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      _swipeOffset = _swipeOffset != null
          ? _swipeOffset! + details.delta
          : details.localPosition;
    });
    
    // Notify parent of swipe position
    if (widget.onSwipeUpdate != null) {
      final screenSize = MediaQuery.of(context).size;
      final baseTop = widget.position * screenSize.height;
      final baseLeft = screenSize.width / 2 - 75;
      final globalOffset = Offset(
        baseLeft + (_swipeOffset?.dx ?? 0),
        baseTop + (_swipeOffset?.dy ?? 0),
      );
      widget.onSwipeUpdate!(globalOffset);
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    if (widget.onSwipeEnd != null && _swipeOffset != null) {
      final screenSize = MediaQuery.of(context).size;
      final baseTop = widget.position * screenSize.height;
      final baseLeft = screenSize.width / 2 - 75;
      final globalOffset = Offset(
        baseLeft + _swipeOffset!.dx,
        baseTop + _swipeOffset!.dy,
      );
      widget.onSwipeEnd!(globalOffset);
    }
    
    setState(() {
      _isSwiping = false;
      _swipeOffset = null;
    });
  }

  void _handlePanCancel() {
    setState(() {
      _isSwiping = false;
      _swipeOffset = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if word reached bottom
    if (widget.position >= 0.95 && widget.onReachedBottom != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onReachedBottom?.call();
      });
    }

    final screenSize = MediaQuery.of(context).size;
    final baseTop = widget.position * screenSize.height;
    final baseLeft = screenSize.width / 2 - 75;
    
    // Calculate position with swipe offset
    final top = _isSwiping && _swipeOffset != null
        ? baseTop + _swipeOffset!.dy
        : baseTop;
    final left = _isSwiping && _swipeOffset != null
        ? baseLeft + _swipeOffset!.dx
        : baseLeft;

    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: widget.onTap,
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        onPanCancel: _handlePanCancel,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isSwiping ? 1.15 : _pulseAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isSwiping
                        ? [
                            AppTheme.electricLavender,
                            AppTheme.primaryMintGreen,
                          ]
                        : [
                            AppTheme.electricLavender,
                            AppTheme.softCyan,
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (_isSwiping
                              ? AppTheme.electricLavender
                              : AppTheme.electricLavender)
                          .withValues(alpha: _isSwiping ? 0.6 : 0.4),
                      blurRadius: _isSwiping ? 20 : 12,
                      spreadRadius: _isSwiping ? 2 : 0,
                      offset: Offset(0, _isSwiping ? 8 : 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.language_rounded,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.word.wordText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

