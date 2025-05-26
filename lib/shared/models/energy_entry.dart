class EnergyEntry {
  final int? id;
  final DateTime timestamp;
  final int energyLevel; // 1-10 scale
  final String? notes;
  final String? mood;
  final List<String>? tags;

  // Enhanced tracking fields
  final int? sleepQuality; // 1-10 scale
  final double? sleepHours;
  final List<String>? activities; // Exercise, work, social, etc.
  final List<String>? nutrition; // Meals, supplements, etc.
  final List<String>? symptoms; // Health symptoms
  final Map<String, dynamic>? customData; // Flexible additional data

  EnergyEntry({
    this.id,
    required this.timestamp,
    required this.energyLevel,
    this.notes,
    this.mood,
    this.tags,
    this.sleepQuality,
    this.sleepHours,
    this.activities,
    this.nutrition,
    this.symptoms,
    this.customData,
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'energyLevel': energyLevel,
      'notes': notes,
      'mood': mood,
      'tags': tags?.join(','), // Store tags as comma-separated string
      'sleepQuality': sleepQuality,
      'sleepHours': sleepHours,
      'activities': activities?.join(','),
      'nutrition': nutrition?.join(','),
      'symptoms': symptoms?.join(','),
      'customData': customData != null ? _encodeCustomData(customData!) : null,
    };
  }

  // Helper method to encode custom data as JSON string
  String _encodeCustomData(Map<String, dynamic> data) {
    try {
      return data.entries.map((e) => '${e.key}:${e.value}').join('|');
    } catch (e) {
      return '';
    }
  }

  // Create from Map (database retrieval)
  factory EnergyEntry.fromMap(Map<String, dynamic> map) {
    return EnergyEntry(
      id: map['id'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      energyLevel: map['energyLevel'],
      notes: map['notes'],
      mood: map['mood'],
      tags: map['tags'] != null
          ? (map['tags'] as String).split(',').where((tag) => tag.isNotEmpty).toList()
          : null,
      sleepQuality: map['sleepQuality'],
      sleepHours: map['sleepHours']?.toDouble(),
      activities: map['activities'] != null
          ? (map['activities'] as String).split(',').where((item) => item.isNotEmpty).toList()
          : null,
      nutrition: map['nutrition'] != null
          ? (map['nutrition'] as String).split(',').where((item) => item.isNotEmpty).toList()
          : null,
      symptoms: map['symptoms'] != null
          ? (map['symptoms'] as String).split(',').where((item) => item.isNotEmpty).toList()
          : null,
      customData: map['customData'] != null ? _decodeCustomData(map['customData']) : null,
    );
  }

  // Helper method to decode custom data from string
  static Map<String, dynamic>? _decodeCustomData(String? data) {
    if (data == null || data.isEmpty) return null;
    try {
      final Map<String, dynamic> result = {};
      final pairs = data.split('|');
      for (final pair in pairs) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          result[parts[0]] = parts[1];
        }
      }
      return result.isNotEmpty ? result : null;
    } catch (e) {
      return null;
    }
  }

  // Create a copy with updated fields
  EnergyEntry copyWith({
    int? id,
    DateTime? timestamp,
    int? energyLevel,
    String? notes,
    String? mood,
    List<String>? tags,
    int? sleepQuality,
    double? sleepHours,
    List<String>? activities,
    List<String>? nutrition,
    List<String>? symptoms,
    Map<String, dynamic>? customData,
  }) {
    return EnergyEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      energyLevel: energyLevel ?? this.energyLevel,
      notes: notes ?? this.notes,
      mood: mood ?? this.mood,
      tags: tags ?? this.tags,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      sleepHours: sleepHours ?? this.sleepHours,
      activities: activities ?? this.activities,
      nutrition: nutrition ?? this.nutrition,
      symptoms: symptoms ?? this.symptoms,
      customData: customData ?? this.customData,
    );
  }

  @override
  String toString() {
    return 'EnergyEntry{id: $id, timestamp: $timestamp, energyLevel: $energyLevel, notes: $notes, mood: $mood, tags: $tags}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EnergyEntry &&
        other.id == id &&
        other.timestamp == timestamp &&
        other.energyLevel == energyLevel &&
        other.notes == notes &&
        other.mood == mood;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        timestamp.hashCode ^
        energyLevel.hashCode ^
        notes.hashCode ^
        mood.hashCode;
  }
}
