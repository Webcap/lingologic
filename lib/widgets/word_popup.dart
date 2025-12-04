import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/word.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class WordPopup extends StatefulWidget {
  final String word;
  final String? translation;
  final String languageCode;
  final Word? wordData;

  const WordPopup({
    super.key,
    required this.word,
    this.translation,
    required this.languageCode,
    this.wordData,
  });

  @override
  State<WordPopup> createState() => _WordPopupState();

  static Future<void> show(
    BuildContext context, {
    required String word,
    String? translation,
    required String languageCode,
    Word? wordData,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => WordPopup(
        word: word,
        translation: translation,
        languageCode: languageCode,
        wordData: wordData,
      ),
    );
  }
}

class _WordPopupState extends State<WordPopup> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    // Convert simple language code to full locale code for TTS
    String ttsLanguageCode = _getTTSLanguageCode(widget.languageCode);
    await _flutterTts.setLanguage(ttsLanguageCode);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });
  }

  String _getTTSLanguageCode(String languageCode) {
    // Map simple language codes to TTS locale codes
    switch (languageCode.toLowerCase()) {
      case 'es':
        return 'es-ES';
      case 'en':
        return 'en-US';
      default:
        // If already in full format (e.g., 'es-ES'), return as is
        if (languageCode.contains('-')) {
          return languageCode;
        }
        // Default fallback
        return 'en-US';
    }
  }

  Future<void> _playPronunciation() async {
    setState(() {
      _isSpeaking = true;
    });

    await _flutterTts.speak(widget.word);

    // Fallback to set speaking false after a delay in case completion handler doesn't fire
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translation = widget.translation ?? widget.wordData?.translation ?? '';
    
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 350),
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Word display
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.electricLavender.withOpacity(0.2),
                    AppTheme.softCyan.withOpacity(0.2),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    widget.word,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  if (translation.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      translation,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            // Pronunciation button
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSpeaking ? null : _playPronunciation,
                      icon: Icon(
                        _isSpeaking
                            ? Icons.volume_up_rounded
                            : Icons.volume_up_outlined,
                        size: 22,
                      ),
                      label: Text(
                        _isSpeaking
                            ? AppLocalizations.of(context)!.playing
                            : AppLocalizations.of(context)!.hearPronunciation,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryMintGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(AppLocalizations.of(context)!.close),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
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
}

