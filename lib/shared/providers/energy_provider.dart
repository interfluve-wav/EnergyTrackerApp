import 'package:flutter/foundation.dart';
import '../models/energy_entry.dart';

class EnergyProvider extends ChangeNotifier {
  List<EnergyEntry> _entries = [];
  bool _isLoading = false;

  List<EnergyEntry> get entries => _entries;
  bool get isLoading => _isLoading;

  // Get today's entries
  List<EnergyEntry> get todayEntries {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return _entries.where((entry) {
      return entry.timestamp.isAfter(startOfDay) && 
             entry.timestamp.isBefore(endOfDay);
    }).toList();
  }

  // Get average energy level for today
  double get todayAverageEnergy {
    final today = todayEntries;
    if (today.isEmpty) return 0.0;
    
    final total = today.fold(0, (sum, entry) => sum + entry.energyLevel);
    return total / today.length;
  }

  // Get weekly average
  double get weeklyAverageEnergy {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    
    final weekEntries = _entries.where((entry) {
      return entry.timestamp.isAfter(weekAgo);
    }).toList();
    
    if (weekEntries.isEmpty) return 0.0;
    
    final total = weekEntries.fold(0, (sum, entry) => sum + entry.energyLevel);
    return total / weekEntries.length;
  }

  // Add a new energy entry
  Future<void> addEnergyEntry(EnergyEntry entry) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Save to database
      _entries.insert(0, entry); // Add to beginning for chronological order
      notifyListeners();
    } catch (e) {
      // Handle error
      debugPrint('Error adding energy entry: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load entries from database
  Future<void> loadEntries() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Load from database
      // For now, we'll use sample data
      _entries = _generateSampleData();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading entries: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing entry
  Future<void> updateEnergyEntry(EnergyEntry entry) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Update in database
      final index = _entries.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        _entries[index] = entry;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating energy entry: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete an entry
  Future<void> deleteEnergyEntry(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Delete from database
      _entries.removeWhere((entry) => entry.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting energy entry: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Generate sample data for UI testing
  List<EnergyEntry> _generateSampleData() {
    final now = DateTime.now();
    return [
      EnergyEntry(
        id: 1,
        timestamp: now.subtract(const Duration(hours: 2)),
        energyLevel: 8,
        notes: 'Great workout this morning! Feeling energized.',
        mood: 'energetic',
        tags: ['workout', 'morning'],
      ),
      EnergyEntry(
        id: 2,
        timestamp: now.subtract(const Duration(hours: 5)),
        energyLevel: 6,
        notes: 'Post-lunch dip but still productive',
        mood: 'neutral',
        tags: ['afternoon', 'work'],
      ),
      EnergyEntry(
        id: 3,
        timestamp: now.subtract(const Duration(hours: 8)),
        energyLevel: 9,
        notes: 'Perfect start to the day',
        mood: 'excited',
        tags: ['morning', 'coffee'],
      ),
      EnergyEntry(
        id: 4,
        timestamp: now.subtract(const Duration(days: 1, hours: 3)),
        energyLevel: 4,
        notes: 'Feeling tired after a long day',
        mood: 'tired',
        tags: ['evening', 'tired'],
      ),
      EnergyEntry(
        id: 5,
        timestamp: now.subtract(const Duration(days: 1, hours: 10)),
        energyLevel: 7,
        notes: 'Good energy for tackling projects',
        mood: 'positive',
        tags: ['morning', 'productive'],
      ),
    ];
  }

  // Get energy trend (improving, declining, stable)
  String get energyTrend {
    if (_entries.length < 4) return 'insufficient_data';
    
    final recent = _entries.take(2).toList();
    final older = _entries.skip(2).take(2).toList();
    
    final recentAvg = recent.fold(0, (sum, entry) => sum + entry.energyLevel) / recent.length;
    final olderAvg = older.fold(0, (sum, entry) => sum + entry.energyLevel) / older.length;
    
    final difference = recentAvg - olderAvg;
    
    if (difference > 0.5) return 'improving';
    if (difference < -0.5) return 'declining';
    return 'stable';
  }
}
