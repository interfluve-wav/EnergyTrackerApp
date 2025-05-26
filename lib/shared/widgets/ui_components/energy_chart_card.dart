import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class EnergyChartCard extends StatefulWidget {
  const EnergyChartCard({super.key});

  @override
  State<EnergyChartCard> createState() => _EnergyChartCardState();
}

class _EnergyChartCardState extends State<EnergyChartCard> {
  String _selectedPeriod = 'Week';
  final List<String> _periods = ['Day', 'Week', 'Month'];

  @override
  Widget build(BuildContext context) {
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
                  Icons.show_chart,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Energy Trends',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                _buildPeriodSelector(),
              ],
            ),
            const SizedBox(height: 20),
            
            // Chart
            SizedBox(
              height: 200,
              child: _buildChart(),
            ),
            
            const SizedBox(height: 16),
            
            // Chart legend and insights
            _buildChartLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _periods.map((period) {
          final isSelected = period == _selectedPeriod;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPeriod = period;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                period,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChart() {
    // TODO: Replace with actual data
    final spots = _generateSampleData();
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return _getBottomTitle(value.toInt());
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: spots.length.toDouble() - 1,
        minY: 0,
        maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: _getEnergyColor(spot.y.round()),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Theme.of(context).colorScheme.surface,
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                return LineTooltipItem(
                  'Energy: ${barSpot.y.toStringAsFixed(1)}',
                  Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: _getEnergyColor(barSpot.y.round()),
                        fontWeight: FontWeight.bold,
                      ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _getBottomTitle(int value) {
    String text;
    switch (_selectedPeriod) {
      case 'Day':
        // Show hours
        text = '${value * 3}h';
        break;
      case 'Week':
        // Show days of week
        final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        text = value < days.length ? days[value] : '';
        break;
      case 'Month':
        // Show weeks
        text = 'W${value + 1}';
        break;
      default:
        text = '';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      children: [
        _buildLegendItem('High Energy', Colors.green),
        const SizedBox(width: 16),
        _buildLegendItem('Medium Energy', Colors.yellow.shade700),
        const SizedBox(width: 16),
        _buildLegendItem('Low Energy', Colors.red),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
      ],
    );
  }

  List<FlSpot> _generateSampleData() {
    // TODO: Replace with actual data from database
    switch (_selectedPeriod) {
      case 'Day':
        return [
          const FlSpot(0, 6), // 0h
          const FlSpot(1, 7), // 3h
          const FlSpot(2, 8), // 6h
          const FlSpot(3, 9), // 9h
          const FlSpot(4, 7), // 12h
          const FlSpot(5, 6), // 15h
          const FlSpot(6, 5), // 18h
          const FlSpot(7, 4), // 21h
        ];
      case 'Week':
        return [
          const FlSpot(0, 7), // Monday
          const FlSpot(1, 6), // Tuesday
          const FlSpot(2, 8), // Wednesday
          const FlSpot(3, 5), // Thursday
          const FlSpot(4, 7), // Friday
          const FlSpot(5, 9), // Saturday
          const FlSpot(6, 8), // Sunday
        ];
      case 'Month':
        return [
          const FlSpot(0, 6.5), // Week 1
          const FlSpot(1, 7.2), // Week 2
          const FlSpot(2, 6.8), // Week 3
          const FlSpot(3, 7.5), // Week 4
        ];
      default:
        return [];
    }
  }

  Color _getEnergyColor(int level) {
    if (level <= 2) return Colors.red;
    if (level <= 4) return Colors.orange;
    if (level <= 6) return Colors.yellow.shade700;
    if (level <= 8) return Colors.lightGreen;
    return Colors.green;
  }
}
