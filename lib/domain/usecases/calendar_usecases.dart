import 'package:event_manager_app/data/local/sqlite_helper.dart';
import 'package:event_manager_app/data/models/event_model.dart';
import 'package:flutter/material.dart';

class CalendarUseCases {
  final SQLiteHelper _sqliteHelper = SQLiteHelper.instance;

  Future<List<Event>> getEventsForDate(DateTime date) async {
    final dateString =
        date.toIso8601String().split('T').first; // Format as YYYY-MM-DD
    debugPrint('Fetching events for date: $dateString');
    final events = await _sqliteHelper.getEventsForDate(dateString);
    debugPrint('Events fetched: $events');
    return events;
  }

  Future<void> loadAllEvents() async {
    final events = await _sqliteHelper.getAllEvents();
    debugPrint('All events: $events');
  }

  Future<void> addEvent(Event event) async {
    await _sqliteHelper.insertEvent(event);
  }

  Future<void> updateEvent(Event event) async {
    await _sqliteHelper.updateEvent(event);
  }

  Future<void> deleteEvent(int id) async {
    await _sqliteHelper.deleteEvent(id);
  }

  Future<List<Event>> getAllEvents() async {
    return await _sqliteHelper.getAllEvents();
  }

  // New method to get a specific event by ID
  Future<Event?> getEventById(int id) async {
    return await _sqliteHelper.getEventById(id);
  }
}
