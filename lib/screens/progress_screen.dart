// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/lesson_service.dart';
import '../data/remote/supabase_repository.dart';
import '../utils/error_handler.dart';
import '../theme/app_theme.dart';
import '../services/language_service.dart';
import '../widgets/language_selector.dart';
import '../l10n/app_localizations.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => ProgressScreenState();
}

class ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  final _supabaseRepository = SupabaseRepository();
  final _lessonService = LessonService();
  final _languageService = LanguageService();

  int _wordsLearned = 0;
  int _noviceCount = 0;
  int _intermediateCount = 0;
  int _masteredCount = 0;
  int _lessonsCompleted = 0;
  int _lessonsInProgress = 0;
  String? _activeLanguage;
  bool _isLoading = true;
  bool _hasInitialLoad = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _loadProgress();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasInitialLoad && !_isLoading) {
      _loadProgress();
    }
  }

  /// Public method to refresh progress data
  void refresh() {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final authService = AuthService();
      // Ensure session is loaded before checking user
      await authService.ensureSessionLoaded();

      final user = authService.currentUser;
      if (user == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasInitialLoad = true;
          });
        }
        return;
      }

      final activeLanguage = await _languageService.getActiveLanguage();

      // Get unlocked words from completed lessons (this is what shows progress)
      final unlockedWordIds = await _lessonService.getUnlockedWordIds(
        user.id,
        language: activeLanguage,
      );

      // Get masteries for mastery breakdown (words that have been practiced)
      final allMasteries = await _supabaseRepository.getWordMasteries(user.id);
      final words = await _supabaseRepository.getWords(
        language: activeLanguage,
      );
      final wordIds = words.map((w) => w.id).toSet();
      final unlockedWordIdsSet = unlockedWordIds.toSet();

      // Filter masteries to only include unlocked words from active language
      final masteries = allMasteries
          .where(
            (m) =>
                wordIds.contains(m.wordId) &&
                unlockedWordIdsSet.contains(m.wordId),
          )
          .toList();

      final lessons = await _lessonService.getLessons();
      final lessonIds = lessons.map((l) => l.id).toSet();

      final allProgress = await _lessonService.getUserLessonProgressAll();
      final progressList = allProgress
          .where((p) => lessonIds.contains(p.lessonId))
          .toList();

      final completed = progressList.where((p) => p.isCompleted).length;
      final inProgress = progressList.where((p) => p.isInProgress).length;

      if (mounted) {
        setState(() {
          _activeLanguage = activeLanguage;
          // Count unlocked words as words learned (from completed lessons)
          _wordsLearned = unlockedWordIds.length;
          // Mastery breakdown for words that have been practiced
          _noviceCount = masteries.where((m) => m.masteryLevel <= 2).length;
          _intermediateCount = masteries
              .where((m) => m.masteryLevel >= 3 && m.masteryLevel <= 4)
              .length;
          _masteredCount = masteries.where((m) => m.masteryLevel >= 5).length;
          _lessonsCompleted = completed;
          _lessonsInProgress = inProgress;
          _isLoading = false;
          _hasInitialLoad = true;
        });
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleError(
          context,
          e,
          contextMessage: AppLocalizations.of(context)!.errorLoadingProgress,
        );
        setState(() {
          _isLoading = false;
          _hasInitialLoad = true;
        });
      }
    }
  }

  double get _totalMasteryProgress {
    if (_wordsLearned == 0) return 0.0;
    final total = _noviceCount + _intermediateCount + _masteredCount;
    if (total == 0) return 0.0;
    return (_masteredCount / total);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadProgress,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasNoData()
                ? _buildEmptyState(context)
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          actions: [
                            LanguageSelector(
                              onLanguageSelected: (language) {
                                _loadProgress();
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
                                  l10n.yourProgress,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.textPrimary,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.trackYourLearningJourney,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Hero Stats Card
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            child: _buildHeroCard(context),
                          ),
                        ),

                        // Mastery Progress Section
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            child: _buildMasterySection(context),
                          ),
                        ),

                        // Lessons Progress Section
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            child: _buildLessonsSection(context),
                          ),
                        ),

                        // Bottom padding
                        const SliverToBoxAdapter(child: SizedBox(height: 24)),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.softCyan, AppTheme.electricLavender],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.electricLavender.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_wordsLearned',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.wordsLearned,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Overall Mastery Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.masteryProgress,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(_totalMasteryProgress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _totalMasteryProgress,
                  minHeight: 8,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMasterySection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final total = _noviceCount + _intermediateCount + _masteredCount;
    final novicePercent = total > 0 ? _noviceCount / total : 0.0;
    final intermediatePercent = total > 0 ? _intermediateCount / total : 0.0;
    final masteredPercent = total > 0 ? _masteredCount / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryMintGreen,
                      AppTheme.primaryMintGreen.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.stars_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.wordMastery,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Mastery Cards
          _buildMasteryLevelCard(
            title: l10n.mastered,
            count: _masteredCount,
            percent: masteredPercent,
            color: AppTheme.primaryMintGreen,
            icon: Icons.check_circle_rounded,
          ),
          const SizedBox(height: 16),
          _buildMasteryLevelCard(
            title: l10n.masteryIntermediate,
            count: _intermediateCount,
            percent: intermediatePercent,
            color: AppTheme.goldenOrange,
            icon: Icons.trending_up_rounded,
          ),
          const SizedBox(height: 16),
          _buildMasteryLevelCard(
            title: l10n.novice,
            count: _noviceCount,
            percent: novicePercent,
            color: AppTheme.salmonPink,
            icon: Icons.school_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildMasteryLevelCard({
    required String title,
    required int count,
    required double percent,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 6,
                    backgroundColor: color.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.electricLavender,
                      AppTheme.electricLavender.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.lessonsProgress,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildLessonStatCard(
                  title: l10n.completed,
                  value: '$_lessonsCompleted',
                  icon: Icons.check_circle_rounded,
                  color: AppTheme.successGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildLessonStatCard(
                  title: l10n.inProgress,
                  value: '$_lessonsInProgress',
                  icon: Icons.play_circle_rounded,
                  color: AppTheme.goldenOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLessonStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  bool _hasNoData() {
    return _wordsLearned == 0 &&
        _lessonsCompleted == 0 &&
        _lessonsInProgress == 0 &&
        !_isLoading;
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: mediaQuery.size.height - mediaQuery.padding.vertical,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.electricLavender.withOpacity(0.2),
                    AppTheme.softCyan.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(
                Icons.trending_up_rounded,
                size: 100,
                color: AppTheme.textSecondary.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.noProgressYet,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                l10n.startLearningToSeeProgress,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 48),
            Container(
              decoration: AppTheme.pillDecoration(AppTheme.primaryMintGreen),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.school_rounded, size: 20),
                label: Text(
                  l10n.startLearning,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
