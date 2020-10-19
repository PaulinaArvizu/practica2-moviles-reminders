import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pract_dos/home/home_page.dart';

import 'models/todo_reminder.dart';

void main() async {
  // DONE: inicializar hive y agregar el adapter
  WidgetsFlutterBinding.ensureInitialized();
  //local storage
  final _localStorage = await getApplicationDocumentsDirectory();
  Hive
    ..init(_localStorage.path)
    ..registerAdapter(ReminderAdapter());
  //open boxes
  await Hive.openBox("Reminder");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarea 2',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomePage(),
    );
  }
}
