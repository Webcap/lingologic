import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'word_popup.dart';
import '../data/remote/supabase_repository.dart';

class ClickableTextWidget extends StatelessWidget {
  final String text;
  final String languageCode;
  final TextStyle? style;
  final TextAlign? textAlign;

  const ClickableTextWidget({
    super.key,
    required this.text,
    required this.languageCode,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    // Split text into words while preserving punctuation
    final words = _parseWords(text);

    if (words.isEmpty) {
      return Text(text, style: style, textAlign: textAlign);
    }

    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(
        children: words.map((wordInfo) {
          if (wordInfo.isWord) {
            return TextSpan(
              text: wordInfo.text,
              style: (style ?? const TextStyle()).copyWith(
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue.withOpacity(0.5),
                decorationThickness: 1.5,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _onWordTap(context, wordInfo.text),
            );
          } else {
            return TextSpan(
              text: wordInfo.text,
              style: style,
            );
          }
        }).toList(),
      ),
    );
  }

  List<_WordInfo> _parseWords(String text) {
    final words = <_WordInfo>[];
    final regex = RegExp(r'\b[\wáéíóúñüÁÉÍÓÚÑÜ]+\b');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      // Add text before the word
      if (match.start > lastEnd) {
        words.add(_WordInfo(
          text: text.substring(lastEnd, match.start),
          isWord: false,
        ));
      }

      // Add the word
      words.add(_WordInfo(
        text: match.group(0)!,
        isWord: true,
      ));

      lastEnd = match.end;
    }

    // Add remaining text after last word
    if (lastEnd < text.length) {
      words.add(_WordInfo(
        text: text.substring(lastEnd),
        isWord: false,
      ));
    }

    return words.isEmpty ? [_WordInfo(text: text, isWord: false)] : words;
  }

  Future<void> _onWordTap(BuildContext context, String wordText) async {
    try {
      // Look up the word in the database
      final repository = SupabaseRepository();
      final word = await repository.getWordByText(
        wordText,
        language: languageCode,
      );

      // Show popup with word info
      await WordPopup.show(
        context,
        word: wordText,
        translation: word?.translation,
        languageCode: languageCode,
        wordData: word,
      );
    } catch (e) {
      // If lookup fails, still show popup with just the word
      await WordPopup.show(
        context,
        word: wordText,
        languageCode: languageCode,
      );
    }
  }
}

class _WordInfo {
  final String text;
  final bool isWord;

  _WordInfo({required this.text, required this.isWord});
}

