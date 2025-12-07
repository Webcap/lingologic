import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/lesson.dart';
import '../../models/lesson_progress.dart';
import '../../services/lesson_service.dart';
import '../../services/auth_service.dart';
import '../../services/mini_game_service.dart';
import '../../services/level_progression_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/error_handler.dart';
import '../../widgets/language_selector.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/mini_game_card.dart';
import '../mini_games/vocabulary_review_mini_game.dart';
import '../level_tests/level_knowledge_test_screen.dart';
import 'widgets/knowledge_test_card.dart';

class LessonsListScreen extends StatefulWidget {
  const LessonsListScreen({super.key});

  @override
  State<LessonsListScreen> createState() => _LessonsListScreenState();
}

class _LessonsListScreenState extends State<LessonsListScreen> {
  final _lessonService = LessonService();
  final _authService = AuthService();
  final _miniGameService = MiniGameService();
  final _levelProgressionService = LevelProgressionService();

  List<Lesson> _lessons = [];
  Map<String, LessonProgress> _progressMap = {};
  bool _isLoading = true;
  String? _selectedCategory;
  bool _hasInitialLoad = false;
  int? _availableMiniGame;
  String? _currentLevel;
  bool _canTakeLevelTest = false;
  bool _hasPassedLevelTest = false;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh when screen becomes visible again (e.g., after completing a lesson)
    // Skip the first call since initState already loads
    if (_hasInitialLoad && !_isLoading) {
      _loadLessons();
    }
  }

  Future<void> _loadLessons() async {
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

      // GetLessons will automatically filter by active language
      final lessons = await _lessonService.getLessons();
      final progressList = await _lessonService.getUserLessonProgressAll();

      // Filter progress to only include lessons for active language
      final lessonIds = lessons.map((l) => l.id).toSet();
      final filteredProgress = progressList
          .where((p) => lessonIds.contains(p.lessonId))
          .toList();

      final progressMap = <String, LessonProgress>{};
      for (final progress in filteredProgress) {
        progressMap[progress.lessonId] = progress;
      }

      // Check if a mini game should be shown
      final miniGameNumber = await _miniGameService.shouldShowMiniGame();

      // Calculate current level (highest level from completed lessons)
      String? currentLevel;
      final completedLessonIds = filteredProgress
          .where((p) => p.isCompleted)
          .map((p) => p.lessonId)
          .toSet();

      final completedLessons = lessons
          .where((l) => completedLessonIds.contains(l.id))
          .toList();
      if (completedLessons.isNotEmpty) {
        final levels = completedLessons
            .map((l) => l.level)
            .whereType<String>()
            .toList();
        if (levels.isNotEmpty) {
          // Sort levels by CEFR order and get highest
          final cefrOrder = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
          levels.sort((a, b) {
            final aIndex = cefrOrder.indexOf(a);
            final bIndex = cefrOrder.indexOf(b);
            if (aIndex == -1 && bIndex == -1) return 0;
            if (aIndex == -1) return 1;
            if (bIndex == -1) return -1;
            return aIndex.compareTo(bIndex);
          });
          currentLevel = levels.last;
        }
      }

      // Default to A1 if no completed lessons
      final effectiveCurrentLevel = currentLevel ?? 'A1';

      // Check if all lessons in current level are completed
      // If so, advance to next level
      final currentLevelLessons = lessons
          .where((l) => l.level == effectiveCurrentLevel)
          .toList();
      final allCurrentLevelCompleted =
          currentLevelLessons.isNotEmpty &&
          currentLevelLessons.every((lesson) {
            final progress = progressMap[lesson.id];
            return progress?.isCompleted == true;
          });

      // Check level progression test status
      final hasPassedTest = await _levelProgressionService.hasPassedLevelTest(
        effectiveCurrentLevel,
      );
      final completionPercentage = _levelProgressionService
          .calculateLevelCompletionPercentage(
            effectiveCurrentLevel,
            lessons,
            progressMap,
          );
      final canTakeTest = completionPercentage >= 70 && !hasPassedTest;

      // Advance to next level if all current level lessons are completed OR if test is passed
      String finalCurrentLevel = effectiveCurrentLevel;
      if (allCurrentLevelCompleted || hasPassedTest) {
        final cefrOrder = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
        final currentLevelIndex = cefrOrder.indexOf(effectiveCurrentLevel);
        if (currentLevelIndex >= 0 &&
            currentLevelIndex < cefrOrder.length - 1) {
          // Check if next level has lessons available
          final nextLevel = cefrOrder[currentLevelIndex + 1];
          final hasNextLevelLessons = lessons.any((l) => l.level == nextLevel);
          if (hasNextLevelLessons) {
            finalCurrentLevel = nextLevel;
          }
        }
      }

      if (mounted) {
        setState(() {
          _lessons = lessons;
          _progressMap = progressMap;
          _availableMiniGame = miniGameNumber;
          _currentLevel = finalCurrentLevel;
          _canTakeLevelTest = canTakeTest;
          _hasPassedLevelTest = hasPassedTest;
          _isLoading = false;
          _hasInitialLoad = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleError(
          context,
          e,
          contextMessage: AppLocalizations.of(context)!.errorLoadingLessons,
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  LessonProgress? _getProgress(String lessonId) {
    return _progressMap[lessonId];
  }

  List<Lesson> get _filteredLessons {
    // Filter to only show lessons for current level
    var filtered = _lessons.where((lesson) {
      // Only show lessons matching current level
      if (_currentLevel != null && lesson.level != _currentLevel) {
        return false;
      }
      // Filter out completed lessons
      final progress = _getProgress(lesson.id);
      return progress?.isCompleted != true;
    }).toList();

    // Apply category filter if selected
    if (_selectedCategory != null) {
      filtered = filtered
          .where((l) => l.category == _selectedCategory)
          .toList();
    }

    return filtered;
  }

  // Group lessons by level (A1, A2, B1, etc.)
  Map<String, List<Lesson>> get _lessonsByLevel {
    final grouped = <String, List<Lesson>>{};

    for (final lesson in _filteredLessons) {
      final level = lesson.level ?? 'Other';
      grouped.putIfAbsent(level, () => []).add(lesson);
    }

    // Sort lessons within each level by orderIndex
    for (final level in grouped.keys) {
      grouped[level]!.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    }

    return grouped;
  }

  List<String> get _levels {
    // Only show current level
    if (_currentLevel == null) return [];
    if (!_lessonsByLevel.containsKey(_currentLevel!)) return [];
    return [_currentLevel!];
  }

  List<String> get _categories {
    // Only include categories from visible (non-completed) lessons
    final visibleLessons = _lessons.where((lesson) {
      final progress = _getProgress(lesson.id);
      return progress?.isCompleted != true;
    }).toList();
    final categories = visibleLessons
        .map((l) => l.category)
        .whereType<String>()
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  String _getLevelDescription(BuildContext context, String level) {
    final l10n = AppLocalizations.of(context)!;
    switch (level) {
      case 'A1':
        return l10n.beginner;
      case 'A2':
        return l10n.elementary;
      case 'B1':
        return l10n.intermediate;
      case 'B2':
        return l10n.upperIntermediate;
      case 'C1':
        return l10n.advanced;
      case 'C2':
        return l10n.proficient;
      default:
        return l10n.mixedLevel;
    }
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'A1':
        return AppTheme.primaryMintGreen;
      case 'A2':
        return AppTheme.softCyan;
      case 'B1':
        return AppTheme.electricLavender;
      case 'B2':
        return AppTheme.goldenOrange;
      case 'C1':
        return AppTheme.salmonPink;
      case 'C2':
        return const Color(0xFF9333EA);
      default:
        return AppTheme.textSecondary;
    }
  }

  int get _completedCount {
    // Count all completed lessons (even if hidden)
    return _progressMap.values.where((p) => p.isCompleted).length;
  }

  int get _inProgressCount {
    // Count only visible in-progress lessons
    return _lessons.where((lesson) {
      final progress = _getProgress(lesson.id);
      return progress?.isInProgress == true;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    expandedHeight: 0,
                    floating: true,
                    pinned: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.cardWhite.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppTheme.textPrimary,
                          size: 18,
                        ),
                      ),
                      onPressed: () => context.pop(),
                    ),
                    actions: [
                      LanguageSelector(
                        onLanguageSelected: (language) {
                          _loadLessons();
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),

                  // Header Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.lessons,
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.masterGrammarVocabulary,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 24),

                          // Stats Cards
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  context: context,
                                  icon: Icons.check_circle_rounded,
                                  value: '$_completedCount',
                                  labelKey: 'completed',
                                  color: AppTheme.successGreen,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  context: context,
                                  icon: Icons.book_rounded,
                                  value: '$_inProgressCount',
                                  labelKey: 'inProgress',
                                  color: AppTheme.goldenOrange,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  context: context,
                                  icon: Icons.library_books_rounded,
                                  value: '${_filteredLessons.length}',
                                  labelKey: 'available',
                                  color: AppTheme.electricLavender,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // Category Filter
                  if (_categories.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.categories,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 44,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  _CategoryChip(
                                    label: AppLocalizations.of(context)!.all,
                                    isSelected: _selectedCategory == null,
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory = null;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  ..._categories.map(
                                    (category) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: _CategoryChip(
                                        label: category.replaceAll('_', ' '),
                                        isSelected:
                                            _selectedCategory == category,
                                        onTap: () {
                                          setState(() {
                                            _selectedCategory = category;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),

                  // Lessons List Grouped by Level
                  if (_filteredLessons.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: 64,
                              color: AppTheme.textSecondary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.noLessonsAvailable,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._levels.expand((level) {
                      final levelLessons = _lessonsByLevel[level]!;
                      // Get completion percentage for current level (before filtering)
                      final completionPercentage = _levelProgressionService
                          .calculateLevelCompletionPercentage(
                            level,
                            _lessons,
                            _progressMap,
                          );

                      return [
                        // Level Header
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              24,
                              level == _levels.first ? 0 : 32,
                              24,
                              16,
                            ),
                            child: _LevelHeader(
                              level: level,
                              description: _getLevelDescription(context, level),
                              color: _getLevelColor(level),
                              lessonCount: levelLessons.length,
                              completionPercentage: completionPercentage,
                            ),
                          ),
                        ),
                        // Mini Game Card (if required) - show below level header
                        if (_availableMiniGame != null &&
                            level == _levels.first)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                              child: MiniGameCard(
                                miniGameNumber: _availableMiniGame!,
                                onTap: () async {
                                  await _launchMiniGame(_availableMiniGame!);
                                },
                              ),
                            ),
                          ),
                        // Knowledge Test Card (if 70% completed and test not passed)
                        if (_currentLevel == level &&
                            _canTakeLevelTest &&
                            !_hasPassedLevelTest)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                              child: KnowledgeTestCard(
                                level: level,
                                completionPercentage: completionPercentage,
                                onTap: () async {
                                  await _launchKnowledgeTest(level);
                                },
                              ),
                            ),
                          ),
                        // Level Lessons
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final lesson = levelLessons[index];
                              final progress = _getProgress(lesson.id);
                              // Lock lesson if mini game is required
                              final isLocked = _availableMiniGame != null;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _LessonCard(
                                  lesson: lesson,
                                  progress: progress,
                                  isLocked: isLocked,
                                  onTap: () async {
                                    if (isLocked) {
                                      // Show message that mini game must be completed first
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.completeMiniGameToContinue,
                                          ),
                                          backgroundColor:
                                              AppTheme.goldenOrange,
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                      return;
                                    }
                                    final result = await context.push(
                                      '/lessons/${lesson.id}',
                                    );
                                    if (result == true) {
                                      _loadLessons();
                                    }
                                  },
                                ),
                              );
                            }, childCount: levelLessons.length),
                          ),
                        ),
                      ];
                    }).toList(),

                  // Bottom padding
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
      ),
    );
  }

  Future<void> _launchKnowledgeTest(String level) async {
    try {
      // Launch the knowledge test
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LevelKnowledgeTestScreen(level: level),
        ),
      );

      // Reload lessons after completing test (if test was completed)
      if (result == true) {
        _loadLessons();
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleError(
          context,
          e,
          contextMessage: AppLocalizations.of(
            context,
          )!.errorLaunchingKnowledgeTest,
        );
      }
    }
  }

  Future<void> _launchMiniGame(int miniGameNumber) async {
    try {
      // Load words for the mini game
      final words = await _miniGameService.getMiniGameWords(miniGameNumber);

      if (!mounted) return;

      if (words.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.noWordsAvailableForMiniGame,
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Launch the mini game
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VocabularyReviewMiniGame(
            miniGameNumber: miniGameNumber,
            words: words,
          ),
        ),
      );

      // Reload lessons after completing mini game
      _loadLessons();
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleError(
          context,
          e,
          contextMessage: AppLocalizations.of(context)!.errorLaunchingMiniGame,
        );
      }
    }
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String labelKey,
    required Color color,
  }) {
    final l10n = AppLocalizations.of(context)!;
    String label;
    switch (labelKey) {
      case 'completed':
        label = l10n.completed;
        break;
      case 'inProgress':
        label = l10n.inProgress;
        break;
      case 'available':
        label = l10n.available;
        break;
      default:
        label = '';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppTheme.primaryMintGreen,
                    AppTheme.primaryMintGreen.withOpacity(0.8),
                  ],
                )
              : null,
          color: isSelected ? null : AppTheme.cardWhite.withOpacity(0.7),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppTheme.textSecondary.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryMintGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final Lesson lesson;
  final LessonProgress? progress;
  final bool isLocked;
  final VoidCallback onTap;

  const _LessonCard({
    required this.lesson,
    this.progress,
    this.isLocked = false,
    required this.onTap,
  });

  Color _getCategoryColor(String? category) {
    if (category == null) return AppTheme.electricLavender;
    switch (category.toLowerCase()) {
      case 'grammar':
        return AppTheme.electricLavender;
      case 'vocabulary':
        return AppTheme.softCyan;
      case 'listening':
        return AppTheme.salmonPink;
      default:
        return AppTheme.primaryMintGreen;
    }
  }

  IconData _getCategoryIcon(String? category) {
    if (category == null) return Icons.school_rounded;
    switch (category.toLowerCase()) {
      case 'grammar':
        return Icons.auto_stories_rounded;
      case 'vocabulary':
        return Icons.book_rounded;
      case 'listening':
        return Icons.headphones_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = progress?.status ?? LessonStatus.notStarted;
    final progressPercentage = progress?.progressPercentage ?? 0;
    final isCompleted = status == LessonStatus.completed;
    final isInProgress = status == LessonStatus.inProgress;
    final categoryColor = _getCategoryColor(lesson.category);
    final categoryIcon = _getCategoryIcon(lesson.category);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardWhite.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCompleted
              ? AppTheme.successGreen.withOpacity(0.3)
              : isInProgress
              ? AppTheme.goldenOrange.withOpacity(0.3)
              : AppTheme.textSecondary.withOpacity(0.1),
          width: isCompleted || isInProgress ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLocked ? null : onTap,
          borderRadius: BorderRadius.circular(24),
          child: Opacity(
            opacity: isLocked ? 0.6 : 1.0,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Icon
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  categoryColor,
                                  categoryColor.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: categoryColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              categoryIcon,
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Title and Description
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        lesson.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: AppTheme.textPrimary,
                                            ),
                                      ),
                                    ),
                                    // Status Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isCompleted
                                            ? AppTheme.successGreen.withOpacity(
                                                0.15,
                                              )
                                            : isInProgress
                                            ? AppTheme.goldenOrange.withOpacity(
                                                0.15,
                                              )
                                            : Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isCompleted
                                                ? Icons.check_circle_rounded
                                                : isInProgress
                                                ? Icons.play_circle_rounded
                                                : Icons
                                                      .radio_button_unchecked_rounded,
                                            size: 14,
                                            color: isCompleted
                                                ? AppTheme.successGreen
                                                : isInProgress
                                                ? AppTheme.goldenOrange
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            isCompleted
                                                ? AppLocalizations.of(
                                                    context,
                                                  )!.done
                                                : isInProgress
                                                ? AppLocalizations.of(
                                                    context,
                                                  )!.active
                                                : AppLocalizations.of(
                                                    context,
                                                  )!.newLesson,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: isCompleted
                                                  ? AppTheme.successGreen
                                                  : isInProgress
                                                  ? AppTheme.goldenOrange
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (lesson.description != null) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    lesson.description!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Progress Bar (if in progress or completed)
                      if (isInProgress || isCompleted) ...[
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.progress,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppTheme.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Text(
                                  '$progressPercentage%',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: isCompleted
                                            ? AppTheme.successGreen
                                            : AppTheme.goldenOrange,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progressPercentage / 100,
                                minHeight: 8,
                                backgroundColor: Colors.grey.withOpacity(0.15),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isCompleted
                                      ? AppTheme.successGreen
                                      : AppTheme.goldenOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Footer with Category and Time
                      Row(
                        children: [
                          if (lesson.category != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: categoryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    categoryIcon,
                                    size: 14,
                                    color: categoryColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    lesson.category!.replaceAll('_', ' '),
                                    style: TextStyle(
                                      color: categoryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.textSecondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: AppTheme.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${lesson.estimatedMinutes} ${AppLocalizations.of(context)!.min}',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Lock overlay icon
                if (isLocked)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.goldenOrange.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelHeader extends StatelessWidget {
  final String level;
  final String description;
  final Color color;
  final int lessonCount;
  final double? completionPercentage;

  const _LevelHeader({
    required this.level,
    required this.description,
    required this.color,
    required this.lessonCount,
    this.completionPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              level,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Builder(
                      builder: (context) {
                        final l10n = AppLocalizations.of(context)!;
                        return Text(
                          '$lessonCount ${lessonCount == 1 ? l10n.lesson : l10n.lessonsPlural}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                        );
                      },
                    ),
                    if (completionPercentage != null) ...[
                      const SizedBox(width: 12),
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${completionPercentage!.round()}% ${l10n.complete}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: color,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
