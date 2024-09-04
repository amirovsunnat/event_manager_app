import 'package:event_manager_app/presentation/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:event_manager_app/presentation/blocs/calendar_bloc/calendar_event.dart';
import 'package:event_manager_app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  final DateTime selectedDate;

  const AddEventScreen({super.key, required this.selectedDate});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _timeController = TextEditingController();
  Color selectedColor = Colors.red;

  @override
  void dispose() {
    _timeController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _addEvent() {
    final bloc = BlocProvider.of<CalendarBloc>(context);

    final event = Event(
      date: DateFormat('yyyy-MM-dd').format(widget.selectedDate),
      title: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      priorityColor: selectedColor.value.toRadixString(16).padLeft(6, '0'),
      time: _timeController.text, // Ensure time is formatted as needed
    );

    debugPrint('Adding event: ${event.toMap()}'); // Log event data

    bloc.add(AddEvent(event));

    Navigator.pop(context);
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
                  maxLines: null, // Ensure it expands vertically
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.shade300,
                ),
                child: DropdownButton<Color>(
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
                      value: Colors.red,
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: 20,
                            height: 20,
                            color: Colors.red,
                          ),
                          const Text('Red'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: Colors.blue,
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: 20,
                            height: 20,
                            color: Colors.blue,
                          ),
                          const Text('Blue'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: Colors.amber,
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: 20,
                            height: 20,
                            color: Colors.amber,
                          ),
                          const Text('Amber'),
                        ],
                      ),
                    ),
                  ],
                ),
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
                          print(_timeController.text);
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
                    onPressed: _addEvent,
                    child: const Text("Add"),
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
