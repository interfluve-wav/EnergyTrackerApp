import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/energy_provider.dart';
import '../analysis/pattern_analyzer.dart';
import 'kanpeki/accordion.dart';
import 'kanpeki/card.dart';

class EnhancedInsightsDashboard extends StatefulWidget {
  const EnhancedInsightsDashboard({super.key});

  @override
  State<EnhancedInsightsDashboard> createState() => _EnhancedInsightsDashboardState();
}

class _EnhancedInsightsDashboardState extends State<EnhancedInsightsDashboard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EnergyProvider>(
      builder: (context, energyProvider, child) {
        final analyzer = PatternAnalyzer(energyProvider.entries);
        final patterns = analyzer.identifyPatterns();
        final suggestions = analyzer.generateSuggestions();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.insights,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Enhanced Insights & Analytics',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Quick Stats Overview
              _buildQuickStatsGrid(patterns),
              const SizedBox(height: 32),

              // Sleep Correlation Analysis
              _buildSleepCorrelationCard(patterns['sleepCorrelation']),
              const SizedBox(height: 24),

              // Mood-Energy Correlation
              _buildMoodCorrelationCard(patterns['moodCorrelation']),
              const SizedBox(height: 24),

              // Activity Impact Analysis
              _buildActivityImpactCard(patterns['activityImpact']),
              const SizedBox(height: 24),

              // Nutrition Impact Analysis
              _buildNutritionImpactCard(patterns['nutritionImpact']),
              const SizedBox(height: 24),

              // Energy Patterns Accordion
              _buildEnergyPatternsAccordion(patterns),
              const SizedBox(height: 24),

              // Personalized Recommendations
              _buildRecommendationsCard(suggestions),
              const SizedBox(height: 24),

              // Energy Forecast
              _buildEnergyForecastCard(analyzer),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickStatsGrid(Map<String, dynamic> patterns) {
    final avgEnergy = patterns['averageEnergyLevel'] as double;
    final peakHour = patterns['peakEnergyHour'] as int?;
    final lowHour = patterns['lowEnergyHour'] as int?;
    final trend = patterns['energyTrend'] as String;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Average Energy',
          avgEnergy.toStringAsFixed(1),
          Icons.battery_charging_full,
          _getEnergyColor(avgEnergy.round()),
        ),
        _buildStatCard(
          'Peak Time',
          peakHour != null ? '${peakHour}:00' : 'N/A',
          Icons.trending_up,
          Colors.green,
        ),
        _buildStatCard(
          'Low Time',
          lowHour != null ? '${lowHour}:00' : 'N/A',
          Icons.trending_down,
          Colors.orange,
        ),
        _buildStatCard(
          'Trend',
          _getTrendDisplayText(trend),
          _getTrendIcon(trend),
          _getTrendColor(trend),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSleepCorrelationCard(Map<String, dynamic> sleepData) {
    final qualityCorr = sleepData['qualityCorrelation'] as double;
    final hoursCorr = sleepData['hoursCorrelation'] as double;
    final insights = sleepData['insights'] as List<String>;
    final recommendations = sleepData['recommendations'] as List<String>;

    return EnergyInsightCard(
      title: 'Sleep Impact Analysis',
      icon: Icons.bedtime,
      iconColor: Colors.indigo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Correlation Metrics
          Row(
            children: [
              Expanded(
                child: _buildCorrelationMetric(
                  'Quality Correlation',
                  qualityCorr,
                  'Sleep quality vs energy',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCorrelationMetric(
                  'Duration Correlation',
                  hoursCorr,
                  'Sleep hours vs energy',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Insights
          if (insights.isNotEmpty) ...[
            Text(
              'Key Insights:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            ...insights.map((insight) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb, size: 16, color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          insight,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
          ],

          // Recommendations
          if (recommendations.isNotEmpty) ...[
            Text(
              'Recommendations:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            ...recommendations.map((rec) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.arrow_forward, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          rec,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildCorrelationMetric(String title, double correlation, String subtitle) {
    final strength = _getCorrelationStrength(correlation);
    final color = _getCorrelationColor(correlation);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            correlation.toStringAsFixed(2),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          Text(
            strength,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCorrelationCard(Map<String, dynamic> moodData) {
    final moodEnergyMap = moodData['moodEnergyMap'] as Map<String, double>;
    final insights = moodData['insights'] as List<String>;

    return EnergyInsightCard(
      title: 'Mood-Energy Correlation',
      icon: Icons.sentiment_satisfied,
      iconColor: Colors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (moodEnergyMap.isNotEmpty) ...[
            Text(
              'Mood Impact on Energy:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            ...moodEnergyMap.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.key,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: LinearProgressIndicator(
                          value: entry.value / 10,
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getEnergyColor(entry.value.round()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        entry.value.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: _getEnergyColor(entry.value.round()),
                            ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
          ],

          if (insights.isNotEmpty) ...[
            Text(
              'Key Insights:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            ...insights.map((insight) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.psychology, size: 16, color: Colors.purple),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          insight,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  // Helper methods
  Color _getEnergyColor(int level) {
    if (level <= 2) return const Color(0xFFEF4444);
    if (level <= 4) return const Color(0xFFF97316);
    if (level <= 6) return const Color(0xFFEAB308);
    if (level <= 8) return const Color(0xFF84CC16);
    return const Color(0xFF22C55E);
  }

  String _getCorrelationStrength(double correlation) {
    final abs = correlation.abs();
    if (abs >= 0.7) return 'Strong';
    if (abs >= 0.5) return 'Moderate';
    if (abs >= 0.3) return 'Weak';
    return 'Very Weak';
  }

  Color _getCorrelationColor(double correlation) {
    final abs = correlation.abs();
    if (abs >= 0.7) return Colors.green;
    if (abs >= 0.5) return Colors.orange;
    if (abs >= 0.3) return Colors.amber;
    return Colors.grey;
  }

  String _getTrendDisplayText(String trend) {
    switch (trend) {
      case 'improving':
        return 'Improving';
      case 'declining':
        return 'Declining';
      case 'stable':
        return 'Stable';
      default:
        return 'Unknown';
    }
  }

  IconData _getTrendIcon(String trend) {
    switch (trend) {
      case 'improving':
        return Icons.trending_up;
      case 'declining':
        return Icons.trending_down;
      case 'stable':
        return Icons.trending_flat;
      default:
        return Icons.help;
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'improving':
        return Colors.green;
      case 'declining':
        return Colors.red;
      case 'stable':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getActivityTypeIcon(dynamic type) {
    // This would need to be implemented based on your ActivityType enum
    return Icons.fitness_center; // Default icon
  }
}