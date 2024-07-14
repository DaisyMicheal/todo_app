import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/font_controller.dart';
import '../controller/theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChange;
  final Function(double) onFontSizeChange;

  const SettingsScreen({
    required this.onThemeChange,
    required this.onFontSizeChange,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;
  TimeOfDay _notificationTime = TimeOfDay.now();
  String _notificationSound = 'Default';
  DateTime _defaultDueDate = DateTime.now();
  String _defaultPriority = 'Normal';
  String _defaultCategory = 'Work';
  bool _autoArchive = false;
  String _selectedLanguage = 'English';

  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      _notificationTime = TimeOfDay(
        hour: prefs.getInt('notificationHour') ?? 9,
        minute: prefs.getInt('notificationMinute') ?? 0,
      );
      _notificationSound = prefs.getString('notificationSound') ?? 'Default';
      _defaultDueDate = DateTime.tryParse(prefs.getString('defaultDueDate') ?? '') ?? DateTime.now();
      _defaultPriority = prefs.getString('defaultPriority') ?? 'Normal';
      _defaultCategory = prefs.getString('defaultCategory') ?? 'Work';
      _autoArchive = prefs.getBool('autoArchive') ?? false;
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
      _isDarkMode = prefs.getBool('isDarkMode') ?? false; // Load dark mode setting
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setInt('notificationHour', _notificationTime.hour);
    await prefs.setInt('notificationMinute', _notificationTime.minute);
    await prefs.setString('notificationSound', _notificationSound);
    await prefs.setString('defaultDueDate', _defaultDueDate.toIso8601String());
    await prefs.setString('defaultPriority', _defaultPriority);
    await prefs.setString('defaultCategory', _defaultCategory);
    await prefs.setBool('autoArchive', _autoArchive);
    await prefs.setString('selectedLanguage', _selectedLanguage);
  }

  Future<void> _saveThemePreferences(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  void _selectNotificationTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
    );
    if (picked != null && picked != _notificationTime) {
      setState(() {
        _notificationTime = picked;
      });
      _saveSettings();
    }
  }

  void _selectDefaultDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _defaultDueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _defaultDueDate) {
      setState(() {
        _defaultDueDate = picked;
      });
      _saveSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final fontSizeController = Provider.of<FontSizeController>(context);
    final isDarkMode = themeController.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildThemeAndAppearanceSection(themeController, fontSizeController, isDarkMode),
          Divider(color: Colors.grey),
          _buildNotificationSettingsSection(isDarkMode, fontSizeController.fontSize),
          Divider(color: Colors.grey),
          _buildTaskManagementSection(isDarkMode, fontSizeController.fontSize),
          Divider(color: Colors.grey),
          _buildLanguageAndRegionSection(isDarkMode, fontSizeController.fontSize),
          Divider(color: Colors.grey),
          _buildIntegrationsSection(isDarkMode, fontSizeController.fontSize),
        ],
      ),
    );
  }

  Widget _buildThemeAndAppearanceSection(ThemeController themeController, FontSizeController fontSizeController, bool isDarkMode) {
    return ExpansionTile(
      leading: Icon(Icons.palette, color: Colors.yellow),
      title: Text('Theme and Appearance', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: fontSizeController.fontSize)),
      children: [
        SwitchListTile(
          title: Text('Dark Mode', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: fontSizeController.fontSize)),
          value: themeController.isDarkMode,
          onChanged: (bool value) {
            setState(() {
              _isDarkMode = value;
            });
            widget.onThemeChange(value);
            themeController.setDarkMode(value); // Update theme controller
            _saveThemePreferences(value);
          },
        ),
        ListTile(
          title: Text('Font Size', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: fontSizeController.fontSize)),
          subtitle: Slider(
            value: fontSizeController.fontSize,
            min: 10.0,
            max: 24.0,
            divisions: 7,
            label: fontSizeController.fontSize.toString(),
            onChanged: (double value) {
              setState(() {
                fontSizeController.setFontSize(value);
              });
              widget.onFontSizeChange(value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSettingsSection(bool isDarkMode, double fontSize) {
    return ExpansionTile(
      leading: Icon(Icons.notifications, color: Colors.yellow),
      title: Text('Notification Settings', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: fontSize)),
      children: [
        SwitchListTile(
          title: Text('Enable Notifications', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: fontSize)),
          value: _notificationsEnabled,
          onChanged: (bool value) {
            setState(() {
              _notificationsEnabled = value;
            });
            _saveSettings();
          },
        ),
        ListTile(
          title: Text('Notification Time', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: fontSize)),
          subtitle: Text(_notificationTime.format(context), style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: fontSize)),
          onTap: () => _selectNotificationTime(context),
        ),
        ListTile(
          title: Text('Notification Sound', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: fontSize)),
          subtitle: Text(_notificationSound, style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: fontSize)),
          onTap: () {
            // Show dialog to select notification sound
          },
        ),
      ],
    );
  }

  Widget _buildTaskManagementSection(bool isDarkMode, double fontSize) {
    return ExpansionTile(
      leading: Icon(Icons.task, color: Colors.yellow),
      title: Text('Task Management', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: fontSize)),
      children: [
        ListTile(
          title: Text('Default Due Date', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: fontSize)),
          subtitle: Text('${_defaultDueDate.toLocal()}'.split(' ')[0], style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: fontSize)),
          onTap: () => _selectDefaultDueDate(context),
        ),
        ListTile(
          title: Text('Default Priority', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: fontSize)),
          subtitle: Text(_defaultPriority, style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: fontSize)),
          onTap: () {
            // Show dialog to select default priority
          },
        ),
        ListTile(
          title: Text('Default Category', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: fontSize)),
          subtitle: Text(_defaultCategory, style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: fontSize)),
          onTap: () {
            // Show dialog to select default category
          },
        ),
        SwitchListTile(
          title: Text('Auto-archive Completed Tasks', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: fontSize)),
          value: _autoArchive,
          onChanged: (bool value) {
            setState(() {
              _autoArchive = value;
            });
            _saveSettings();
          },
        ),
        ListTile(
          title: Text('Delete Account and Data', style: TextStyle(color: Colors.red, fontSize: fontSize)),
          onTap: () {
            // Show confirmation dialog to delete account and data
          },
        ),
      ],
    );
  }

  Widget _buildLanguageAndRegionSection(bool isDarkMode, double fontSize) {
    return ExpansionTile(
      leading: Icon(Icons.language, color: Colors.yellow),
      title: Text('Language and Region', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: fontSize)),
      children: [
        ListTile(
          title: Text('Language', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: fontSize)),
          subtitle: Text(_selectedLanguage, style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: fontSize)),
          onTap: () {
            // Show dialog to select language
          },
        ),
      ],
    );
  }

  Widget _buildIntegrationsSection(bool isDarkMode, double fontSize) {
    return ListTile(
      leading: Icon(Icons.extension, color: Colors.yellow),
      title: Text('Integrations', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: fontSize)),
      onTap: () {
        // Navigate to integrations settings
      },
    );
  }
}
