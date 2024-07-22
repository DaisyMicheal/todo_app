import 'package:flutter/material.dart';

class Task {
  String title;
  String category;
  DateTime dateTime;
  Color color;
  bool completed;

  Task({
    required this.title,
    required this.category,
    required this.dateTime,
    required this.color,
    this.completed = false,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    try {
      return Task(
        title: map['title'] ?? '',
        category: map['category'] ?? '',
        dateTime: DateTime.parse(map['dateTime'] ?? ''),
        color: _parseColor(map['color']) ?? Colors.black,
        completed: map['completed'] ?? false,
      );
    } catch (e) {
      print('Error parsing Task from map: $e');
      return Task(
        title: '',
        category: '',
        dateTime: DateTime.now(),
        color: Colors.black,
        completed: false,
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
