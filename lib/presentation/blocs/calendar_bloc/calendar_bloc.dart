import 'package:event_manager_app/data/models/event_model.dart';
import 'package:event_manager_app/domain/usecases/calendar_usecases.dart';
import 'package:event_manager_app/presentation/blocs/calendar_bloc/calendar_event.dart';
import 'package:event_manager_app/presentation/blocs/calendar_bloc/calendar_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarUseCases _calendarUseCases = CalendarUseCases();

  CalendarBloc() : super(CalendarInitial()) {
    on<LoadCalendar>(_onLoadCalendar);
    on<AddEvent>(_onAddEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<SelectDate>(_onSelectDate);
    on<ChangeView>(_onChangeView);
    on<LoadAllEvents>(_onLoadAllEvents);
    on<LoadEventDetails>(_onLoadEventDetails);
  }

  Future<void> _onLoadAllEvents(
      LoadAllEvents event, Emitter<CalendarState> emit) async {
    emit(CalendarLoading());
    try {
      final events = await _calendarUseCases.getAllEvents(); // Load all events
      final selectedDate = state is CalendarLoaded
          ? (state as CalendarLoaded).selectedDate
          : DateTime.now();
      emit(CalendarLoaded(
        events: events,
        selectedDate: selectedDate,
      ));
    } catch (e) {
      emit(CalendarError(message: e.toString()));
    }
  }

  Future<void> _onLoadCalendar(
      LoadCalendar event, Emitter<CalendarState> emit) async {
    emit(CalendarLoading());
    try {
      final allEvents = await _calendarUseCases.getAllEvents();
      final eventsForDate = allEvents
          .where((e) => e.date == DateFormat('yyyy-MM-dd').format(event.date))
          .toList();
      emit(CalendarLoaded(
        events: allEvents,
        selectedDate: event.date,
      ));
    } catch (e) {
      emit(CalendarError(message: e.toString()));
    }
  }

  Future<void> _onAddEvent(AddEvent event, Emitter<CalendarState> emit) async {
    final currentState = state;
    if (currentState is CalendarLoaded) {
      await _calendarUseCases.addEvent(event.event);

      final updatedEvents = await _calendarUseCases.getAllEvents();
      emit(CalendarLoaded(
        events: updatedEvents,
        selectedDate: currentState.selectedDate,
      ));
    }
  }

  void _onLoadEventDetails(
      LoadEventDetails event, Emitter<CalendarState> emit) async {
    try {
      emit(CalendarLoading());
      final eventDetails = await _calendarUseCases.getEventById(event.id);
      emit(EventDetailsLoaded(event: eventDetails!));
    } catch (e) {
      emit(CalendarError(message: e.toString()));
    }
  }

  void _onDeleteEvent(DeleteEvent event, Emitter<CalendarState> emit) async {
    try {
      await _calendarUseCases.deleteEvent(event.id);
      final updatedEvents = await _calendarUseCases.getAllEvents();
      emit(CalendarLoaded(
        events: updatedEvents,
        selectedDate: state is CalendarLoaded
            ? (state as CalendarLoaded).selectedDate
            : DateTime.now(),
      ));
    } catch (e) {
      emit(CalendarError(message: e.toString()));
    }
  }

  Future<void> _onUpdateEvent(
      UpdateEvent event, Emitter<CalendarState> emit) async {
    final currentState = state;
    if (currentState is CalendarLoaded) {
      await _calendarUseCases.updateEvent(event.event);
      final updatedEvents = await _calendarUseCases.getAllEvents();
      emit(CalendarLoaded(
        events: updatedEvents,
        selectedDate: currentState.selectedDate,
      ));
    }
  }

  Future<void> _onSelectDate(
      SelectDate event, Emitter<CalendarState> emit) async {
    final currentState = state;
    if (currentState is CalendarLoaded) {
      final eventsForDate = currentState.events
          .where((e) => DateFormat('yyyy-MM-dd')
              .parse(e.date)
              .isAtSameMomentAs(event.date))
          .toList();
      emit(CalendarLoaded(
        events: currentState.events,
        selectedDate: event.date,
      ));
    }
  }

  Future<void> _onChangeView(
      ChangeView event, Emitter<CalendarState> emit) async {
    final currentState = state;
    if (currentState is CalendarLoaded) {
      emit(CalendarLoaded(
        events: currentState.events,
        selectedDate: currentState.selectedDate,
        viewType: event.viewType,
      ));
    }
  }
}
