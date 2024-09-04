import 'package:event_manager_app/core/utils/parse_color.dart';
import 'package:event_manager_app/data/models/event_model.dart';
import 'package:event_manager_app/presentation/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:event_manager_app/presentation/blocs/calendar_bloc/calendar_event.dart';
import 'package:event_manager_app/presentation/screens/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateEventScreen extends StatefulWidget {
  final Event event;

  const UpdateEventScreen({super.key, required this.event});

  @override
  State<UpdateEventScreen> createState() => _UpdateEventScreenState();
}

class _UpdateEventScreenState extends State<UpdateEventScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _timeController;
  Color selectedColor = Colors.red;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _locationController = TextEditingController(text: widget.event.location);
    _timeController = TextEditingController(text: widget.event.time);
    selectedColor = parseColor(widget.event.priorityColor);
  }

  @override
  void dispose() {
    _timeController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _updateEvent() {
    final bloc = BlocProvider.of<CalendarBloc>(context);

    final updatedEvent = Event(
      id: widget.event.id,
      date: widget.event.date,
      title: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      priorityColor: selectedColor.value.toRadixString(16).padLeft(6, '0'),
      time: _timeController.text,
    );

    bloc.add(UpdateEvent(updatedEvent));
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CalendarScreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Event name",
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Event description",
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Event location",
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.place),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Priority color",
                style: TextStyle(fontSize: 20),
              ),
              DropdownButton<Color>(
                borderRadius: BorderRadius.circular(10),
                underline: Container(),
                value: selectedColor,
                onChanged: (Color? newColor) {
                  if (newColor != null) {
                    setState(() {
                      selectedColor = newColor;
                    });
                  }
                },
                items: [
                  DropdownMenuItem(
                    value: const Color(0xfff44336), // Red
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          width: 20,
                          height: 20,
                          color: const Color(0xfff44336),
                        ),
                        const Text('Red'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: const Color(0xff2196f3), // Blue
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          width: 20,
                          height: 20,
                          color: const Color(0xff2196f3),
                        ),
                        const Text('Blue'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: const Color(0xffffc107), // Amber
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          width: 20,
                          height: 20,
                          color: const Color(0xffffc107),
                        ),
                        const Text('Amber'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Event time",
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            _timeController.text = pickedTime.format(context);
                          }
                        },
                        controller: _timeController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.watch),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _updateEvent,
                    child: const Text("Update"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
