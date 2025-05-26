import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/energy_entry.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('energy_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT';

    await db.execute('''
      CREATE TABLE energy_entries (
        id $idType,
        timestamp $integerType,
        energyLevel $integerType,
        notes $textType,
        mood $textType,
        tags $textType
      )
    ''');
  }

  // Insert a new energy entry
  Future<int> insertEnergyEntry(EnergyEntry entry) async {
    final db = await instance.database;
    return await db.insert('energy_entries', entry.toMap());
  }

  // Get all energy entries
  Future<List<EnergyEntry>> getAllEnergyEntries() async {
    final db = await instance.database;
    final result = await db.query(
      'energy_entries',
      orderBy: 'timestamp DESC',
    );
    return result.map((map) => EnergyEntry.fromMap(map)).toList();
  }

  // Get energy entries for a specific date range
  Future<List<EnergyEntry>> getEnergyEntriesInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await instance.database;
    final result = await db.query(
      'energy_entries',
      where: 'timestamp >= ? AND timestamp <= ?',
      whereArgs: [
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
      ],
      orderBy: 'timestamp DESC',
    );
    return result.map((map) => EnergyEntry.fromMap(map)).toList();
  }

  // Get energy entries for today
  Future<List<EnergyEntry>> getTodayEnergyEntries() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return await getEnergyEntriesInRange(startOfDay, endOfDay);
  }

  // Update an energy entry
  Future<int> updateEnergyEntry(EnergyEntry entry) async {
    final db = await instance.database;
    return await db.update(
      'energy_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  // Delete an energy entry
  Future<int> deleteEnergyEntry(int id) async {
    final db = await instance.database;
    return await db.delete(
      'energy_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get average energy level for a date range
  Future<double?> getAverageEnergyLevel(DateTime startDate, DateTime endDate) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT AVG(energyLevel) as average
      FROM energy_entries
      WHERE timestamp >= ? AND timestamp <= ?
    ''', [
      startDate.millisecondsSinceEpoch,
      endDate.millisecondsSinceEpoch,
    ]);
    
    return result.first['average'] as double?;
  }

  // Close the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
