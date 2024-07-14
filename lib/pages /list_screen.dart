import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controller/font_controller.dart';
import '../controller/theme_controller.dart';
import '../models/taskList_model.dart';

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  Map<String, List<TaskList>> categorizedTaskLists = {
    'Family': [],
    'Work': [],
    'Holiday': [],
  };

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _listController = TextEditingController();
  final TextEditingController _folderController = TextEditingController();
  String selectedCategory = 'Family';
  int? selectedTaskListIndex;
  DateTime? selectedDueDate;

  void _addTask(String title) {
    if (selectedTaskListIndex != null && selectedCategory.isNotEmpty) {
      setState(() {
        categorizedTaskLists[selectedCategory]![selectedTaskListIndex!].tasks.add(Task(
          title: title,
          category: selectedCategory,
          dateTime: DateTime.now(),
          color: Colors.blue,
        ));
      });
      _taskController.clear();
    }
  }

  void _addTaskList(String title) {
    setState(() {
      categorizedTaskLists[selectedCategory]!.add(TaskList(title: title));
    });
    _listController.clear();
  }


  void _addCategory(String category) {
    setState(() {
      categorizedTaskLists[category] = [];
    });
    _folderController.clear();
  }

  void _toggleTaskCompletion(int taskListIndex, int taskIndex) {
    setState(() {
      categorizedTaskLists[selectedCategory]![taskListIndex].tasks[taskIndex].completed =
      !categorizedTaskLists[selectedCategory]![taskListIndex].tasks[taskIndex].completed;
    });
  }

  void _toggleFavorite(int taskListIndex, int taskIndex) {
    setState(() {
      categorizedTaskLists[selectedCategory]![taskListIndex].tasks[taskIndex].favorite =
      !categorizedTaskLists[selectedCategory]![taskListIndex].tasks[taskIndex].favorite;
    });
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDueDate) {
      setState(() {
        selectedDueDate = picked;
      });
    }
  }

  void _toggleRemindMe(int taskListIndex, int taskIndex) {
    setState(() {
      categorizedTaskLists[selectedCategory]![taskListIndex].tasks[taskIndex].remindMe =
      !categorizedTaskLists[selectedCategory]![taskListIndex].tasks[taskIndex].remindMe;
    });
  }

  void _toggleRepeat(int taskListIndex, int taskIndex) {
    setState(() {
      categorizedTaskLists[selectedCategory]![taskListIndex].tasks[taskIndex].repeat =
      !categorizedTaskLists[selectedCategory]![taskListIndex].tasks[taskIndex].repeat;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final fontSizeController = Provider.of<FontSizeController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping List',
          style: TextStyle(
            color: themeController.isDarkMode ? Colors.white : Colors.black,
            fontSize: fontSizeController.fontSize,
          ),
        ),
        backgroundColor: themeController.isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeController.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: themeController.isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              // Handle search icon press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.star,
                    color: themeController.isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    // Handle favorite icon press
                  },
                ),
                SizedBox(width: 8),
                Text(
                  'Favorite',
                  style: TextStyle(
                    color: themeController.isDarkMode ? Colors.white : Colors.black,
                    fontSize: fontSizeController.fontSize,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: themeController.isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    // Handle remind me icon press
                  },
                ),
                SizedBox(width: 8),
                Text(
                  'Remind me',
                  style: TextStyle(
                    color: themeController.isDarkMode ? Colors.white : Colors.black,
                    fontSize: fontSizeController.fontSize,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDueDate(context);
                  },
                ),
                SizedBox(width: 8),
                Text(
                  selectedDueDate != null
                      ? 'Due ${DateFormat('EEE, d MMM').format(selectedDueDate!)} at ${DateFormat('hh:mm a').format(DateTime.now())}'
                      : 'Due date',
                  style: TextStyle(
                    color: themeController.isDarkMode ? Colors.white : Colors.black,
                    fontSize: fontSizeController.fontSize,
                  ),
                ),
                if (selectedDueDate != null)
                  IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: themeController.isDarkMode ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedDueDate = null;
                      });
                    },
                  ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.repeat,
                    color: themeController.isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    // Handle repeat icon press
                  },
                ),
                SizedBox(width: 8),
                Text(
                  'Repeat',
                  style: TextStyle(
                    color: themeController.isDarkMode ? Colors.white : Colors.black,
                    fontSize: fontSizeController.fontSize,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.attach_file,
                    color: themeController.isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    // Handle file attachment
                  },
                ),
                SizedBox(width: 8),
                Text(
                  'Add a file',
                  style: TextStyle(
                    color: themeController.isDarkMode ? Colors.white : Colors.black,
                    fontSize: fontSizeController.fontSize,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                DropdownButton<String>(
                  value: selectedCategory,
                  dropdownColor: themeController.isDarkMode ? Colors.black : Colors.white,
                  items: categorizedTaskLists.keys.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: TextStyle(
                          color: themeController.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                      selectedTaskListIndex = null;
                    });
                  },
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Add Category'),
                          content: TextField(
                            controller: _folderController,
                            decoration: InputDecoration(hintText: 'Category name'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _addCategory(_folderController.text);
                                Navigator.of(context).pop();
                              },
                              child: Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Task Lists',
              style: TextStyle(
                color: themeController.isDarkMode ? Colors.white : Colors.black,
                fontSize: fontSizeController.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categorizedTaskLists[selectedCategory]!.length,
                itemBuilder: (context, taskListIndex) {
                  final taskList = categorizedTaskLists[selectedCategory]![taskListIndex];
                  return ExpansionTile(
                    title: Text(
                      taskList.title,
                      style: TextStyle(
                        color: themeController.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    onExpansionChanged: (bool expanded) {
                      setState(() {
                        if (expanded) {
                          selectedTaskListIndex = taskListIndex;
                        } else if (selectedTaskListIndex == taskListIndex) {
                          selectedTaskListIndex = null;
                        }
                      });
                    },
                    children: [
                      ...taskList.tasks.map((task) {
                        return ListTile(
                          leading: Checkbox(
                            value: task.completed,
                            onChanged: (bool? value) {
                              setState(() {
                                task.completed = value!;
                              });
                            },
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              color: task.completed
                                  ? Colors.grey
                                  : themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              decoration:
                              task.completed ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: task.favorite ? Colors.yellow : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    task.favorite = !task.favorite;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.notifications,
                                  color: task.remindMe ? Colors.blue : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    task.remindMe = !task.remindMe;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.repeat,
                                  color: task.repeat ? Colors.green : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    task.repeat = !task.repeat;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      ListTile(
                        title: TextField(
                          controller: _taskController,
                          decoration: InputDecoration(hintText: 'Add a new task'),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _addTask(value);
                            }
                          },
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            if (_taskController.text.isNotEmpty) {
                              _addTask(_taskController.text);
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeController.isDarkMode ? Colors.white : Colors.black,
        onPressed: () {
          if (_listController.text.isNotEmpty) {
            _addTaskList(_listController.text);
          }
        },
        child: Icon(Icons.add,
            color: themeController.isDarkMode ? Colors.black : Colors.white),
      ),
    );
  }
}
