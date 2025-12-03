// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/lesson.dart';
import '../../models/lesson_progress.dart';
import '../../models/lesson_content.dart';
import '../../services/lesson_service.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../services/language_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/error_handler.dart';
import 'widgets/text_section_widget.dart';
import 'widgets/exercise_section_widget.dart';
import 'widgets/example_section_widget.dart';

class LessonDetailScreen extends StatefulWidget {
  final String lessonId;

  const LessonDetailScreen({
    super.key,
    required this.lessonId,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final _lessonService = LessonService();
  final _authService = AuthService();
  final _userService = UserService();
  final _languageService = LanguageService();
  final PageController _pageController = PageController();

  Lesson? _lesson;
  LessonProgress? _progress;
  bool _isLoading = true;
  int _currentSlideIndex = 0;
  final Map<int, bool> _completedExercises = {};
  final Map<int, bool?> _exerciseAnswers = {}; // null = not answered, true = correct, false = incorrect
  final Map<int, ExerciseSection> _alternativeExercises = {}; // Track alternative exercises for retry
  final Map<int, List<String>> _usedExerciseIds = {}; // Track which exercise IDs have been used for each position
  final Map<int, String> _originalExerciseIds = {}; // Track original exercise ID for each slide position
  DateTime? _startTime;
  int _timeSpentMinutes = 0;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadLesson() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _authService.currentUser;
      if (user == null) {
        if (mounted) {
          context.go('/login');
        }
        return;
      }

      final lesson = await _lessonService.getLessonById(widget.lessonId);
      if (lesson == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lesson not found')),
          );
          context.pop();
        }
        return;
      }

      final progress = await _lessonService.getUserLessonProgress(
        user.id,
        widget.lessonId,
      );

      // Start lesson if not started
      if (progress == null || progress.isNotStarted) {
        await _lessonService.startLesson(user.id, widget.lessonId);
        _startTime = DateTime.now();
      } else if (progress.isInProgress) {
        _startTime = DateTime.now();
      }

