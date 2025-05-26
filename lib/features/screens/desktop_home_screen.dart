import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import '../../shared/providers/energy_provider.dart';
import '../../shared/widgets/design_systems/nyxb/magic_card.dart';
import '../../shared/widgets/design_systems/nyxb/animated_circular_progress.dart';
import '../../shared/widgets/design_systems/nyxb/number_ticker.dart';
import '../../shared/widgets/design_systems/nyxb/shimmer_button.dart';
import '../../shared/widgets/design_systems/nyxb/gradient_background.dart';
import '../../shared/widgets/design_systems/kanpeki/accordion.dart';
import '../../shared/widgets/design_systems/kanpeki/card.dart';
import '../../shared/widgets/design_systems/cult/dynamic_island.dart';
import '../../shared/widgets/design_systems/cult/texture_button.dart';
import '../../shared/widgets/ui_components/desktop/sidebar_navigation.dart';
import '../../shared/widgets/ui_components/desktop/desktop_energy_dashboard.dart';
import '../../shared/widgets/ui_components/desktop/desktop_energy_chart.dart';
import '../../shared/widgets/ui_components/desktop/desktop_energy_history.dart';
import '../../shared/widgets/ui_components/desktop/custom_title_bar.dart';

class DesktopHomeScreen extends StatefulWidget {
  const DesktopHomeScreen({super.key});

