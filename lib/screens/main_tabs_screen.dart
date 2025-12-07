import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'home/home_tab.dart';
import 'lessons/lessons_list_screen.dart';
import 'progress_screen.dart';
import '../games/neuro_match/neuro_match_game.dart';
import '../games/syntax_constructor/syntax_constructor_game.dart';
import '../widgets/language_selector.dart';
import '../services/game_service.dart';
import '../services/mini_game_service.dart';
import '../services/language_service.dart';
import '../models/mini_game_type.dart';
import '../screens/mini_games/vocabulary_review_mini_game.dart';
import '../screens/mini_games/word_search_mini_game.dart';
import '../screens/mini_games/hangman_mini_game.dart';
import '../screens/mini_games/pictionary_mini_game.dart';
import '../screens/mini_games/image_to_word_mini_game.dart';
import '../screens/mini_games/charades_mini_game.dart';

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({super.key});

  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  final GlobalKey<_GamesTabState> _gamesTabKey = GlobalKey<_GamesTabState>();
  int _previousTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      final newIndex = _tabController.index;
      // Refresh games tab when it becomes visible
      if (newIndex == 2 && _previousTabIndex != 2) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _gamesTabKey.currentState?.refresh();
        });
      }
      setState(() {
        _currentIndex = newIndex;
        _previousTabIndex = newIndex;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
        child: TabBarView(
          controller: _tabController,
          children: [
            const HomeTab(),
            const _LessonsTab(),
            _GamesTab(key: _gamesTabKey),
            const ProgressScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabItem(
                  context: context,
                  icon: Icons.home_rounded,
                  label: AppLocalizations.of(context)!.home,
                  index: 0,
                  onTap: () => _tabController.animateTo(0),
                ),
                _buildTabItem(
                  context: context,
                  icon: Icons.school_rounded,
                  label: AppLocalizations.of(context)!.lessons,
                  index: 1,
                  onTap: () => _tabController.animateTo(1),
                ),
                _buildTabItem(
                  context: context,
                  icon: Icons.sports_esports_rounded,
                  label: AppLocalizations.of(context)!.games,
                  index: 2,
                  onTap: () => _tabController.animateTo(2),
                ),
                _buildTabItem(
                  context: context,
                  icon: Icons.bar_chart_rounded,
                  label: AppLocalizations.of(context)!.progress,
                  index: 3,
                  onTap: () => _tabController.animateTo(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryMintGreen.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppTheme.primaryMintGreen
                    : AppTheme.textSecondary,
                size: 22,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppTheme.primaryMintGreen
                    : AppTheme.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Wrapper for Lessons List - shows lessons without back button in tab context
class _LessonsTab extends StatelessWidget {
  const _LessonsTab();

  @override
  Widget build(BuildContext context) {
    return const LessonsListScreen();
  }
}

// Games Tab
class _GamesTab extends StatefulWidget {
  const _GamesTab({super.key});

  @override
  State<_GamesTab> createState() => _GamesTabState();
}

class _GamesTabState extends State<_GamesTab>
    with AutomaticKeepAliveClientMixin {
  final _gameService = GameService();
  final _miniGameService = MiniGameService();
  final _languageService = LanguageService();
  bool _areGamesUnlocked = false;
  bool _isLoading = true;
  String? _activeLanguage; // Store active language for game ID construction
  List<({int miniGameNumber, MiniGameType gameType, bool isCompleted})>
  _unlockedMiniGames = [];
  Map<String, Map<String, String>> _gameInfoCache =
      {}; // Cache: gameId -> {name, description}

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  void refresh() {
    // Public method to refresh unlock status
    _loadGames();
  }

  Future<void> _loadGames() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final unlocked = await _gameService.areGamesUnlocked();
      final miniGames = await _miniGameService.getUnlockedMiniGames();

      // Pre-load game info (name and description) from database
      final gameInfoCache = <String, Map<String, String>>{};
      final activeLanguage = await _languageService.getActiveLanguage();

      if (activeLanguage != null) {
        for (final miniGame in miniGames) {
          final gameId =
              'minigame_${activeLanguage}_${miniGame.miniGameNumber}';
          try {
            final gameInfo = await _miniGameService.getGameInfo(
              gameId,
              miniGame.gameType,
              miniGame.miniGameNumber,
            );
            gameInfoCache[gameId] = gameInfo;
          } catch (e) {
            // Will use fallback in the card
          }
        }
      }

      if (mounted) {
        setState(() {
          _areGamesUnlocked = unlocked;
          _unlockedMiniGames = miniGames;
          _gameInfoCache = gameInfoCache;
          _activeLanguage = activeLanguage; // Store active language
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _areGamesUnlocked = false;
          _unlockedMiniGames = [];
          _gameInfoCache = {};
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              pinned: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                LanguageSelector(
                  onLanguageSelected: (language) {
                    // Reload games when language changes
                    _loadGames();
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.games,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.practiceWithGames,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (_isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (!_areGamesUnlocked)
                      _buildLockedGamesMessage(context)
                    else ...[
                      // Mini Games Section
                      if (_unlockedMiniGames.isNotEmpty) ...[
                        Text(
                          'Mini Games',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 16),
                        ..._unlockedMiniGames.map((miniGame) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildMiniGameCard(
                              context: context,
                              miniGameNumber: miniGame.miniGameNumber,
                              gameType: miniGame.gameType,
                              isCompleted: miniGame.isCompleted,
                            ),
                          );
                        }),
                        const SizedBox(height: 32),
                        Text(
                          'Practice Games',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      _buildGameCard(
                        context: context,
                        title: AppLocalizations.of(context)!.neuroMatch,
                        description: AppLocalizations.of(
                          context,
                        )!.fastPacedWordMatching,
                        icon: Icons.psychology_rounded,
                        gradient: const LinearGradient(
                          colors: [AppTheme.salmonPink, Color(0xFFFF6B9D)],
                        ),
                        isUnlocked: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NeuroMatchGame(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildGameCard(
                        context: context,
                        title: AppLocalizations.of(context)!.syntaxConstructor,
                        description: AppLocalizations.of(
                          context,
                        )!.buildSentencesWithDragDrop,
                        icon: Icons.construction_rounded,
                        gradient: const LinearGradient(
                          colors: [AppTheme.softCyan, Color(0xFF22D3EE)],
                        ),
                        isUnlocked: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SyntaxConstructorGame(),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedGamesMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite.withOpacity(0.95),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppTheme.textSecondary.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.textSecondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_rounded,
              size: 50,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.gamesLocked,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.completeFirstLessonToUnlock,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontSize: 15,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Refresh button for testing
          TextButton.icon(
            onPressed: () => refresh(),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(AppLocalizations.of(context)!.refresh),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryMintGreen,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryMintGreen, AppTheme.softCyan],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryMintGreen.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Switch to lessons tab (index 1)
                  if (context.mounted) {
                    // Use a callback or navigate - for now show lessons route
                    context.go('/lessons');
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.goToLessons,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Gradient gradient,
    required bool isUnlocked,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardWhite.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.textSecondary.withOpacity(0.1),
          width: 1,
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors.first.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 32, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniGameCard({
    required BuildContext context,
    required int miniGameNumber,
    required MiniGameType gameType,
    required bool isCompleted,
  }) {
    final difficulty = MiniGameDifficulty.fromMiniGameNumber(miniGameNumber);

    // Try to get game info from cache, otherwise use fallbacks
    String gameName;
    String gameDescription;

    // Construct the game ID the same way it was stored in cache
    final gameId = _activeLanguage != null
        ? 'minigame_${_activeLanguage}_$miniGameNumber'
        : '';

    if (gameId.isNotEmpty && _gameInfoCache.containsKey(gameId)) {
      gameName =
          _gameInfoCache[gameId]!['name'] ??
          gameType.getFunName(miniGameNumber);
      gameDescription =
          _gameInfoCache[gameId]!['description'] ?? gameType.description;
    } else {
      // Use fallback values
      gameName = gameType.getFunName(miniGameNumber);
      gameDescription = gameType.description;
    }

    Gradient gradient;
    switch (gameType) {
      case MiniGameType.vocabularyReview:
        gradient = LinearGradient(
          colors: [AppTheme.primaryMintGreen, AppTheme.softCyan],
        );
        break;
      case MiniGameType.wordSearch:
        gradient = LinearGradient(
          colors: [AppTheme.goldenOrange, Color(0xFFFFA726)],
        );
        break;
      case MiniGameType.neuroMatch:
        gradient = LinearGradient(
          colors: [AppTheme.salmonPink, Color(0xFFFF6B9D)],
        );
        break;
      case MiniGameType.syntaxConstructor:
        gradient = LinearGradient(
          colors: [AppTheme.softCyan, Color(0xFF22D3EE)],
        );
        break;
      case MiniGameType.pictionary:
        gradient = LinearGradient(
          colors: [AppTheme.electricLavender, Color(0xFFB794F6)],
        );
        break;
      case MiniGameType.imageToWord:
      case MiniGameType.hangman:
      case MiniGameType.charades:
        // Default gradient for unimplemented game types
        gradient = LinearGradient(
          colors: [AppTheme.primaryMintGreen, AppTheme.softCyan],
        );
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardWhite.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCompleted
              ? AppTheme.successGreen.withOpacity(0.3)
              : AppTheme.textSecondary.withOpacity(0.1),
          width: isCompleted ? 2 : 1,
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
          onTap: () =>
              _launchMiniGame(context, miniGameNumber, gameType, difficulty),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors.first.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(gameType.icon, size: 32, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              gameName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          if (isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.successGreen.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    size: 14,
                                    color: AppTheme.successGreen,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Completed',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.successGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        gameDescription,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mini Game $miniGameNumber',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchMiniGame(
    BuildContext context,
    int miniGameNumber,
    MiniGameType gameType,
    MiniGameDifficulty difficulty,
  ) async {
    try {
      // Load words for the mini game
      final words = await _miniGameService.getMiniGameWords(
        miniGameNumber,
        difficulty,
      );

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
      switch (gameType) {
        case MiniGameType.wordSearch:
          gameWidget = WordSearchMiniGame(
            miniGameNumber: miniGameNumber,
            words: words,
            difficulty: difficulty,
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

      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => gameWidget));

      // Reload mini games after completing
      if (mounted) {
        _loadGames();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorLaunchingMiniGame),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
