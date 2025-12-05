import 'package:flutter/material.dart';

/// Enum representing different types of mini games
enum MiniGameType {
  vocabularyReview('vocabulary_review'),
  wordSearch('word_search'),
  neuroMatch('neuro_match'),
  syntaxConstructor('syntax_constructor'),
  pictionary('pictionary'),
  imageToWord('image_to_word'),
  hangman('hangman'),
  charades('charades');

  const MiniGameType(this.value);
  final String value;

  /// Get a fun, display-friendly name for the game
  String getFunName(int miniGameNumber) {
    switch (this) {
      case MiniGameType.vocabularyReview:
        return 'Vocabulary Review';
      case MiniGameType.wordSearch:
        return 'Word Search';
      case MiniGameType.neuroMatch:
        return 'Neuro Match';
      case MiniGameType.syntaxConstructor:
        return 'Syntax Constructor';
      case MiniGameType.pictionary:
        return 'Pictionary';
      case MiniGameType.imageToWord:
        return 'Image to Word';
      case MiniGameType.hangman:
        return 'Hangman';
      case MiniGameType.charades:
        return 'Charades';
    }
  }

  /// Get the description of the game
  String get description {
    switch (this) {
      case MiniGameType.vocabularyReview:
        return 'Review and practice vocabulary';
      case MiniGameType.wordSearch:
        return 'Find words hidden in a grid';
      case MiniGameType.neuroMatch:
        return 'Fast-paced word matching game';
      case MiniGameType.syntaxConstructor:
        return 'Build sentences with drag & drop';
      case MiniGameType.pictionary:
        return 'Draw and guess words';
      case MiniGameType.imageToWord:
        return 'Match images to words';
      case MiniGameType.hangman:
        return 'Guess the word letter by letter';
      case MiniGameType.charades:
        return 'Act out and guess words';
    }
  }

  /// Get the icon for the game
  IconData get icon {
    switch (this) {
      case MiniGameType.vocabularyReview:
        return Icons.book_rounded;
      case MiniGameType.wordSearch:
        return Icons.search_rounded;
      case MiniGameType.neuroMatch:
        return Icons.psychology_rounded;
      case MiniGameType.syntaxConstructor:
        return Icons.construction_rounded;
      case MiniGameType.pictionary:
        return Icons.edit_rounded;
      case MiniGameType.imageToWord:
        return Icons.image_rounded;
      case MiniGameType.hangman:
        return Icons.games_rounded;
      case MiniGameType.charades:
        return Icons.theater_comedy_rounded;
    }
  }

  /// Convert from string value (database)
  static MiniGameType? fromString(String value) {
    for (final type in MiniGameType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return null;
  }
}

/// Enum representing difficulty levels for mini games
enum MiniGameDifficulty {
  easy,
  medium,
  hard;

  /// Create difficulty from mini game number
  /// Lower numbers = easier, higher numbers = harder
  static MiniGameDifficulty fromMiniGameNumber(int miniGameNumber) {
    if (miniGameNumber <= 3) {
      return MiniGameDifficulty.easy;
    } else if (miniGameNumber <= 6) {
      return MiniGameDifficulty.medium;
    } else {
      return MiniGameDifficulty.hard;
    }
  }

  /// Get the number of words for word search games based on difficulty
  int get wordCount {
    switch (this) {
      case MiniGameDifficulty.easy:
        return 6;
      case MiniGameDifficulty.medium:
        return 8;
      case MiniGameDifficulty.hard:
        return 10;
    }
  }

  /// Get the time limit in seconds based on difficulty
  int get timeLimitSeconds {
    switch (this) {
      case MiniGameDifficulty.easy:
        return 180; // 3 minutes
      case MiniGameDifficulty.medium:
        return 150; // 2.5 minutes
      case MiniGameDifficulty.hard:
        return 120; // 2 minutes
    }
  }
}