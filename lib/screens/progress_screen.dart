import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../data/remote/supabase_repository.dart';
import '../utils/error_handler.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final _supabaseRepository = SupabaseRepository();
  
  int _wordsLearned = 0;
  int _noviceCount = 0;
  int _intermediateCount = 0;
  int _masteredCount = 0;
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

      final masteries = await _supabaseRepository.getWordMasteries(user.id);
      
      if (mounted) {
        setState(() {
          _wordsLearned = masteries.length;
          _noviceCount = masteries.where((m) => m.masteryLevel <= 2).length;
          _intermediateCount = masteries.where((m) => m.masteryLevel >= 3 && m.masteryLevel <= 4).length;
          _masteredCount = masteries.where((m) => m.masteryLevel >= 5).length;
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
      ),
      body: _isLoading
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildStatCard(
                    title: 'Words Learned',
                    value: '$_wordsLearned',
                    icon: Icons.book,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _buildMasteryCard(
                    title: 'Novice',
                    count: _noviceCount,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  _buildMasteryCard(
                    title: 'Intermediate',
                    count: _intermediateCount,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  _buildMasteryCard(
                    title: 'Mastered',
                    count: _masteredCount,
                    color: Colors.green,
                  ),
                ],
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasteryCard({
    required String title,
    required int count,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '$_wordsLearned' == '0' ? '0' : count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

