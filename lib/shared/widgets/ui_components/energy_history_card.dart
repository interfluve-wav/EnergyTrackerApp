import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/energy_provider.dart';
import '../models/energy_entry.dart';

class EnergyHistoryCard extends StatelessWidget {
  const EnergyHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EnergyProvider>(
      builder: (context, energyProvider, child) {
        final recentEntries = energyProvider.entries.take(3).toList();

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
                  Icons.history,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent Entries',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to full history
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (recentEntries.isEmpty)
              _buildEmptyState(context)
            else
              ...recentEntries.map((entry) => _buildEntryItem(context, entry)),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.energy_savings_leaf_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No energy entries yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your energy levels to see patterns and insights',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEntryItem(BuildContext context, EnergyEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getEnergyColor(entry.level).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Energy level indicator
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getEnergyColor(entry.energyLevel),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                entry.energyLevel.toString(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Entry details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _getEnergyLevelText(entry.energyLevel),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('h:mm a').format(entry.timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (entry.notes != null && entry.notes!.isNotEmpty) ...[
                  Text(
                    entry.notes!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                ],
                if (entry.mood != null) ...[
                  Row(
                    children: [
                      Icon(
                        _getMoodIcon(entry.mood!),
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        entry.mood!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Action button
          IconButton(
            onPressed: () {
              // TODO: Show entry details or edit
            },
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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

  String _getEnergyLevelText(int level) {
    if (level <= 2) return 'Very Low Energy';
    if (level <= 4) return 'Low Energy';
    if (level <= 6) return 'Moderate Energy';
    if (level <= 8) return 'High Energy';
    return 'Very High Energy';
  }

  IconData _getMoodIcon(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
      case 'excited':
      case 'energetic':
        return Icons.sentiment_very_satisfied;
      case 'good':
      case 'positive':
        return Icons.sentiment_satisfied;
      case 'neutral':
      case 'okay':
        return Icons.sentiment_neutral;
      case 'tired':
      case 'low':
        return Icons.sentiment_dissatisfied;
      case 'stressed':
      case 'anxious':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

}
