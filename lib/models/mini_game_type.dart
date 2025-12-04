import 'dart:math';
import 'package:flutter/material.dart';

/// Enum representing different types of mini games
enum MiniGameType {
  vocabularyReview,
  neuroMatch,
  syntaxConstructor,
  wordSearch,
  pictionary,
  imageToWord;

  String get displayName {
    switch (this) {
      case MiniGameType.vocabularyReview:
        return 'Vocabulary Review';
      case MiniGameType.neuroMatch:
        return 'Neuro Match';
      case MiniGameType.syntaxConstructor:
        return 'Syntax Constructor';
      case MiniGameType.wordSearch:
        return 'Word Search';
      case MiniGameType.pictionary:
        return 'Pictionary';
      case MiniGameType.imageToWord:
        return 'Image to Word';
    }
  }

  /// Get a fun random name for this game type based on mini game number
  /// Uses the mini game number as a seed to ensure consistency
  /// This is a fallback method - prefer using database-stored names via MiniGameService
  String getFunName(int miniGameNumber) {
    final random = Random(miniGameNumber);
    
    switch (this) {
      case MiniGameType.vocabularyReview:
        final names = [
          'Word Wizard',
          'Vocab Victory',
          'Lexicon Quest',
          'Word Warrior',
          'Vocabulary Voyage',
          'Word Whiz',
          'Lexicon Legend',
          'Vocab Venture',
          'Word Wonder',
          'Dictionary Dash',
          'Word Wizardry',
          'Vocab Victory',
        ];
        return names[random.nextInt(names.length)];
        
      case MiniGameType.wordSearch:
        final names = [
          'Letter Hunt',
          'Word Detective',
          'Grid Explorer',
          'Letter Quest',
          'Word Finder',
          'Grid Master',
          'Letter Seeker',
          'Word Hunter',
          'Grid Navigator',
          'Letter Tracker',
          'Word Scout',
          'Grid Explorer',
        ];
        return names[random.nextInt(names.length)];
        
      case MiniGameType.neuroMatch:
        final names = [
          'Speed Match',
          'Lightning Link',
          'Rapid Recall',
          'Flash Match',
          'Quick Connect',
          'Speed Sprint',
          'Rapid Reflex',
          'Flash Find',
          'Quick Quest',
          'Speed Strike',
          'Rapid Round',
          'Flash Focus',
        ];
        return names[random.nextInt(names.length)];
        
      case MiniGameType.syntaxConstructor:
        final names = [
          'Sentence Builder',
          'Grammar Guru',
          'Syntax Studio',
          'Sentence Craft',
          'Grammar Genius',
          'Syntax Savant',
          'Sentence Sculptor',
          'Grammar Guide',
          'Syntax Specialist',
          'Sentence Shaper',
          'Grammar Guardian',
          'Syntax Sage',
        ];
        return names[random.nextInt(names.length)];
        
      case MiniGameType.pictionary:
        final names = [
          'Draw & Learn',
          'Sketch Master',
          'Artistic Words',
          'Draw Quest',
          'Creative Canvas',
          'Picture Perfect',
          'Drawing Dash',
          'Sketch Sprint',
          'Art Adventure',
          'Draw Delight',
          'Creative Challenge',
          'Picture Power',
        ];
        return names[random.nextInt(names.length)];
        
      case MiniGameType.imageToWord:
        final names = [
          'Visual Vocab',
          'Picture Puzzle',
          'Image Quest',
          'Visual Match',
          'Picture Power',
          'Image Insight',
          'Visual Victory',
          'Picture Perfect',
          'Image Intel',
          'Visual Venture',
          'Picture Pro',
          'Image Impact',
        ];
        return names[random.nextInt(names.length)];
    }
  }

  String get description {
    switch (this) {
      case MiniGameType.vocabularyReview:
        return 'Test your vocabulary knowledge with multiple choice questions';
      case MiniGameType.neuroMatch:
        return 'Match words quickly as they fall from the top';
      case MiniGameType.syntaxConstructor:
        return 'Build sentences by dragging and dropping words';
      case MiniGameType.wordSearch:
        return 'Find hidden words in a letter grid';
      case MiniGameType.pictionary:
        return 'Draw words to reinforce visual memory';
      case MiniGameType.imageToWord:
        return 'Type the word shown in the image';
    }
  }

  IconData get icon {
    switch (this) {
      case MiniGameType.vocabularyReview:
        return Icons.quiz_rounded;
      case MiniGameType.neuroMatch:
        return Icons.speed_rounded;
      case MiniGameType.syntaxConstructor:
        return Icons.construction_rounded;
      case MiniGameType.wordSearch:
        return Icons.grid_view_rounded;
      case MiniGameType.pictionary:
        return Icons.draw_rounded;
      case MiniGameType.imageToWord:
        return Icons.image_rounded;
    }
  }
}

/// Configuration for mini game difficulty
class MiniGameDifficulty {
  final int miniGameNumber;
  final int wordCount;
  final int? timeLimitSeconds;
  final int optionCount;
  final double speedMultiplier; // For games with speed elements

  const MiniGameDifficulty({
    required this.miniGameNumber,
    required this.wordCount,
    this.timeLimitSeconds,
    required this.optionCount,
    this.speedMultiplier = 1.0,
  });

  /// Calculate difficulty based on mini game number
  /// Difficulty increases: more words, fewer options, time limits, faster speeds
  factory MiniGameDifficulty.fromMiniGameNumber(int miniGameNumber) {
    // Progressive difficulty
    // Mini game 1: 10 words, 4 options, no time limit
    // Mini game 2: 12 words, 4 options, no time limit
    // Mini game 3: 15 words, 4 options, 120s time limit
    // Mini game 4: 18 words, 3 options, 90s time limit
    // Mini game 5+: 20 words, 3 options, 60s time limit, faster speed
    
    int wordCount;
    int optionCount;
    int? timeLimitSeconds;
    double speedMultiplier;
    
    if (miniGameNumber == 1) {
      wordCount = 10;
      optionCount = 4;
      timeLimitSeconds = null;
      speedMultiplier = 1.0;
    } else if (miniGameNumber == 2) {
      wordCount = 12;
      optionCount = 4;
      timeLimitSeconds = null;
      speedMultiplier = 1.1;
    } else if (miniGameNumber == 3) {
      wordCount = 15;
      optionCount = 4;
      timeLimitSeconds = 120;
      speedMultiplier = 1.2;
    } else if (miniGameNumber == 4) {
      wordCount = 18;
      optionCount = 3;
      timeLimitSeconds = 90;
      speedMultiplier = 1.3;
    } else {
      // Mini game 5 and beyond
      wordCount = 20;
      optionCount = 3;
      timeLimitSeconds = 60;
      speedMultiplier = 1.0 + (miniGameNumber - 1) * 0.1;
    }
    
    return MiniGameDifficulty(
      miniGameNumber: miniGameNumber,
      wordCount: wordCount,
      timeLimitSeconds: timeLimitSeconds,
      optionCount: optionCount,
      speedMultiplier: speedMultiplier,
    );
  }
}

