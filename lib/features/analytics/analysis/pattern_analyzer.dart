import '../models/energy_entry.dart';
import '../models/activity_suggestion.dart';

class PatternAnalyzer {
  List<EnergyEntry> entries;

  PatternAnalyzer(this.entries);

  Map<String, dynamic> identifyPatterns() {
    if (entries.isEmpty) {
      return {
        'hourlyPatterns': <int, double>{},
        'dailyPatterns': <int, double>{},
        'averageEnergyLevel': 0.0,
        'peakEnergyHour': null,
        'lowEnergyHour': null,
        'energyTrend': 'insufficient_data',
        'sleepCorrelation': {},
        'moodCorrelation': {},
        'activityImpact': {},
        'nutritionImpact': {},
      };
    }

    // Analyze energy patterns by time of day
    final hourlyPatterns = _analyzeHourlyPatterns();
    final dailyPatterns = _analyzeDailyPatterns();
    final averageEnergyLevel = _calculateAverageEnergyLevel();
    final peakEnergyHour = _findPeakEnergyHour(hourlyPatterns);
    final lowEnergyHour = _findLowEnergyHour(hourlyPatterns);
    final energyTrend = _calculateEnergyTrend();

    // Enhanced analysis
    final sleepCorrelation = _analyzeSleepCorrelation();
    final moodCorrelation = _analyzeMoodCorrelation();
    final activityImpact = _analyzeActivityImpact();
    final nutritionImpact = _analyzeNutritionImpact();

    return {
      'hourlyPatterns': hourlyPatterns,
      'dailyPatterns': dailyPatterns,
      'averageEnergyLevel': averageEnergyLevel,
      'peakEnergyHour': peakEnergyHour,
      'lowEnergyHour': lowEnergyHour,
      'energyTrend': energyTrend,
      'sleepCorrelation': sleepCorrelation,
      'moodCorrelation': moodCorrelation,
      'activityImpact': activityImpact,
      'nutritionImpact': nutritionImpact,
      'totalEntries': entries.length,
      'dateRange': {
        'start': entries.last.timestamp,
        'end': entries.first.timestamp,
      },
    };
  }

  List<ActivitySuggestion> generateSuggestions() {
    final patterns = identifyPatterns();
    final suggestions = <ActivitySuggestion>[];

    final currentHour = DateTime.now().hour;
    final hourlyPatterns = patterns['hourlyPatterns'] as Map<int, double>;
    final averageEnergy = patterns['averageEnergyLevel'] as double;

    // Get current hour's typical energy level
    final currentHourEnergy = hourlyPatterns[currentHour] ?? averageEnergy;

    // Generate suggestions based on current energy patterns
    if (currentHourEnergy >= 7) {
      // High energy suggestions
      suggestions.addAll(_getHighEnergySuggestions());
    } else if (currentHourEnergy >= 4) {
      // Medium energy suggestions
      suggestions.addAll(_getMediumEnergySuggestions());
    } else {
      // Low energy suggestions
      suggestions.addAll(_getLowEnergySuggestions());
    }

    // Add pattern-based suggestions
    suggestions.addAll(_getPatternBasedSuggestions(patterns));

    // Sort by confidence and return top suggestions
    suggestions.sort((a, b) => b.confidence.compareTo(a.confidence));
    return suggestions.take(5).toList();
  }

  Map<int, double> _analyzeHourlyPatterns() {
    final hourlyData = <int, List<int>>{};

    for (final entry in entries) {
      final hour = entry.timestamp.hour;
      hourlyData.putIfAbsent(hour, () => []).add(entry.energyLevel);
    }

    return hourlyData.map((hour, energyLevels) {
      final average = energyLevels.reduce((a, b) => a + b) / energyLevels.length;
      return MapEntry(hour, average);
    });
  }

  Map<int, double> _analyzeDailyPatterns() {
    final dailyData = <int, List<int>>{};

    for (final entry in entries) {
      final weekday = entry.timestamp.weekday;
      dailyData.putIfAbsent(weekday, () => []).add(entry.energyLevel);
    }

    return dailyData.map((day, energyLevels) {
      final average = energyLevels.reduce((a, b) => a + b) / energyLevels.length;
      return MapEntry(day, average);
    });
  }

  double _calculateAverageEnergyLevel() {
    if (entries.isEmpty) return 0.0;
    final total = entries.fold(0, (sum, entry) => sum + entry.energyLevel);
    return total / entries.length;
  }

