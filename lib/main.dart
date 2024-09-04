import 'package:event_manager_app/presentation/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/screens/calendar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CalendarApp());
}

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarBloc(),
      child: MaterialApp(
        title: 'Calendar App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CalendarScreen(),
      ),
    );
  }
}
