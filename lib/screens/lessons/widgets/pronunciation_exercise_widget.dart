import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../../../models/lesson_content.dart';
import '../../../theme/app_theme.dart';
import '../../../services/pronunciation_skip_service.dart';
import '../../../l10n/app_localizations.dart';

class PronunciationExerciseWidget extends StatefulWidget {
  final PronunciationExerciseSection section;
  final ValueChanged<bool>? onAnswerSubmitted;
  final VoidCallback? onRetry;
  final bool isAnswered;
  final bool isCorrect;
  final bool canRetry;

  const PronunciationExerciseWidget({
    super.key,
    required this.section,
    this.onAnswerSubmitted,
    this.onRetry,
    this.isAnswered = false,
    this.isCorrect = false,
    this.canRetry = false,
  });

  @override
  State<PronunciationExerciseWidget> createState() => _PronunciationExerciseWidgetState();
}

class _PronunciationExerciseWidgetState extends State<PronunciationExerciseWidget> {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final PronunciationSkipService _skipService = PronunciationSkipService();
  
  int _currentWordIndex = 0;
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _showResult = false;
  bool? _isCorrect;
  String _recognizedText = '';
  double _confidence = 0.0;
  bool _speechAvailable = false;
  bool _initialized = false;
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    // Check microphone permission status only - don't request automatically
    final microphoneStatus = await Permission.microphone.status;
    
    setState(() {
      _permissionGranted = microphoneStatus.isGranted;
    });