  int? _findPeakEnergyHour(Map<int, double> hourlyPatterns) {
    if (hourlyPatterns.isEmpty) return null;
    return hourlyPatterns.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  int? _findLowEnergyHour(Map<int, double> hourlyPatterns) {
    if (hourlyPatterns.isEmpty) return null;
    return hourlyPatterns.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;
  }

  String _calculateEnergyTrend() {
    if (entries.length < 7) return 'insufficient_data';

    final recentEntries = entries.take(7).toList();
    final olderEntries = entries.skip(7).take(7).toList();

    if (olderEntries.isEmpty) return 'insufficient_data';

    final recentAverage = recentEntries.fold(0, (sum, entry) => sum + entry.energyLevel) / recentEntries.length;
    final olderAverage = olderEntries.fold(0, (sum, entry) => sum + entry.energyLevel) / olderEntries.length;

    final difference = recentAverage - olderAverage;

    if (difference > 0.5) return 'improving';
    if (difference < -0.5) return 'declining';
    return 'stable';
  }

  List<ActivitySuggestion> _getHighEnergySuggestions() {
    return [
      ActivitySuggestion(
        title: 'Intense Workout',
        description: 'Perfect time for high-intensity exercise or strength training',
        type: ActivityType.exercise,
        reason: SuggestionReason.highEnergyOptimal,
        recommendedEnergyLevel: 7,
        expectedEnergyImpact: 2,
        estimatedDuration: const Duration(minutes: 45),
        confidence: 0.9,
      ),
      ActivitySuggestion(
        title: 'Tackle Complex Tasks',
        description: 'Focus on challenging work or learning activities',
        type: ActivityType.work,
        reason: SuggestionReason.highEnergyOptimal,
        recommendedEnergyLevel: 7,
        expectedEnergyImpact: -1,
        estimatedDuration: const Duration(hours: 2),
        confidence: 0.85,
      ),
    ];
  }

  List<ActivitySuggestion> _getMediumEnergySuggestions() {
    return [
      ActivitySuggestion(
        title: 'Light Exercise',
        description: 'Go for a walk or do some yoga',
        type: ActivityType.exercise,
        reason: SuggestionReason.energyBooster,
        recommendedEnergyLevel: 4,
        expectedEnergyImpact: 1,
        estimatedDuration: const Duration(minutes: 30),
        confidence: 0.8,
      ),
      ActivitySuggestion(
        title: 'Creative Work',
        description: 'Engage in creative projects or hobbies',
        type: ActivityType.creative,
        reason: SuggestionReason.moodBooster,
        recommendedEnergyLevel: 4,
        expectedEnergyImpact: 1,
        estimatedDuration: const Duration(hours: 1),
        confidence: 0.75,
      ),
    ];
  }

  List<ActivitySuggestion> _getLowEnergySuggestions() {
    return [
      ActivitySuggestion(
        title: 'Meditation',
        description: 'Take time for mindfulness and relaxation',
        type: ActivityType.selfCare,
        reason: SuggestionReason.lowEnergyAppropriate,
        recommendedEnergyLevel: 1,
        expectedEnergyImpact: 2,
        estimatedDuration: const Duration(minutes: 15),
        confidence: 0.9,
      ),
      ActivitySuggestion(
        title: 'Light Reading',
        description: 'Read something enjoyable or educational',
        type: ActivityType.learning,
        reason: SuggestionReason.lowEnergyAppropriate,
        recommendedEnergyLevel: 2,
        expectedEnergyImpact: 0,
        estimatedDuration: const Duration(minutes: 30),
        confidence: 0.8,
      ),
    ];
  }

  List<ActivitySuggestion> _getPatternBasedSuggestions(Map<String, dynamic> patterns) {
    final suggestions = <ActivitySuggestion>[];
    final trend = patterns['energyTrend'] as String;

    if (trend == 'declining') {
      suggestions.add(
        ActivitySuggestion(
          title: 'Energy Assessment',
          description: 'Consider what might be affecting your energy levels',
          type: ActivityType.selfCare,
          reason: SuggestionReason.patternBased,
          recommendedEnergyLevel: 1,
          expectedEnergyImpact: 1,
          estimatedDuration: const Duration(minutes: 10),
          confidence: 0.7,
        ),
      );
    }

    return suggestions;
  }

  /// Analyze correlation between sleep and energy levels
  Map<String, dynamic> _analyzeSleepCorrelation() {
    final sleepEntries = entries.where((e) => e.sleepQuality != null || e.sleepHours != null).toList();

    if (sleepEntries.length < 3) {
      return {
        'qualityCorrelation': 0.0,
        'hoursCorrelation': 0.0,
        'insights': <String>[],
        'recommendations': <String>[],
      };
    }

    double qualityCorrelation = 0.0;
    double hoursCorrelation = 0.0;

    // Calculate correlation between sleep quality and energy
    final qualityEntries = sleepEntries.where((e) => e.sleepQuality != null).toList();
    if (qualityEntries.length >= 3) {
      qualityCorrelation = _calculateCorrelation(
        qualityEntries.map((e) => e.sleepQuality!.toDouble()).toList(),
        qualityEntries.map((e) => e.energyLevel.toDouble()).toList(),
      );
    }

    // Calculate correlation between sleep hours and energy
    final hoursEntries = sleepEntries.where((e) => e.sleepHours != null).toList();
    if (hoursEntries.length >= 3) {
      hoursCorrelation = _calculateCorrelation(
        hoursEntries.map((e) => e.sleepHours!).toList(),
        hoursEntries.map((e) => e.energyLevel.toDouble()).toList(),
      );
    }

    final insights = <String>[];
    final recommendations = <String>[];

    if (qualityCorrelation > 0.5) {
      insights.add('Strong positive correlation between sleep quality and energy levels');
      recommendations.add('Focus on improving sleep quality for better energy');
    }

    if (hoursCorrelation > 0.3) {
      insights.add('Sleep duration significantly impacts your energy levels');
      final avgHours = hoursEntries.map((e) => e.sleepHours!).reduce((a, b) => a + b) / hoursEntries.length;
      if (avgHours < 7) {
        recommendations.add('Consider getting more sleep - aim for 7-9 hours per night');
      } else if (avgHours > 9) {
        recommendations.add('You might be oversleeping - try reducing sleep duration slightly');
      }
    }

    return {
      'qualityCorrelation': qualityCorrelation,
      'hoursCorrelation': hoursCorrelation,
      'insights': insights,
      'recommendations': recommendations,
      'optimalSleepHours': _findOptimalSleepHours(hoursEntries),
      'optimalSleepQuality': _findOptimalSleepQuality(qualityEntries),
    };
  }

  /// Analyze correlation between mood and energy levels
  Map<String, dynamic> _analyzeMoodCorrelation() {
    final moodEntries = entries.where((e) => e.mood != null).toList();

    if (moodEntries.length < 3) {
      return {
        'moodEnergyMap': <String, double>{},
        'insights': <String>[],
        'recommendations': <String>[],
      };
    }

    // Group by mood and calculate average energy
    final moodEnergyMap = <String, List<int>>{};
    for (final entry in moodEntries) {
      moodEnergyMap.putIfAbsent(entry.mood!, () => []).add(entry.energyLevel);
    }

    final moodAverages = moodEnergyMap.map((mood, energyLevels) {
      final average = energyLevels.reduce((a, b) => a + b) / energyLevels.length;
      return MapEntry(mood, average);
    });

    final insights = <String>[];
    final recommendations = <String>[];

    // Find best and worst moods for energy
    if (moodAverages.isNotEmpty) {
      final bestMood = moodAverages.entries.reduce((a, b) => a.value > b.value ? a : b);
      final worstMood = moodAverages.entries.reduce((a, b) => a.value < b.value ? a : b);

      insights.add('Your energy is highest when feeling ${bestMood.key} (avg: ${bestMood.value.toStringAsFixed(1)})');
      insights.add('Your energy is lowest when feeling ${worstMood.key} (avg: ${worstMood.value.toStringAsFixed(1)})');

      if (bestMood.value - worstMood.value > 2) {
        recommendations.add('Focus on activities that promote ${bestMood.key} mood');
        recommendations.add('Identify triggers that lead to ${worstMood.key} mood and work to minimize them');
      }
    }

    return {
      'moodEnergyMap': moodAverages,
      'insights': insights,
      'recommendations': recommendations,
    };
  }

  /// Analyze impact of activities on energy levels
  Map<String, dynamic> _analyzeActivityImpact() {
    final activityEntries = entries.where((e) => e.activities != null && e.activities!.isNotEmpty).toList();

    if (activityEntries.length < 3) {
      return {
        'activityImpact': <String, double>{},
        'insights': <String>[],
        'recommendations': <String>[],
      };
    }

    final activityEnergyMap = <String, List<int>>{};
    for (final entry in activityEntries) {
      for (final activity in entry.activities!) {
        activityEnergyMap.putIfAbsent(activity, () => []).add(entry.energyLevel);
      }
    }

    final activityAverages = activityEnergyMap.map((activity, energyLevels) {
      final average = energyLevels.reduce((a, b) => a + b) / energyLevels.length;
      return MapEntry(activity, average);
    });

    final insights = <String>[];
    final recommendations = <String>[];

    if (activityAverages.isNotEmpty) {
      final bestActivity = activityAverages.entries.reduce((a, b) => a.value > b.value ? a : b);
      final worstActivity = activityAverages.entries.reduce((a, b) => a.value < b.value ? a : b);

      insights.add('${bestActivity.key} is associated with your highest energy levels');
      recommendations.add('Consider doing more ${bestActivity.key} activities');

      if (worstActivity.value < 4) {
        insights.add('${worstActivity.key} seems to drain your energy');
        recommendations.add('Try to limit ${worstActivity.key} or find ways to make it more energizing');
      }
    }

    return {
      'activityImpact': activityAverages,
      'insights': insights,
      'recommendations': recommendations,
    };
  }

  /// Analyze impact of nutrition on energy levels
  Map<String, dynamic> _analyzeNutritionImpact() {
    final nutritionEntries = entries.where((e) => e.nutrition != null && e.nutrition!.isNotEmpty).toList();

    if (nutritionEntries.length < 3) {
      return {
        'nutritionImpact': <String, double>{},
        'insights': <String>[],
        'recommendations': <String>[],
      };
    }

    final nutritionEnergyMap = <String, List<int>>{};
    for (final entry in nutritionEntries) {
      for (final nutrition in entry.nutrition!) {
        nutritionEnergyMap.putIfAbsent(nutrition, () => []).add(entry.energyLevel);
      }
    }

    final nutritionAverages = nutritionEnergyMap.map((nutrition, energyLevels) {
      final average = energyLevels.reduce((a, b) => a + b) / energyLevels.length;
      return MapEntry(nutrition, average);
    });

    final insights = <String>[];
    final recommendations = <String>[];

    if (nutritionAverages.isNotEmpty) {
      final bestNutrition = nutritionAverages.entries.reduce((a, b) => a.value > b.value ? a : b);
      final worstNutrition = nutritionAverages.entries.reduce((a, b) => a.value < b.value ? a : b);

      insights.add('${bestNutrition.key} is associated with higher energy levels');
      recommendations.add('Consider including more ${bestNutrition.key} in your diet');

      if (worstNutrition.value < 4) {
        insights.add('${worstNutrition.key} may be negatively affecting your energy');
        recommendations.add('Consider reducing ${worstNutrition.key} or timing it differently');
      }
    }

    return {
      'nutritionImpact': nutritionAverages,
      'insights': insights,
      'recommendations': recommendations,
    };
  }

  /// Calculate Pearson correlation coefficient between two lists
  double _calculateCorrelation(List<double> x, List<double> y) {
    if (x.length != y.length || x.length < 2) return 0.0;

    final n = x.length;
    final sumX = x.reduce((a, b) => a + b);
    final sumY = y.reduce((a, b) => a + b);
    final sumXY = List.generate(n, (i) => x[i] * y[i]).reduce((a, b) => a + b);
    final sumX2 = x.map((val) => val * val).reduce((a, b) => a + b);
    final sumY2 = y.map((val) => val * val).reduce((a, b) => a + b);

    final numerator = (n * sumXY) - (sumX * sumY);
    final denominator = ((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY));

    if (denominator <= 0) return 0.0;

    return numerator / (denominator.sqrt());
  }

  /// Find optimal sleep hours based on energy correlation
  double? _findOptimalSleepHours(List<EnergyEntry> hoursEntries) {
    if (hoursEntries.length < 3) return null;

    final hourEnergyMap = <double, List<int>>{};
    for (final entry in hoursEntries) {
      final roundedHours = (entry.sleepHours! * 2).round() / 2; // Round to nearest 0.5
      hourEnergyMap.putIfAbsent(roundedHours, () => []).add(entry.energyLevel);
    }

    if (hourEnergyMap.isEmpty) return null;

    final hourAverages = hourEnergyMap.map((hours, energyLevels) {
      final average = energyLevels.reduce((a, b) => a + b) / energyLevels.length;
      return MapEntry(hours, average);
    });

    return hourAverages.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Find optimal sleep quality based on energy correlation
  int? _findOptimalSleepQuality(List<EnergyEntry> qualityEntries) {
    if (qualityEntries.length < 3) return null;

    final qualityEnergyMap = <int, List<int>>{};
    for (final entry in qualityEntries) {
      qualityEnergyMap.putIfAbsent(entry.sleepQuality!, () => []).add(entry.energyLevel);
    }

    if (qualityEnergyMap.isEmpty) return null;

    final qualityAverages = qualityEnergyMap.map((quality, energyLevels) {
      final average = energyLevels.reduce((a, b) => a + b) / energyLevels.length;
      return MapEntry(quality, average);
    });

    return qualityAverages.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Predict energy level for a given time based on historical patterns
  double predictEnergyLevel(DateTime targetTime) {
    final hourOfDay = targetTime.hour;
    final dayOfWeek = targetTime.weekday;

    final patterns = identifyPatterns();
    final hourlyPatterns = patterns['hourlyPatterns'] as Map<int, double>;
    final dailyPatterns = patterns['dailyPatterns'] as Map<int, double>;

    double timeScore = hourlyPatterns[hourOfDay] ?? 5.0;
    double dayScore = dailyPatterns[dayOfWeek] ?? 5.0;

    // Weight time of day more heavily than day of week
    return (timeScore * 0.7) + (dayScore * 0.3);
  }
}
