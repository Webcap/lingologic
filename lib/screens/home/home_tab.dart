import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/user_service.dart';
import '../../services/lesson_service.dart';
import '../../services/language_service.dart';
import '../../services/auth_service.dart';
import '../../services/mini_game_service.dart';
import '../../services/feature_flag_service.dart';
import '../../models/lesson.dart';
import '../../models/mini_game_type.dart';
import '../../theme/app_theme.dart';
import '../../config/supported_languages.dart';
import '../../widgets/language_selector.dart';
import '../../l10n/app_localizations.dart';
import '../mini_games/vocabulary_review_mini_game.dart';
import '../mini_games/hangman_mini_game.dart';
import '../mini_games/pictionary_mini_game.dart';
import '../mini_games/image_to_word_mini_game.dart';
import '../mini_games/charades_mini_game.dart';
import '../../games/neuro_match/neuro_match_game.dart';
import '../../games/syntax_constructor/syntax_constructor_game.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  final _userService = UserService();
  final _lessonService = LessonService();
  final _languageService = LanguageService();
  final _authService = authService;
  final _miniGameService = MiniGameService();

  int _streakDays = 0;
  int _totalTimeMinutes = 0;
  int _lessonsCompleted = 0;
  int _lessonsInProgress = 0;
  String? _activeLanguage;
  Lesson? _nextLesson;
  int? _requiredMiniGame;
  MiniGameType? _requiredMiniGameType;
  String? _currentLevel;
  bool _isLoading = true;
  bool _talkTutorEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Exposed for parent to trigger a refresh when tab becomes visible again
  void refresh() {
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload when returning to this tab
    if (!_isLoading) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Ensure auth session is fully loaded before accessing user
      await _authService.ensureSessionLoaded();
      final user = _authService.currentUser;
      if (user == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      // Initialize default language if needed
      await _languageService.initializeDefaultLanguage();
      
      final activeLanguage = await _languageService.getActiveLanguage();
      final profile = await _userService.getUserProfile();
      
      // Get lessons filtered by active language
      final lessons = await _lessonService.getLessons();
      final progressList = await _lessonService.getUserLessonProgressAll();
      
      // Filter progress by active language lessons
      final activeLanguageLessonIds = lessons.map((l) => l.id).toSet();
      final filteredProgress = progressList
          .where((p) => activeLanguageLessonIds.contains(p.lessonId))
          .toList();
      
      final completed = filteredProgress.where((p) => p.isCompleted).length;
      final inProgress = filteredProgress.where((p) => p.isInProgress).length;
      
      // Check if mini game is required first (priority over next lesson)
      final requiredMiniGameInfo = await _miniGameService.shouldShowMiniGame();
      
      // Get next recommended lesson (only if no mini game required)
      Lesson? nextLesson;
      if (requiredMiniGameInfo == null) {
        nextLesson = await _lessonService.getNextRecommendedLesson(user.id);
      }
      
      // Get current level (highest level from completed lessons)
      String? currentLevel;
      final completedLessonIds = filteredProgress
          .where((p) => p.isCompleted)
          .map((p) => p.lessonId)
          .toSet();
      
      final completedLessons = lessons.where((l) => completedLessonIds.contains(l.id)).toList();
      if (completedLessons.isNotEmpty) {
        final levels = completedLessons.map((l) => l.level).whereType<String>().toList();
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
      
      // Get language-specific stats (use effective streak - 0 if inactive for 2+ days)
      int languageStreak = 0;
      if (activeLanguage != null) {
        final langProgress = await _languageService.getLanguageProgress(activeLanguage);
        languageStreak = _languageService.getEffectiveStreakDays(langProgress);
      }

      final talkTutorEnabled = await featureFlagService.isFeatureEnabled('talk_tutor');
      
      if (mounted) {
        setState(() {
          _activeLanguage = activeLanguage;
          _streakDays = languageStreak > 0
              ? languageStreak
              : _userService.getEffectiveStreakDays(profile);
          _totalTimeMinutes = profile?.totalTimeMinutes ?? 0;
          _lessonsCompleted = completed;
          _lessonsInProgress = inProgress;
          _nextLesson = nextLesson;
          _requiredMiniGame = requiredMiniGameInfo?.miniGameNumber;
          _requiredMiniGameType = requiredMiniGameInfo?.gameType;
          _currentLevel = currentLevel;
          _talkTutorEnabled = talkTutorEnabled;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    final l10n = AppLocalizations.of(context)!;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
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
        return l10n.learning;
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.mainGradient,
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.mainGradient,
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with Greeting and Language
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              pinned: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                LanguageSelector(
                  onLanguageSelected: (language) {
                    _loadUserData();
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.cardWhite.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.settings, color: AppTheme.textPrimary),
                  ),
                  onPressed: () => context.push('/settings'),
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting
                    Text(
                      _getGreeting(context),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.readyToLearn,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                ),
                          ),
                        ),
                        if (_activeLanguage != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.cardWhite.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.primaryMintGreen.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  SupportedLanguages.getByCode(_activeLanguage!)?.flagEmoji ?? '🇪🇸',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  SupportedLanguages.getByCode(_activeLanguage!)?.name ?? 'Spanish',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Talk Tutor CTA Card (feature-flagged)
                    if (_talkTutorEnabled) ...[
                      _buildTalkTutorCard(context),
                      const SizedBox(height: 24),
                    ],

                    // Current Level Card
                    if (_currentLevel != null) ...[
                      _buildCurrentLevelCard(context),
                      const SizedBox(height: 24),
                    ],

                    // Streak Card
                    if (_streakDays > 0) ...[
                      _buildStreakCard(context),
                      const SizedBox(height: 24),
                    ],

                    // Next Lesson or Mini Game Card (mini game has priority)
                    if (_requiredMiniGame != null) ...[
                      _buildNextMiniGameCard(context),
                      const SizedBox(height: 24),
                    ] else if (_nextLesson != null) ...[
                      _buildNextLessonCard(context),
                      const SizedBox(height: 24),
                    ],

                    // Progress Overview
                    _buildProgressOverview(context),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTalkTutorCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.electricLavender, AppTheme.softCyan],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.electricLavender.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/talktutor'),
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.mic_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.speakingPractice,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!.practiceSpeaking,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentLevelCard(BuildContext context) {
    final levelColor = _getLevelColor(_currentLevel!);
    final levelDesc = _getLevelDescription(context, _currentLevel!);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            levelColor.withOpacity(0.2),
            levelColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: levelColor.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: levelColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: levelColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: levelColor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              _currentLevel!,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.currentLevel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  levelDesc,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.goldenOrange,
            AppTheme.goldenOrange.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.goldenOrange.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_streakDays',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.dayStreak,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                          Text(
                            '$_totalTimeMinutes${AppLocalizations.of(context)!.min}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextMiniGameCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.goldenOrange,
            AppTheme.goldenOrange.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.goldenOrange.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await _launchMiniGame(_requiredMiniGame!);
          },
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.celebration_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.nextMiniGame,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mini Game $_requiredMiniGame',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.reviewVocabularyMiniGame,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.sports_esports_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppLocalizations.of(context)!.game,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.start,
                        style: TextStyle(
                          color: AppTheme.goldenOrange,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchMiniGame(int miniGameNumber) async {
    try {
      final gameType = _requiredMiniGameType ?? MiniGameType.vocabularyReview;
      final difficulty = MiniGameDifficulty.fromMiniGameNumber(miniGameNumber);
      
      // Load words for the mini game
      final words = await _miniGameService.getMiniGameWords(miniGameNumber, difficulty);

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

      // Launch the appropriate mini game based on type
      Widget gameWidget;
      debugPrint('HomeTab: Launching mini game $miniGameNumber with type: ${gameType.value}');
      
      switch (gameType) {
        case MiniGameType.wordSearch:
          gameWidget = VocabularyReviewMiniGame(
            miniGameNumber: miniGameNumber,
            words: words,
          );
          break;
        case MiniGameType.hangman:
          gameWidget = HangmanMiniGame(
            miniGameNumber: miniGameNumber,
            words: words,
          );
          break;
        case MiniGameType.pictionary:
          gameWidget = PictionaryMiniGame(
            miniGameNumber: miniGameNumber,
            words: words,
          );
          break;
        case MiniGameType.imageToWord:
          gameWidget = ImageToWordMiniGame(
            miniGameNumber: miniGameNumber,
            words: words,
          );
          break;
        case MiniGameType.charades:
          gameWidget = CharadesMiniGame(
            miniGameNumber: miniGameNumber,
            words: words,
          );
          break;
        case MiniGameType.neuroMatch:
          gameWidget = const NeuroMatchGame();
          break;
        case MiniGameType.syntaxConstructor:
          gameWidget = const SyntaxConstructorGame();
          break;
        case MiniGameType.vocabularyReview:
          gameWidget = VocabularyReviewMiniGame(
            miniGameNumber: miniGameNumber,
            words: words,
          );
          break;
      }

      // Launch the mini game
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => gameWidget,
        ),
      );

      // Reload user data after completing mini game
      _loadUserData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorLaunchingMiniGame,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildNextLessonCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppTheme.primaryMintGreen.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push('/lessons/${_nextLesson!.id}');
          },
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppTheme.primaryMintGreen,
                            AppTheme.softCyan,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.nextLesson,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _nextLesson!.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_nextLesson!.description != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _nextLesson!.description!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (_nextLesson!.level != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getLevelColor(_nextLesson!.level!).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _nextLesson!.level!,
                          style: TextStyle(
                            color: _getLevelColor(_nextLesson!.level!),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    if (_nextLesson!.level != null) const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.textSecondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
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
                            '${_nextLesson!.estimatedMinutes} ${AppLocalizations.of(context)!.min}',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppTheme.primaryMintGreen,
                            AppTheme.softCyan,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.start,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressOverview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.electricLavender.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  color: AppTheme.electricLavender,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.progressOverview,
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
                child: _buildProgressStat(
                  context: context,
                  icon: Icons.check_circle_rounded,
                  value: '$_lessonsCompleted',
                  labelKey: 'completed',
                  color: AppTheme.successGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildProgressStat(
                  context: context,
                  icon: Icons.book_rounded,
                  value: '$_lessonsInProgress',
                  labelKey: 'inProgress',
                  color: AppTheme.goldenOrange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildProgressStat(
                  context: context,
                  icon: Icons.timer_rounded,
                  value: '${(_totalTimeMinutes / 60).toStringAsFixed(1)}h',
                  labelKey: 'totalTime',
                  color: AppTheme.softCyan,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat({
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
      case 'totalTime':
        label = l10n.totalTime;
        break;
      default:
        label = '';
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
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

