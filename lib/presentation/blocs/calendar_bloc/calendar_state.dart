import 'package:equatable/equatable.dart';
import 'package:event_manager_app/data/models/event_model.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<Event> events;
  final DateTime selectedDate;
  final String? viewType; // Optional: if you handle different view types

  CalendarLoaded({
    required this.events,
    required this.selectedDate,
    this.viewType,
  });

  @override
  List<Object> get props => [
        events,
        selectedDate,
        // Include viewType only if it's not null, otherwise default to a constant or empty string
        viewType ?? '',
      ];
}

class CalendarError extends CalendarState {
  final String message;

  CalendarError({required this.message});

  @override
  List<Object> get props => [message];
}

class EventDetailsLoaded extends CalendarState {
  final Event event;

  EventDetailsLoaded({required this.event});

  @override
  List<Object> get props => [event];
}
