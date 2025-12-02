import 'package:flutter/material.dart';
import '../../../models/word.dart';

class TargetZoneWidget extends StatefulWidget {
  final Word targetWord;
  final VoidCallback onMatch;
  final bool isActive;
  final bool isMatched;

  const TargetZoneWidget({
    super.key,
    required this.targetWord,
    required this.onMatch,
    this.isActive = false,
    this.isMatched = false,
  });

  @override
  State<TargetZoneWidget> createState() => _TargetZoneWidgetState();
}

class _TargetZoneWidgetState extends State<TargetZoneWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    if (widget.isActive) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TargetZoneWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _glowController.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _glowController.stop();
      _glowController.reset();
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.grey.shade400;
    Color backgroundColor = Colors.grey.shade100;

    if (widget.isMatched) {
      borderColor = Colors.green;
      backgroundColor = Colors.green.shade50;
    } else if (widget.isActive) {
      borderColor = Colors.blue;
      backgroundColor = Colors.blue.shade50;
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: widget.isActive ? 3 : 2,
          ),
          boxShadow: widget.isActive
              ? [
                  BoxShadow(
                    color: borderColor.withOpacity(_glowAnimation.value * 0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: widget.isMatched
            ? const Center(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Placeholder for image - in real app, load from word.imageUrl
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.targetWord.translation,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}

