import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../controller/theme_controller.dart';

class CreateTaskScreen extends StatefulWidget {
  final Function(String, String, DateTime, Color) onAddTask;
  final Map<String, dynamic>? existingTask;

  CreateTaskScreen({required this.onAddTask, this.existingTask});

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  String category = 'Family';
  String title = '';
  String time = '';
  String date = DateFormat('yMd').format(DateTime.now());
  bool repeat = false;
  List<String> subtasks = [];
  List<String> attachments = [];
  String notes = '';
  Color color = Colors.blue;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      category = widget.existingTask!['category'];
      title = widget.existingTask!['title'];
      _titleController.text = title;
      var dateTime = widget.existingTask!['dateTime'];
      if (dateTime != null && dateTime.contains(',')) {
        date = dateTime.split(',')[0];
        if (dateTime.split(',').length > 1) {
          time = dateTime.split(',')[1].trim();
        }
      }
      color = widget.existingTask!['color'];
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null)
      setState(() {
        date = DateFormat('yMd').format(picked);
      });
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null)
      setState(() {
        time = picked.format(context);
      });
  }

  void _pickAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        attachments.add(result.files.single.name);
      });
    }
  }

  void _addSubtask() {
    if (_subtaskController.text.isNotEmpty) {
      setState(() {
        subtasks.add(_subtaskController.text);
        _subtaskController.clear();
      });
    }
  }

  void _createTask() {
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to create task. Please add a title.')),
      );
    } else {
      try {
        DateTime dateTime = DateFormat('M/d/yyyy hh:mm a').parse('$date $time');
        widget.onAddTask(category, title, dateTime, color);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating task. Please check date and time formats.')),
        );
        print('Error parsing date and time: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        title: Text('Create Task', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTitleInput(isDarkMode),
              SizedBox(height: 10),
              _buildSubtasksInput(isDarkMode),
              SizedBox(height: 10),
              _buildCategorySelector(isDarkMode),
              SizedBox(height: 10),
              _buildDateSelector(context, isDarkMode),
              SizedBox(height: 10),
              _buildTimeSelector(context, isDarkMode),
              SizedBox(height: 10),
              _buildRepeatOption(isDarkMode),
              SizedBox(height: 10),
              _buildAttachmentOption(isDarkMode),
              SizedBox(height: 10),
              _buildNotesInput(isDarkMode),
              SizedBox(height: 20),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleInput(bool isDarkMode) {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        hintText: 'Enter task title',
        hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!),
        ),
        contentPadding: EdgeInsets.all(10),
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      onChanged: (value) {
        title = value;
      },
    );
  }

  Widget _buildSubtasksInput(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.list, color: isDarkMode ? Colors.white70 : Colors.black54),
          title: Text(
            'Subtasks',
            style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
          ),
        ),
        TextField(
          controller: _subtaskController,
          decoration: InputDecoration(
            hintText: 'Enter subtask',
            hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
            filled: true,
            fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!),
            ),
            contentPadding: EdgeInsets.all(10),
            suffixIcon: IconButton(
              icon: Icon(Icons.add, color: isDarkMode ? Colors.white70 : Colors.black54),
              onPressed: _addSubtask,
            ),
          ),
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: subtasks.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.subdirectory_arrow_right, color: isDarkMode ? Colors.white70 : Colors.black54),
              title: Text(
                subtasks[index],
                style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategorySelector(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.category, color: isDarkMode ? Colors.white70 : Colors.black54),
          title: Text(
            'Category',
            style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
          ),
        ),
        DropdownButton<String>(
          value: category,
          dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          items: <String>['Family', 'Work', 'Personal'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              category = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context, bool isDarkMode) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.calendar_today, color: Colors.yellow),
      title: Text(
        date,
        style: TextStyle(color: Colors.yellow),
      ),
      onTap: () {
        _selectDate(context);
      },
    );
  }

  Widget _buildTimeSelector(BuildContext context, bool isDarkMode) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.access_time, color: Colors.yellow),
      title: Text(
        time.isEmpty ? 'Select time' : time,
        style: TextStyle(color: Colors.yellow),
      ),
      onTap: () {
        _selectTime(context);
      },
    );
  }

  Widget _buildRepeatOption(bool isDarkMode) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.repeat, color: isDarkMode ? Colors.white70 : Colors.black54),
      title: Text(
        'Repeat',
        style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
      ),
      onTap: () {
        setState(() {
          repeat = !repeat;
        });
      },
    );
  }

  Widget _buildAttachmentOption(bool isDarkMode) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.attach_file, color: isDarkMode ? Colors.white70 : Colors.black54),
      title: Text(
        'Attachments (${attachments.length})',
        style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
      ),
      onTap: () {
        _pickAttachment();
      },
    );
  }

  Widget _buildNotesInput(bool isDarkMode) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Notes',
        hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!),
        ),
        contentPadding: EdgeInsets.all(10),
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      maxLines: 3,
      onChanged: (value) {
        notes = value;
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Clear', style: TextStyle(color: Colors.yellow)),
        ),
        ElevatedButton(
          onPressed: _createTask,
          child: Text(widget.existingTask != null ? 'Update' : 'Create'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.yellow,
          ),
        ),
      ],
    );
  }
}
