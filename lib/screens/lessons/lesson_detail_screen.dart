// ignore_for_file: unused_field, unused_element

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/lesson.dart';
import '../../models/lesson_progress.dart';
import '../../models/lesson_content.dart';
import '../../services/lesson_service.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../services/language_service.dart';
import '../../services/pronunciation_skip_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/error_handler.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/text_section_widget.dart';
import 'widgets/exercise_section_widget.dart';
import 'widgets/example_section_widget.dart';
import 'widgets/matching_exercise_widget.dart';
import 'widgets/pronunciation_exercise_widget.dart';

class LessonDetailScreen extends StatefulWidget {
  final String lessonId;

  const LessonDetailScreen({super.key, required this.lessonId});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final _lessonService = LessonService();
  final _authService = AuthService();
  final _userService = UserService();
  final _languageService = LanguageService();
  final _pronunciationSkipService = PronunciationSkipService();
  final PageController _pageController = PageController();

  Lesson? _lesson;
  LessonProgress? _progress;
  bool _isLoading = true;
  int _currentSlideIndex = 0;

  // Unified section list: normal sections + retry exercises appended at end
  List<LessonSection> _allSections = [];
  int _normalSectionCount =
      0; // Track where normal sections end and retry begins

  // Track exercise completion by exercise ID (works for all phases)
  final Map<String, bool> _completedExerciseIds = {};
  // Track answers by exercise ID (null = not answered, true = correct, false = incorrect)
  final Map<String, bool?> _exerciseAnswersById = {};

  // Track which exercises need to be retried (by ID to avoid duplicates)
  final Set<String> _exercisesToRetry = {};
  // Track retry attempt counts (how many times they got it wrong in retry phase)
  final Map<String, int> _retryAttemptCounts = {};

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

