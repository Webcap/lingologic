import 'package:flutter/material.dart';
import '../../../models/word.dart';
import '../../../theme/app_theme.dart';

class TargetZoneWidget extends StatefulWidget {
  final Word targetWord;
  final VoidCallback onMatch;
  final bool isActive;
  final bool isMatched;
  final bool isHovered;

  const TargetZoneWidget({
    super.key,
    required this.targetWord,
    required this.onMatch,
    this.isActive = false,
    this.isMatched = false,
    this.isHovered = false,
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
    Color borderColor = Colors.grey.shade300;
    Color backgroundColor = Colors.white;
    Color? gradientColor1;
    Color? gradientColor2;

    if (widget.isMatched) {
      borderColor = AppTheme.successGreen;
      backgroundColor = AppTheme.successGreen.withValues(alpha: 0.1);
      gradientColor1 = AppTheme.successGreen;
      gradientColor2 = AppTheme.primaryMintGreen;
    } else if (widget.isHovered) {
      borderColor = AppTheme.goldenOrange;
      backgroundColor = AppTheme.goldenOrange.withValues(alpha: 0.15);
      gradientColor1 = AppTheme.goldenOrange;
      gradientColor2 = AppTheme.salmonPink;
    } else if (widget.isActive) {
      borderColor = AppTheme.primaryMintGreen;
      backgroundColor = AppTheme.primaryMintGreen.withValues(alpha: 0.1);
      gradientColor1 = AppTheme.primaryMintGreen;
      gradientColor2 = AppTheme.softCyan;
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: (widget.isActive || widget.isHovered || widget.isMatched) ? 3 : 2,
          ),
          boxShadow: (widget.isActive || widget.isHovered || widget.isMatched)
              ? [
                  BoxShadow(
                    color: borderColor.withValues(
                      alpha: _glowAnimation.value * (widget.isHovered ? 0.6 : 0.4),
                    ),
                    blurRadius: widget.isHovered ? 20 : widget.isMatched ? 16 : 12,
                    spreadRadius: widget.isHovered ? 4 : widget.isMatched ? 3 : 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: widget.isMatched
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            gradientColor1 ?? AppTheme.successGreen,
                            gradientColor2 ?? AppTheme.primaryMintGreen,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image placeholder with better styling
                    Flexible(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: widget.isHovered
                              ? gradientColor1?.withValues(alpha: 0.1)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.image_rounded,
                          size: 28,
                          color: widget.isHovered
                              ? gradientColor1
                              : Colors.grey.shade400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          widget.targetWord.translation,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: widget.isHovered
                                ? gradientColor1
                                : AppTheme.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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

