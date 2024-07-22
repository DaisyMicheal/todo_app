import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [
    Task(title: 'Sample Task', dateTime: DateTime.now(), color: Colors.blue, category: ''),
  ];

  List<Task> tasksForDay(DateTime day) {
    return _tasks.where((task) => isSameDay(task.dateTime, day)).toList();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }
}
