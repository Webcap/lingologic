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
        // Show completion dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: AppTheme.successGreen, size: 32),
                const SizedBox(width: 12),
                const Text('Lesson Complete!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Great job! You\'ve completed "${_lesson!.title}"',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_open, color: AppTheme.successGreen, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'New content unlocked!',
                        style: TextStyle(
                          color: AppTheme.successGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.pop(); // Go back to lessons list
                },
                child: const Text('Continue'),
              ),
            ],
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
    
    // If it's an exercise, check if it's been answered correctly
    if (currentSection is ExerciseSection) {
      int exerciseIndex = 0;
      for (int i = 0; i < _currentSlideIndex; i++) {
        if (_lesson!.content.sections[i] is ExerciseSection) {
          exerciseIndex++;
        }
      }
      return _exerciseAnswers[exerciseIndex] == true;
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
      return ExerciseSectionWidget(
        section: section,
        onAnswerSubmitted: (isCorrect) {
          _onExerciseAnswered(currentExerciseIndex, isCorrect);
        },
        isAnswered: _exerciseAnswers[currentExerciseIndex] != null,
        isCorrect: _exerciseAnswers[currentExerciseIndex] == true,
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
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_lesson == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.mainGradient,
          ),
          child: const Center(child: Text('Lesson not found')),
        ),
      );
    }

    final totalSlides = _lesson!.content.sections.length;
    final isLastSlide = _currentSlideIndex == totalSlides - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(_lesson!.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.mainGradient,
        ),
        child: Column(
          children: [
            // Progress dots (like Duolingo)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: List.generate(totalSlides, (index) {
                  bool isCompleted = false;
                  bool isExercise = _lesson!.content.sections[index] is ExerciseSection;
                  
                  if (isExercise) {
                    int exerciseIndex = 0;
                    for (int i = 0; i < index; i++) {
                      if (_lesson!.content.sections[i] is ExerciseSection) {
                        exerciseIndex++;
                      }
                    }
                    isCompleted = _exerciseAnswers[exerciseIndex] == true;
                  } else {
                    isCompleted = index < _currentSlideIndex;
                  }

                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index == _currentSlideIndex
                            ? AppTheme.primaryMintGreen
                            : isCompleted
                                ? AppTheme.successGreen
                                : AppTheme.textSecondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Slide counter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_currentSlideIndex + 1}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryMintGreen,
                        ),
                  ),
                  Text(
                    ' / $totalSlides',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            // Slide content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentSlideIndex = index;
                  });
                },
                itemCount: totalSlides,
                itemBuilder: (context, index) {
                  final section = _lesson!.content.sections[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: _buildSlideContent(section, index),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Navigation buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Previous button
                    if (_currentSlideIndex > 0)
                      TextButton.icon(
                        onPressed: _goToPreviousSlide,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                      ),
                    const Spacer(),
                    // Next/Complete button
                    if (isLastSlide && _canCompleteLesson)
                      ElevatedButton.icon(
                        onPressed: _completeLesson,
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Complete Lesson'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.successGreen,
                          foregroundColor: Colors.white,
                        ),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: _canGoToNextSlide() ? _goToNextSlide : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: Text(isLastSlide ? 'Complete' : 'Continue'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryMintGreen,
                          foregroundColor: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
