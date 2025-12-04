class FeatureFlag {
  final String id;
  final String key;
  final String name;
  final String? description;
  final bool enabled;
  final int enabledForPercentage;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  FeatureFlag({
    required this.id,
    required this.key,
    required this.name,
    this.description,
    required this.enabled,
    required this.enabledForPercentage,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeatureFlag.fromJson(Map<String, dynamic> json) {
    return FeatureFlag(
      id: json['id'] as String,
      key: json['key'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      enabled: json['enabled'] as bool? ?? false,
      enabledForPercentage: json['enabled_for_percentage'] as int? ?? 100,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'name': name,
      'description': description,
      'enabled': enabled,
      'enabled_for_percentage': enabledForPercentage,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  FeatureFlag copyWith({
    String? id,
    String? key,
    String? name,
    String? description,
    bool? enabled,
    int? enabledForPercentage,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FeatureFlag(
      id: id ?? this.id,
      key: key ?? this.key,
      name: name ?? this.name,
      description: description ?? this.description,
      enabled: enabled ?? this.enabled,
      enabledForPercentage: enabledForPercentage ?? this.enabledForPercentage,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


