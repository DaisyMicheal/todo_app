import 'package:flutter/material.dart';


class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning,',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              Text(
                'Çağla Yılmaz',
                style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.png'), // Replace with your image asset
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateSelector(),
              SizedBox(height: 20),
              _buildSearchBar(),
              SizedBox(height: 20),
              _buildSectionHeader('Folders', 'See All'),
              SizedBox(height: 10),
              _buildFolders(),
              SizedBox(height: 20),
              _buildSectionHeader('Tasks', 'See All'),
              SizedBox(height: 10),
              _buildTasks(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        DateTime date = DateTime.now().subtract(Duration(days: 3 - index));
        bool isSelected = index == 3;
        return Column(
          children: [
            Text(
              ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'][date.weekday - 1],
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 5),
            CircleAvatar(
              radius: 16,
              backgroundColor: isSelected ? Colors.blue : Colors.transparent,
              child: Text(
                date.day.toString(),
                style: TextStyle(color: isSelected ? Colors.white : Colors.black),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search Task',
          icon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          child: Text(actionText),
        ),
      ],
    );
  }

  Widget _buildFolders() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFolderCard('Personal', '4 Lists', Colors.pink, 'assets/personal.png'),
        _buildFolderCard('Writing', '8 Lists', Colors.purple, 'assets/writing.png'),
      ],
    );
  }

  Widget _buildFolderCard(String title, String subtitle, Color color, String imageAsset) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imageAsset, height: 40), // Replace with your image asset
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
            SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasks() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pink),
          ),
          SizedBox(height: 10),
          _buildTaskItem('Update planner', '13:00', 'High', Colors.red),
          _buildTaskItem('Lunch', '15:00', 'Low', Colors.green),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, String time, String priority, Color priorityColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.radio_button_unchecked),
              SizedBox(width: 10),
              Text(title),
            ],
          ),
          Row(
            children: [
              Text(time),
              SizedBox(width: 10),
              Text(priority, style: TextStyle(color: priorityColor)),
            ],
          ),
        ],
      ),
    );
  }
}
