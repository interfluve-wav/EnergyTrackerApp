import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../shared/models/energy_entry.dart';
import '../../shared/providers/energy_provider.dart';
import '../../shared/widgets/design_systems/nyxb/shimmer_button.dart';

class EnhancedEnergyLogger extends StatefulWidget {
  final Function(EnergyEntry)? onEntrySaved;

  const EnhancedEnergyLogger({
    super.key,
    this.onEntrySaved,
  });

  @override
  State<EnhancedEnergyLogger> createState() => _EnhancedEnergyLoggerState();
}

class _EnhancedEnergyLoggerState extends State<EnhancedEnergyLogger>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  int? _selectedEnergyLevel;
  String? _selectedMood;
  int? _sleepQuality;
  double? _sleepHours;
  final List<String> _selectedActivities = [];
  final List<String> _selectedNutrition = [];
  final List<String> _selectedSymptoms = [];

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _sleepHoursController = TextEditingController();

  // Predefined options
  final List<String> _moodOptions = [
    'Excellent', 'Energized', 'Good', 'Moderate', 'Tired', 'Low', 'Exhausted'
  ];

  final List<String> _activityOptions = [
    'Exercise', 'Work', 'Social', 'Creative', 'Learning', 'Relaxation',
    'Household', 'Travel', 'Entertainment', 'Meditation'
  ];

  final List<String> _nutritionOptions = [
    'Healthy Breakfast', 'Coffee', 'Tea', 'Protein', 'Vegetables', 'Fruits',
    'Fast Food', 'Alcohol', 'Sugar', 'Water', 'Supplements', 'Late Meal'
  ];

  final List<String> _symptomOptions = [
    'Headache', 'Fatigue', 'Stress', 'Anxiety', 'Back Pain', 'Eye Strain',
    'Insomnia', 'Digestive Issues', 'Muscle Tension', 'Brain Fog'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _notesController.dispose();
    _sleepHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Log Energy & Wellness',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Energy Level Selection
          _buildEnergyLevelSection(),
          const SizedBox(height: 24),

          // Mood Selection
          _buildMoodSection(),
          const SizedBox(height: 24),

          // Sleep Tracking
          _buildSleepSection(),
          const SizedBox(height: 24),

          // Activity Selection
          _buildActivitySection(),
          const SizedBox(height: 24),

          // Nutrition Selection
          _buildNutritionSection(),
          const SizedBox(height: 24),

          // Symptoms Selection
          _buildSymptomsSection(),
          const SizedBox(height: 24),

          // Notes
          _buildNotesSection(),
          const SizedBox(height: 32),

          // Save Button
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildEnergyLevelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Energy Level (1-10)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(10, (index) {
            final level = index + 1;
            final isSelected = _selectedEnergyLevel == level;
            return GestureDetector(
              onTap: () => _selectEnergyLevel(level),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? _getEnergyColor(level)
                      : Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: _getEnergyColor(level),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    level.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : _getEnergyColor(level),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        if (_selectedEnergyLevel != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getEnergyColor(_selectedEnergyLevel!).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _getEnergyIcon(_selectedEnergyLevel!),
                  color: _getEnergyColor(_selectedEnergyLevel!),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getEnergyDescription(_selectedEnergyLevel!),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMoodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mood',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _moodOptions.map((mood) {
            final isSelected = _selectedMood == mood;
            return GestureDetector(
              onTap: () => setState(() => _selectedMood = isSelected ? null : mood),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  mood,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSleepSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sleep',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Sleep Quality
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quality (1-10)',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    children: List.generate(10, (index) {
                      final quality = index + 1;
                      final isSelected = _sleepQuality == quality;
                      return GestureDetector(
                        onTap: () => setState(() => _sleepQuality = isSelected ? null : quality),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              quality.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Sleep Hours
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hours',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _sleepHoursController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: '7.5',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (value) {
                      _sleepHours = double.tryParse(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivitySection() {
    return _buildMultiSelectSection(
      'Activities',
      _activityOptions,
      _selectedActivities,
      Icons.fitness_center,
    );
  }

  Widget _buildNutritionSection() {
    return _buildMultiSelectSection(
      'Nutrition',
      _nutritionOptions,
      _selectedNutrition,
      Icons.restaurant,
    );
  }

  Widget _buildSymptomsSection() {
    return _buildMultiSelectSection(
      'Symptoms',
      _symptomOptions,
      _selectedSymptoms,
      Icons.health_and_safety,
    );
  }

  Widget _buildMultiSelectSection(
    String title,
    List<String> options,
    List<String> selectedItems,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedItems.contains(option);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedItems.remove(option);
                  } else {
                    selectedItems.add(option);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      Icon(
                        Icons.check,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    if (isSelected) const SizedBox(width: 4),
                    Text(
                      option,
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes (Optional)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'How are you feeling? What affected your energy today?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    final canSave = _selectedEnergyLevel != null;

    return SizedBox(
      width: double.infinity,
      child: ShimmerButton(
        onPressed: canSave ? _saveEntry : null,
        backgroundColor: canSave
            ? Theme.of(context).colorScheme.primary
            : Colors.grey,
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(vertical: 16),
        enabled: canSave,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.save,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Save Entry',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectEnergyLevel(int level) {
    setState(() {
      _selectedEnergyLevel = level;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  void _saveEntry() {
    if (_selectedEnergyLevel == null) return;

    final energyProvider = Provider.of<EnergyProvider>(context, listen: false);

    final entry = EnergyEntry(
      timestamp: DateTime.now(),
      energyLevel: _selectedEnergyLevel!,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      mood: _selectedMood,
      sleepQuality: _sleepQuality,
      sleepHours: _sleepHours,
      activities: _selectedActivities.isNotEmpty ? List.from(_selectedActivities) : null,
      nutrition: _selectedNutrition.isNotEmpty ? List.from(_selectedNutrition) : null,
      symptoms: _selectedSymptoms.isNotEmpty ? List.from(_selectedSymptoms) : null,
    );

    energyProvider.addEnergyEntry(entry);

    // Call callback if provided
    widget.onEntrySaved?.call(entry);

    // Reset form
    _resetForm();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Energy entry logged successfully!'),
        backgroundColor: _getEnergyColor(_selectedEnergyLevel!),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _selectedEnergyLevel = null;
      _selectedMood = null;
      _sleepQuality = null;
      _sleepHours = null;
      _selectedActivities.clear();
      _selectedNutrition.clear();
      _selectedSymptoms.clear();
    });
    _notesController.clear();
    _sleepHoursController.clear();
  }

  Color _getEnergyColor(int level) {
    if (level <= 2) return const Color(0xFFEF4444);
    if (level <= 4) return const Color(0xFFF97316);
    if (level <= 6) return const Color(0xFFEAB308);
    if (level <= 8) return const Color(0xFF84CC16);
    return const Color(0xFF22C55E);
  }

  IconData _getEnergyIcon(int level) {
    if (level <= 2) return Icons.battery_0_bar;
    if (level <= 4) return Icons.battery_2_bar;
    if (level <= 6) return Icons.battery_4_bar;
    if (level <= 8) return Icons.battery_6_bar;
    return Icons.battery_full;
  }

  String _getEnergyDescription(int level) {
    switch (level) {
      case 1:
        return 'Completely drained, need immediate rest';
      case 2:
        return 'Very low energy, struggling to function';
      case 3:
        return 'Low energy, feeling sluggish';
      case 4:
        return 'Below average, somewhat tired';
      case 5:
        return 'Average energy level';
      case 6:
        return 'Good energy, feeling capable';
      case 7:
        return 'High energy, feeling productive';
      case 8:
        return 'Very high energy, feeling great';
      case 9:
        return 'Excellent energy, highly motivated';
      case 10:
        return 'Peak energy, feeling unstoppable';
      default:
        return 'Select your energy level';
    }
  }
}