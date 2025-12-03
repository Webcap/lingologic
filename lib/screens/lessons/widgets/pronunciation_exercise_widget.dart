import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../../../models/lesson_content.dart';
import '../../../theme/app_theme.dart';

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
    // Check microphone permission
    final microphoneStatus = await Permission.microphone.status;
    
    setState(() {
      _permissionGranted = microphoneStatus.isGranted;
    });

    if (microphoneStatus.isGranted) {
      _initializeSpeechRecognition();
    } else if (microphoneStatus.isDenied || microphoneStatus.isLimited) {
      // Request permission
      await _requestMicrophonePermission();
    }
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    
    setState(() {
      _permissionGranted = status.isGranted;
    });

    if (status.isGranted) {
      _initializeSpeechRecognition();
    } else if (status.isPermanentlyDenied) {
      // Show dialog to open app settings
      if (mounted) {
        _showPermissionDeniedDialog();
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Microphone Permission Required'),
        content: const Text(
          'To practice pronunciation, we need access to your microphone. '
          'Please enable microphone permission in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryMintGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Open Settings'),
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
    // Check permission first
    if (!_permissionGranted) {
      await _requestMicrophonePermission();
      if (!_permissionGranted) {
        return;
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
                    onPressed: (_isListening || !_permissionGranted)
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
                              ? 'Microphone Permission Required'
                              : (!_speechAvailable || !_initialized)
                                  ? 'Initializing...'
                                  : 'Record Your Pronunciation',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isListening
                          ? Colors.red
                          : (!_permissionGranted)
                              ? Colors.grey
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
                
                // Permission request button if not granted
                if (!_permissionGranted) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _requestMicrophonePermission,
                      icon: const Icon(Icons.settings, size: 20),
                      label: const Text('Grant Microphone Permission'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryMintGreen,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide(
                          color: AppTheme.primaryMintGreen,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
                
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

