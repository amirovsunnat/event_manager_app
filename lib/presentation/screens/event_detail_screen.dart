import 'package:event_manager_app/presentation/screens/update_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_manager_app/presentation/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:event_manager_app/presentation/blocs/calendar_bloc/calendar_event.dart';
import 'package:event_manager_app/presentation/blocs/calendar_bloc/calendar_state.dart';

class EventDetailsScreen extends StatelessWidget {
  final int eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => CalendarBloc()..add(LoadEventDetails(id: eventId)),
        child: BlocBuilder<CalendarBloc, CalendarState>(
          builder: (context, state) {
            if (state is CalendarLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventDetailsLoaded) {
              final event = state.event;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton.filled(
                                  highlightColor: Colors.white,
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    BlocProvider.of<CalendarBloc>(context)
                                        .add(LoadAllEvents());
                                  },
                                  icon: const Icon(Icons.arrow_back_ios)),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateEventScreen(
                                        event: event,
                                      ),
                                    ),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            event.description,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.timer,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                event.time,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.place,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                event.location,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        const Text(
                          "Reminder",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "15 minutes before",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(height: 50),
                        const Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          event.description,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(height: 200),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.4),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            if (event.id != null) {
                              context
                                  .read<CalendarBloc>()
                                  .add(DeleteEvent(event.id!));
                              Navigator.of(context).pop();
                              BlocProvider.of<CalendarBloc>(context)
                                  .add(LoadAllEvents());
                            } else {
                              debugPrint(
                                  'Event ID is null. Cannot delete event.');
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              Text("Delete Event")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is CalendarError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text("No event details available."));
            }
          },
        ),
      ),
    );
  }
}