  // Save current slide position
  Future<void> _saveSlidePosition(int slideIndex) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        'lesson_${widget.lessonId}_slide_position',
        slideIndex,
      );
    } catch (e) {
      debugPrint('Error saving slide position: $e');
    }
  }

  // Load saved slide position
  Future<int?> _loadSavedSlidePosition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('lesson_${widget.lessonId}_slide_position');
    } catch (e) {
      debugPrint('Error loading slide position: $e');
      return null;
    }
  }

  // Clear saved slide position
  Future<void> _clearSavedSlidePosition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('lesson_${widget.lessonId}_slide_position');
    } catch (e) {
      debugPrint('Error clearing slide position: $e');
    }
  }

  // Save current progress when exiting
  Future<void> _saveCurrentProgress() async {
    if (_lesson == null) return;
    final user = _authService.currentUser;
    if (user == null) return;

    try {
      final totalSlides = _getTotalSlides();
      final progressPercentage = totalSlides > 0
          ? ((_currentSlideIndex + 1) / totalSlides * 100).round()
          : 0;

      // Calculate time spent
      if (_startTime != null) {
        _timeSpentMinutes = DateTime.now().difference(_startTime!).inMinutes;
      }

      await _lessonService.updateLessonProgress(
        user.id,
        widget.lessonId,
        progressPercentage,
      );

      // Note: Time is only added to total when lesson is completed to avoid double-counting
      // when users save progress multiple times or resume lessons
    } catch (e) {
      debugPrint('Error saving progress: $e');
    }
  }

  // Show exit dialog with reset/save options
  Future<void> _showExitDialog() async {
    if (!mounted) return;

    // Capture the parent Navigator before showing dialog to use after async operations
    final parentNavigator = Navigator.of(context);

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (dialogContext) => Dialog(
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
              const SizedBox(height: 32),
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.goldenOrange.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.exit_to_app_rounded,
                  color: AppTheme.goldenOrange,
                  size: 36,
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  AppLocalizations.of(dialogContext)!.exitLesson,
                  style: Theme.of(dialogContext).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              // Message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  AppLocalizations.of(dialogContext)!.exitLessonMessage,
                  style: Theme.of(dialogContext).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              // Reset button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    Navigator.pop(dialogContext); // Close dialog using dialog's context
                    await _confirmAndResetLesson();
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: Text(AppLocalizations.of(dialogContext)!.reset),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.goldenOrange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    side: BorderSide(color: AppTheme.goldenOrange, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Save and Close button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(dialogContext); // Close dialog using dialog's context
                    try {
                      // Save current slide position first
                      await _saveSlidePosition(_currentSlideIndex);
                      // Save progress
                      await _saveCurrentProgress();
                      // Navigate back after saving using captured parent navigator
                      if (mounted) {
                        parentNavigator.pop(true);
                      }
                    } catch (e) {
                      debugPrint('Error saving and closing lesson: $e');
                      // Error is logged, still navigate back even if save failed
                      if (mounted) {
                        parentNavigator.pop(true);
                      }
                    }
                  },
                  icon: const Icon(Icons.check_rounded, size: 20),
                  label: Text(AppLocalizations.of(dialogContext)!.saveAndClose),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryMintGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Cancel button
              Container(
                margin: const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(AppLocalizations.of(dialogContext)!.cancel),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.textSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Confirm and reset lesson
  Future<void> _confirmAndResetLesson() async {
    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          AppLocalizations.of(context)!.reset,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.resetLessonConfirmation,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.goldenOrange,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)!.reset),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _resetLesson();
    }
  }

  // Reset lesson
  Future<void> _resetLesson() async {
    final user = _authService.currentUser;
    if (user == null) return;

    // Reset time tracking
    _startTime = DateTime.now();
    _timeSpentMinutes = 0;

    if (mounted) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryMintGreen,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.resettingLesson,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
    }

    try {
      // Reset lesson progress
      await _lessonService.resetLesson(user.id, widget.lessonId);

      // Clear saved slide position
      await _clearSavedSlidePosition();

      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        // Reset local state
        setState(() {
          _currentSlideIndex = 0;
          _completedExerciseIds.clear();
          _exerciseAnswersById.clear();
          _exercisesToRetry.clear();
          _retryAttemptCounts.clear();
          _progress = null;
        });

        // Reset to first slide
        if (_pageController.hasClients) {
          _pageController.jumpToPage(0);
        }

        // Reload lesson to get fresh state
        await _loadLesson();
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ErrorHandler.handleError(
          context,
          e,
          contextMessage: AppLocalizations.of(context)!.errorResettingLesson,
        );
      }
    }
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
            SnackBar(
              content: Text(AppLocalizations.of(context)!.lessonNotFound),
            ),
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
        // Randomize all exercises in the lesson
        final shuffledSections = _randomizeExercises(lesson.content.sections);

        // Load saved slide position if lesson is not 100% complete
        int savedSlideIndex = 0;
        if (progress != null && !progress.isCompleted) {
          final savedPosition = await _loadSavedSlidePosition();
          if (savedPosition != null && savedPosition >= 0) {
            // Validate saved position is within bounds
            final maxIndex = shuffledSections.length - 1;
            savedSlideIndex = savedPosition > maxIndex
                ? maxIndex
                : savedPosition;
          }
        }

        setState(() {
          _lesson = lesson;
          _progress = progress;
          _allSections = List.from(shuffledSections);
          _normalSectionCount = shuffledSections.length;
          _currentSlideIndex = savedSlideIndex;
          _isLoading = false;
        });

        // Restore to saved position after PageView is built
        if (savedSlideIndex > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _pageController.hasClients) {
              final totalSlides = _getTotalSlides();
              if (savedSlideIndex < totalSlides) {
                _pageController.jumpToPage(savedSlideIndex);
              }
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleError(
          context,
          e,
          contextMessage: AppLocalizations.of(context)!.errorLoadingLesson,
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Get exercise ID from a section
  String? _getExerciseId(LessonSection section) {
    if (section is ExerciseSection) return section.id;
    if (section is MatchingExerciseSection) return section.id;
    if (section is PronunciationExerciseSection) return section.id;
    return null;
  }

  // Unified exercise answered handler - uses ID-based tracking throughout
  void _onExerciseAnswered(
    int exerciseIndex, // Not used in new system, kept for compatibility
    bool isCorrect, {
    String? exerciseId,
  }) {
    if (exerciseId == null) {
      // Fallback: try to get ID from current section
      final currentSection = _getCurrentSection(_currentSlideIndex);
      exerciseId = currentSection != null
          ? _getExerciseId(currentSection)
          : null;
      if (exerciseId == null) return;
    }

    final isInRetrySection = _currentSlideIndex >= _normalSectionCount;
    final isRetryExercise = _exercisesToRetry.contains(exerciseId);

    // Track retry attempt count before setState for navigation logic
    int? retryAttemptCountAfterIncrement;
    if (!isCorrect && isInRetrySection && isRetryExercise) {
      final currentAttemptCount = _retryAttemptCounts[exerciseId] ?? 0;
      retryAttemptCountAfterIncrement = currentAttemptCount + 1;
    }

    setState(() {
      // Track answer by exercise ID (works for both normal and retry)
      _exerciseAnswersById[exerciseId!] = isCorrect;

      if (isCorrect) {
        // Mark exercise as completed
        _completedExerciseIds[exerciseId] = true;
        // Remove from retry set if it was there
        _exercisesToRetry.remove(exerciseId);
        // Clear retry attempt count
        _retryAttemptCounts.remove(exerciseId);
      } else {
        // Handle incorrect answers
        if (isInRetrySection && isRetryExercise) {
          // In retry phase - track attempts (already calculated above)
          _retryAttemptCounts[exerciseId] = retryAttemptCountAfterIncrement!;

          // If they've had 2 wrong attempts in retry (after first wrong = 1 attempt, after second wrong = 2 attempts, can proceed)
          if (retryAttemptCountAfterIncrement >= 2) {
            // Mark as "failed but can proceed" - count it as completed so lesson can progress
            _completedExerciseIds[exerciseId] = true;
            _exercisesToRetry.remove(exerciseId);
          } else {
            // Still have attempts remaining - reset answer state so they can try again
            _exerciseAnswersById[exerciseId] = null;
          }
        } else if (!isInRetrySection) {
          // Normal section - add to retry set if not already there
          if (!_exercisesToRetry.contains(exerciseId)) {
            _exercisesToRetry.add(exerciseId);
          }
        }
      }
    });

    _updateProgress();

    // No automatic navigation - user must click Next button to proceed
  }

  // Append retry exercises to _allSections when finishing normal sections
  void _appendRetryExercises() {
    if (_lesson == null || _exercisesToRetry.isEmpty) return;

    // Collect all sections from the lesson that match exercises to retry
    // We need to find the original sections from the lesson content
    final retrySections = <LessonSection>[];

    for (final exerciseId in _exercisesToRetry) {
      // Find the section from the original lesson sections
      for (final section in _lesson!.content.sections) {
        final sectionId = _getExerciseId(section);
        if (sectionId == exerciseId) {
          retrySections.add(section);
          break; // Found it, move to next exercise ID
        }
      }
    }

    // Only append if we have retry exercises and they're not already added
    if (retrySections.isNotEmpty &&
        _allSections.length == _normalSectionCount) {
      setState(() {
        _allSections.addAll(retrySections);
        // Clear answer state for retry exercises so they start fresh
        // Exercises in _exercisesToRetry were answered incorrectly, so they need fresh state
        for (final exerciseId in _exercisesToRetry) {
          _exerciseAnswersById[exerciseId] = null;
          // Initialize retry attempt count to 0 for each retry exercise
          _retryAttemptCounts[exerciseId] = 0;
        }
        // PageView will automatically rebuild with new itemCount
      });
    }
  }

  void _moveToNextSlide() {
    // Delegate to _goToNextSlide which handles retry appending logic
    _goToNextSlide();
  }

  // Randomize all exercises within the lesson
  // This shuffles all exercises together while keeping non-exercise sections in place
  List<LessonSection> _randomizeExercises(List<LessonSection> sections) {
    final result = <LessonSection>[];
    final exercises = <LessonSection>[];

    // Separate exercises from non-exercises
    for (final section in sections) {
      if (section is ExerciseSection ||
          section is MatchingExerciseSection ||
          section is PronunciationExerciseSection) {
        exercises.add(section);
      }
    }

    // Shuffle all exercises together
    exercises.shuffle(Random());

    // Rebuild the sections list, replacing exercises with shuffled ones
    int exerciseIndex = 0;
    for (final section in sections) {
      if (section is ExerciseSection ||
          section is MatchingExerciseSection ||
          section is PronunciationExerciseSection) {
        // Replace with shuffled exercise
        result.add(exercises[exerciseIndex]);
        exerciseIndex++;
      } else {
        // Keep non-exercise sections in their original position
        result.add(section);
      }
    }

    return result;
  }

  int _getTotalSlides() {
    return _allSections.length;
  }

  // Get the current section from unified list
  LessonSection? _getCurrentSection(int slideIndex) {
    if (slideIndex < 0 || slideIndex >= _allSections.length) return null;
    return _allSections[slideIndex];
  }

  Future<void> _updateProgress() async {
    if (_lesson == null) return;

    final user = _authService.currentUser;
    if (user == null) return;

    final totalExercises = _lesson!.content.totalExercises;
    final completedCount = _completedExerciseIds.length;
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

      // Add time spent to user's total time when lesson is completed
      if (_timeSpentMinutes > 0) {
        await _userService.addTimeSpent(_timeSpentMinutes);
      }

      // Update streaks (both user profile and language-specific)
      await _userService.updateStreak();
      final activeLanguage = await _languageService.getActiveLanguage();
      if (activeLanguage != null) {
        await _languageService.updateLanguageStreak(activeLanguage);
      }

      // Clear saved slide position when lesson is completed
      await _clearSavedSlidePosition();

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
                      AppLocalizations.of(context)!.lessonComplete,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
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
                      AppLocalizations.of(
                        context,
                      )!.greatJobCompletedLesson(_lesson!.title),
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
                            AppLocalizations.of(context)!.newContentUnlocked,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
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
                      onPressed: () async {
                        Navigator.pop(context); // Close dialog
                        // Return true to indicate lesson was completed so lessons list refreshes
                        if (mounted) {
                          context.pop(true);
                        }
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
                      child: Text(
                        AppLocalizations.of(context)!.done,
                        style: const TextStyle(
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
        ErrorHandler.handleError(
          context,
          e,
          contextMessage: AppLocalizations.of(context)!.errorCompletingLesson,
        );
      }
    }
  }

  bool get _canCompleteLesson {
    if (_lesson == null) return false;
    final totalExercises = _lesson!.content.totalExercises;
    if (totalExercises == 0)
      return true; // No exercises, can complete immediately
    final completedCount = _completedExerciseIds.length;
    return completedCount >= totalExercises;
  }

  bool _canGoToNextSlide() {
    if (_lesson == null) return false;
    final currentSection = _getCurrentSection(_currentSlideIndex);
    if (currentSection == null) return false;

    // If it's an exercise, allow proceeding if it's been answered
    if (currentSection is ExerciseSection ||
        currentSection is MatchingExerciseSection ||
        currentSection is PronunciationExerciseSection) {
      final exerciseId = _getExerciseId(currentSection);
      if (exerciseId != null) {
        final isInRetrySection = _currentSlideIndex >= _normalSectionCount;
        final isRetryExercise = _exercisesToRetry.contains(exerciseId);

        // For retry exercises, check if they've answered or attempted
        if (isInRetrySection && isRetryExercise) {
          final attemptCount = _retryAttemptCounts[exerciseId] ?? 0;
          final isAnswered = _exerciseAnswersById[exerciseId] != null;
          // Allow proceeding if:
          // 1. They've answered it (correct answer, or wrong answer after max attempts)
          // 2. OR they've attempted it at least once (so they can move to next retry question)
          // This allows them to go through all retries once, then come back for final attempts
          return isAnswered || attemptCount > 0;
        }

        // For normal exercises, allow proceeding if answered
        return _exerciseAnswersById[exerciseId] != null;
      }
      return false;
    }

    // For text and example sections, can always proceed
    return true;
  }

  void _goToNextSlide() {
    final totalSlides = _getTotalSlides();

    // Check if we just finished the last normal section and need to append retries
    if (_currentSlideIndex == _normalSectionCount - 1 &&
        _allSections.length == _normalSectionCount &&
        _exercisesToRetry.isNotEmpty) {
      // Append retry exercises first
      _appendRetryExercises();
      // Then navigate to first retry exercise after a brief delay to allow rebuild
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted && _pageController.hasClients) {
          final newTotalSlides = _getTotalSlides();
          if (newTotalSlides > _normalSectionCount) {
            // Jump to first retry exercise
            _pageController.jumpToPage(_normalSectionCount);
          } else if (_canCompleteLesson) {
            // No retries needed or all completed - complete lesson
            _completeLesson();
          }
        }
      });
      return;
    }

    // Normal navigation
    if (_currentSlideIndex < totalSlides - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // We're on the last slide - check if we can complete
      if (_canCompleteLesson) {
        _completeLesson();
      }
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
    if (section is TextSection) {
      return TextSectionWidget(section: section);
    } else if (section is ExampleSection) {
      return ExampleSectionWidget(
        section: section,
        languageCode: _lesson?.language ?? 'es',
      );
    } else if (section is ExerciseSection) {
      final exerciseId = section.id;
      final isAnswered = _exerciseAnswersById[exerciseId] != null;
      final isCorrect = _exerciseAnswersById[exerciseId] == true;

      return ExerciseSectionWidget(
        section: section,
        onAnswerSubmitted: (isCorrect) {
          _onExerciseAnswered(
            0, // Not used in new system
            isCorrect,
            exerciseId: exerciseId,
          );
        },
        isAnswered: isAnswered,
        isCorrect: isCorrect,
      );
    } else if (section is MatchingExerciseSection) {
      final exerciseId = section.id;
      final isAnswered = _exerciseAnswersById[exerciseId] != null;
      final isCorrect = _exerciseAnswersById[exerciseId] == true;

      return MatchingExerciseWidget(
        section: section,
        onAnswerSubmitted: (isCorrect) {
          _onExerciseAnswered(
            0, // Not used in new system
            isCorrect,
            exerciseId: exerciseId,
          );
        },
        isAnswered: isAnswered,
        isCorrect: isCorrect,
        canRetry: false,
      );
    } else if (section is PronunciationExerciseSection) {
      final exerciseId = section.id;
      final isAnswered = _exerciseAnswersById[exerciseId] != null;
      final isCorrect = _exerciseAnswersById[exerciseId] == true;

      // Check if pronunciation exercises are skipped
      return FutureBuilder<bool>(
        future: _pronunciationSkipService.isPronunciationSkipped(),
        builder: (context, snapshot) {
          final isSkipped = snapshot.data ?? false;

          // If skipped, auto-complete the exercise
          if (isSkipped && !isAnswered) {
            // Auto-mark as completed after a short delay to ensure state is updated
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _onExerciseAnswered(0, true, exerciseId: exerciseId);
              }
            });

            // Show a simple message that pronunciation is skipped
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.cardWhite,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppTheme.goldenOrange.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.skip_next_rounded,
                    color: AppTheme.goldenOrange,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.pronunciationSkipped,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.pronunciationSkippedMessage,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          // Not skipped, show the normal pronunciation widget
          return PronunciationExerciseWidget(
            section: section,
            onAnswerSubmitted: (isCorrect) {
              _onExerciseAnswered(
                0, // Not used in new system
                isCorrect,
                exerciseId: exerciseId,
              );
            },
            isAnswered: isAnswered,
            isCorrect: isCorrect,
            canRetry: false,
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryMintGreen,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.loadingLesson,
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
          decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
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
                  AppLocalizations.of(context)!.lessonNotFound,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: Text(AppLocalizations.of(context)!.goBack),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final totalSlides = _getTotalSlides();
    final isLastSlide = _currentSlideIndex == totalSlides - 1;
    final progressPercentage = totalSlides > 0
        ? ((_currentSlideIndex + 1) / totalSlides)
        : 0.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
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
                    // Save slide position whenever user navigates
                    _saveSlidePosition(index);
                  },
                  itemCount: totalSlides,
                  itemBuilder: (context, index) {
                    final section = _getCurrentSection(index);
                    if (section == null) return const SizedBox.shrink();
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
                          child: Opacity(opacity: value, child: child),
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
              onPressed: () => _showExitDialog(),
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
              _buildSectionTypeBadge(
                context,
                _getCurrentSection(_currentSlideIndex) ??
                    (_lesson!.content.sections.isNotEmpty &&
                            _currentSlideIndex <
                                _lesson!.content.sections.length
                        ? _lesson!.content.sections[_currentSlideIndex]
                        : _lesson!.content.sections.first),
              ),
              const SizedBox(width: 12),
              // Slide counter
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
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

  Widget _buildSectionTypeBadge(BuildContext context, LessonSection section) {
    IconData icon;
    Color color;
    String label;

    final l10n = AppLocalizations.of(context)!;
    if (section is TextSection) {
      icon = Icons.menu_book_rounded;
      color = AppTheme.electricLavender;
      label = l10n.learn;
    } else if (section is ExampleSection) {
      icon = Icons.translate_rounded;
      color = AppTheme.softCyan;
      label = l10n.example;
    } else {
      icon = Icons.quiz_rounded;
      color = AppTheme.goldenOrange;
      label = l10n.practice;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
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
                  label: Text(AppLocalizations.of(context)!.previous),
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
                      ? AppLocalizations.of(context)!.completeButton
                      : AppLocalizations.of(context)!.continueButton,
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
