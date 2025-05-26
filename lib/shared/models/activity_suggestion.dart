enum ActivityType {
  exercise,
  work,
  creative,
  social,
  rest,
  learning,
  household,
  selfCare,
}

enum SuggestionReason {
  highEnergyOptimal,
  lowEnergyAppropriate,
  patternBased,
  moodBooster,
  energyBooster,
}

class ActivitySuggestion {
  final String title;
  final String description;
  final ActivityType type;
  final SuggestionReason reason;
  final int recommendedEnergyLevel; // Minimum energy level recommended
  final int expectedEnergyImpact; // -5 to +5 scale
  final Duration estimatedDuration;
  final List<String> tags;
  final double confidence; // 0.0 to 1.0

  ActivitySuggestion({
    required this.title,
    required this.description,
    required this.type,
    required this.reason,
    required this.recommendedEnergyLevel,
    required this.expectedEnergyImpact,
    required this.estimatedDuration,
    this.tags = const [],
    this.confidence = 0.5,
  });

  // Convert to Map for storage/serialization
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'type': type.name,
      'reason': reason.name,
      'recommendedEnergyLevel': recommendedEnergyLevel,
      'expectedEnergyImpact': expectedEnergyImpact,
      'estimatedDurationMinutes': estimatedDuration.inMinutes,
      'tags': tags.join(','),
      'confidence': confidence,
    };
  }

  // Create from Map
  factory ActivitySuggestion.fromMap(Map<String, dynamic> map) {
    return ActivitySuggestion(
      title: map['title'],
      description: map['description'],
      type: ActivityType.values.firstWhere((e) => e.name == map['type']),
      reason: SuggestionReason.values.firstWhere((e) => e.name == map['reason']),
      recommendedEnergyLevel: map['recommendedEnergyLevel'],
      expectedEnergyImpact: map['expectedEnergyImpact'],
      estimatedDuration: Duration(minutes: map['estimatedDurationMinutes']),
      tags: map['tags'] != null 
          ? (map['tags'] as String).split(',').where((tag) => tag.isNotEmpty).toList()
          : [],
      confidence: map['confidence']?.toDouble() ?? 0.5,
    );
  }

  String get reasonDescription {
    switch (reason) {
      case SuggestionReason.highEnergyOptimal:
        return 'Perfect for your high energy periods';
      case SuggestionReason.lowEnergyAppropriate:
        return 'Suitable for when energy is low';
      case SuggestionReason.patternBased:
        return 'Based on your energy patterns';
      case SuggestionReason.moodBooster:
        return 'May help improve your mood';
      case SuggestionReason.energyBooster:
        return 'Could boost your energy levels';
    }
  }

  String get energyImpactDescription {
    if (expectedEnergyImpact > 2) return 'High energy boost';
    if (expectedEnergyImpact > 0) return 'Mild energy boost';
    if (expectedEnergyImpact == 0) return 'Neutral energy impact';
    if (expectedEnergyImpact > -3) return 'Mild energy drain';
    return 'High energy drain';
  }

  @override
  String toString() {
    return 'ActivitySuggestion{title: $title, type: $type, reason: $reason, confidence: $confidence}';
  }
}
