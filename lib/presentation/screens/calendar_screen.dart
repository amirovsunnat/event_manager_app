import 'package:event_manager_app/core/utils/parse_color.dart';
import 'package:event_manager_app/presentation/blocs/calendar_bloc/calendar_state.dart';
import 'package:event_manager_app/presentation/screens/event_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:event_manager_app/presentation/screens/add_event_screen.dart';
import 'package:event_manager_app/presentation/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:event_manager_app/presentation/blocs/calendar_bloc/calendar_event.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    // Load all events first
    BlocProvider.of<CalendarBloc>(context).add(LoadAllEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          if (state is CalendarLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CalendarLoaded) {
            // Update selectedDate if it has no events and if it's not the default today
            final eventsForSelectedDate = state.events
                .where((event) => DateFormat('yyyy-MM-dd')
                    .parse(event.date)
                    .isAtSameMomentAs(selectedDate))
                .toList();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                children: [
                  _buildHeader(state),
                  _buildMonthAndYearSelector(),
                  _buildDaysOfWeek(),
                  _buildCalendarGrid(state),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Schedule",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddEventScreen(
                                    selectedDate: selectedDate,
                                  ),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "Add event",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (eventsForSelectedDate.isNotEmpty)
                          Expanded(
                            child: ListView.builder(
                              itemCount: eventsForSelectedDate.length,
                              itemBuilder: (context, index) {
                                final event = eventsForSelectedDate[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => EventDetailsScreen(
                                          eventId: event.id!),
                                    ))
                                        .then((_) {
                                      BlocProvider.of<CalendarBloc>(context)
                                          .add(LoadAllEvents());
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                            color:
                                                parseColor(event.priorityColor),
                                          ),
                                          height: 20,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ),
                                            color:
                                                parseColor(event.priorityColor)
                                                    .withOpacity(0.6),
                                          ),
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(event.title),
                                                Text(event.location),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.timer),
                                                    const SizedBox(width: 5),
                                                    Text(event.time),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          const Text("No events for this date"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is CalendarError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Unexpected state: $state'));
          }
        },
      ),
    );
  }

  Widget _buildHeader(CalendarLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(
            DateFormat('EEEE').format(selectedDate), // Day of the week
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('d MMMM').format(selectedDate), // Date and Month
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 5), // Spacing between date and dropdown
              DropdownButton<int>(
                value: selectedYear,
                items: List.generate(1000, (index) => 1950 + index)
                    .map((int year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  );
                }).toList(),
                onChanged: (int? newYear) {
                  if (newYear != null) {
                    setState(() {
                      selectedYear = newYear;
                      focusedDate = DateTime(selectedYear, focusedDate.month);
                      BlocProvider.of<CalendarBloc>(context)
                          .add(LoadCalendar(focusedDate));
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthAndYearSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('MMMM yyyy').format(focusedDate),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_left),
              onPressed: () {
                setState(() {
                  int newMonth = focusedDate.month - 1;
                  if (newMonth < 1) {
                    newMonth = 12;
                    selectedYear--;
                  }
                  focusedDate = DateTime(selectedYear, newMonth);
                  BlocProvider.of<CalendarBloc>(context)
                      .add(LoadCalendar(focusedDate));
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  int newMonth = focusedDate.month + 1;
                  if (newMonth > 12) {
                    newMonth = 1;
                    selectedYear++;
                  }
                  focusedDate = DateTime(selectedYear, newMonth);
                  BlocProvider.of<CalendarBloc>(context)
                      .add(LoadCalendar(focusedDate));
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaysOfWeek() {
    return Container(
      color: Colors
          .grey[200], // Optional: Background color for better visualization
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
            .map((day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(CalendarLoaded state) {
    int daysInMonth =
        DateUtils.getDaysInMonth(focusedDate.year, focusedDate.month);
    int firstDayOffset =
        DateTime(focusedDate.year, focusedDate.month, 1).weekday;

    List<Widget> dayWidgets = [];

    // Adding empty containers for the days before the first day of the month
    for (int i = 0; i < firstDayOffset; i++) {
      dayWidgets.add(Container()); // Empty container for alignment
    }

    // Adding day numbers to the grid
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(focusedDate.year, focusedDate.month, day);

      // Get events for the current date
      final eventDots = state.events
          .where((event) =>
              DateFormat('yyyy-MM-dd').format(date) ==
              event.date) // Match events with current date
          .map((event) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 1.0),
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: parseColor(event.priorityColor), // Use event color
                ),
              ))
          .toList();

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = date;
              BlocProvider.of<CalendarBloc>(context)
                  .add(SelectDate(selectedDate));
            });
          },
          child: Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selectedDate.day == day &&
                      selectedDate.month == focusedDate.month
                  ? Colors.blue
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    color: selectedDate.day == day &&
                            selectedDate.month == focusedDate.month
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                // Display event dots
                if (eventDots.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: eventDots,
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 7,
        children: dayWidgets,
      ),
    );
  }
}
