class Word {
  final String id;
  final String language;
  final String wordText;
  final String translation;
  final String? imageUrl;
  final String? audioUrl;
  final String category;

  Word({
    required this.id,
    required this.language,
    required this.wordText,
    required this.translation,
    this.imageUrl,
    this.audioUrl,
    required this.category,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'] as String,
      language: json['language'] as String,
      wordText: json['word_text'] as String,
      translation: json['translation'] as String,
      imageUrl: json['image_url'] as String?,
      audioUrl: json['audio_url'] as String?,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'language': language,
      'word_text': wordText,
      'translation': translation,
      'image_url': imageUrl,
      'audio_url': audioUrl,
      'category': category,
    };
  }
}

