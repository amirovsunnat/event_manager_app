import 'package:event_manager_app/data/models/event_model.dart';

abstract class CalendarEvent {}

class LoadCalendar extends CalendarEvent {
  final DateTime date;

  LoadCalendar(this.date);
}

class AddEvent extends CalendarEvent {
  final Event event;

  AddEvent(this.event);
}

class LoadAllEvents extends CalendarEvent {}

class DeleteEvent extends CalendarEvent {
  final int id;

  DeleteEvent(this.id);
}

class UpdateEvent extends CalendarEvent {
  final Event event;

  UpdateEvent(this.event);
}

class SelectDate extends CalendarEvent {
  final DateTime date;

  SelectDate(this.date);
}

class ChangeView extends CalendarEvent {
  final String viewType;

  ChangeView({required this.viewType});
}

class LoadEventDetails extends CalendarEvent {
  final int id;

  LoadEventDetails({required this.id});

  @override
  List<Object?> get props => [id];
}
