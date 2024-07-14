import 'package:flutter/material.dart';

class Appointment {
  final String title;
  final DateTime startTime;
  final DateTime endTime;

  Appointment({
    required this.title,
    required this.startTime,
    required this.endTime,
  });
}

class AppointmentBuilder {
  List<Appointment> buildAppointments() {
    // Implement your logic to build appointments here
    return [
      Appointment(
        title: 'Meeting',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 1)),
      ),
      Appointment(
        title: 'Event',
        startTime: DateTime.now().add(Duration(days: 1)),
        endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
      ),
    ];
  }
}
