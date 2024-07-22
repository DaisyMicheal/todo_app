import 'package:flutter/material.dart';
import 'controller/font_controller.dart';
import 'controller/theme_controller.dart';
import 'pages /homescreen.dart';
import 'package:provider/provider.dart';
import 'pages /list_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeController()),
        ChangeNotifierProvider(create: (context) => FontSizeController(14.0)),
      ],
      child: Consumer2<ThemeController, FontSizeController>(
        builder: (context, themeController, fontSizeController, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: themeController.isDarkMode ? Brightness.dark : Brightness.light,
              textTheme: TextTheme(
                bodyMedium: TextStyle(fontSize: fontSizeController.fontSize),
              ),
            ),
            home: TodoHomepage(),
          );
        },
      ),
    );
  }
}
