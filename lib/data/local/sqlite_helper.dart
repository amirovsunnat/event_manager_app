import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:event_manager_app/data/models/event_model.dart';

class SQLiteHelper {
  // Singleton pattern
  SQLiteHelper._privateConstructor();
  static final SQLiteHelper instance = SQLiteHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'events.db');
    debugPrint('Database path: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE events (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          location TEXT,
          priorityColor TEXT,
          time TEXT,
          date TEXT
        )
      ''');
      },
    );
  }

  Future<void> insertEvent(Event event) async {
    final db = await database;
    try {
      final result = await db.insert(
        'events',
        event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('Event inserted successfully: ${event.toMap()}');
      debugPrint('Inserted row id: $result');
    } catch (e) {
      debugPrint('Error inserting event: $e');
    }
  }

  Future<List<Event>> getAllEvents() async {
    final db = await database;
    final maps = await db.query('events');
    debugPrint('Retrieved ${maps.length} events');
    return List.generate(maps.length, (i) {
      debugPrint('Row $i: ${maps[i]}');
      return Event.fromMap(maps[i]);
    });
  }

  Future<List<Event>> getEventsForDate(String date) async {
    final db = await database;
    final maps = await db.query(
      'events',
      where: 'date = ?',
      whereArgs: [date],
    );
    debugPrint(
        'Query executed for date $date. Number of rows returned: ${maps.length}');
    return List.generate(maps.length, (i) {
      debugPrint('Row $i: ${maps[i]}');
      return Event.fromMap(maps[i]);
    });
  }

  Future<void> deleteEvent(int id) async {
    final db = await database;
    await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
    debugPrint('Event deleted successfully');
  }

  Future<void> updateEvent(Event event) async {
    final db = await database;
    await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
    debugPrint('Event updated successfully');
  }

  // Add this new method to fetch a single event by its ID
  Future<Event?> getEventById(int id) async {
    final db = await database;
    final maps = await db.query(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      debugPrint('Event retrieved successfully: ${maps.first}');
      return Event.fromMap(maps.first);
    } else {
      debugPrint('Event with id $id not found');
      return null;
    }
  }
}
