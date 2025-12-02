class LanguageInfo {
  final String code; // 'spanish', 'french', etc.
  final String name; // 'Spanish', 'French'
  final String nativeName; // 'Español', 'Français'
  final String flagEmoji; // '🇪🇸', '🇫🇷'
  final bool isAvailable; // Whether content exists

  const LanguageInfo({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flagEmoji,
    required this.isAvailable,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageInfo &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}

