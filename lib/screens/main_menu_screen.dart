import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/user_service.dart';
import '../services/asset_preloader.dart';
import '../utils/error_handler.dart';
import '../theme/app_theme.dart';
import '../games/neuro_match/neuro_match_game.dart';
import '../games/syntax_constructor/syntax_constructor_game.dart';
import '../services/lesson_service.dart';
import '../services/language_service.dart';
import '../widgets/language_selector.dart';
import '../config/supported_languages.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final _userService = UserService();
  final _lessonService = LessonService();
  final _languageService = LanguageService();
  int _streakDays = 0;
  int _totalTimeMinutes = 0;
  int _lessonsCompleted = 0;
  int _lessonsInProgress = 0;
  String? _activeLanguage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Preload game assets when menu loads
    AssetPreloader.preloadGameAssets();
  }

  Future<void> _loadUserData() async {
    try {
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
      
      // Get language-specific stats
      int languageStreak = 0;
      if (activeLanguage != null) {
        final langProgress = await _languageService.getLanguageProgress(activeLanguage);
        languageStreak = langProgress?.streakDays ?? 0;
      }
      
      if (mounted) {
        setState(() {
          _activeLanguage = activeLanguage;
          _streakDays = languageStreak > 0 ? languageStreak : (profile?.streakDays ?? 0);
          _totalTimeMinutes = profile?.totalTimeMinutes ?? 0;
          _lessonsCompleted = completed;
          _lessonsInProgress = inProgress;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleError(context, e, contextMessage: 'Error loading user data');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.mainGradient,
              ),
              child: const Center(child: CircularProgressIndicator()),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.mainGradient,
              ),
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    // App Bar with Language Selector
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
                    
                    // Hero Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Greeting
                            Text(
                              _getGreeting(),
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            // Title with Language
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Ready to learn?',
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
                            const SizedBox(height: 24),
                            
                            // Streak Card - Hero Feature
                            _buildStreakCard(),
                            const SizedBox(height: 24),
                            
                            // Quick Stats
                            _buildQuickStats(),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                    
                    // Learning Activities Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Continue Learning',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textPrimary,
                                      ),
                                ),
                                TextButton(
                                  onPressed: () => context.push('/progress'),
                                  child: const Text(
                                    'View All',
                                    style: TextStyle(
                                      color: AppTheme.primaryMintGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    
                    // Learning Cards
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildLearningCard(
                            title: 'Lessons',
                            description: 'Master grammar and vocabulary',
                            icon: Icons.school_rounded,
                            gradient: const LinearGradient(
                              colors: [AppTheme.electricLavender, Color(0xFFC084FC)],
                            ),
                            badge: _lessonsInProgress > 0 ? '$_lessonsInProgress in progress' : null,
                            onTap: () => context.push('/lessons'),
                          ),
                          const SizedBox(height: 16),
                          _buildLearningCard(
                            title: 'Neuro-Match',
                            description: 'Fast-paced word matching game',
                            icon: Icons.psychology_rounded,
                            gradient: const LinearGradient(
                              colors: [AppTheme.salmonPink, Color(0xFFFF6B9D)],
                            ),
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
                          _buildLearningCard(
                            title: 'Syntax Constructor',
                            description: 'Build sentences with drag & drop',
                            icon: Icons.construction_rounded,
                            gradient: const LinearGradient(
                              colors: [AppTheme.softCyan, Color(0xFF22D3EE)],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SyntaxConstructorGame(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStreakCard() {
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
                const Text(
                  'Day Streak',
                  style: TextStyle(
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
                  '${_totalTimeMinutes}m',
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

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle_rounded,
            value: '$_lessonsCompleted',
            label: 'Completed',
            color: AppTheme.successGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.book_rounded,
            value: '$_lessonsInProgress',
            label: 'In Progress',
            color: AppTheme.electricLavender,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.trending_up_rounded,
            value: '${(_totalTimeMinutes / 60).toStringAsFixed(1)}h',
            label: 'Total Time',
            color: AppTheme.softCyan,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
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

  Widget _buildLearningCard({
    required String title,
    required String description,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
    String? badge,
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
                // Icon with gradient
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
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          if (badge != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryMintGreen.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                badge,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryMintGreen,
                                ),
                              ),
                            ),
                        ],
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
                // Arrow
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
}
