class Game {
  final String id;
  final String gameId;
  final String name;
  final String? description;
  final String gameType;
  final String? language;
  final int? miniGameNumber;
  final bool isActive;

  Game({
    required this.id,
    required this.gameId,
    required this.name,
    this.description,
    required this.gameType,
    this.language,
    this.miniGameNumber,
    required this.isActive,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as String,
      gameId: json['game_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      gameType: json['game_type'] as String,
      language: json['language'] as String?,
      miniGameNumber: json['mini_game_number'] as int?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_id': gameId,
      'name': name,
      'description': description,
      'game_type': gameType,
      'language': language,
      'mini_game_number': miniGameNumber,
      'is_active': isActive,
    };
  }
}

