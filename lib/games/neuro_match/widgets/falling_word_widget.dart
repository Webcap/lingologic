import 'package:flutter/material.dart';
import '../../../models/word.dart';

class FallingWordWidget extends StatefulWidget {
  final Word word;
  final double position;
  final VoidCallback? onReachedBottom;
  final VoidCallback? onTap;

  const FallingWordWidget({
    super.key,
    required this.word,
    required this.position,
    this.onReachedBottom,
    this.onTap,
  });

  @override
  State<FallingWordWidget> createState() => _FallingWordWidgetState();
}

class _FallingWordWidgetState extends State<FallingWordWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

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

  @override
  Widget build(BuildContext context) {
    // Check if word reached bottom
    if (widget.position >= 0.95 && widget.onReachedBottom != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onReachedBottom?.call();
      });
    }

    return Positioned(
      top: widget.position * MediaQuery.of(context).size.height,
      left: MediaQuery.of(context).size.width / 2 - 75,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  widget.word.wordText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

