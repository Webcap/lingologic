// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/lesson_service.dart';
import '../data/remote/supabase_repository.dart';
import '../utils/error_handler.dart';
import '../theme/app_theme.dart';
import '../services/language_service.dart';
import '../widgets/language_selector.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
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

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final authService = AuthService();
      final user = authService.currentUser;
      if (user == null) return;

      // Get active language
      final activeLanguage = await _languageService.getActiveLanguage();
      
      // Get words for active language
      final words = await _supabaseRepository.getWords(language: activeLanguage);
      final wordIds = words.map((w) => w.id).toSet();
      
      // Get masteries and filter by active language words
      final allMasteries = await _supabaseRepository.getWordMasteries(user.id);
      final masteries = allMasteries.where((m) => wordIds.contains(m.wordId)).toList();
      
      // Get lessons for active language
      final lessons = await _lessonService.getLessons();
      final lessonIds = lessons.map((l) => l.id).toSet();
      
      // Get progress and filter by active language lessons
      final allProgress = await _lessonService.getUserLessonProgressAll();
      final progressList = allProgress.where((p) => lessonIds.contains(p.lessonId)).toList();
      
      final completed = progressList.where((p) => p.isCompleted).length;
      final inProgress = progressList.where((p) => p.isInProgress).length;
      
      if (mounted) {
        setState(() {
          _activeLanguage = activeLanguage;
          _wordsLearned = masteries.length;
          _noviceCount = masteries.where((m) => m.masteryLevel <= 2).length;
          _intermediateCount = masteries.where((m) => m.masteryLevel >= 3 && m.masteryLevel <= 4).length;
          _masteredCount = masteries.where((m) => m.masteryLevel >= 5).length;
          _lessonsCompleted = completed;
          _lessonsInProgress = inProgress;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.handleError(context, e, contextMessage: 'Error loading progress');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        actions: [
          LanguageSelector(
            onLanguageSelected: (language) {
              // Reload progress when language changes
              _loadProgress();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.mainGradient,
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Learning Progress',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildStatCard(
                      title: 'Words Learned',
                      value: '$_wordsLearned',
                      icon: Icons.book,
                      color: AppTheme.primaryMintGreen,
                    ),
                    const SizedBox(height: 16),
                    _buildMasteryCard(
                      title: 'Novice',
                      count: _noviceCount,
                      color: AppTheme.salmonPink,
                    ),
                    const SizedBox(height: 16),
                    _buildMasteryCard(
                      title: 'Intermediate',
                      count: _intermediateCount,
                      color: AppTheme.goldenOrange,
                    ),
                    const SizedBox(height: 16),
                    _buildMasteryCard(
                      title: 'Mastered',
                      count: _masteredCount,
                      color: AppTheme.primaryMintGreen,
                    ),
                    const SizedBox(height: 32),
                    // Lessons Progress
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.electricLavender.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.electricLavender.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.school,
                                color: AppTheme.electricLavender,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Lessons Progress',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatCard(
                                title: 'Completed',
                                value: '$_lessonsCompleted',
                                icon: Icons.check_circle,
                                color: AppTheme.successGreen,
                              ),
                              _buildStatCard(
                                title: 'In Progress',
                                value: '$_lessonsInProgress',
                                icon: Icons.play_circle,
                                color: AppTheme.goldenOrange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasteryCard({
    required String title,
    required int count,
    required Color color,
  }) {
    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color,
                  color.withValues(alpha: 0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