    if (microphoneStatus.isGranted) {
      _initializeSpeechRecognition();
    }
  }

  Future<void> _requestMicrophonePermission() async {
    if (!mounted) return;
    
    // First, check current status
    final currentStatus = await Permission.microphone.status;
    debugPrint('Microphone permission status: $currentStatus');
    
    // If permanently denied, show settings dialog
    if (currentStatus.isPermanentlyDenied) {
      if (mounted) {
        _showPermissionDeniedDialog();
      }
      return;
    }
    
    // If already granted, initialize speech recognition
    if (currentStatus.isGranted) {
      setState(() {
        _permissionGranted = true;
      });
      _initializeSpeechRecognition();
      return;
    }
    
    // Show an informational dialog first explaining why we need permission
    // The permission request will be triggered directly from the dialog button
    if (mounted) {
      await _showPermissionRequestDialog();
      // Permission request is handled in the dialog button callback
    }
  }

  Future<void> _requestMicrophonePermissionDirectly() async {
    if (!mounted) return;
    
    debugPrint('Requesting microphone permission directly...');
    final status = await Permission.microphone.request();
    debugPrint('Permission request result: $status');
    
    if (!mounted) return;
    
    setState(() {
      _permissionGranted = status.isGranted;
    });

    if (status.isGranted) {
      debugPrint('Microphone permission granted!');
      _initializeSpeechRecognition();
    } else if (status.isPermanentlyDenied) {
      debugPrint('Microphone permission permanently denied');
      // Show dialog to open app settings
      if (mounted) {
        _showPermissionDeniedDialog();
      }
    } else if (status.isDenied) {
      debugPrint('Microphone permission denied');
      // Permission was denied, show a message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission is required to practice pronunciation.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<bool> _showPermissionRequestDialog() async {
    if (!mounted) return false;
    
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryMintGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.mic_rounded,
                color: AppTheme.primaryMintGreen,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Microphone Permission',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'To practice pronunciation, we need access to your microphone to record and check your pronunciation.\n\nA system dialog will appear asking for permission.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Not Now',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              // Use post-frame callback to ensure dialog is fully dismissed
              // before requesting permission (required for Android)
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _requestMicrophonePermissionDirectly();
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryMintGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Allow',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.settings_rounded,
                color: Colors.orange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Permission Required',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'Microphone permission is required to practice pronunciation. '
          'Please enable it in your device settings.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryMintGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Open Settings',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _speech.stop();
    super.dispose();
  }

  Future<void> _initializeTTS() async {
    await _flutterTts.setLanguage(widget.section.languageCode ?? 'en-US');
    await _flutterTts.setSpeechRate(0.5); // Slower for better understanding
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);
    
    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });
  }

  Future<void> _initializeSpeechRecognition() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (mounted) {
          setState(() {
            _isListening = status == 'listening';
          });
        }
      },
      onError: (error) {
        if (mounted) {
          debugPrint('Speech recognition error: $error');
        }
      },
    );

    if (mounted) {
      setState(() {
        _speechAvailable = available;
        _initialized = true;
      });
    }
  }

  Future<void> _playPronunciation() async {
    if (widget.section.words.isEmpty) return;
    
    final currentWord = widget.section.words[_currentWordIndex];
    setState(() {
      _isSpeaking = true;
    });

    await _flutterTts.speak(currentWord.word);
  }

  Future<void> _startListening() async {
    // Check permission first - request from user action if needed
    if (!_permissionGranted) {
      // Re-check status in case it changed
      final status = await Permission.microphone.status;
      if (!status.isGranted) {
        await _requestMicrophonePermission();
        // Re-check after request
        final newStatus = await Permission.microphone.status;
        if (!newStatus.isGranted) {
          return;
        }
        setState(() {
          _permissionGranted = true;
        });
      } else {
        setState(() {
          _permissionGranted = true;
        });
      }
    }

    if (!_speechAvailable || !_initialized) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Speech recognition is not available on this device.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    final currentWord = widget.section.words[_currentWordIndex];
    
    setState(() {
      _recognizedText = '';
      _confidence = 0.0;
      _isListening = true;
    });

    await _speech.listen(
      onResult: (result) {
        if (mounted) {
          setState(() {
            _recognizedText = result.recognizedWords;
            _confidence = result.confidence;
            
            if (result.finalResult) {
              _isListening = false;
              _checkPronunciation(currentWord);
            }
          });
        }
      },
      localeId: widget.section.languageCode ?? 'en-US',
      listenMode: stt.ListenMode.confirmation,
    );
  }

  void _checkPronunciation(PronunciationWord targetWord) {
    final recognized = _recognizedText.trim().toLowerCase();
    final target = targetWord.word.trim().toLowerCase();
    
    // Simple similarity check - can be improved with more sophisticated algorithms
    final isExactMatch = recognized == target;
    final isCloseMatch = _calculateSimilarity(recognized, target) > 0.75;
    final isCorrect = isExactMatch || isCloseMatch;

    setState(() {
      _showResult = true;
      _isCorrect = isCorrect;
    });

    HapticFeedback.mediumImpact();
    widget.onAnswerSubmitted?.call(isCorrect);
  }

  double _calculateSimilarity(String s1, String s2) {
    // Simple Levenshtein distance-based similarity
    if (s1 == s2) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;
    
    final distance = _levenshteinDistance(s1, s2);
    final maxLength = s1.length > s2.length ? s1.length : s2.length;
    return 1.0 - (distance / maxLength);
  }

  int _levenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    List<List<int>> d = List.generate(
      s1.length + 1,
      (_) => List.filled(s2.length + 1, 0),
    );

    for (int i = 0; i <= s1.length; i++) {
      d[i][0] = i;
    }
    for (int j = 0; j <= s2.length; j++) {
      d[0][j] = j;
    }

    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        d[i][j] = [
          d[i - 1][j] + 1,
          d[i][j - 1] + 1,
          d[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return d[s1.length][s2.length];
  }

  void _moveToNextWord() {
    if (_currentWordIndex < widget.section.words.length - 1) {
      setState(() {
        _currentWordIndex++;
        _showResult = false;
        _isCorrect = null;
        _recognizedText = '';
        _confidence = 0.0;
      });
    }
  }

  Future<void> _handleSkip() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.goldenOrange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.skip_next_rounded,
                color: AppTheme.goldenOrange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.skipPronunciation,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          AppLocalizations.of(context)!.skipPronunciationMessage,
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.goldenOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              AppLocalizations.of(context)!.skip,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _skipService.skipPronunciation();
      if (success && mounted) {
        // Mark this exercise as answered/complete so user can continue
        widget.onAnswerSubmitted?.call(true);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.pronunciationSkipped),
            backgroundColor: AppTheme.goldenOrange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.section.words.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentWord = widget.section.words[_currentWordIndex];
    final borderColor = _showResult
        ? (_isCorrect == true
            ? AppTheme.successGreen
            : Colors.red)
        : AppTheme.goldenOrange;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: borderColor.withOpacity(_showResult ? 0.4 : 0.2),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          if (_showResult && _isCorrect == true)
            BoxShadow(
              color: AppTheme.successGreen.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 0),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryMintGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.mic_rounded,
                    color: AppTheme.primaryMintGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pronunciation Practice',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.primaryMintGreen,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          widget.section.instruction,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                        ),
                      if (_showResult)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(
                                _isCorrect == true
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                size: 16,
                                color: _isCorrect == true
                                    ? AppTheme.successGreen
                                    : Colors.red,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _isCorrect == true ? 'Great pronunciation!' : 'Try again',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: _isCorrect == true
                                          ? AppTheme.successGreen
                                          : Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                // Skip button
                if (!_showResult)
                  IconButton(
                    onPressed: _handleSkip,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.goldenOrange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.skip_next_rounded,
                        color: AppTheme.goldenOrange,
                        size: 20,
                      ),
                    ),
                    tooltip: AppLocalizations.of(context)!.skip,
                  ),
              ],
            ),
          ),

          // Word display
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Column(
              children: [
                // Progress indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Word ${_currentWordIndex + 1} of ${widget.section.words.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Word card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryMintGreen.withOpacity(0.1),
                        AppTheme.electricLavender.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primaryMintGreen.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        currentWord.word,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      if (currentWord.phonetic != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          currentWord.phonetic!,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],
                      if (currentWord.translation != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          currentWord.translation!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Controls
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Column(
              children: [
                // Listen button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSpeaking ? null : _playPronunciation,
                    icon: Icon(
                      _isSpeaking ? Icons.volume_up_rounded : Icons.play_arrow_rounded,
                      size: 24,
                    ),
                    label: Text(_isSpeaking ? 'Playing...' : 'Listen to Pronunciation'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.electricLavender,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Record button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isListening
                        ? null
                        : (!_permissionGranted)
                            ? _requestMicrophonePermission
                            : (!_speechAvailable || !_initialized)
                                ? null
                                : _startListening,
                    icon: Icon(
                      _isListening 
                          ? Icons.mic_rounded 
                          : (!_permissionGranted)
                              ? Icons.mic_off_rounded
                              : Icons.mic_none_rounded,
                      size: 24,
                    ),
                    label: Text(
                      _isListening
                          ? 'Listening...'
                          : (!_permissionGranted)
                              ? 'Enable Microphone Permission'
                              : (!_speechAvailable || !_initialized)
                                  ? 'Initializing...'
                                  : 'Record Your Pronunciation',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isListening
                          ? Colors.red
                          : (!_permissionGranted)
                              ? AppTheme.primaryMintGreen
                              : AppTheme.goldenOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                
                // Recognized text
                if (_recognizedText.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You said:',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _recognizedText,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                        ),
                        if (_confidence > 0) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Confidence: ${(_confidence * 100).toStringAsFixed(0)}%',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Explanation
          if (_showResult && widget.section.explanation != null) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (_isCorrect == true
                        ? AppTheme.successGreen
                        : Colors.red)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (_isCorrect == true
                          ? AppTheme.successGreen
                          : Colors.red)
                      .withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: (_isCorrect == true
                              ? AppTheme.successGreen
                              : Colors.red)
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _isCorrect == true
                          ? Icons.check_circle_rounded
                          : Icons.error_rounded,
                      color: _isCorrect == true
                          ? AppTheme.successGreen
                          : Colors.red,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.section.explanation!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            height: 1.5,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Next word or retry button
          if (_showResult) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  if (_isCorrect == false && widget.canRetry && widget.onRetry != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: widget.onRetry,
                        icon: const Icon(Icons.refresh_rounded, size: 20),
                        label: const Text('Try Again'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.goldenOrange,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: BorderSide(
                            color: AppTheme.goldenOrange,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  if (_isCorrect == false && widget.canRetry && widget.onRetry != null)
                    const SizedBox(width: 12),
                  if (_currentWordIndex < widget.section.words.length - 1)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _moveToNextWord,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                        label: const Text('Next Word'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryMintGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

