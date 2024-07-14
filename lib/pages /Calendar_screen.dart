// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:provider/provider.dart';
// import '../models/task.dart'; // Import your Task model
// import 'task_provider.dart'; // Import your TaskProvider
//
// class CalendarPage extends StatefulWidget {
//   @override
//   _CalendarPageState createState() => _CalendarPageState();
// }
//
// class _CalendarPageState extends State<CalendarPage> {
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Calendar'),
//       ),
//       body: Column(
//         children: [
//           TableCalendar(
//             firstDay: DateTime.utc(2022, 1, 1),
//             lastDay: DateTime.utc(2030, 12, 31),
//             focusedDay: _focusedDay,
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             onDaySelected: (selectedDay, focusedDay) {
//               setState(() {
//                 _selectedDay = selectedDay;
//                 _focusedDay = focusedDay;
//               });
//             },
//             calendarFormat: CalendarFormat.month,
//             startingDayOfWeek: StartingDayOfWeek.sunday,
//             // Calendar customization
//           ),
//           Expanded(
//             child: Consumer<TaskProvider>(
//               builder: (context, taskProvider, child) {
//                 List<Task> tasks = taskProvider.tasksForDay(_selectedDay ?? DateTime.now());
//                 return ListView.builder(
//                   itemCount: tasks.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(tasks[index].title),
//                       // Additional task information display
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