      if (mounted) {
        setState(() {
          _lesson = lesson;
          _progress = progress;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleError(context, e, contextMessage: 'Error loading lesson');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onExerciseAnswered(int exerciseIndex, bool isCorrect) {
    setState(() {
      _exerciseAnswers[exerciseIndex] = isCorrect;
      if (isCorrect) {
        _completedExercises[exerciseIndex] = true;
      }
    });
    _updateProgress();
  }

  // Get an alternative exercise from the lesson for retry
  ExerciseSection? _getAlternativeExercise(int slideIndex, String currentExerciseId) {
    if (_lesson == null) return null;

    final allExercises = _lesson!.content.exercises;
    if (allExercises.isEmpty || allExercises.length == 1) return null;

    // Initialize used IDs list if needed
    if (!_usedExerciseIds.containsKey(slideIndex)) {
      final originalId = _originalExerciseIds[slideIndex];
      _usedExerciseIds[slideIndex] = originalId != null ? [originalId] : [currentExerciseId];
    }

    // Add current exercise ID to used list
    if (!_usedExerciseIds[slideIndex]!.contains(currentExerciseId)) {
      _usedExerciseIds[slideIndex]!.add(currentExerciseId);
    }

    // Find exercises that haven't been used yet
    final usedIds = _usedExerciseIds[slideIndex]!;
    final availableExercises = allExercises
        .where((exercise) => !usedIds.contains(exercise.id))
        .toList();

    // If all exercises have been used, reset and pick a different one
    if (availableExercises.isEmpty) {
      // Reset to just the original
      final originalId = _originalExerciseIds[slideIndex] ?? currentExerciseId;
      _usedExerciseIds[slideIndex] = [originalId];
      
      // Pick a random exercise that's different from current
      final differentExercises = allExercises
          .where((exercise) => exercise.id != currentExerciseId && exercise.id != originalId)
          .toList();
      
      if (differentExercises.isEmpty) {
        // If only one exercise exists or all are the same, return null
        return null;
      }
      
      final random = differentExercises[DateTime.now().millisecondsSinceEpoch % differentExercises.length];
      _usedExerciseIds[slideIndex]!.add(random.id);
      return random;
    }

    // Pick a random exercise from available ones
    final randomIndex = DateTime.now().millisecondsSinceEpoch % availableExercises.length;
    final randomExercise = availableExercises[randomIndex];
    _usedExerciseIds[slideIndex]!.add(randomExercise.id);
    return randomExercise;
  }

  // Handle retry with a different exercise
  void _retryExerciseWithDifferentQuestion(int slideIndex) {
    if (_lesson == null) return;

    // Get the current exercise being shown (either original or alternative)
    final currentExercise = _alternativeExercises[slideIndex] ?? 
                           (_lesson!.content.sections[slideIndex] as ExerciseSection?);
    if (currentExercise == null) return;

    // Get the original exercise ID for this position
    final originalExerciseId = _originalExerciseIds[slideIndex] ?? 
                              (_lesson!.content.sections[slideIndex] as ExerciseSection?)?.id;
    if (originalExerciseId == null) return;

    // Get exercise index for tracking
    int exerciseIndex = 0;
    for (int i = 0; i < slideIndex; i++) {
      if (_lesson!.content.sections[i] is ExerciseSection) {
        exerciseIndex++;
      }
    }

    // Store original exercise ID if not already stored
    if (!_originalExerciseIds.containsKey(slideIndex)) {
      _originalExerciseIds[slideIndex] = originalExerciseId;
    }

    // Get alternative exercise using the original ID as reference
    final alternativeExercise = _getAlternativeExercise(slideIndex, currentExercise.id);
    if (alternativeExercise == null) return;

    // Reset answer state for this exercise
    setState(() {
      _exerciseAnswers[exerciseIndex] = null;
      _completedExercises[exerciseIndex] = false;
      _alternativeExercises[slideIndex] = alternativeExercise;
    });
  }

  Future<void> _updateProgress() async {
    if (_lesson == null) return;

    final user = _authService.currentUser;
    if (user == null) return;

    final totalExercises = _lesson!.content.totalExercises;
    final completedCount = _completedExercises.values.where((v) => v).length;
    final progressPercentage = totalExercises > 0
        ? ((completedCount / totalExercises) * 100).round()
        : 0;

    await _lessonService.updateLessonProgress(
      user.id,
      widget.lessonId,
      progressPercentage,
    );

    // Reload progress
    final updatedProgress = await _lessonService.getUserLessonProgress(
      user.id,
      widget.lessonId,
    );

    if (mounted) {
      setState(() {
        _progress = updatedProgress;
      });
    }
  }

  Future<void> _completeLesson() async {
    if (_lesson == null) return;

    final user = _authService.currentUser;
    if (user == null) return;

    // Calculate time spent
    if (_startTime != null) {
      _timeSpentMinutes = DateTime.now().difference(_startTime!).inMinutes;
    }

    try {
      await _lessonService.completeLesson(
        user.id,
        widget.lessonId,
        _timeSpentMinutes,
      );

      // Update streaks (both user profile and language-specific)
      await _userService.updateStreak();
      final activeLanguage = await _languageService.getActiveLanguage();
      if (activeLanguage != null) {
        await _languageService.updateLanguageStreak(activeLanguage);
      }

      if (mounted) {
        // Show modern completion dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.6),
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
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
                  // Success icon with animation
                  Container(
                    margin: const EdgeInsets.only(top: 32),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: AppTheme.successGreen,
                      size: 56,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Lesson Complete!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Great job! You\'ve completed "${_lesson!.title}"',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Unlocked content badge
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.successGreen.withOpacity(0.15),
                          AppTheme.primaryMintGreen.withOpacity(0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.successGreen.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_open_rounded,
                          color: AppTheme.successGreen,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            'New content unlocked!',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppTheme.successGreen,
                                  fontWeight: FontWeight.w700,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Continue button
                  Container(
                    margin: const EdgeInsets.only(
                      left: 32,
                      right: 32,
                      bottom: 32,
                    ),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.pop(true); // Return true to indicate lesson was completed
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryMintGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Reload progress
        final updatedProgress = await _lessonService.getUserLessonProgress(
          user.id,
          widget.lessonId,
        );

        setState(() {
          _progress = updatedProgress;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleError(context, e, contextMessage: 'Error completing lesson');
      }
    }
  }

  bool get _canCompleteLesson {
    if (_lesson == null) return false;
    final totalExercises = _lesson!.content.totalExercises;
    if (totalExercises == 0) return true; // No exercises, can complete immediately
    final completedCount = _completedExercises.values.where((v) => v).length;
    return completedCount >= totalExercises;
  }

  bool _canGoToNextSlide() {
    if (_lesson == null) return false;
    final currentSection = _lesson!.content.sections[_currentSlideIndex];
    
    // If it's an exercise, allow proceeding if it's been answered (correct or incorrect)
    // Users can retry or move on
    if (currentSection is ExerciseSection) {
      int exerciseIndex = 0;
      for (int i = 0; i < _currentSlideIndex; i++) {
        if (_lesson!.content.sections[i] is ExerciseSection) {
          exerciseIndex++;
        }
      }
      // Allow proceeding if answered (either correct or incorrect)
      return _exerciseAnswers[exerciseIndex] != null;
    }
    
    // For text and example sections, can always proceed
    return true;
  }

  void _goToNextSlide() {
    if (_currentSlideIndex < _lesson!.content.sections.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_canCompleteLesson) {
      _completeLesson();
    }
  }

  void _goToPreviousSlide() {
    if (_currentSlideIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildSlideContent(LessonSection section, int slideIndex) {
    int exerciseIndex = 0;
    for (int i = 0; i < slideIndex; i++) {
      if (_lesson!.content.sections[i] is ExerciseSection) {
        exerciseIndex++;
      }
    }

    if (section is TextSection) {
      return TextSectionWidget(section: section);
    } else if (section is ExampleSection) {
      return ExampleSectionWidget(section: section);
    } else if (section is ExerciseSection) {
      final currentExerciseIndex = exerciseIndex;
      // Store original exercise ID if not already stored
      if (!_originalExerciseIds.containsKey(slideIndex)) {
        _originalExerciseIds[slideIndex] = section.id;
      }
      
      // Use alternative exercise if available, otherwise use the original
      final exerciseToShow = _alternativeExercises[slideIndex] ?? section;
      
      // Check if there are multiple exercises available for retry
      final canRetry = _lesson!.content.exercises.length > 1;
      
      return ExerciseSectionWidget(
        section: exerciseToShow,
        onAnswerSubmitted: (isCorrect) {
          _onExerciseAnswered(currentExerciseIndex, isCorrect);
        },
        onRetry: () {
          _retryExerciseWithDifferentQuestion(slideIndex);
        },
        isAnswered: _exerciseAnswers[currentExerciseIndex] != null,
        isCorrect: _exerciseAnswers[currentExerciseIndex] == true,
        canRetry: _exerciseAnswers[currentExerciseIndex] == false && canRetry,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.mainGradient,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryMintGreen),
                ),
                const SizedBox(height: 24),
                Text(
                  'Loading lesson...',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_lesson == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.mainGradient,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Lesson not found',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final totalSlides = _lesson!.content.sections.length;
    final isLastSlide = _currentSlideIndex == totalSlides - 1;
    final progressPercentage = totalSlides > 0 
        ? ((_currentSlideIndex + 1) / totalSlides) 
        : 0.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.mainGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern AppBar with lesson title
              _buildModernAppBar(context),
              
              // Enhanced progress indicator
              _buildProgressIndicator(context, totalSlides, progressPercentage),
              
              // Slide content with smooth animations
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentSlideIndex = index;
                    });
                  },
                  itemCount: totalSlides,
                  itemBuilder: (context, index) {
                    final section = _lesson!.content.sections[index];
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.position.haveDimensions) {
                          value = _pageController.page! - index;
                          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                        }
                        return Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 680),
                            child: _buildSlideContent(section, index),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Modern navigation footer
              _buildNavigationFooter(context, isLastSlide),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Close button with glassmorphism
          Container(
            decoration: BoxDecoration(
              color: AppTheme.glassWhite,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => context.pop(),
              color: AppTheme.textPrimary,
              iconSize: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Lesson title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _lesson!.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_lesson!.description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    _lesson!.description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(
    BuildContext context,
    int totalSlides,
    double progressPercentage,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          // Progress bar with animated fill
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width: MediaQuery.of(context).size.width * progressPercentage,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryMintGreen,
                        AppTheme.successGreen,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryMintGreen.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Slide counter and section type badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Section type indicator
              _buildSectionTypeBadge(_lesson!.content.sections[_currentSlideIndex]),
              const SizedBox(width: 12),
              // Slide counter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.glassWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_currentSlideIndex + 1}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryMintGreen,
                          ),
                    ),
                    Text(
                      ' / $totalSlides',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTypeBadge(LessonSection section) {
    IconData icon;
    Color color;
    String label;

    if (section is TextSection) {
      icon = Icons.menu_book_rounded;
      color = AppTheme.electricLavender;
      label = 'Learn';
    } else if (section is ExampleSection) {
      icon = Icons.translate_rounded;
      color = AppTheme.softCyan;
      label = 'Example';
    } else {
      icon = Icons.quiz_rounded;
      color = AppTheme.goldenOrange;
      label = 'Practice';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationFooter(BuildContext context, bool isLastSlide) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Previous button
            if (_currentSlideIndex > 0)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _goToPreviousSlide,
                  icon: const Icon(Icons.arrow_back_rounded, size: 20),
                  label: const Text('Previous'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ),
            if (_currentSlideIndex > 0) const SizedBox(width: 12),
            
            // Next/Complete button
            Expanded(
              flex: _currentSlideIndex > 0 ? 1 : 1,
              child: ElevatedButton.icon(
                onPressed: _canGoToNextSlide()
                    ? (isLastSlide && _canCompleteLesson
                        ? _completeLesson
                        : _goToNextSlide)
                    : null,
                icon: Icon(
                  isLastSlide && _canCompleteLesson
                      ? Icons.check_circle_rounded
                      : Icons.arrow_forward_rounded,
                  size: 20,
                ),
                label: Text(
                  isLastSlide && _canCompleteLesson
                      ? 'Complete'
                      : isLastSlide
                          ? 'Complete'
                          : 'Continue',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLastSlide && _canCompleteLesson
                      ? AppTheme.successGreen
                      : AppTheme.primaryMintGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
