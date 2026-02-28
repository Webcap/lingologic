import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../services/talk_tutor_service.dart';
import '../../services/language_service.dart';
import '../../l10n/app_localizations.dart';

class TalkTutorScreen extends StatefulWidget {
  const TalkTutorScreen({super.key});

  @override
  State<TalkTutorScreen> createState() => _TalkTutorScreenState();
}

class _TalkTutorScreenState extends State<TalkTutorScreen> {
  final TalkTutorService _talkTutorService = TalkTutorService();
  final LanguageService _languageService = LanguageService();
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();

  String? _activeLanguage;
  bool _isListening = false;
  bool _isLoading = false;
  bool _isSpeaking = false;
  String _recognizedText = '';
  bool _speechAvailable = false;
  bool _initialized = false;
  bool _permissionGranted = false;
  final List<Map<String, String>> _conversationHistory = [];
  static const int _maxHistoryTurns = 5;
  bool _welcomePlayed = false;
  bool _ttsReady = false;
  String? _currentSpeakingText;
  static const String _welcomePlayedKey = 'talk_tutor_welcome_played';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _initializeTTS();
    _checkPermissions();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _speech.stop();
    super.dispose();
  }

  Future<void> _loadLanguage() async {
    final lang = await _languageService.getActiveLanguage();
    if (mounted) {
      setState(() {
        _activeLanguage = lang;
      });
      _maybePlayWelcome();
    }
  }

  /// Onboarding script (voice-only): hello, I'm your tutor, prompt user to speak so we can assess their level.
  String _getWelcomeMessage(String? lang) {
    switch (lang?.toLowerCase()) {
      case 'spanish':
        return '¡Hola! Soy tu tutor. Toca el micrófono y di hola, o cuéntame algo en español. Te diré en qué nivel estás y te responderé.';
      case 'english':
        return "Hello! I'm your tutor. Tap the mic and say hello, or tell me a bit about yourself. I'll tell you what level you're at and reply.";
      case 'french':
        return 'Bonjour ! Je suis ton tuteur. Appuie sur le micro et dis bonjour, ou dis-moi un peu qui tu es. Je te dirai ton niveau et te répondrai.';
      default:
        return "Hello! I'm your tutor. Tap the mic and say hello, or tell me a bit about yourself. I'll tell you what level you're at and reply.";
    }
  }

  Future<void> _maybePlayWelcome() async {
    if (_welcomePlayed || !_ttsReady || _activeLanguage == null || !mounted) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_welcomePlayedKey) == true) {
      if (mounted) setState(() => _welcomePlayed = true);
      return;
    }
    _welcomePlayed = true;
    await prefs.setBool(_welcomePlayedKey, true);
    final message = _getWelcomeMessage(_activeLanguage);
    await _speakResponse(message);
  }

  String _languageToLocale(String? lang) {
    switch (lang?.toLowerCase()) {
      case 'spanish':
        return 'es-ES';
      case 'english':
        return 'en-US';
      case 'french':
        return 'fr-FR';
      default:
        return 'en-US';
    }
  }

  /// Short language code for TTS fallback when full locale is not available on device.
  String _languageToShortCode(String? lang) {
    switch (lang?.toLowerCase()) {
      case 'spanish':
        return 'es';
      case 'english':
        return 'en';
      case 'french':
        return 'fr';
      default:
        return 'en';
    }
  }

  Future<void> _initializeTTS() async {
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);
    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() {
        _isSpeaking = false;
        _currentSpeakingText = null;
      });
    });
    if (mounted) {
      setState(() => _ttsReady = true);
      _maybePlayWelcome();
    }
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.microphone.status;
    if (mounted) {
      setState(() {
        _permissionGranted = status.isGranted;
      });
      if (status.isGranted) {
        _initializeSpeechRecognition();
      }
    }
  }

  Future<void> _requestMicrophonePermission() async {
    if (!mounted) return;
    final status = await Permission.microphone.status;
    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return;
    }
    if (status.isGranted) {
      setState(() => _permissionGranted = true);
      _initializeSpeechRecognition();
      return;
    }
    final result = await Permission.microphone.request();
    if (!mounted) return;
    setState(() => _permissionGranted = result.isGranted);
    if (result.isGranted) {
      _initializeSpeechRecognition();
    } else if (result.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.talkTutorMicRequired),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(AppLocalizations.of(context)!.talkTutorPermissionRequired),
        content: Text(AppLocalizations.of(context)!.talkTutorPermissionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
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
            child: Text(AppLocalizations.of(context)!.openSettings),
          ),
        ],
      ),
    );
  }

  Future<void> _initializeSpeechRecognition() async {
    final available = await _speech.initialize(
      onStatus: (status) {
        if (mounted) setState(() => _isListening = status == 'listening');
      },
      onError: (_) {},
    );
    if (mounted) {
      setState(() {
        _speechAvailable = available;
        _initialized = true;
      });
    }
  }

  Future<void> _toggleListening() async {
    if (!_permissionGranted) {
      await _requestMicrophonePermission();
      return;
    }
    if (!_speechAvailable || !_initialized) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.talkTutorSpeechUnavailable),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }
    if (_isListening) {
      await _speech.stop();
      return;
    }

    setState(() {
      _recognizedText = '';
      _isListening = true;
    });

    await _speech.listen(
      onResult: (result) async {
        if (!mounted) return;
        setState(() => _recognizedText = result.recognizedWords);
        if (result.finalResult && result.recognizedWords.trim().isNotEmpty) {
          await _speech.stop();
          await _sendToTutor(result.recognizedWords.trim());
        }
      },
      localeId: _languageToLocale(_activeLanguage),
      listenMode: stt.ListenMode.dictation,
      partialResults: true,
    );
  }

  Future<void> _sendToTutor(String transcript) async {
    if (transcript.isEmpty) return;
    setState(() {
      _isLoading = true;
      _isListening = false;
    });

    final history = _conversationHistory.length > _maxHistoryTurns * 2
        ? _conversationHistory.sublist(_conversationHistory.length - _maxHistoryTurns * 2)
        : List<Map<String, String>>.from(_conversationHistory);

    final response = await _talkTutorService.sendMessage(
      transcript,
      language: _activeLanguage ?? 'spanish',
      history: history.isEmpty ? null : history,
      isFirstMessage: _conversationHistory.isEmpty,
    );

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _recognizedText = '';
    });

    if (response == null || response.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.talkTutorError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _conversationHistory.add({'role': 'user', 'content': transcript});
    _conversationHistory.add({'role': 'assistant', 'content': response});

    setState(() {});

    await _speakResponse(response);
  }

  Future<void> _speakResponse(String text) async {
    if (text.trim().isEmpty) return;
    final lang = _activeLanguage ?? 'spanish';
    final locale = _languageToLocale(lang);
    final shortCode = _languageToShortCode(lang);
    try {
      await _flutterTts.setLanguage(locale);
    } catch (_) {
      try {
        await _flutterTts.setLanguage(shortCode);
      } catch (_) {}
    }
    if (!mounted) return;
    setState(() {
      _isSpeaking = true;
      _currentSpeakingText = text;
    });
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  l10n.talkTutor,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                centerTitle: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        l10n.practiceSpeaking,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      GestureDetector(
                        onTap: _isLoading ? null : _toggleListening,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: _isListening
                                  ? [AppTheme.salmonPink, AppTheme.salmonPink.withOpacity(0.8)]
                                  : [AppTheme.primaryMintGreen, AppTheme.softCyan],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (_isListening ? AppTheme.salmonPink : AppTheme.primaryMintGreen)
                                    .withOpacity(0.4),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: _isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(36),
                                  child: CircularProgressIndicator(color: Colors.white),
                                )
                              : Icon(
                                  _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                                  size: 48,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isListening ? l10n.talkTutorListening : l10n.tapToSpeak,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (_isSpeaking && _currentSpeakingText != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.cardWhite.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.primaryMintGreen.withOpacity(0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryMintGreen.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.volume_up_rounded,
                                color: AppTheme.primaryMintGreen,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.talkTutorSpeaking,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: AppTheme.primaryMintGreen,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _currentSpeakingText!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: AppTheme.textPrimary,
                                            height: 1.4,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (_recognizedText.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildBubble(context, _recognizedText, isUser: true),
                      ],
                      if (_conversationHistory.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            l10n.talkTutorConversation,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(
                          _conversationHistory.length,
                          (i) {
                            final isAssistant = _conversationHistory[i]['role'] == 'assistant';
                            final isLatestAssistant = isAssistant &&
                                (i == _conversationHistory.length - 1);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildBubble(
                                context,
                                _conversationHistory[i]['content']!,
                                isUser: !isAssistant,
                                onPlayTts: isAssistant
                                    ? () => _speakResponse(_conversationHistory[i]['content']!)
                                    : null,
                                isSpeaking: isLatestAssistant && _isSpeaking,
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
      ),
    );
  }

  Widget _buildBubble(
    BuildContext context,
    String text, {
    required bool isUser,
    VoidCallback? onPlayTts,
    bool isSpeaking = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUser
            ? AppTheme.primaryMintGreen.withOpacity(0.15)
            : AppTheme.cardWhite.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUser
              ? AppTheme.primaryMintGreen.withOpacity(0.3)
              : AppTheme.textSecondary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
            ),
          ),
          if (onPlayTts != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onPlayTts,
              icon: Icon(
                isSpeaking ? Icons.volume_up_rounded : Icons.volume_up_outlined,
                color: AppTheme.primaryMintGreen,
                size: 24,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
