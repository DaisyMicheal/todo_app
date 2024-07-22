import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controller/font_controller.dart';
import '../controller/theme_controller.dart';
import '../models/task.dart' as models;
import 'create_task_screen.dart';
import 'setting_screen.dart';

class TodoHomepage extends StatefulWidget {
  @override
  _TodoHomepageState createState() => _TodoHomepageState();
}

class _TodoHomepageState extends State<TodoHomepage> {
  int _selectedIndex = 0;
  List<models.Task> tasks = [];
  List<models.Task> filteredTasks = [];
  String searchQuery = '';

  final GlobalKey<NavigatorState> _settingsNavigatorKey = GlobalKey<NavigatorState>();

  void _addTask(String title, String category, DateTime dateTime, Color color) {
    setState(() {
      tasks.add(
        models.Task(
          title: title,
          category: category,
          dateTime: dateTime,
          color: color,
        ),
      );
      _filterTasks(searchQuery);
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].completed = !tasks[index].completed;
      _filterTasks(searchQuery);
    });
  }

  void _editTask(int index, String newTitle, String newCategory, DateTime newDateTime, Color newColor) {
    setState(() {
      tasks[index].title = newTitle;
      tasks[index].category = newCategory;
      tasks[index].dateTime = newDateTime;
      tasks[index].color = newColor;
      _filterTasks(searchQuery);
    });
  }

  void _onEditTask(int index) {
    final task = tasks[index];
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateTaskScreen(
          onAddTask: (category, title, dateTimeStr, color) {
            DateTime dateTime = DateTime.parse(dateTimeStr as String);
            _editTask(index, title, category, dateTime, color);
          },
          existingTask: task.toMap(),
        ),
      ),
    );
  }

  void _filterTasks(String query) {
    setState(() {
      searchQuery = query;
      filteredTasks = tasks.where((task) {
        return task.title.toLowerCase().contains(query.toLowerCase()) ||
            task.category.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final fontSizeController = Provider.of<FontSizeController>(context);

    return Scaffold(
      backgroundColor: themeController.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: themeController.isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: themeController.isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {

            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: themeController.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                style: TextStyle(
                  color: themeController.isDarkMode ? Colors.white : Colors.black,
                  fontSize: fontSizeController.fontSize,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: themeController.isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: themeController.isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
                onChanged: (query) {
                  _filterTasks(query);
                },
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(themeController, fontSizeController),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateTaskScreen(
                onAddTask: _addTask,
              ),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: themeController.isDarkMode ? Colors.black : Colors.white,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: themeController.isDarkMode ? Colors.white : Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ThemeController themeController, FontSizeController fontSizeController) {
    switch (_selectedIndex) {
      case 0:
        return _buildTaskSection('Tasks', filteredTasks, themeController, fontSizeController);
      case 1:
        return _buildGroupSection(themeController, fontSizeController);
      case 2:
        return _buildSettingsSection(themeController, fontSizeController);
      default:
        return Container();
    }
  }

  Widget _buildTaskSection(String title, List<models.Task> taskList,
      ThemeController themeController, FontSizeController fontSizeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              color: themeController.isDarkMode ? Colors.white : Colors.black,
              fontSize: fontSizeController.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: taskList.length,
            itemBuilder: (context, index) {
              final task = taskList[index];
              final bool isCompleted = task.completed;

              return ListTile(
                leading: Icon(
                  Icons.label,
                  color: isCompleted ? Colors.blue : task.color ?? Colors.white,
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    color: themeController.isDarkMode ? Colors.white : Colors.black,
                    fontSize: fontSizeController.fontSize,
                    decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
                subtitle: Text(
                  '${task.category} - ${DateFormat('yMd').format(task.dateTime)}',
                  style: TextStyle(
                    color: themeController.isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: fontSizeController.fontSize,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check_circle, color: isCompleted ? Colors.blue : Colors.grey),
                      onPressed: () {
                        _toggleTaskCompletion(index);
                      },
                    ),
                    if (!isCompleted)
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.green),
                        onPressed: () {
                          _onEditTask(index); // Navigate to edit screen
                        },
                      ),
                  ],
                ),
                onTap: () {
                  _toggleTaskCompletion(index);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGroupSection(
      ThemeController themeController, FontSizeController fontSizeController) {
    return Center(
      child: Text(
        'Group section.',
        style: TextStyle(
          color: themeController.isDarkMode ? Colors.white : Colors.black,
          fontSize: fontSizeController.fontSize,
        ),
      ),
    );
  }

  Widget _buildSettingsSection(ThemeController themeController, FontSizeController fontSizeController) {
    return Navigator(
      key: _settingsNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => SettingsScreen(
            onThemeChange: (bool isDarkMode) {
              themeController.setDarkMode(isDarkMode);
            },
            onFontSizeChange: (double newFontSize) {
              fontSizeController.setFontSize(newFontSize);
            },
          ),
        );
      },
    );
  }
}