  @override
  State<DesktopHomeScreen> createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load sample data when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EnergyProvider>(context, listen: false).loadEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f0f23),
      body: WarpBackground(
        baseColor: const Color(0xFF667eea),
        intensity: 0.15,
        child: Stack(
          children: [
            Column(
              children: [
                // Custom Title Bar
                const CustomTitleBar(),

                // Main Content
                Expanded(
                  child: Row(
                    children: [
                      // Sidebar Navigation
                      SidebarNavigation(
                        selectedIndex: _selectedIndex,
                        onItemSelected: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                      ),

                      // Main Content Area
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          child: _buildMainContent(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Floating Dynamic Island
            Consumer<EnergyProvider>(
              builder: (context, energyProvider, child) {
                if (energyProvider.todayEntries.isNotEmpty) {
                  return FloatingEnergyStatus(
                    energyLevel: energyProvider.todayAverageEnergy.round(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0:
        return const DesktopEnergyDashboard();
      case 1:
        return const DesktopEnergyHistory();
      case 2:
        return const DesktopEnergyChart();
      case 3:
        return _buildInsightsView();
      case 4:
        return _buildSettingsView();
      default:
        return const DesktopEnergyDashboard();
    }
  }

  Widget _buildInsightsView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Energy Insights',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Discover patterns and get personalized recommendations',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 30),

          // Insight Cards Row
          Row(
            children: [
              Expanded(
                child: EnergyInsightCard(
                  title: 'Peak Performance',
                  description: 'Your energy peaks between 9-11 AM. Schedule important tasks during this window.',
                  icon: Icons.trending_up,
                  color: const Color(0xFF22C55E),
                  actionText: 'View Schedule',
                  onAction: () {},
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: EnergyInsightCard(
                  title: 'Sleep Impact',
                  description: 'Quality sleep increases your next-day energy by 23% on average.',
                  icon: Icons.bedtime,
                  color: const Color(0xFF667eea),
                  actionText: 'Sleep Tips',
                  onAction: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Detailed Insights Accordion
          KanpekiCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detailed Analysis',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const EnergyInsightsAccordion(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsView() {
    return const Center(
      child: Text(
        'Settings View - Coming Soon',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Desktop Energy Dashboard
class DesktopEnergyDashboard extends StatelessWidget {
  const DesktopEnergyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EnergyProvider>(
      builder: (context, energyProvider, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: 30),

              // Main Stats Row
              Row(
                children: [
                  // Current Energy Card
                  Expanded(
                    flex: 2,
                    child: _buildCurrentEnergyCard(energyProvider),
                  ),

                  const SizedBox(width: 20),

                  // Quick Stats
                  Expanded(
                    child: Column(
                      children: [
                        _buildStatCard(
                          'Today\'s Entries',
                          energyProvider.todayEntries.length.toString(),
                          Icons.edit_note,
                          const Color(0xFF22C55E),
                        ),
                        const SizedBox(height: 16),
                        _buildStatCard(
                          'Weekly Average',
                          energyProvider.weeklyAverageEnergy.toStringAsFixed(1),
                          Icons.trending_up,
                          const Color(0xFFF59E0B),
                        ),
                        const SizedBox(height: 16),
                        _buildStatCard(
                          'Trend',
                          _getTrendText(energyProvider.energyTrend),
                          _getTrendIcon(energyProvider.energyTrend),
                          _getTrendColor(energyProvider.energyTrend),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Recent Entries and Quick Actions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recent Entries
                  Expanded(
                    flex: 2,
                    child: _buildRecentEntries(energyProvider),
                  ),

                  const SizedBox(width: 20),

                  // Quick Actions
                  Expanded(
                    child: _buildQuickActions(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final greeting = _getGreeting();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(0, 2),
                blurRadius: 4,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat('EEEE, MMMM d, yyyy').format(now),
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentEnergyCard(EnergyProvider energyProvider) {
    return MagicCard(
      borderColor: const Color(0xFF667eea),
      spotlightColor: const Color(0x33667eea),
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Energy Level',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF667eea),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    EnergyNumberTicker(
                      energyValue: energyProvider.todayAverageEnergy,
                      textStyle: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF667eea),
                      ),
                    ),
                    const Text(
                      '/10',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _getEnergyDescription(energyProvider.todayAverageEnergy),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          EnergyCircularProgress(
            energyLevel: energyProvider.todayAverageEnergy.round(),
            size: 150,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return MagicCard(
      borderColor: color,
      spotlightColor: color.withOpacity(0.2),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentEntries(EnergyProvider energyProvider) {
    return MagicCard(
      borderColor: Colors.white.withOpacity(0.2),
      spotlightColor: Colors.white.withOpacity(0.1),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Entries',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          if (energyProvider.entries.isEmpty)
            _buildEmptyState()
          else
            ...energyProvider.entries.take(5).map((entry) =>
              _buildEntryItem(entry)).toList(),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return KanpekiCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const EnergyQuickActions(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.energy_savings_leaf_outlined,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'No energy entries yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your energy levels to see patterns and insights',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEntryItem(entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getEnergyColor(entry.energyLevel).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getEnergyColor(entry.energyLevel),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                entry.energyLevel.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getEnergyLevelText(entry.energyLevel),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (entry.notes != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    entry.notes!,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Text(
            DateFormat('h:mm a').format(entry.timestamp),
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showEnergyLogDialog(BuildContext context) {
    // TODO: Implement desktop energy log dialog
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _getEnergyDescription(double energy) {
    if (energy >= 8) return 'Excellent energy levels! You\'re feeling great.';
    if (energy >= 6) return 'Good energy levels. You\'re doing well.';
    if (energy >= 4) return 'Moderate energy. Consider some activities to boost it.';
    return 'Low energy levels. Focus on rest and self-care.';
  }

  Color _getEnergyColor(int level) {
    if (level <= 2) return const Color(0xFFEF4444);
    if (level <= 4) return const Color(0xFFF97316);
    if (level <= 6) return const Color(0xFFEAB308);
    if (level <= 8) return const Color(0xFF84CC16);
    return const Color(0xFF22C55E);
  }

  String _getEnergyLevelText(int level) {
    if (level <= 2) return 'Very Low Energy';
    if (level <= 4) return 'Low Energy';
    if (level <= 6) return 'Moderate Energy';
    if (level <= 8) return 'High Energy';
    return 'Very High Energy';
  }

  String _getTrendText(String trend) {
    switch (trend) {
      case 'improving': return 'Improving';
      case 'declining': return 'Declining';
      case 'stable': return 'Stable';
      default: return 'No Data';
    }
  }

  IconData _getTrendIcon(String trend) {
    switch (trend) {
      case 'improving': return Icons.trending_up;
      case 'declining': return Icons.trending_down;
      case 'stable': return Icons.trending_flat;
      default: return Icons.help_outline;
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'improving': return const Color(0xFF22C55E);
      case 'declining': return const Color(0xFFEF4444);
      case 'stable': return const Color(0xFFF59E0B);
      default: return Colors.grey;
    }
  }
}
