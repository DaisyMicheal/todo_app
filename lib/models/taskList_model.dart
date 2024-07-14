import 'package:flutter/material.dart';


class TaskList {
  String title;
  List<Task> tasks;

  TaskList({
    required this.title,
    this.tasks = const [],
  });
}
class Task {
  String title;
  String category;
  DateTime dateTime;
  Color color;
  bool completed;
  bool favorite;
  bool remindMe;
  bool repeat;
  DateTime? dueDate;

  Task({
    required this.title,
    required this.category,
    required this.dateTime,
    required this.color,
    this.completed = false,
    this.favorite = false,
    this.remindMe = false,
    this.repeat = false,
    this.dueDate,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    try {
      return Task(
        title: map['title'] ?? '',
        category: map['category'] ?? '',
        dateTime: DateTime.parse(map['dateTime'] ?? ''),
        color: _parseColor(map['color']) ?? Colors.black,
        completed: map['completed'] ?? false,
        favorite: map['favorite'] ?? false,
        remindMe: map['remindMe'] ?? false,
        repeat: map['repeat'] ?? false,
        dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      );
    } catch (e) {
      print('Error parsing Task from map: $e');
      return Task(
        title: '',
        category: '',
        dateTime: DateTime.now(),
        color: Colors.black,
        completed: false,
        favorite: false,
        remindMe: false,
        repeat: false,
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'dateTime': dateTime.toIso8601String(),
      'color': color.value,
      'completed': completed,
      'favorite': favorite,
      'remindMe': remindMe,
      'repeat': repeat,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  static Color? _parseColor(dynamic colorValue) {
    if (colorValue is int) {
      return Color(colorValue);
    } else if (colorValue is String) {
      return Color(int.tryParse(colorValue) ?? 0);
    }
    return null;
  }
}

void main() {
  // Example usage
  Task task = Task(
    title: 'Complete Flutter project',
    category: 'Work',
    dateTime: DateTime.now(),
    color: Colors.blue,
    completed: false,
    favorite: false,
    remindMe: true,
    repeat: false,
    dueDate: DateTime.now().add(Duration(days: 7)),
  );

  print('Task title: ${task.title}');
  print('Task category: ${task.category}');
  print('Task due date: ${task.dueDate}');
}
