import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/energy_entry.dart';
import '../providers/energy_provider.dart';
import 'nyxb/magic_card.dart';
import 'nyxb/shimmer_button.dart';

class EnergyLevelSelector extends StatefulWidget {
  final Function(int)? onEnergySelected;
  final int? initialValue;

  const EnergyLevelSelector({
    super.key,
    this.onEnergySelected,
    this.initialValue,
  });

  @override
  State<EnergyLevelSelector> createState() => _EnergyLevelSelectorState();
}

class _EnergyLevelSelectorState extends State<EnergyLevelSelector>
    with TickerProviderStateMixin {
  int? _selectedLevel;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.initialValue;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Energy level grid
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Energy level buttons
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  final level = index + 1;
                  final isSelected = _selectedLevel == level;

                  return GestureDetector(
                    onTap: () => _selectLevel(level),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _getEnergyColor(level)
                            : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? _getEnergyColor(level)
                              : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: _getEnergyColor(level).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              level.toString(),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            if (level == 1 || level == 5 || level == 10)
                              Text(
                                _getEnergyLabel(level),
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: isSelected
                                          ? Colors.white.withOpacity(0.9)
                                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                      fontSize: 8,
                                    ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Energy level description
              if (_selectedLevel != null) ...[
                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    key: ValueKey(_selectedLevel),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getEnergyColor(_selectedLevel!).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getEnergyIcon(_selectedLevel!),
                          color: _getEnergyColor(_selectedLevel!),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getEnergyDescription(_selectedLevel!),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Notes section
        TextField(
          controller: _notesController,
          decoration: InputDecoration(
            labelText: 'Notes (optional)',
            hintText: 'How are you feeling? What affected your energy?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.note_outlined),
          ),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),

        const SizedBox(height: 24),

        // Save button
        SizedBox(
          width: double.infinity,
          child: ShimmerButton(
            onPressed: _selectedLevel != null ? _saveEntry : null,
            backgroundColor: _selectedLevel != null
                ? _getEnergyColor(_selectedLevel!)
                : Colors.grey,
            borderRadius: 12,
            padding: const EdgeInsets.symmetric(vertical: 16),
            enabled: _selectedLevel != null,
            child: const Text(
              'Save Entry',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _selectLevel(int level) {
    setState(() {
      _selectedLevel = level;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    widget.onEnergySelected?.call(level);
  }

  void _saveEntry() {
    if (_selectedLevel == null) return;

    final energyProvider = Provider.of<EnergyProvider>(context, listen: false);

    final entry = EnergyEntry(
      timestamp: DateTime.now(),
      energyLevel: _selectedLevel!,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    energyProvider.addEnergyEntry(entry);

    Navigator.of(context).pop();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Energy level $_selectedLevel logged successfully!'),
        backgroundColor: _getEnergyColor(_selectedLevel!),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  IconData _getEnergyIcon(int level) {
    if (level <= 2) return Icons.battery_0_bar;
    if (level <= 4) return Icons.battery_2_bar;
    if (level <= 6) return Icons.battery_4_bar;
    if (level <= 8) return Icons.battery_6_bar;
    return Icons.battery_full;
  }

  String _getEnergyLabel(int level) {
    switch (level) {
      case 1:
        return 'Low';
      case 5:
        return 'Medium';
      case 10:
        return 'High';
      default:
        return '';
    }
  }

  String _getEnergyDescription(int level) {
    switch (level) {
      case 1:
        return 'Completely drained, need rest immediately';
      case 2:
        return 'Very low energy, struggling to function';
      case 3:
        return 'Low energy, can do light activities';
      case 4:
        return 'Below average, feeling sluggish';
      case 5:
        return 'Average energy, can handle routine tasks';
      case 6:
        return 'Good energy, feeling productive';
      case 7:
        return 'High energy, ready for challenges';
      case 8:
        return 'Very energetic, feeling great';
      case 9:
        return 'Excellent energy, highly motivated';
      case 10:
        return 'Peak energy, unstoppable!';
      default:
        return '';
    }
  }
}
