import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/energy_provider.dart';

class QuickStatsCard extends StatelessWidget {
  const QuickStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EnergyProvider>(
      builder: (context, energyProvider, child) {
        final todayAverage = energyProvider.todayAverageEnergy;
        final todayEntries = energyProvider.todayEntries.length;
        final weeklyAverage = energyProvider.weeklyAverageEnergy;
        final trend = energyProvider.energyTrend;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.today_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Today\'s Energy',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                _buildTrendIndicator(context, trend),
              ],
            ),
            const SizedBox(height: 20),

            // Main stats row
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Average',
                    todayAverage.toStringAsFixed(1),
                    Icons.trending_up,
                    _getEnergyColor(todayAverage.round()),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Entries',
                    todayEntries.toString(),
                    Icons.edit_note,
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Weekly Avg',
                    weeklyAverage.toStringAsFixed(1),
                    Icons.calendar_view_week,
                    Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Energy level indicator
            _buildEnergyLevelIndicator(context, todayAverage),

            const SizedBox(height: 16),

            // Quick insights
            _buildQuickInsight(context, todayAverage, trend),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendIndicator(BuildContext context, String trend) {
    IconData icon;
    Color color;
    String text;

    switch (trend) {
      case 'improving':
        icon = Icons.trending_up;
        color = Colors.green;
        text = 'Improving';
        break;
      case 'declining':
        icon = Icons.trending_down;
        color = Colors.red;
        text = 'Declining';
        break;
      default:
        icon = Icons.trending_flat;
        color = Colors.grey;
        text = 'Stable';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyLevelIndicator(BuildContext context, double average) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Energy Level',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              '${average.toStringAsFixed(1)}/10',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getEnergyColor(average.round()),
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: average / 10,
          backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(_getEnergyColor(average.round())),
          borderRadius: BorderRadius.circular(4),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildQuickInsight(BuildContext context, double average, String trend) {
    String insight;
    IconData icon;
    Color color;

    if (average >= 8) {
      insight = 'You\'re having a high-energy day! Perfect time for challenging tasks.';
      icon = Icons.bolt;
      color = Colors.green;
    } else if (average >= 6) {
      insight = 'Good energy levels today. You\'re on track for a productive day.';
      icon = Icons.check_circle_outline;
      color = Colors.blue;
    } else if (average >= 4) {
      insight = 'Moderate energy today. Consider some light activities to boost it.';
      icon = Icons.info_outline;
      color = Colors.orange;
    } else {
      insight = 'Low energy today. Focus on rest and self-care activities.';
      icon = Icons.self_improvement;
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              insight,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getEnergyColor(int level) {
    if (level <= 2) return Colors.red;
    if (level <= 4) return Colors.orange;
    if (level <= 6) return Colors.yellow.shade700;
    if (level <= 8) return Colors.lightGreen;
    return Colors.green;
  }
}
